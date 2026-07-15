/// Computed metadata for `@MixableSpec` constructor fields.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../checkers.dart';
import '../curated/type_metadata.dart';
import '../errors.dart';
import 'type_helpers.dart';

export '../curated/type_metadata.dart' show DiagnosticKind;

/// Derives the canonical Styler name for [specName].
///
/// Strips a trailing `Spec` (e.g. `BoxSpec` -> `BoxStyler`) and falls back to
/// appending `Styler` when the spec name does not end in `Spec`.
String deriveStylerName(String specName) {
  if (specName.endsWith('Spec')) {
    return '${specName.substring(0, specName.length - 4)}Styler';
  }

  return '${specName}Styler';
}

/// Extracts [FieldModel]s from the unnamed constructor of [classElement].
///
/// Returns an empty list when the class has no unnamed constructor. Fails via
/// [fail] when a named parameter is missing a matching field declaration.
List<FieldModel> extractSpecFields(ClassElement classElement, String specName) {
  final constructor = classElement.unnamedConstructor;
  if (constructor == null) return [];

  final stylerName = deriveStylerName(specName);
  final namedParams = constructor.formalParameters
      .where((p) => p.isNamed)
      .toList();

  return namedParams.map((p) {
    final paramName = p.name!;
    final field = classElement.getField(paramName);
    if (field == null) {
      fail(classElement, 'Field $paramName not found in $specName');
    }

    return FieldModel.fromElement(field, stylerName: stylerName);
  }).toList();
}

/// A Spec field with derived type, interpolation, and diagnostic metadata.
class FieldModel {
  /// The field name.
  final String name;

  /// The base type name (without nullability).
  final String typeName;

  /// Whether the field type is `List`.
  final bool isList;

  /// The list element type when [isList] is true.
  final String? listElementType;

  /// The spec type argument name `X` when the field type is Mix's
  /// `StyleSpec<X>`, or `null` otherwise.
  ///
  /// Analyzer-derived (URL-checked against `package:mix`, so same-named user
  /// classes never match); synthesized models must set it explicitly.
  final String? styleSpecArgument;

  /// The resolved spec element inside Mix's `StyleSpec<X>`, when available.
  ///
  /// The source spec remains resolvable even when its generated Styler does
  /// not, which lets later generator stages derive the Styler's public surface
  /// during clean same-package builds.
  final InterfaceElement? styleSpecElement;

  /// The type emitted in generated `copyWith` and `lerp` methods.
  final String effectiveSpecType;

  /// Whether this field can be lerped.
  final bool isLerpable;

  /// The diagnostic property type to use.
  final DiagnosticKind diagnosticKind;

  /// The diagnostic label override, or `null` to use [name].
  final String? diagnosticLabel;

  /// The flag description for bool fields.
  final String? flagDescription;

  const FieldModel({
    required this.name,
    required this.typeName,
    required this.isList,
    this.listElementType,
    this.styleSpecArgument,
    this.styleSpecElement,
    required this.effectiveSpecType,
    required this.isLerpable,
    required this.diagnosticKind,
    this.diagnosticLabel,
    this.flagDescription,
  });

  /// Creates a [FieldModel] from an analyzer [FieldElement].
  factory FieldModel.fromElement(
    FieldElement element, {
    required String stylerName,
  }) {
    final field = extractField(element);
    final type = field.type;
    final name = field.name;
    final typeName = field.typeName;

    final isList = _isList(type);
    final listElementType = isList ? _getListElementType(type) : null;

    final effectiveSpecType = _getEffectiveSpecType(element);
    final isLerpable = _isLerpable(typeName, isList, listElementType);
    final diagnosticKind = diagnosticKindFor(typeName, isList: isList);

    final aliasConfig = fieldAliasMap['$stylerName.$name'];
    final diagnosticLabel = aliasConfig?.diagnosticLabel;

    final flagDescription = typeName == 'bool'
        ? flagDescriptionFor(name)
        : null;

    final styleSpec = _styleSpecOf(type);

    return FieldModel(
      name: name,
      typeName: typeName,
      isList: isList,
      listElementType: listElementType,
      styleSpecArgument: styleSpec?.name,
      styleSpecElement: styleSpec?.element,
      effectiveSpecType: effectiveSpecType,
      isLerpable: isLerpable,
      diagnosticKind: diagnosticKind,
      diagnosticLabel: diagnosticLabel,
      flagDescription: flagDescription,
    );
  }

  /// The field name to show in generated diagnostics.
  String get displayName => diagnosticLabel ?? name;

  /// The corresponding Styler field name, with the `$` prefix.
  String get stylerFieldName => '\$$name';

  @override
  String toString() => 'FieldModel($name: $typeName)';
}

bool _isList(DartType type) {
  if (type is! InterfaceType) return false;

  return type.isDartCoreList;
}

/// The spec type argument name `X` of Mix's `StyleSpec<X>`, or `null` when
/// [type] is not that `StyleSpec` or its argument is not an interface type.
({String name, InterfaceElement element})? _styleSpecOf(DartType type) {
  if (type is! InterfaceType) return null;
  if (!styleSpecChecker.isExactlyType(type)) return null;
  if (type.typeArguments.length != 1) return null;

  final argument = type.typeArguments.single;

  if (argument is! InterfaceType) return null;
  final name = argument.element.name;

  return name == null ? null : (name: name, element: argument.element);
}

String? _getListElementType(DartType type) {
  if (type is! InterfaceType) return null;
  if (!type.isDartCoreList) return null;
  if (type.typeArguments.isEmpty) return null;

  return getBaseTypeName(type.typeArguments.first);
}

String _getEffectiveSpecType(FieldElement element) {
  return visibleTypeCodeForField(element, visibleFrom: element.library);
}

bool _isLerpable(String typeName, bool isList, String? listElementType) {
  if (isEnumType(typeName)) {
    return false;
  }

  if (isSnappableType(typeName)) {
    return false;
  }

  if (isLerpableType(typeName)) {
    return true;
  }

  if (isList && listElementType != null) {
    final mixElementType = listElementMixTypeFor(listElementType);

    return mixElementType != null && listMixTypeFor(mixElementType) != null;
  }

  // Unknown types snap instead of interpolating.
  return false;
}

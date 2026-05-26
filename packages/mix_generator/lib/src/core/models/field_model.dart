/// Computed metadata for `@MixableSpec` constructor fields.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../curated/type_metadata.dart';
import 'type_helpers.dart';

export '../curated/type_metadata.dart' show DiagnosticKind;

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

    return FieldModel(
      name: name,
      typeName: typeName,
      isList: isList,
      listElementType: listElementType,
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

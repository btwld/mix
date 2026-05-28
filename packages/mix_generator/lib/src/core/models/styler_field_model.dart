/// Computed metadata for `@MixableStyler` fields.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../checkers.dart';
import '../curated/type_metadata.dart';
import 'type_helpers.dart' as type_helpers;

/// A Styler field with derived setter, type, and diagnostic metadata.
class StylerFieldModel {
  /// The public field name, without the `$` prefix.
  final String name;

  /// The field name as declared, including the `$` prefix.
  final String declaredName;

  /// The Dart code for this field's type from the annotated library.
  final String fieldTypeCode;

  /// Whether this is a raw list field, not wrapped in `Prop`.
  final bool isRawList;

  /// The public parameter type emitted for generated setter methods.
  final String effectivePublicParamType;

  /// Whether to generate a setter for this field.
  final bool generateSetter;

  /// The setter name, which may differ from [name].
  final String? setterName;

  /// The diagnostic label override, or `null` to use [name].
  final String? diagnosticLabel;

  const StylerFieldModel({
    required this.name,
    required this.declaredName,
    required this.fieldTypeCode,
    required this.isRawList,
    required this.effectivePublicParamType,
    required this.generateSetter,
    this.setterName,
    this.diagnosticLabel,
  });

  /// Creates a [StylerFieldModel] from an analyzer [FieldElement].
  factory StylerFieldModel.fromElement(
    FieldElement element, {
    required String stylerName,
  }) {
    final field = type_helpers.extractField(element, stripDollar: true);
    final type = field.type;
    final name = field.name;

    final wrappedInProp = type_helpers.isWrappedInProp(type);
    final innerType = type_helpers.getInnerType(type, isWrapped: wrappedInProp);
    final innerTypeName = type_helpers.getBaseTypeName(innerType);
    final fieldTypeCode = type_helpers.visibleTypeCodeForField(
      element,
      visibleFrom: element.library,
    );

    final isRawList = isRawListField(name);
    final rawListElementType = rawListElementTypeFor(name);

    final mixableFieldAnnotation = mixableFieldAnnotationChecker
        .firstAnnotationOf(element);
    final ignoreSetter =
        mixableFieldAnnotation?.getField('ignoreSetter')?.toBoolValue() ??
        false;

    final setterTypeValue = mixableFieldAnnotation?.getField('setterType');
    final setterType = setterTypeValue?.toTypeValue();
    final setterTypeOverride = setterType == null
        ? null
        : type_helpers.visibleTypeCodeForField(
            element,
            visibleFrom: element.library,
            type: setterType,
            usage: 'setter type',
          );

    final effectivePublicParamType =
        setterTypeOverride ??
        _getEffectivePublicParamType(
          innerType,
          innerTypeName,
          isRawList,
          rawListElementType,
          element,
        );

    final aliasConfig = fieldAliasMap['$stylerName.$name'];
    final diagnosticLabel = aliasConfig?.diagnosticLabel;
    final setterNameOverride = aliasConfig?.setterName;

    // A mapped `null` setter name explicitly disables generation.
    final generateSetter =
        !ignoreSetter && (setterNameOverride != null || aliasConfig == null);
    final setterName = generateSetter
        ? (setterNameOverride?.isNotEmpty == true ? setterNameOverride! : name)
        : null;

    return StylerFieldModel(
      name: name,
      declaredName: field.declaredName,
      fieldTypeCode: fieldTypeCode,
      isRawList: isRawList,
      effectivePublicParamType: effectivePublicParamType,
      generateSetter: generateSetter,
      setterName: setterName,
      diagnosticLabel: diagnosticLabel,
    );
  }

  /// The field name to show in generated diagnostics.
  String get displayName => diagnosticLabel ?? name;

  @override
  String toString() => 'StylerFieldModel($name: $fieldTypeCode)';
}

String _getEffectivePublicParamType(
  DartType innerType,
  String innerTypeName,
  bool isRawList,
  String? rawListElementType,
  FieldElement element,
) {
  // Raw list fields keep their original type.
  if (isRawList && rawListElementType != null) {
    return 'List<$rawListElementType>';
  }

  final mixType = mixTypeFor(innerTypeName);
  if (mixType != null) {
    return mixType;
  }

  return _stripNullableSuffix(
    type_helpers.visibleTypeCodeForField(
      element,
      visibleFrom: element.library,
      type: innerType,
      usage: 'setter type',
    ),
  );
}

String _stripNullableSuffix(String typeCode) => typeCode.endsWith('?')
    ? typeCode.substring(0, typeCode.length - 1)
    : typeCode;

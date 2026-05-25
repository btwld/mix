/// Field model for Styler fields.
///
/// Represents a Styler field with computed values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../checkers.dart';
import '../curated/type_metadata.dart';
import 'type_helpers.dart' as type_helpers;

/// Represents a Styler field with computed values for generation.
class StylerFieldModel {
  /// The field name (without $ prefix).
  final String name;

  /// The field name as declared (with $ prefix).
  final String declaredName;

  /// The Dart code for this field's type from the annotated library.
  final String fieldTypeCode;

  /// Whether this is a raw list field (not wrapped in Prop).
  final bool isRawList;

  /// The effective public parameter type (for setter methods).
  final String effectivePublicParamType;

  /// Whether to generate a setter for this field.
  final bool generateSetter;

  /// The setter name (may differ from field name).
  final String? setterName;

  /// Optional diagnostic label override.
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

  /// Creates a StylerFieldModel from a FieldElement.
  factory StylerFieldModel.fromElement(
    FieldElement element, {
    required String stylerName,
  }) {
    final field = type_helpers.extractField(element, stripDollar: true);
    final type = field.type;
    final name = field.name;

    // Check if wrapped in Prop<>
    final wrappedInProp = type_helpers.isWrappedInProp(type);
    final innerType = type_helpers.getInnerType(type, isWrapped: wrappedInProp);
    final innerTypeName = type_helpers.getBaseTypeName(innerType);
    final fieldTypeCode = type_helpers.visibleTypeCodeForField(
      element,
      visibleFrom: element.library,
    );

    // Check if raw list
    final isRawList = isRawListField(name);
    final rawListElementType = rawListElementTypeFor(name);

    // Check for @MixableField annotation
    final mixableFieldAnnotation = mixableFieldAnnotationChecker
        .firstAnnotationOf(element);
    final ignoreSetter =
        mixableFieldAnnotation?.getField('ignoreSetter')?.toBoolValue() ??
        false;

    // Get setterType override from annotation if specified
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

    // Determine effective public param type
    // Use @MixableField(setterType:) override if provided, otherwise compute from type
    final effectivePublicParamType =
        setterTypeOverride ??
        _getEffectivePublicParamType(
          innerType,
          innerTypeName,
          isRawList,
          rawListElementType,
          element,
        );

    // Get field alias config
    final aliasConfig = fieldAliasMap['$stylerName.$name'];
    final diagnosticLabel = aliasConfig?.diagnosticLabel;
    final setterNameOverride = aliasConfig?.setterName;

    // Setter is generated unless:
    // 1. @MixableField(ignoreSetter: true) is present, OR
    // 2. aliasConfig explicitly sets setterName to null
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

  /// Gets the display name for diagnostics.
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
  // Raw list fields keep their original type
  if (isRawList && rawListElementType != null) {
    return 'List<$rawListElementType>';
  }

  // Check for a Mix type mapping
  final mixType = mixTypeFor(innerTypeName);
  if (mixType != null) {
    return mixType;
  }

  // Use original type
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

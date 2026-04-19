/// Field model for Styler fields.
///
/// Represents a Styler field with computed values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../checkers.dart';
import '../curated/type_mappings.dart';
import 'type_helpers.dart' as type_helpers;

/// Represents a Styler field with computed values for generation.
class StylerFieldModel {
  /// The field name (without $ prefix).
  final String name;

  /// The field name as declared (with $ prefix).
  final String declaredName;

  /// The Dart type of the field.
  final DartType dartType;

  /// The field element from analyzer.
  final FieldElement element;

  /// Whether the field is nullable.
  final bool isNullable;

  /// The inner type name (inside Prop<>).
  final String innerTypeName;

  /// Whether this field is wrapped in Prop<>.
  final bool isWrappedInProp;

  /// Whether this is a raw list field (not wrapped in Prop).
  final bool isRawList;

  /// The raw list element type (if isRawList is true).
  final String? rawListElementType;

  /// The effective public parameter type (for setter methods).
  final String effectivePublicParamType;

  /// Whether to generate a setter for this field.
  final bool generateSetter;

  /// The setter name (may differ from field name).
  final String? setterName;

  /// Optional diagnostic label override.
  final String? diagnosticLabel;

  /// Whether this field has a Mix type variant.
  final bool hasMixType;

  const StylerFieldModel({
    required this.name,
    required this.declaredName,
    required this.dartType,
    required this.element,
    required this.isNullable,
    required this.innerTypeName,
    required this.isWrappedInProp,
    required this.isRawList,
    this.rawListElementType,
    required this.effectivePublicParamType,
    required this.generateSetter,
    this.setterName,
    this.diagnosticLabel,
    required this.hasMixType,
  });

  /// Creates a StylerFieldModel from a FieldElement.
  factory StylerFieldModel.fromElement(
    FieldElement element, {
    required String stylerName,
  }) {
    final type = element.type;
    // FieldElement.name is String? in analyzer 10.x, but fields always have names
    final declaredName = element.name!;

    // Field name without $ prefix
    final name = declaredName.startsWith(r'$')
        ? declaredName.substring(1)
        : declaredName;

    final isNullable = type.nullabilitySuffix == .question;

    // Check if wrapped in Prop<>
    final wrappedInProp = type_helpers.isWrappedInProp(type);
    final innerTypeName = type_helpers.getInnerTypeName(type, wrappedInProp);

    // Check if raw list
    final isRawList = rawListTypes.containsKey(name);
    final rawListElementType = rawListTypes[name];

    // Check if has Mix type
    final hasMixType = mixTypeMap.containsKey(innerTypeName);

    // Check for @MixableField annotation
    final mixableFieldAnnotation = mixableFieldAnnotationChecker
        .firstAnnotationOf(element);
    final ignoreSetter =
        mixableFieldAnnotation?.getField('ignoreSetter')?.toBoolValue() ??
        false;

    // Get setterType override from annotation if specified
    final setterTypeValue = mixableFieldAnnotation?.getField('setterType');
    final setterTypeOverride = setterTypeValue
        ?.toTypeValue()
        ?.getDisplayString();

    // Determine effective public param type
    // Use @MixableField(setterType:) override if provided, otherwise compute from type
    final effectivePublicParamType =
        setterTypeOverride ??
        _getEffectivePublicParamType(
          innerTypeName,
          isRawList,
          rawListElementType,
        );

    // Get field alias config
    final aliasConfig = fieldAliasMap['$stylerName.$name'];
    final diagnosticLabel = aliasConfig?.diagnosticLabel;
    final setterNameOverride = aliasConfig?.setterName;

    // Setter is generated unless:
    // 1. @MixableField(ignoreSetter: true) is present, OR
    // 2. aliasConfig explicitly sets setterName to empty string
    final generateSetter =
        !ignoreSetter && (setterNameOverride != null || aliasConfig == null);
    final setterName = generateSetter
        ? (setterNameOverride?.isNotEmpty == true ? setterNameOverride! : name)
        : null;

    return StylerFieldModel(
      name: name,
      declaredName: declaredName,
      dartType: type,
      element: element,
      isNullable: isNullable,
      innerTypeName: innerTypeName,
      isWrappedInProp: wrappedInProp,
      isRawList: isRawList,
      rawListElementType: rawListElementType,
      effectivePublicParamType: effectivePublicParamType,
      generateSetter: generateSetter,
      setterName: setterName,
      diagnosticLabel: diagnosticLabel,
      hasMixType: hasMixType,
    );
  }

  /// Gets the display name for diagnostics.
  String get displayName => diagnosticLabel ?? name;

  @override
  String toString() => 'StylerFieldModel($name: $innerTypeName)';
}

String _getEffectivePublicParamType(
  String innerTypeName,
  bool isRawList,
  String? rawListElementType,
) {
  // Raw list fields keep their original type
  if (isRawList && rawListElementType != null) {
    return 'List<$rawListElementType>';
  }

  // Check for direct Mix type mapping
  final mixType = mixTypeMap[innerTypeName];
  if (mixType != null) {
    return mixType;
  }

  // Use original type
  return innerTypeName;
}

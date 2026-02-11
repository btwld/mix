/// Field model for Spec fields.
///
/// Represents a field with computed effective values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../curated/flag_descriptions.dart';
import '../curated/type_mappings.dart';
import '../registry/mix_type_registry.dart';

/// Represents a Spec field with computed values for generation.
class FieldModel {
  /// The field name.
  final String name;

  /// The Dart type of the field.
  final DartType dartType;

  /// The field element from analyzer.
  final FieldElement element;

  /// Whether the field is nullable.
  final bool isNullable;

  /// The base type name (without nullability).
  final String typeName;

  /// Whether this is a List type.
  final bool isList;

  /// The list element type (if isList is true).
  final String? listElementType;

  /// The effective Spec type (for copyWith/lerp).
  final String effectiveSpecType;

  /// The effective Mix type (for Styler public constructor).
  final String? effectiveMixType;

  /// The effective public parameter type (for Styler public constructor).
  final String effectivePublicParamType;

  /// Whether this field can be lerped.
  final bool isLerpable;

  /// The kind of Prop wrapper to use.
  final PropWrapperKind propWrapperKind;

  /// Whether this field is wrapped in Prop<> in the Styler.
  final bool isWrappedInProp;

  /// The diagnostic property type to use.
  final DiagnosticKind diagnosticKind;

  /// Optional diagnostic label override.
  final String? diagnosticLabel;

  /// Optional setter name override (null = skip setter).
  final String? setterName;

  /// Whether to generate a setter for this field.
  final bool generateSetter;

  /// The flag description for bool fields.
  final String? flagDescription;

  const FieldModel({
    required this.name,
    required this.dartType,
    required this.element,
    required this.isNullable,
    required this.typeName,
    required this.isList,
    this.listElementType,
    required this.effectiveSpecType,
    this.effectiveMixType,
    required this.effectivePublicParamType,
    required this.isLerpable,
    required this.propWrapperKind,
    required this.isWrappedInProp,
    required this.diagnosticKind,
    this.diagnosticLabel,
    this.setterName,
    required this.generateSetter,
    this.flagDescription,
  });

  /// Creates a FieldModel from a FieldElement.
  factory FieldModel.fromElement(
    FieldElement element, {
    required String stylerName,
  }) {
    final type = element.type;
    // FieldElement.name is String? in analyzer 10.x, but fields always have names
    final name = element.name!;
    final isNullable = type.nullabilitySuffix == .question;

    // Get base type name
    final typeName = _getBaseTypeName(type);

    // Check if list
    final isList = _isList(type);
    final listElementType = isList ? _getListElementType(type) : null;

    // Determine effective types
    final effectiveSpecType = _getEffectiveSpecType(type);
    final effectiveMixType = _getEffectiveMixType(typeName, listElementType);
    final effectivePublicParamType = _getEffectivePublicParamType(
      typeName,
      isNullable,
      isList,
      listElementType,
      name,
    );

    // Determine lerp strategy
    final isLerpable = _isLerpable(typeName, isList, listElementType);

    // Determine prop wrapper
    final propWrapperKind = mixTypeRegistry.getPropWrapperKind(
      typeName,
      isList: isList,
      listElementType: listElementType,
      fieldName: name,
    );

    final isWrappedInProp = propWrapperKind != .none;

    // Determine diagnostic kind
    final diagnosticKind = _getDiagnosticKind(typeName, isList);

    // Get field alias config
    final aliasConfig = fieldAliasMap['$stylerName.$name'];
    final diagnosticLabel = aliasConfig?.diagnosticLabel;
    final setterNameOverride = aliasConfig?.setterName;
    final generateSetter = setterNameOverride != null || aliasConfig == null;
    final setterName = generateSetter
        ? (setterNameOverride?.isNotEmpty == true ? setterNameOverride! : name)
        : null;

    // Get flag description for bool fields
    final flagDescription = typeName == 'bool'
        ? getFlagDescription(name)
        : null;

    return FieldModel(
      name: name,
      dartType: type,
      element: element,
      isNullable: isNullable,
      typeName: typeName,
      isList: isList,
      listElementType: listElementType,
      effectiveSpecType: effectiveSpecType,
      effectiveMixType: effectiveMixType,
      effectivePublicParamType: effectivePublicParamType,
      isLerpable: isLerpable,
      propWrapperKind: propWrapperKind,
      isWrappedInProp: isWrappedInProp,
      diagnosticKind: diagnosticKind,
      diagnosticLabel: diagnosticLabel,
      setterName: setterName,
      generateSetter: generateSetter,
      flagDescription: flagDescription,
    );
  }

  /// Gets the display name for diagnostics.
  String get displayName => diagnosticLabel ?? name;

  /// Gets the Styler field name (with $ prefix).
  String get stylerFieldName => '\$$name';

  @override
  String toString() => 'FieldModel($name: $typeName)';
}

/// Kind of diagnostic property to use.
enum DiagnosticKind {
  /// DiagnosticsProperty (default)
  diagnostics,

  /// ColorProperty
  color,

  /// DoubleProperty
  doubleProperty,

  /// IntProperty
  intProperty,

  /// StringProperty
  stringProperty,

  /// `EnumProperty<T>`
  enumProperty,

  /// FlagProperty (for bool with ifTrue)
  flagProperty,

  /// `IterableProperty<T>`
  iterableProperty,
}

// Helper functions

String _getBaseTypeName(DartType type) {
  final displayString = type.getDisplayString();
  // Remove nullability suffix
  if (displayString.endsWith('?')) {
    return displayString.substring(0, displayString.length - 1);
  }

  return displayString;
}

bool _isList(DartType type) {
  if (type is! InterfaceType) return false;

  return type.isDartCoreList;
}

String? _getListElementType(DartType type) {
  if (type is! InterfaceType) return null;
  if (!type.isDartCoreList) return null;
  if (type.typeArguments.isEmpty) return null;

  return _getBaseTypeName(type.typeArguments.first);
}

String _getEffectiveSpecType(DartType type) {
  return type.getDisplayString();
}

String? _getEffectiveMixType(String typeName, String? listElementType) {
  // Check for direct Mix type mapping
  if (mixTypeMap.containsKey(typeName)) {
    return mixTypeMap[typeName];
  }

  // Check for list element Mix type
  if (listElementType != null) {
    final elementMixType = listElementMixTypeMap[listElementType];
    if (elementMixType != null) {
      return 'List<$elementMixType>';
    }
  }

  return null;
}

String _getEffectivePublicParamType(
  String typeName,
  bool isNullable,
  bool isList,
  String? listElementType,
  String fieldName,
) {
  // Raw list fields keep their original type
  final rawListElementType = rawListTypes[fieldName];
  if (rawListElementType != null) {
    final suffix = isNullable ? '?' : '';

    return 'List<$rawListElementType>$suffix';
  }

  // Check for list element Mix type
  if (isList && listElementType != null) {
    final elementMixType = listElementMixTypeMap[listElementType];
    if (elementMixType != null) {
      final suffix = isNullable ? '?' : '';

      return 'List<$elementMixType>$suffix';
    }
  }

  // Check for direct Mix type mapping
  final mixType = mixTypeMap[typeName];
  if (mixType != null) {
    final suffix = isNullable ? '?' : '';

    return '$mixType$suffix';
  }

  // Use original type
  final suffix = isNullable ? '?' : '';

  return '$typeName$suffix';
}

bool _isLerpable(String typeName, bool isList, String? listElementType) {
  // Check enum types first (always snap)
  if (enumTypes.contains(typeName)) {
    return false;
  }

  // Check snappable types
  if (snappableTypes.contains(typeName)) {
    return false;
  }

  // Check lerpable types
  if (lerpableTypes.contains(typeName)) {
    return true;
  }

  // Handle list types
  if (isList && listElementType != null) {
    // List<Shadow> and List<BoxShadow> are lerpable
    if ({'Shadow', 'BoxShadow'}.contains(listElementType)) {
      return true;
    }

    // List<Directive<T>> is snappable
    return false;
  }

  // Default to snap for unknown types
  return false;
}

DiagnosticKind _getDiagnosticKind(String typeName, bool isList) {
  if (isList) {
    return .iterableProperty;
  }

  return switch (typeName) {
    'Color' => .color,
    'double' => .doubleProperty,
    'int' => .intProperty,
    'String' => .stringProperty,
    'bool' => .flagProperty,
    _ when enumTypes.contains(typeName) => .enumProperty,
    _ => .diagnostics,
  };
}

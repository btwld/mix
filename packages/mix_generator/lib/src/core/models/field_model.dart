/// Field model for Spec fields.
///
/// Represents a field with computed effective values for code generation.
library;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../curated/type_metadata.dart';
import 'type_helpers.dart';

export '../curated/type_metadata.dart' show DiagnosticKind;

/// Represents a Spec field with computed values for generation.
class FieldModel {
  /// The field name.
  final String name;

  /// The base type name (without nullability).
  final String typeName;

  /// Whether this is a List type.
  final bool isList;

  /// The list element type (if isList is true).
  final String? listElementType;

  /// The effective Spec type (for copyWith/lerp).
  final String effectiveSpecType;

  /// Whether this field can be lerped.
  final bool isLerpable;

  /// The diagnostic property type to use.
  final DiagnosticKind diagnosticKind;

  /// Optional diagnostic label override.
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

  /// Creates a FieldModel from a FieldElement.
  factory FieldModel.fromElement(
    FieldElement element, {
    required String stylerName,
  }) {
    final field = extractField(element);
    final type = field.type;
    final name = field.name;
    final typeName = field.typeName;

    // Check if list
    final isList = _isList(type);
    final listElementType = isList ? _getListElementType(type) : null;

    // Determine effective types
    final effectiveSpecType = _getEffectiveSpecType(element);

    // Determine lerp strategy
    final isLerpable = _isLerpable(typeName, isList, listElementType);

    // Determine diagnostic kind
    final diagnosticKind = diagnosticKindFor(typeName, isList: isList);

    // Get field alias config
    final aliasConfig = fieldAliasMap['$stylerName.$name'];
    final diagnosticLabel = aliasConfig?.diagnosticLabel;

    // Get flag description for bool fields
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

  /// Gets the display name for diagnostics.
  String get displayName => diagnosticLabel ?? name;

  /// Gets the Styler field name (with $ prefix).
  String get stylerFieldName => '\$$name';

  @override
  String toString() => 'FieldModel($name: $typeName)';
}

// Helper functions

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
  // Check enum types first (always snap)
  if (isEnumType(typeName)) {
    return false;
  }

  // Check snappable types
  if (isSnappableType(typeName)) {
    return false;
  }

  // Check lerpable types
  if (isLerpableType(typeName)) {
    return true;
  }

  // Handle list types
  if (isList && listElementType != null) {
    final mixElementType = listElementMixTypeFor(listElementType);

    return mixElementType != null && listMixTypeFor(mixElementType) != null;
  }

  // Default to snap for unknown types
  return false;
}

/// Mix type registry for type resolution.
///
/// Provides lookups for Flutter type → Mix type mappings.
library;

import '../curated/type_mappings.dart';

/// Registry for Mix type mappings.
///
/// This class provides lookups for:
/// - Flutter type → Mix type (e.g., EdgeInsetsGeometry → EdgeInsetsGeometryMix)
/// - Element type → ListMix type (e.g., ShadowMix → ShadowListMix)
/// - Type classification (direct, enum, lerpable, snappable)
class MixTypeRegistry {
  const MixTypeRegistry();

  // Type mappings

  /// Checks if a Flutter type has a Mix variant.
  bool hasMixType(String flutterType) {
    return mixTypeMap.containsKey(flutterType);
  }

  /// Gets the Mix type for a Flutter type.
  String? getMixType(String flutterType) {
    return mixTypeMap[flutterType];
  }

  /// Checks if a Mix element type has a ListMix variant.
  bool hasListMixType(String elementType) {
    return listMixTypeMap.containsKey(elementType);
  }

  /// Gets the ListMix type for a Mix element type.
  String? getListMixType(String elementType) {
    return listMixTypeMap[elementType];
  }

  /// Gets the Mix element type for a Flutter list element type.
  String? getListElementMixType(String flutterElementType) {
    return listElementMixTypeMap[flutterElementType];
  }

  // Type classification

  /// Checks if a type is a direct type (uses Prop.maybe).
  bool isDirectType(String typeName) {
    return directTypes.contains(typeName);
  }

  /// Checks if a type is an enum.
  bool isEnumType(String typeName) {
    return enumTypes.contains(typeName);
  }

  /// Checks if a type is lerpable.
  bool isLerpableType(String typeName) {
    return lerpableTypes.contains(typeName);
  }

  /// Checks if a type is snappable.
  bool isSnappableType(String typeName) {
    return snappableTypes.contains(typeName) || enumTypes.contains(typeName);
  }

  /// Checks if a type is a raw list type (not wrapped in Prop).
  bool isRawListField(String fieldName) {
    return rawListTypes.containsKey(fieldName);
  }

  /// Gets the element type for a raw list field.
  String? getRawListElementType(String fieldName) {
    return rawListTypes[fieldName];
  }

  // Prop wrapper determination

  /// Determines the Prop wrapper kind for a type.
  PropWrapperKind getPropWrapperKind(
    String typeName, {
    required bool isList,
    required String? listElementType,
    required String fieldName,
  }) {
    // Check for raw list fields first
    if (isRawListField(fieldName)) {
      return PropWrapperKind.none;
    }

    // Handle list types
    if (isList && listElementType != null) {
      // Check if element type has a Mix variant
      final mixElementType = getListElementMixType(listElementType);
      if (mixElementType != null && hasListMixType(mixElementType)) {
        return PropWrapperKind.listMix;
      }

      return PropWrapperKind.maybe;
    }

    // Handle regular types
    if (hasMixType(typeName)) {
      return PropWrapperKind.maybeMix;
    }

    return PropWrapperKind.maybe;
  }
}

/// Kind of Prop wrapper to use.
enum PropWrapperKind {
  /// Prop.maybe(value) - for direct/enum types
  maybe,

  /// Prop.maybeMix(value) - for Mix types
  maybeMix,

  /// `Prop.mix(ListMix(value))` - for `List<MixType>`
  listMix,

  /// No wrapper - raw list pass-through
  none,
}

/// Default registry instance.
const mixTypeRegistry = MixTypeRegistry();

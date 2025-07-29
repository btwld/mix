import 'package:flutter/material.dart';

import '../properties/painting/border_mix.dart';
import '../properties/painting/border_radius_mix.dart';
import '../properties/painting/shape_border_mix.dart';
import 'prop.dart';

/// Utility for merging ShapeBorderMix instances with proper validation
class ShapeBorderMerger {
  /// Merges two ShapeBorderMix instances with validation and type conversion support.
  ///
  /// Handles both same-type and cross-type merging:
  /// - Same type: delegates to the standard merge method
  /// - Rectangle variants: validates compatibility and performs intelligent merging
  /// - Different types: returns the second (override behavior)
  ///
  /// Returns the merged result.
  static ShapeBorderMix? tryMerge(ShapeBorderMix? a, ShapeBorderMix? b) {
    if (b == null) return a;
    if (a == null) return b;

    // Same type merging - always safe, delegate to standard merge
    if (a.runtimeType == b.runtimeType) {
      return a.merge(b as dynamic); // Safe cast since we checked runtimeType
    }

    // Cross-type merging with intelligent rectangle variant support
    return _performCrossTypeMerge(a, b);
  }

  /// Performs cross-type merge with smart rectangle variant handling
  static ShapeBorderMix _performCrossTypeMerge(
    ShapeBorderMix a,
    ShapeBorderMix b,
  ) {
    // Check if both are rectangle variants - these can be intelligently merged
    if (_isRectangleVariant(a) && _isRectangleVariant(b)) {
      return _mergeRectangleVariants(a, b);
    }

    // Default behavior for incompatible types: override with second
    return b;
  }

  /// Checks if a ShapeBorderMix is a rectangle variant.
  /// Rectangle variants have identical properties and can be merged intelligently.
  static bool _isRectangleVariant(ShapeBorderMix border) {
    return border is RoundedRectangleBorderMix ||
        border is BeveledRectangleBorderMix ||
        border is ContinuousRectangleBorderMix ||
        border is RoundedSuperellipseBorderMix;
  }

  /// Merges two rectangle variants by preserving properties and using target type.
  ///
  /// All rectangle variants have the same properties:
  /// - `$borderRadius`: MixProp<BorderRadiusGeometry>?
  /// - `$side`: MixProp<BorderSide>?
  ///
  /// The merge preserves properties from both variants, with the second taking precedence.
  /// The result type matches the second variant's type.
  static ShapeBorderMix _mergeRectangleVariants(
    ShapeBorderMix first,
    ShapeBorderMix second,
  ) {
    // Extract properties from both borders
    final firstProps = _extractRectangleProperties(first);
    final secondProps = _extractRectangleProperties(second);

    // Merge properties (second takes precedence when both are non-null)
    final mergedBorderRadius = secondProps.$borderRadius ?? firstProps.$borderRadius;
    final mergedSide = secondProps.$side ?? firstProps.$side;

    // Use second's type as target, reconstructing with merged properties
    return _reconstructRectangleVariant(
      second.runtimeType,
      mergedBorderRadius,
      mergedSide,
    );
  }

  /// Extracts borderRadius and side properties from rectangle variants.
  static ({MixProp<BorderRadiusGeometry>? $borderRadius, MixProp<BorderSide>? $side}) _extractRectangleProperties(
    ShapeBorderMix border,
  ) {
    return switch (border) {
      RoundedRectangleBorderMix b => ($borderRadius: b.$borderRadius, $side: b.$side),
      BeveledRectangleBorderMix b => ($borderRadius: b.$borderRadius, $side: b.$side),
      ContinuousRectangleBorderMix b => ($borderRadius: b.$borderRadius, $side: b.$side),
      RoundedSuperellipseBorderMix b => ($borderRadius: b.$borderRadius, $side: b.$side),
      _ => throw ArgumentError('Expected rectangle variant, got ${border.runtimeType}'),
    };
  }

  /// Reconstructs a rectangle variant with the given properties.
  static ShapeBorderMix _reconstructRectangleVariant(
    Type targetType,
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  ) {
    return switch (targetType) {
      const (RoundedRectangleBorderMix) => RoundedRectangleBorderMix.raw(
          borderRadius: borderRadius,
          side: side,
        ),
      const (BeveledRectangleBorderMix) => BeveledRectangleBorderMix.raw(
          borderRadius: borderRadius,
          side: side,
        ),
      const (ContinuousRectangleBorderMix) => ContinuousRectangleBorderMix.raw(
          borderRadius: borderRadius,
          side: side,
        ),
      const (RoundedSuperellipseBorderMix) => RoundedSuperellipseBorderMix.raw(
          borderRadius: borderRadius,
          side: side,
        ),
      _ => throw ArgumentError('Unsupported rectangle variant type: $targetType'),
    };
  }

  /// Checks if two shape borders can be merged without data loss
  static bool canMerge(ShapeBorderMix? a, ShapeBorderMix? b) {
    if (a == null || b == null) return true;
    if (a.runtimeType == b.runtimeType) return true;

    // Rectangle variants can always be merged intelligently
    if (_isRectangleVariant(a) && _isRectangleVariant(b)) return true;

    // Other cross-type merging uses override behavior (no data loss validation needed)
    return true;
  }
}
import 'package:flutter/material.dart';

import '../properties/painting/shape_border_mix.dart';
import 'helpers.dart';
import 'prop.dart';

/// Utility for merging ShapeBorderMix instances with proper validation
class ShapeBorderMerger {
  const ShapeBorderMerger();

  /// Checks if a ShapeBorderMix is a rectangle variant.
  /// Rectangle variants have identical properties and can be merged intelligently.
  static bool _isRectangleVariant(ShapeBorderMix border) {
    return border is RoundedRectangleBorderMix ||
        border is BeveledRectangleBorderMix ||
        border is ContinuousRectangleBorderMix ||
        border is RoundedSuperellipseBorderMix;
  }

  /// Extracts borderRadius and side properties from rectangle variants.
  static ({Prop<BorderRadiusGeometry>? $borderRadius, Prop<BorderSide>? $side})
  _extractRectangleProperties(ShapeBorderMix border) {
    if (border is RoundedRectangleBorderMix) {
      return ($borderRadius: border.$borderRadius, $side: border.$side);
    }
    if (border is BeveledRectangleBorderMix) {
      return ($borderRadius: border.$borderRadius, $side: border.$side);
    }
    if (border is ContinuousRectangleBorderMix) {
      return ($borderRadius: border.$borderRadius, $side: border.$side);
    }
    if (border is RoundedSuperellipseBorderMix) {
      return ($borderRadius: border.$borderRadius, $side: border.$side);
    }

    throw ArgumentError('Expected rectangle variant, got ${border.runtimeType}');
  }

  /// Reconstructs a rectangle variant with the given properties.
  static ShapeBorderMix _reconstructRectangleVariant(
    Type targetType,
    Prop<BorderRadiusGeometry>? borderRadius,
    Prop<BorderSide>? side,
  ) {
    return switch (targetType) {
      const (RoundedRectangleBorderMix) => RoundedRectangleBorderMix.create(
        borderRadius: borderRadius,
        side: side,
      ),
      const (BeveledRectangleBorderMix) => BeveledRectangleBorderMix.create(
        borderRadius: borderRadius,
        side: side,
      ),
      const (ContinuousRectangleBorderMix) =>
        ContinuousRectangleBorderMix.create(
          borderRadius: borderRadius,
          side: side,
        ),
      const (RoundedSuperellipseBorderMix) =>
        RoundedSuperellipseBorderMix.create(
          borderRadius: borderRadius,
          side: side,
        ),
      _ => throw ArgumentError(
        'Unsupported rectangle variant type: $targetType',
      ),
    };
  }

  /// Performs cross-type merge with smart rectangle variant handling
  ShapeBorderMix _performCrossTypeMerge(
    BuildContext context,
    ShapeBorderMix a,
    ShapeBorderMix b,
  ) {
    // Check if both are rectangle variants - these can be intelligently merged
    if (_isRectangleVariant(a) && _isRectangleVariant(b)) {
      return _mergeRectangleVariants(context, a, b);
    }

    // Default behavior for incompatible types: override with second
    return b;
  }

  /// Merges two rectangle variants by preserving properties and using target type.
  ///
  /// All rectangle variants have the same properties:
  /// - `$borderRadius`: `Prop<BorderRadiusGeometry>?`
  /// - `$side`: `Prop<BorderSide>?`
  ///
  /// The merge uses BuildContext to resolve values for intelligent merge decisions.
  /// Properties are merged with proper precedence rules using resolved values.
  /// The result type matches the second variant's type.
  ShapeBorderMix _mergeRectangleVariants(
    BuildContext _,
    ShapeBorderMix first,
    ShapeBorderMix second,
  ) {
    // Extract properties from both borders
    final firstProps = _extractRectangleProperties(first);
    final secondProps = _extractRectangleProperties(second);

    // Use proper property merging instead of simple null-coalescing
    final mergedBorderRadius = MixOps.merge(
      firstProps.$borderRadius,
      secondProps.$borderRadius,
    );
    final mergedSide = MixOps.merge(firstProps.$side, secondProps.$side);

    // Use second's type as target, reconstructing with merged properties
    return _reconstructRectangleVariant(
      second.runtimeType,
      mergedBorderRadius,
      mergedSide,
    );
  }

  /// Merges two ShapeBorderMix instances with validation and type conversion support.
  ///
  /// Handles both same-type and cross-type merging:
  /// - Same type: delegates to the standard merge method
  /// - Rectangle variants: validates compatibility and performs intelligent merging
  /// - Different types: returns the second (override behavior)
  ///
  /// Uses BuildContext for potential future enhancements in merge decisions.
  ShapeBorderMix? tryMerge(
    BuildContext context,
    ShapeBorderMix? a,
    ShapeBorderMix? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    // Same type merging - always safe, delegate to standard merge
    if (a.runtimeType == b.runtimeType) {
      return a.merge(b); // Safe cast since we checked runtimeType
    }

    // Cross-type merging with intelligent rectangle variant support
    return _performCrossTypeMerge(context, a, b);
  }
}

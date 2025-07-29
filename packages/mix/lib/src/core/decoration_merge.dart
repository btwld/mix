import 'package:flutter/material.dart';

import '../properties/painting/border_mix.dart';
import '../properties/painting/decoration_mix.dart';

/// Utility for merging DecorationMix instances with proper validation
class DecorationMerger {
  /// Merges two DecorationMix instances with validation and type conversion support.
  ///
  /// Handles both same-type and cross-type merging:
  /// - Same type: delegates to the standard merge method
  /// - Different types: validates compatibility and performs conversion
  ///
  /// Returns the merged result or throws [ArgumentError] if merging would lose data.
  static DecorationMix? tryMerge(DecorationMix? a, DecorationMix? b) {
    if (b == null) return a;
    if (a == null) return b;

    // Same type merging - always safe
    if (a.runtimeType == b.runtimeType) {
      return a.merge(b);
    }

    // Cross-type merging with validation
    return _performCrossTypeMerge(a, b);
  }

  /// Performs cross-type merge with smart type determination
  /// Only converts types when necessary to accommodate type-specific properties
  static DecorationMix _performCrossTypeMerge(
    DecorationMix a,
    DecorationMix b,
  ) {
    if (a is BoxDecorationMix && b is ShapeDecorationMix) {
      return _mergeBoxWithShape(a, b);
    }

    if (a is ShapeDecorationMix && b is BoxDecorationMix) {
      return _mergeShapeWithBox(a, b);
    }

    throw ArgumentError(
      'Unsupported decoration types for merging: ${a.runtimeType} and ${b.runtimeType}',
    );
  }

  /// Merges BoxDecorationMix with ShapeDecorationMix, preserving type when possible
  static DecorationMix _mergeBoxWithShape(
    BoxDecorationMix box,
    ShapeDecorationMix shape,
  ) {
    // Only convert if shape has shape-specific properties
    if (shape.$shape != null) {
      return shape.mergeableDecor(box);
    }

    // Keep as BoxDecorationMix - only merge common properties
    return box.merge(
      BoxDecorationMix.raw(
        color: shape.$color,
        image: shape.$image,
        gradient: shape.$gradient,
        boxShadow: shape.shadows,
      ),
    );
  }

  /// Merges ShapeDecorationMix with BoxDecorationMix, preserving type when possible
  static DecorationMix _mergeShapeWithBox(
    ShapeDecorationMix shape,
    BoxDecorationMix box,
  ) {
    // Check if conversion is needed
    final needsConversion =
        box.$border != null ||
        box.$borderRadius != null ||
        box.$shape != null ||
        box.$backgroundBlendMode != null;

    if (!needsConversion) {
      // Keep as ShapeDecorationMix - only merge common properties
      return shape.merge(
        ShapeDecorationMix.raw(
          color: box.$color,
          image: box.$image,
          gradient: box.$gradient,
          shadows: box.$boxShadow,
        ),
      );
    }

    // Convert with validation
    _validateBoxToShapeConversion(box);

    return shape.mergeableDecor(box);
  }

  /// Validates that a BoxDecorationMix can be converted to ShapeDecorationMix
  static void _validateBoxToShapeConversion(BoxDecorationMix box) {
    // Check backgroundBlendMode constraint
    if (box.$backgroundBlendMode != null) {
      throw ArgumentError(
        'Cannot merge BoxDecoration with backgroundBlendMode into ShapeDecoration. '
        'ShapeDecoration does not support backgroundBlendMode.',
      );
    }

    // Check border uniformity constraints
    if (box.$border != null) {
      final borderValue = box.$border!.value as BoxBorderMix;
      final shape = box.$shape?.value ?? BoxShape.rectangle;

      // Circle requires uniform borders
      if (shape == BoxShape.circle) {
        if (!borderValue.isUniform) {
          throw ArgumentError(
            'Cannot merge BoxDecoration with circle shape and non-uniform borders. '
            'All border sides must be identical for circles.',
          );
        }
      }

      // Rectangle with borderRadius requires uniform borders
      if (box.$borderRadius != null) {
        if (!borderValue.isUniform) {
          throw ArgumentError(
            'Cannot merge BoxDecoration with borderRadius and non-uniform borders. '
            'All border sides must be identical when using borderRadius.',
          );
        }
      }
    }
  }

  /// Checks if two decorations can be merged without data loss
  static bool canMerge(DecorationMix? a, DecorationMix? b) {
    if (a == null || b == null) return true;
    if (a.runtimeType == b.runtimeType) return true;

    // For cross-type merging, check if problematic box properties exist
    if (a is ShapeDecorationMix && b is BoxDecorationMix) {
      return b.isMergeable;
    }

    // BoxDecorationMix can always receive ShapeDecorationMix properties
    return true;
  }
}

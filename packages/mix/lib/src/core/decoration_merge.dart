import 'package:flutter/material.dart';

import '../properties/painting/border_mix.dart';
import 'decoration_border_utils.dart';
import '../properties/painting/decoration_mix.dart';

/// Utility for merging DecorationMix instances with proper validation
class DecorationMerge {
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

  /// Performs cross-type merge between BoxDecorationMix and ShapeDecorationMix
  static DecorationMix _performCrossTypeMerge(
    DecorationMix a,
    DecorationMix b,
  ) {
    if (a is BoxDecorationMix && b is ShapeDecorationMix) {
      // Box + Shape = Shape (Box can receive Shape properties)
      return _mergeBoxWithShape(a, b);
    }

    if (a is ShapeDecorationMix && b is BoxDecorationMix) {
      // Shape + Box = depends on Box properties
      return _mergeShapeWithBox(a, b);
    }

    throw ArgumentError(
      'Unsupported decoration types for merging: ${a.runtimeType} and ${b.runtimeType}',
    );
  }

  /// Merges BoxDecorationMix with ShapeDecorationMix
  /// Box can always receive Shape properties
  static DecorationMix _mergeBoxWithShape(
    BoxDecorationMix box,
    ShapeDecorationMix shape,
  ) {
    // Use the existing mergeableDecor method
    return box.mergeableDecor(shape);
  }

  /// Merges ShapeDecorationMix with BoxDecorationMix
  /// Validates that Box properties can be converted to Shape
  static DecorationMix _mergeShapeWithBox(
    ShapeDecorationMix shape,
    BoxDecorationMix box,
  ) {
    // Validate conversion constraints
    _validateBoxToShapeConversion(box);

    // Use the existing mergeableDecor method
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
        if (!DecorationBorderUtils.hasUniformBorders(borderValue)) {
          throw ArgumentError(
            'Cannot merge BoxDecoration with circle shape and non-uniform borders. '
            'All border sides must be identical for circles.',
          );
        }
      }

      // Rectangle with borderRadius requires uniform borders
      if (box.$borderRadius != null) {
        if (!DecorationBorderUtils.hasUniformBorders(borderValue)) {
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

    // Same type can always merge
    if (a.runtimeType == b.runtimeType) return true;

    // Check cross-type compatibility
    if (a is BoxDecorationMix && b is ShapeDecorationMix) {
      // Box can always receive Shape
      return true;
    }

    if (a is ShapeDecorationMix && b is BoxDecorationMix) {
      // Shape can receive Box only if it's mergeable
      return b.isMergeable;
    }

    return false;
  }
}

import 'package:flutter/material.dart';

import '../properties/painting/border_mix.dart';
import '../properties/painting/decoration_mix.dart';
import '../properties/painting/shape_border_mix.dart';

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

  /// Performs cross-type merge between BoxDecorationMix and ShapeDecorationMix
  /// Determines target type based on type-specific properties to minimize conversions
  static DecorationMix _performCrossTypeMerge(
    DecorationMix a,
    DecorationMix b,
  ) {
    if (a is BoxDecorationMix && b is ShapeDecorationMix) {
      return _determineBoxShapeTargetType(a, b);
    }

    if (a is ShapeDecorationMix && b is BoxDecorationMix) {
      return _determineShapeBoxTargetType(a, b);
    }

    throw ArgumentError(
      'Unsupported decoration types for merging: ${a.runtimeType} and ${b.runtimeType}',
    );
  }

  /// Determines target type for BoxDecorationMix + ShapeDecorationMix merge
  static DecorationMix _determineBoxShapeTargetType(
    BoxDecorationMix box,
    ShapeDecorationMix shape,
  ) {
    // Check if ShapeDecorationMix has shape-specific properties
    final hasShapeSpecificProps = shape.$shape != null;
    
    if (!hasShapeSpecificProps) {
      // Only common properties - keep as BoxDecorationMix
      return box.merge(BoxDecorationMix.raw(
        color: shape.$color,
        gradient: shape.$gradient,
        image: shape.$image,
        boxShadow: shape.shadows,
      ));
    }
    
    // Has shape properties - convert to ShapeDecorationMix
    return _mergeBoxWithShape(box, shape);
  }

  /// Determines target type for ShapeDecorationMix + BoxDecorationMix merge  
  static DecorationMix _determineShapeBoxTargetType(
    ShapeDecorationMix shape,
    BoxDecorationMix box,
  ) {
    // Check if BoxDecorationMix has box-specific properties
    final hasBoxSpecificProps = box.$border != null || 
                                box.$borderRadius != null || 
                                box.$shape != null || 
                                box.$backgroundBlendMode != null;
    
    if (!hasBoxSpecificProps) {
      // Only common properties - keep as ShapeDecorationMix
      return shape.merge(ShapeDecorationMix.raw(
        color: box.$color,
        gradient: box.$gradient,
        image: box.$image,
        shadows: box.$boxShadow,
      ));
    }
    
    // Has box-specific properties - validate and convert if possible
    _validateBoxToShapeConversion(box);
    return _mergeShapeWithBox(shape, box);
  }

  /// Merges BoxDecorationMix with ShapeDecorationMix
  /// Converts to ShapeDecorationMix to accommodate shape properties  
  static DecorationMix _mergeBoxWithShape(
    BoxDecorationMix box,
    ShapeDecorationMix shape,
  ) {
    // Convert to ShapeDecorationMix: shape is the target, merge box properties into it
    return shape.mergeableDecor(box);
  }

  /// Merges ShapeDecorationMix with BoxDecorationMix
  /// Converts to ShapeDecorationMix since it can accommodate box properties after validation
  static DecorationMix _mergeShapeWithBox(
    ShapeDecorationMix shape,
    BoxDecorationMix box,
  ) {
    // Keep as ShapeDecorationMix: shape is the target, merge box properties into it
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

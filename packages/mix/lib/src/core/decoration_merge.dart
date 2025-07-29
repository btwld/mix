import 'package:flutter/material.dart';

import '../properties/painting/border_mix.dart';
import '../properties/painting/decoration_mix.dart';
import '../properties/painting/shape_border_mix.dart';
import 'prop.dart';

/// Utility for merging DecorationMix instances with proper validation
class DecorationMerger {
  const DecorationMerger();

  /// Merges BoxDecorationMix with ShapeDecorationMix, preserving type when possible
  DecorationMix _mergeBoxWithShape(BoxDecorationMix a, ShapeDecorationMix b) {
    final shape = b.$shape;

    if (shape == null) {
      // Keep as BoxDecorationMix - only merge common properties
      return a.merge(
        BoxDecorationMix.raw(
          color: b.$color,
          image: b.$image,
          gradient: b.$gradient,
          boxShadow: b.shadows,
        ),
      );
    }

    return ShapeDecorationMix.raw(
      color: b.$color,
      image: b.$image,
      gradient: b.$gradient,
      shadows: b.shadows,
    ).merge(b);
  }

  /// Merges ShapeDecorationMix with BoxDecorationMix, preserving type when possible
  DecorationMix _mergeShapeWithBox(ShapeDecorationMix a, BoxDecorationMix b) {
    // Check if conversion is needed
    final needsConversion =
        b.$border != null ||
        b.$borderRadius != null ||
        b.$shape != null ||
        b.$backgroundBlendMode != null;

    if (!needsConversion) {
      // Keep as ShapeDecorationMix - only merge common properties
      return a.merge(
        ShapeDecorationMix.raw(
          color: b.$color,
          image: b.$image,
          gradient: b.$gradient,
          shadows: b.$boxShadow,
        ),
      );
    }

    // Convert BoxDecorationMix properties to ShapeBorder
    final shapeBorder = _createShapeBorderFromBoxBorder(
      shape: b.$shape,
      border: b.$border,
      borderRadius: b.$borderRadius,
    );

    return a.merge(
      ShapeDecorationMix.raw(
        shape: shapeBorder,
        color: b.$color,
        image: b.$image,
        gradient: b.$gradient,
        shadows: b.$boxShadow,
      ),
    );
  }

  /// Creates a ShapeBorderMix from box decoration properties
  /// Only accesses .value when safe to do so (non-token values)
  MixProp<ShapeBorder>? _createShapeBorderFromBoxBorder({
    required Prop<BoxShape>? shape,
    required MixProp<BoxBorder>? border,
    required MixProp<BorderRadiusGeometry>? borderRadius,
  }) {
    // Extract border side if available and safe to access
    MixProp<BorderSide>? side;
    final borderValue = border?.value;
    if (borderValue is BoxBorderMix) {
      if (borderValue.isUniform) {
        side = borderValue.uniformBorderSide;
      }
    }

    // Handle shape conversion - only if we have a direct value
    if (shape?.hasValue == true) {
      final boxShape = (shape as Prop<BoxShape>).value;
      switch (boxShape) {
        case BoxShape.circle:
          return side != null ? MixProp(CircleBorderMix.raw(side: side)) : null;
        case BoxShape.rectangle:
          if (side != null || borderRadius != null) {
            return MixProp(
              RoundedRectangleBorderMix.raw(
                borderRadius: borderRadius,
                side: side,
              ),
            );
          }

          return null;
      }
    }

    // Default to rectangle shape if no specific shape
    if (side != null || borderRadius != null) {
      return MixProp(
        RoundedRectangleBorderMix.raw(borderRadius: borderRadius, side: side),
      );
    }

    return null;
  }

  /// Merges two DecorationMix instances with validation and type conversion support.
  ///
  /// Handles both same-type and cross-type merging:
  /// - Same type: delegates to the standard merge method
  /// - Different types: validates compatibility and performs conversion
  ///
  /// Returns the merged result or throws [ArgumentError] if merging would lose data.
  DecorationMix? tryMerge(DecorationMix? a, DecorationMix? b) {
    if (b == null) return a;
    if (a == null) return b;

    return switch ((a, b)) {
      (BoxDecorationMix a, BoxDecorationMix b) => a.merge(b),
      (ShapeDecorationMix a, ShapeDecorationMix b) => a.merge(b),
      (BoxDecorationMix a, ShapeDecorationMix b) => _mergeBoxWithShape(a, b),
      (ShapeDecorationMix a, BoxDecorationMix b) => _mergeShapeWithBox(a, b),
    };
  }
}

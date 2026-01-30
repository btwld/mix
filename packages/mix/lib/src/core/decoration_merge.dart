import 'package:flutter/material.dart';

import '../properties/painting/decoration_mix.dart';
import '../properties/painting/shape_border_mix.dart';
import 'helpers.dart';
import 'prop.dart';

/// Utility for merging DecorationMix instances with proper validation
class DecorationMerger {
  const DecorationMerger();

  /// Merges BoxDecorationMix with ShapeDecorationMix, preserving type when possible
  DecorationMix _mergeBoxWithShape(
    BuildContext _,
    BoxDecorationMix a,
    ShapeDecorationMix b,
  ) {
    final shape = b.$shape;

    if (shape == null) {
      // Keep as BoxDecorationMix - only merge common properties
      return a.merge(
        BoxDecorationMix.create(
          color: b.$color,
          image: b.$image,
          gradient: b.$gradient,
          boxShadow: b.$shadows,
        ),
      );
    }

    return ShapeDecorationMix.create(
      color: a.$color,
      image: a.$image,
      gradient: a.$gradient,
      shadows: a.$boxShadow,
    ).merge(b);
  }

  /// Merges ShapeDecorationMix with BoxDecorationMix, preserving type when possible
  DecorationMix _mergeShapeWithBox(
    BuildContext context,
    ShapeDecorationMix a,
    BoxDecorationMix b,
  ) {
    // Check if conversion is needed
    final needsConversion =
        b.$border != null ||
        b.$borderRadius != null ||
        b.$shape != null ||
        b.$backgroundBlendMode != null;

    if (!needsConversion) {
      // Keep as ShapeDecorationMix - only merge common properties
      return a.merge(
        ShapeDecorationMix.create(
          color: b.$color,
          image: b.$image,
          gradient: b.$gradient,
          shadows: b.$boxShadow,
        ),
      );
    }

    // Convert BoxDecorationMix properties to ShapeBorder
    final shapeBorder = _createShapeBorderFromBoxBorder(
      context: context,
      shape: b.$shape,
      border: b.$border,
      borderRadius: b.$borderRadius,
    );

    return a.merge(
      ShapeDecorationMix.create(
        shape: shapeBorder,
        color: b.$color,
        image: b.$image,
        gradient: b.$gradient,
        shadows: b.$boxShadow,
      ),
    );
  }

  /// Creates a ShapeBorderMix from box decoration properties using resolved values
  Prop<ShapeBorder>? _createShapeBorderFromBoxBorder({
    required BuildContext context,
    required Prop<BoxShape>? shape,
    required Prop<BoxBorder>? border,
    required Prop<BorderRadiusGeometry>? borderRadius,
  }) {
    // Extract border side using resolved values
    Prop<BorderSide>? side;
    if (border != null) {
      final resolvedBorder = MixOps.resolve(context, border);
      if (resolvedBorder is Border && resolvedBorder.isUniform) {
        side = Prop.value(resolvedBorder.top); // All sides are the same
      }
    }

    // Resolve shape to determine type
    final resolvedShape = MixOps.resolve(context, shape);

    // Handle shape conversion with resolved values
    if (resolvedShape != null) {
      switch (resolvedShape) {
        case .circle:
          return side != null
              ? Prop.mix(CircleBorderMix.create(side: side))
              : null;
        case .rectangle:
          if (side != null || borderRadius != null) {
            return Prop.mix(
              RoundedRectangleBorderMix.create(
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
      return Prop.mix(
        RoundedRectangleBorderMix.create(
          borderRadius: borderRadius,
          side: side,
        ),
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
  /// Uses BuildContext to resolve values for intelligent merge decisions.
  DecorationMix? tryMerge(
    BuildContext context,
    DecorationMix? a,
    DecorationMix? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return switch ((a, b)) {
      (BoxDecorationMix a, BoxDecorationMix b) => a.merge(b),
      (ShapeDecorationMix a, ShapeDecorationMix b) => a.merge(b),
      (BoxDecorationMix a, ShapeDecorationMix b) => _mergeBoxWithShape(
        context,
        a,
        b,
      ),
      (ShapeDecorationMix a, BoxDecorationMix b) => _mergeShapeWithBox(
        context,
        a,
        b,
      ),
    };
  }
}

import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import 'border_mix.dart';
import 'border_radius_mix.dart';
import 'decoration_image_mix.dart';
import 'decoration_mix.dart';
import 'gradient_mix.dart';
import 'shadow_mix.dart';
import 'shape_border_mix.dart';

/// Mixin that provides convenient decoration methods for styles
mixin DecorationMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T decoration(DecorationMix value);

  /// Sets background color
  T color(Color value) {
    return decoration(DecorationMix.color(value));
  }

  /// Sets gradient with any GradientMix type
  T gradient(GradientMix value) {
    return decoration(DecorationMix.gradient(value));
  }

  /// Sets border
  T border(BoxBorderMix value) {
    return decoration(DecorationMix.border(value));
  }

  /// Sets border radius
  T borderRadius(BorderRadiusGeometryMix value) {
    return decoration(DecorationMix.borderRadius(value));
  }

  /// Sets single shadow
  T shadow(BoxShadowMix value) {
    return decoration(BoxDecorationMix.boxShadow([value]));
  }

  /// Sets multiple shadows
  T shadows(List<BoxShadowMix> value) {
    return decoration(BoxDecorationMix.boxShadow(value));
  }

  /// Sets elevation shadow
  T elevation(ElevationShadow value) {
    return decoration(
      BoxDecorationMix.boxShadow(BoxShadowMix.fromElevation(value)),
    );
  }

  /// Sets image decoration
  T image(DecorationImageMix value) {
    return decoration(DecorationMix.image(value));
  }

  /// Sets box shape
  T shape(ShapeBorderMix value) {
    return decoration(ShapeDecorationMix(shape: value));
  }

  /// Sets a circular shape (CircleBorder)
  T shapeCircle({BorderSideMix? side}) {
    return shape(CircleBorderMix(side: side));
  }

  /// Sets a stadium shape (StadiumBorder)
  T shapeStadium({BorderSideMix? side}) {
    return shape(StadiumBorderMix(side: side));
  }

  /// Sets a rounded rectangle shape (RoundedRectangleBorder)
  T shapeRoundedRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      RoundedRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  /// Sets a beveled rectangle shape (BeveledRectangleBorder)
  T shapeBeveledRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      BeveledRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  /// Sets a continuous rectangle shape (ContinuousRectangleBorder)
  T shapeContinuousRectangle({
    BorderSideMix? side,
    BorderRadiusMix? borderRadius,
  }) {
    return shape(
      ContinuousRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  /// Sets a star shape (StarBorder)
  T shapeStar({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return shape(
      StarBorderMix(
        side: side,
        points: points,
        innerRadiusRatio: innerRadiusRatio,
        pointRounding: pointRounding,
        valleyRounding: valleyRounding,
        rotation: rotation,
        squash: squash,
      ),
    );
  }

  /// Sets a linear border shape (LinearBorder)
  T shapeLinear({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) {
    return shape(
      LinearBorderMix(
        side: side,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
    );
  }

  /// Sets a superellipse shape (RoundedSuperellipseBorder)
  T shapeSuperellipse({BorderSideMix? side, BorderRadiusMix? borderRadius}) {
    return shape(
      RoundedSuperellipseBorderMix(borderRadius: borderRadius, side: side),
    );
  }
}

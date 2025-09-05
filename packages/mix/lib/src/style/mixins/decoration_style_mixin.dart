import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/decoration_image_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/gradient_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shape_border_mix.dart';

/// Mixin that provides convenient decoration styling methods
mixin DecorationStyleMixin<T extends Mix<Object?>> {
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

  /// Must be implemented by the class using this mixin for foreground decorations
  T foregroundDecoration(DecorationMix value);

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

  // Background image utilities

  /// Sets a background image from an ImageProvider
  T backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return decoration(
      DecorationMix.image(
        DecorationImageMix.image(image)
            .fit(fit ?? BoxFit.cover)
            .alignment(alignment ?? Alignment.center)
            .repeat(repeat),
      ),
    );
  }

  /// Sets a background image from a network URL
  T backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return backgroundImage(
      NetworkImage(url),
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  /// Sets a background image from an asset path
  T backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return backgroundImage(
      AssetImage(path),
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  // Foreground gradient utilities

  /// Sets a foreground linear gradient
  T foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return foregroundDecoration(
      BoxDecorationMix.gradient(
        LinearGradientMix(
          begin: begin,
          end: end,
          tileMode: tileMode,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  /// Sets a foreground radial gradient
  T foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return foregroundDecoration(
      BoxDecorationMix.gradient(
        RadialGradientMix(
          center: center,
          radius: radius,
          tileMode: tileMode,
          focal: focal,
          focalRadius: focalRadius,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  /// Sets a foreground sweep gradient
  T foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return foregroundDecoration(
      BoxDecorationMix.gradient(
        SweepGradientMix(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          tileMode: tileMode,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  // Background gradient utilities

  /// Sets a background linear gradient
  T linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return decoration(
      BoxDecorationMix.gradient(
        LinearGradientMix(
          begin: begin,
          end: end,
          tileMode: tileMode,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  /// Sets a background radial gradient
  T radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return decoration(
      BoxDecorationMix.gradient(
        RadialGradientMix(
          center: center,
          radius: radius,
          tileMode: tileMode,
          focal: focal,
          focalRadius: focalRadius,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  /// Sets a background sweep gradient
  T sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return decoration(
      BoxDecorationMix.gradient(
        SweepGradientMix(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          tileMode: tileMode,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }
}
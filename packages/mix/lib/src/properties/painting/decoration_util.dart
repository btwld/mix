import 'package:flutter/material.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'border_mix.dart';
import 'border_radius_mix.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'color_util.dart';
import 'decoration_image_mix.dart';
import 'decoration_image_util.dart';
import 'decoration_mix.dart';
import 'gradient_mix.dart';
import 'gradient_util.dart';
import 'shadow_mix.dart';
import 'shadow_util.dart';
import 'shape_border_mix.dart';
import 'shape_border_util.dart';

class DecorationUtility<T extends Style<Object?>>
    extends MixUtility<T, DecorationMix> {
  late final box = BoxDecorationUtility<T>(utilityBuilder);

  late final shape = ShapeDecorationUtility<T>(utilityBuilder);

  DecorationUtility(super.utilityBuilder);

  T as(Decoration value) {
    return utilityBuilder(DecorationMix.value(value));
  }
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
@immutable
final class BoxDecorationUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxDecorationMix> {
  /// Utility for defining [BoxDecorationMix.border]
  late final border = _boxBorder.border;

  late final borderDirectional = _boxBorder.borderDirectional;

  late final borderRadius = _borderRadiusGeometry.borderRadius;

  late final borderRadiusDirectional =
      _borderRadiusGeometry.borderRadiusDirectional;

  /// Utility for defining [BoxDecorationMix.shape]
  late final shape = MixUtility<T, BoxShape>((prop) => only(shape: prop));

  /// Utility for defining [BoxDecorationMix.backgroundBlendMode]
  late final backgroundBlendMode = MixUtility<T, BlendMode>(
    (prop) => only(backgroundBlendMode: prop),
  );

  /// Utility for defining [BoxDecorationMix.color]
  late final color = ColorUtility<T>(
    (prop) => utilityBuilder(BoxDecorationMix.create(color: prop)),
  );

  /// Utility for defining [BoxDecorationMix.gradient]
  late final gradient = GradientUtility<T>((v) => only(gradient: v));

  /// Utility for defining [BoxDecorationMix.image]
  late final image = DecorationImageUtility<T>((v) => only(image: v));

  /// Utility for defining [BoxDecorationMix.boxShadow] from elevation
  late final elevation = MixUtility<T, ElevationShadow>(
    (elevation) => only(boxShadow: BoxShadowMix.fromElevation(elevation)),
  );

  late final boxShadow = BoxShadowUtility<T>((v) => only(boxShadow: [v]));

  /// Utility for defining [BoxDecorationMix.borderRadius]
  late final _borderRadiusGeometry = BorderRadiusGeometryUtility<T>(
    (v) => only(borderRadius: v),
  );

  late final _boxBorder = BoxBorderUtility<T>((v) => only(border: v));

  BoxDecorationUtility(super.utilityBuilder);

  /// Utility for defining [BoxDecorationMix.boxShadow] from a list of BoxShadow

  T boxShadows(List<BoxShadow> shadows) {
    return only(boxShadow: shadows.map(BoxShadowMix.value).toList());
  }

  T only({
    Color? color,
    DecorationImageMix? image,
    BoxBorderMix? border,
    BorderRadiusGeometryMix? borderRadius,
    List<BoxShadowMix>? boxShadow,
    GradientMix? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    return utilityBuilder(
      BoxDecorationMix(
        border: border,
        borderRadius: borderRadius,
        shape: shape,
        backgroundBlendMode: backgroundBlendMode,
        color: color,
        image: image,
        gradient: gradient,
        boxShadow: boxShadow,
      ),
    );
  }

  T call({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    return only(
      color: color,
      image: DecorationImageMix.maybeValue(image),
      border: BoxBorderMix.maybeValue(border),
      borderRadius: BorderRadiusGeometryMix.maybeValue(borderRadius),
      boxShadow: boxShadow?.map(BoxShadowMix.value).toList(),
      gradient: GradientMix.maybeValue(gradient),
      backgroundBlendMode: backgroundBlendMode,
      shape: shape,
    );
  }

  T as(BoxDecoration value) {
    return utilityBuilder(BoxDecorationMix.value(value));
  }
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
@immutable
final class ShapeDecorationUtility<T extends Style<Object?>>
    extends MixUtility<T, ShapeDecorationMix> {
  /// Utility for defining [ShapeDecorationMix.shape]
  late final shape = ShapeBorderUtility<T>((v) => only(shape: v));

  /// Utility for defining [ShapeDecorationMix.color]
  late final color = ColorUtility<T>(
    (prop) => utilityBuilder(ShapeDecorationMix.create(color: prop)),
  );

  /// Utility for defining [ShapeDecorationMix.image]
  late final image = DecorationImageUtility<T>((v) => only(image: v));

  /// Utility for defining [ShapeDecorationMix.gradient]
  late final gradient = GradientUtility<T>((v) => only(gradient: v));

  /// Utility for defining [ShapeDecorationMix.$shadows]
  late final shadows = MixUtility<T, List<BoxShadowMix>>(
    (prop) => only(shadows: prop),
  );

  ShapeDecorationUtility(super.utilityBuilder);

  T only({
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? shadows,
    ShapeBorderMix? shape,
  }) {
    return utilityBuilder(
      ShapeDecorationMix(
        shape: shape,
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      ),
    );
  }

  T call({
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? shadows,
    ShapeBorder? shape,
  }) {
    return only(
      color: color,
      image: DecorationImageMix.maybeValue(image),
      gradient: GradientMix.maybeValue(gradient),
      shadows: shadows?.map(BoxShadowMix.value).toList(),
      shape: ShapeBorderMix.maybeValue(shape),
    );
  }

  T as(ShapeDecoration value) {
    return utilityBuilder(ShapeDecorationMix.value(value));
  }
}

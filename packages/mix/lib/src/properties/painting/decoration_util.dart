import 'package:flutter/material.dart';

import '../../core/prop.dart';
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
    extends MixPropUtility<T, Decoration> {
  late final box = BoxDecorationUtility<T>(builder);

  late final shape = ShapeDecorationUtility<T>(builder);

  DecorationUtility(super.builder) : super(convertToMix: DecorationMix.value);

  T call(DecorationMix value) {
    return builder(MixProp(value));
  }
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
@immutable
final class BoxDecorationUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BoxDecoration> {
  /// Utility for defining [BoxDecorationMix.border]
  late final border = _boxBorder.border;

  late final borderDirectional = _boxBorder.borderDirectional;

  late final borderRadius = _borderRadiusGeometry.borderRadius;

  late final borderRadiusDirectional =
      _borderRadiusGeometry.borderRadiusDirectional;

  /// Utility for defining [BoxDecorationMix.shape]
  late final shape = PropUtility<T, BoxShape>((prop) => onlyProps(shape: prop));

  /// Utility for defining [BoxDecorationMix.backgroundBlendMode]
  late final backgroundBlendMode = PropUtility<T, BlendMode>(
    (prop) => onlyProps(backgroundBlendMode: prop),
  );

  /// Utility for defining [BoxDecorationMix.color]
  late final color = ColorUtility<T>((prop) => onlyProps(color: prop));

  /// Utility for defining [BoxDecorationMix.gradient]
  late final gradient = GradientUtility<T>((v) => onlyProps(gradient: v));

  /// Utility for defining [BoxDecorationMix.image]
  late final image = DecorationImageUtility<T>((v) => onlyProps(image: v));

  /// Utility for defining [BoxDecorationMix.boxShadow] from a list of BoxShadow
  late final boxShadows = MixPropListUtility<T, BoxShadow>(
    (prop) => onlyProps(boxShadow: prop),
    BoxShadowMix.value,
  );

  /// Utility for defining individual [BoxShadow]
  late final boxShadow = BoxShadowUtility<T>((v) => onlyProps(boxShadow: [v]));

  /// Utility for defining [BoxDecorationMix.boxShadow] from elevation
  late final elevation = ElevationMixPropUtility<T>(
    (mixPropList) => onlyProps(boxShadow: mixPropList),
  );

  /// Utility for defining [BoxDecorationMix.borderRadius]
  late final _borderRadiusGeometry = BorderRadiusGeometryUtility<T>(
    (v) => onlyProps(borderRadius: v),
  );

  late final _boxBorder = BoxBorderUtility<T>((v) => onlyProps(border: v));

  BoxDecorationUtility(super.builder)
    : super(convertToMix: BoxDecorationMix.value);

  @protected
  T onlyProps({
    Prop<Color>? color,
    MixProp<DecorationImage>? image,
    MixProp<BoxBorder>? border,
    MixProp<BorderRadiusGeometry>? borderRadius,
    List<MixProp<BoxShadow>>? boxShadow,
    MixProp<Gradient>? gradient,
    Prop<BlendMode>? backgroundBlendMode,
    Prop<BoxShape>? shape,
  }) {
    return builder(
      MixProp(
        BoxDecorationMix.raw(
          border: border,
          borderRadius: borderRadius,
          shape: shape,
          backgroundBlendMode: backgroundBlendMode,
          color: color,
          image: image,
          gradient: gradient,
          boxShadow: boxShadow,
        ),
      ),
    );
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
    return onlyProps(
      color: Prop.maybe(color),
      image: MixProp.maybe(image),
      border: MixProp.maybe(border),
      borderRadius: MixProp.maybe(borderRadius),
      boxShadow: boxShadow?.map(MixProp<BoxShadow>.new).toList(),
      gradient: MixProp.maybe(gradient),
      backgroundBlendMode: Prop.maybe(backgroundBlendMode),
      shape: Prop.maybe(shape),
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
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
@immutable
final class ShapeDecorationUtility<T extends Style<Object?>>
    extends MixPropUtility<T, ShapeDecoration> {
  /// Utility for defining [ShapeDecorationMix.shape]
  late final shape = ShapeBorderUtility<T>((v) => onlyProps(shape: v));

  /// Utility for defining [ShapeDecorationMix.color]
  late final color = ColorUtility<T>((prop) => onlyProps(color: prop));

  /// Utility for defining [ShapeDecorationMix.image]
  late final image = DecorationImageUtility<T>((v) => onlyProps(image: v));

  /// Utility for defining [ShapeDecorationMix.gradient]
  late final gradient = GradientUtility<T>((v) => onlyProps(gradient: v));

  /// Utility for defining [ShapeDecorationMix.shadows]
  late final shadows = MixPropListUtility<T, BoxShadow>(
    (prop) => onlyProps(shadows: prop),
    BoxShadowMix.value,
  );

  ShapeDecorationUtility(super.builder)
    : super(convertToMix: ShapeDecorationMix.value);

  @protected
  T onlyProps({
    Prop<Color>? color,
    MixProp<DecorationImage>? image,
    MixProp<Gradient>? gradient,
    List<MixProp<BoxShadow>>? shadows,
    MixProp<ShapeBorder>? shape,
  }) {
    return builder(
      MixProp(
        ShapeDecorationMix.raw(
          shape: shape,
          color: color,
          image: image,
          gradient: gradient,
          shadows: shadows,
        ),
      ),
    );
  }

  T only({
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? shadows,
    ShapeBorderMix? shape,
  }) {
    return onlyProps(
      color: Prop.maybe(color),
      image: MixProp.maybe(image),
      gradient: MixProp.maybe(gradient),
      shadows: shadows?.map(MixProp<BoxShadow>.new).toList(),
      shape: MixProp.maybe(shape),
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
}

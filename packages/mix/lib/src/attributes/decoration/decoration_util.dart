import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/utility.dart';
import '../border/border_radius_util.dart';
import '../border/border_util.dart';
import '../border/shape_border_util.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../gradient/gradient_util.dart';
import '../shadow/shadow_util.dart';
import 'decoration_dto.dart';
import 'image/decoration_image_util.dart';

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
@immutable
final class BoxDecorationUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, BoxDecoration> {
  /// Utility for defining [BoxDecorationDto.border]
  late final border = BoxBorderUtility<T>(
    (v) => call(BoxDecorationDto(border: v)),
  );

  /// Utility for defining [BoxDecorationDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(BoxDecorationDto(borderRadius: v)),
  );

  /// Utility for defining [BoxDecorationDto.shape]
  late final shape = BoxShapeUtility<T>(
    (prop) => call(BoxDecorationDto(shape: prop)),
  );

  /// Utility for defining [BoxDecorationDto.backgroundBlendMode]
  late final backgroundBlendMode = BlendModeUtility<T>(
    (prop) => call(BoxDecorationDto(backgroundBlendMode: prop)),
  );

  /// Utility for defining [BoxDecorationDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(BoxDecorationDto(color: prop)),
  );

  /// Utility for defining [BoxDecorationDto.gradient]
  late final gradient = GradientUtility<T>(
    (v) => call(BoxDecorationDto(gradient: v)),
  );

  /// Utility for defining [BoxDecorationDto.image]
  late final image = DecorationImageUtility<T>(
    (v) => call(BoxDecorationDto(image: v)),
  );

  /// Utility for defining [BoxDecorationDto.boxShadow] from a list of BoxShadow
  late final boxShadows = BoxShadowMixPropListUtility<T>(
    (mixPropList) => call(BoxDecorationDto(boxShadow: mixPropList)),
  );

  /// Utility for defining individual [BoxShadow]
  late final boxShadow = BoxShadowUtility<T>(
    (v) => call(BoxDecorationDto(boxShadow: [v])),
  );

  /// Utility for defining [BoxDecorationDto.boxShadow] from elevation
  late final elevation = ElevationMixPropUtility<T>(
    (mixPropList) => call(BoxDecorationDto(boxShadow: mixPropList)),
  );

  BoxDecorationUtility(super.builder)
    : super(valueToDto: BoxDecorationDto.value);

  @override
  T call(BoxDecorationDto value) => builder(MixProp(value));
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
@immutable
final class ShapeDecorationUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, ShapeDecoration> {
  /// Utility for defining [ShapeDecorationDto.shape]
  late final shape = ShapeBorderUtility<T>((v) => only(shape: v));

  /// Utility for defining [ShapeDecorationDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(ShapeDecorationDto(color: prop)),
  );

  /// Utility for defining [ShapeDecorationDto.image]
  late final image = DecorationImageUtility<T>((v) => only(image: v));

  /// Utility for defining [ShapeDecorationDto.gradient]
  late final gradient = GradientUtility<T>((v) => only(gradient: v));

  /// Utility for defining [ShapeDecorationDto.shadows]
  late final shadows = BoxShadowMixPropListUtility<T>((v) => only(shadows: v));

  ShapeDecorationUtility(super.builder)
    : super(valueToDto: ShapeDecorationDto.value);

  T only({
    MixProp<ShapeBorder>? shape,
    Prop<Color>? color,
    MixProp<DecorationImage>? image,
    MixProp<Gradient>? gradient,
    List<MixProp<BoxShadow>>? shadows,
  }) {
    return call(
      ShapeDecorationDto(
        shape: shape,
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      ),
    );
  }

  @override
  T call(ShapeDecorationDto value) => builder(MixProp(value));
}

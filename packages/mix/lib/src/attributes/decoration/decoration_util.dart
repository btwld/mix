import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/utility.dart';
import '../border/border_radius_util.dart';
import '../border/border_util.dart';
import '../border/shape_border_dto.dart';
import '../border/shape_border_util.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../gradient/gradient_dto.dart';
import '../gradient/gradient_util.dart';
import '../shadow/shadow_dto.dart';
import '../shadow/shadow_util.dart';
import 'decoration_dto.dart';
import 'image/decoration_image_dto.dart';
import 'image/decoration_image_util.dart';

class DecorationUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, DecorationDto> {
  const DecorationUtility(super.builder);
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
@immutable
final class BoxDecorationUtility<T extends SpecUtility<Object?>>
    extends MixPropUtility<T, BoxDecoration> {
  /// Utility for defining [BoxDecorationDto.border]
  late final border = BoxBorderUtility<T>(
    (v) => call(BoxDecorationDto(border: v, color: null)),
  );

  /// Utility for defining [BoxDecorationDto.border.directional]
  late final borderDirectional = border.directional;

  /// Utility for defining [BoxDecorationDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(BoxDecorationDto(borderRadius: v, color: null)),
  );

  /// Utility for defining [BoxDecorationDto.borderRadius.directional]
  late final borderRadiusDirectional = borderRadius.directional;

  /// Utility for defining [BoxDecorationDto.shape]
  late final shape = BoxShapeUtility<T>(
    (v) => call(BoxDecorationDto(shape: v, color: null)),
  );

  /// Utility for defining [BoxDecorationDto.backgroundBlendMode]
  late final backgroundBlendMode = BlendModeUtility<T>(
    (v) => call(BoxDecorationDto(backgroundBlendMode: v, color: null)),
  );

  /// Utility for defining [BoxDecorationDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(BoxDecorationDto(color: prop)),
  );

  /// Utility for defining [BoxDecorationDto.image]
  late final image = DecorationImageUtility<T>(
    (v) => call(BoxDecorationDto(image: v)),
  );

  /// Utility for defining [BoxDecorationDto.gradient]
  late final gradient = GradientUtility<T>(
    (v) => call(BoxDecorationDto(gradient: v)),
  );

  /// Utility for defining [BoxDecorationDto.boxShadow]
  late final boxShadows = BoxShadowListUtility<T>(
    (v) => call(BoxDecorationDto(boxShadow: v)),
  );

  /// Utility for defining [BoxDecorationDto.boxShadows.add]
  late final boxShadow = boxShadows.add;

  /// Utility for defining [BoxDecorationDto.boxShadow]
  late final elevation = ElevationUtility<T>(
    (v) => call(BoxDecorationDto(boxShadow: v)),
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
  late final shape = ShapeBorderUtility((v) => only(shape: v));

  /// Utility for defining [ShapeDecorationDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(ShapeDecorationDto(color: prop)),
  );

  /// Utility for defining [ShapeDecorationDto.image]
  late final image = DecorationImageUtility((v) => only(image: v));

  /// Utility for defining [ShapeDecorationDto.gradient]
  late final gradient = GradientUtility((v) => only(gradient: v));

  /// Utility for defining [ShapeDecorationDto.shadows]
  late final shadows = BoxShadowListUtility((v) => only(shadows: v));

  ShapeDecorationUtility(super.builder)
    : super(valueToDto: ShapeDecorationDto.value);

  T only({
    ShapeBorderDto? shape,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
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
  T call(ShapeDecorationDto value) {
    return builder(MixProp(value));
  }
}

import 'package:flutter/widgets.dart';

import '../../core/spec.dart';
import '../../core/utility.dart';
import '../border/border_dto.dart';
import '../border/border_radius_dto.dart';
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

class DecorationUtility<T extends SpecAttribute>
    extends MixUtility<T, DecorationDto> {
  const DecorationUtility(super.builder);

  BoxDecorationUtility<T> get box => BoxDecorationUtility(builder);

  ShapeDecorationUtility<T> get shape => ShapeDecorationUtility(builder);
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
class BoxDecorationUtility<T extends SpecAttribute>
    extends DtoUtility<T, BoxDecorationDto, BoxDecoration> {
  /// Utility for defining [BoxDecorationDto.border]
  late final border = BoxBorderUtility((v) => only(border: v));

  /// Utility for defining [BoxDecorationDto.border.directional]
  late final borderDirectional = border.directional;

  /// Utility for defining [BoxDecorationDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [BoxDecorationDto.borderRadius.directional]
  late final borderRadiusDirectional = borderRadius.directional;

  /// Utility for defining [BoxDecorationDto.shape]
  late final shape = BoxShapeUtility((v) => only(shape: v));

  /// Utility for defining [BoxDecorationDto.backgroundBlendMode]
  late final backgroundBlendMode = BlendModeUtility(
    (v) => only(backgroundBlendMode: v),
  );

  /// Utility for defining [BoxDecorationDto.color]
  late final color = ColorUtility(
    (prop) => builder(BoxDecorationDto.props(color: prop)),
  );

  /// Utility for defining [BoxDecorationDto.image]
  late final image = DecorationImageUtility((v) => only(image: v));

  /// Utility for defining [BoxDecorationDto.gradient]
  late final gradient = GradientUtility((v) => only(gradient: v));

  /// Utility for defining [BoxDecorationDto.boxShadow]
  late final boxShadows = BoxShadowListUtility((v) => only(boxShadow: v));

  /// Utility for defining [BoxDecorationDto.boxShadows.add]
  late final boxShadow = boxShadows.add;

  /// Utility for defining [BoxDecorationDto.boxShadow]
  late final elevation = ElevationUtility((v) => only(boxShadow: v));

  BoxDecorationUtility(super.builder)
    : super(
        valueToDto: (v) => throw UnimplementedError(
          'BoxDecoration to DTO conversion not implemented yet. Use only() method instead.',
        ),
      );

  T call({
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
  }) {
    return only(
      border: border != null ? this.border.fromValue(border) : null,
      borderRadius: borderRadius != null
          ? this.borderRadius.fromValue(borderRadius)
          : null,
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: color,
      image: image != null ? this.image.fromValue(image) : null,
      gradient: gradient != null
          ? switch (gradient) {
              LinearGradient() => this.gradient.linear.fromValue(gradient),
              RadialGradient() => this.gradient.radial.fromValue(gradient),
              SweepGradient() => this.gradient.sweep.fromValue(gradient),
              _ => throw ArgumentError(
                'Unsupported gradient type: ${gradient.runtimeType}',
              ),
            }
          : null,
      boxShadow: boxShadow
          ?.map(
            (shadow) => BoxShadowDto(
              color: shadow.color != const Color(0xFF000000)
                  ? shadow.color
                  : null,
              offset: shadow.offset != Offset.zero ? shadow.offset : null,
              blurRadius: shadow.blurRadius != 0.0 ? shadow.blurRadius : null,
              spreadRadius: shadow.spreadRadius != 0.0
                  ? shadow.spreadRadius
                  : null,
            ),
          )
          .toList(),
    );
  }

  /// Returns a new [BoxDecorationDto] with the specified properties.
  @override
  T only({
    BoxBorderDto? border,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? boxShadow,
  }) {
    return builder(
      BoxDecorationDto(
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
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
class ShapeDecorationUtility<T extends SpecAttribute>
    extends DtoUtility<T, ShapeDecorationDto, ShapeDecoration> {
  /// Utility for defining [ShapeDecorationDto.shape]
  late final shape = ShapeBorderUtility((v) => only(shape: v));

  /// Utility for defining [ShapeDecorationDto.color]
  late final color = ColorUtility(
    (prop) => builder(ShapeDecorationDto.props(color: prop)),
  );

  /// Utility for defining [ShapeDecorationDto.image]
  late final image = DecorationImageUtility((v) => only(image: v));

  /// Utility for defining [ShapeDecorationDto.gradient]
  late final gradient = GradientUtility((v) => only(gradient: v));

  /// Utility for defining [ShapeDecorationDto.shadows]
  late final shadows = BoxShadowListUtility((v) => only(shadows: v));

  ShapeDecorationUtility(super.builder)
    : super(
        valueToDto: (v) => throw UnimplementedError(
          'ShapeDecoration to DTO conversion not implemented yet. Use only() method instead.',
        ),
      );

  T call({
    ShapeBorder? shape,
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? shadows,
  }) {
    return only(
      shape: shape != null
          ? switch (shape) {
              RoundedRectangleBorder() => this.shape.roundedRectangle.fromValue(
                shape,
              ),
              BeveledRectangleBorder() => this.shape.beveled.fromValue(shape),
              ContinuousRectangleBorder() => this.shape.continuous.fromValue(
                shape,
              ),
              CircleBorder() => this.shape.circle.fromValue(shape),
              StadiumBorder() => this.shape.stadium.fromValue(shape),
              StarBorder() => this.shape.star.fromValue(shape),
              LinearBorder() => this.shape.linear.fromValue(shape),
              _ => throw ArgumentError(
                'Unsupported shape border type: ${shape.runtimeType}',
              ),
            }
          : null,
      color: color,
      image: image != null ? this.image.fromValue(image) : null,
      gradient: gradient != null
          ? switch (gradient) {
              LinearGradient() => this.gradient.linear.fromValue(gradient),
              RadialGradient() => this.gradient.radial.fromValue(gradient),
              SweepGradient() => this.gradient.sweep.fromValue(gradient),
              _ => throw ArgumentError(
                'Unsupported gradient type: ${gradient.runtimeType}',
              ),
            }
          : null,
      shadows: shadows
          ?.map(
            (shadow) => BoxShadowDto(
              color: shadow.color != const Color(0xFF000000)
                  ? shadow.color
                  : null,
              offset: shadow.offset != Offset.zero ? shadow.offset : null,
              blurRadius: shadow.blurRadius != 0.0 ? shadow.blurRadius : null,
              spreadRadius: shadow.spreadRadius != 0.0
                  ? shadow.spreadRadius
                  : null,
            ),
          )
          .toList(),
    );
  }

  /// Returns a new [ShapeDecorationDto] with the specified properties.
  @override
  T only({
    ShapeBorderDto? shape,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
  }) {
    return builder(
      ShapeDecorationDto(
        shape: shape,
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      ),
    );
  }
}

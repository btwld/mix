import 'package:flutter/material.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'color/color_util.dart';
import 'decoration_dto.dart';
import 'decoration_image_util.dart';
import 'gradient_util.dart';
import 'scalar_util.dart';
import 'shadow_dto.dart';
import 'shadow_util.dart';
import 'shape_border_util.dart';

class DecorationUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, Decoration> {
  late final box = BoxDecorationUtility<T>(builder);

  late final shape = ShapeDecorationUtility<T>(builder);

  DecorationUtility(super.builder) : super(convertToMix: DecorationDto.value);

  @override
  T call(DecorationDto value) {
    return builder(MixProp(value));
  }
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
@immutable
final class BoxDecorationUtility<T extends SpecAttribute<Object?>>
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
  late final boxShadows = MixPropListUtility<T, BoxShadow, BoxShadowDto>(
    (prop) => call(BoxDecorationDto(boxShadow: prop)),
    BoxShadowDto.value,
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
    : super(convertToMix: BoxDecorationDto.value);

  @override
  T call(BoxDecorationDto value) => builder(MixProp(value));
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
@immutable
final class ShapeDecorationUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, ShapeDecoration> {
  /// Utility for defining [ShapeDecorationDto.shape]
  late final shape = ShapeBorderUtility<T>(
    (v) => call(ShapeDecorationDto(shape: v)),
  );

  /// Utility for defining [ShapeDecorationDto.color]
  late final color = ColorUtility<T>(
    (prop) => call(ShapeDecorationDto(color: prop)),
  );

  /// Utility for defining [ShapeDecorationDto.image]
  late final image = DecorationImageUtility<T>(
    (v) => call(ShapeDecorationDto(image: v)),
  );

  /// Utility for defining [ShapeDecorationDto.gradient]
  late final gradient = GradientUtility<T>(
    (v) => call(ShapeDecorationDto(gradient: v)),
  );

  /// Utility for defining [ShapeDecorationDto.shadows]
  late final shadows = MixPropListUtility<T, BoxShadow, BoxShadowDto>(
    (prop) => call(ShapeDecorationDto(shadows: prop)),
    BoxShadowDto.value,
  );

  ShapeDecorationUtility(super.builder)
    : super(convertToMix: ShapeDecorationDto.value);

  @override
  T call(ShapeDecorationDto value) => builder(MixProp(value));
}

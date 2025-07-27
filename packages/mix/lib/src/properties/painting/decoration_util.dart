import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'color_util.dart';
import 'decoration_image_util.dart';
import 'decoration_mix.dart';
import 'gradient_util.dart';
import 'shadow_mix.dart';
import 'shadow_util.dart';
import 'shape_border_util.dart';

class DecorationUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, Decoration> {
  late final box = BoxDecorationUtility<T>(builder);

  late final shape = ShapeDecorationUtility<T>(builder);

  DecorationUtility(super.builder) : super(convertToMix: DecorationMix.value);

  @override
  T call(DecorationMix value) {
    return builder(MixProp(value));
  }
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
@immutable
final class BoxDecorationUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BoxDecoration> {
  /// Utility for defining [BoxDecorationMix.border]
  late final border = _boxBorder.border;

  late final borderDirectional = _boxBorder.borderDirectional;

  late final borderRadius = _borderRadiusGeometry.borderRadius;

  late final borderRadiusDirectional =
      _borderRadiusGeometry.borderRadiusDirectional;

  /// Utility for defining [BoxDecorationMix.shape]
  late final shape = PropUtility<T, BoxShape>(
    (prop) => call(BoxDecorationMix(shape: prop)),
  );

  /// Utility for defining [BoxDecorationMix.backgroundBlendMode]
  late final backgroundBlendMode = PropUtility<T, BlendMode>(
    (prop) => call(BoxDecorationMix(backgroundBlendMode: prop)),
  );

  /// Utility for defining [BoxDecorationMix.color]
  late final color = ColorUtility<T>(
    (prop) => call(BoxDecorationMix(color: prop)),
  );

  /// Utility for defining [BoxDecorationMix.gradient]
  late final gradient = GradientUtility<T>(
    (v) => call(BoxDecorationMix(gradient: v)),
  );

  /// Utility for defining [BoxDecorationMix.image]
  late final image = DecorationImageUtility<T>(
    (v) => call(BoxDecorationMix(image: v)),
  );

  /// Utility for defining [BoxDecorationMix.boxShadow] from a list of BoxShadow
  late final boxShadows = MixPropListUtility<T, BoxShadow>(
    (prop) => call(BoxDecorationMix(boxShadow: prop)),
    BoxShadowMix.value,
  );

  /// Utility for defining individual [BoxShadow]
  late final boxShadow = BoxShadowUtility<T>(
    (v) => call(BoxDecorationMix(boxShadow: [v])),
  );

  /// Utility for defining [BoxDecorationMix.boxShadow] from elevation
  late final elevation = ElevationMixPropUtility<T>(
    (mixPropList) => call(BoxDecorationMix(boxShadow: mixPropList)),
  );

  /// Utility for defining [BoxDecorationMix.borderRadius]
  late final _borderRadiusGeometry = BorderRadiusGeometryUtility<T>(
    (v) => call(BoxDecorationMix(borderRadius: v)),
  );

  late final _boxBorder = BoxBorderUtility<T>(
    (v) => call(BoxDecorationMix(border: v)),
  );

  BoxDecorationUtility(super.builder)
    : super(convertToMix: BoxDecorationMix.value);

  @override
  T call(BoxDecorationMix value) => builder(MixProp(value));
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
@immutable
final class ShapeDecorationUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, ShapeDecoration> {
  /// Utility for defining [ShapeDecorationMix.shape]
  late final shape = ShapeBorderUtility<T>(
    (v) => call(ShapeDecorationMix(shape: v)),
  );

  /// Utility for defining [ShapeDecorationMix.color]
  late final color = ColorUtility<T>(
    (prop) => call(ShapeDecorationMix(color: prop)),
  );

  /// Utility for defining [ShapeDecorationMix.image]
  late final image = DecorationImageUtility<T>(
    (v) => call(ShapeDecorationMix(image: v)),
  );

  /// Utility for defining [ShapeDecorationMix.gradient]
  late final gradient = GradientUtility<T>(
    (v) => call(ShapeDecorationMix(gradient: v)),
  );

  /// Utility for defining [ShapeDecorationMix.shadows]
  late final shadows = MixPropListUtility<T, BoxShadow>(
    (prop) => call(ShapeDecorationMix(shadows: prop)),
    BoxShadowMix.value,
  );

  ShapeDecorationUtility(super.builder)
    : super(convertToMix: ShapeDecorationMix.value);

  @override
  T call(ShapeDecorationMix value) => builder(MixProp(value));
}

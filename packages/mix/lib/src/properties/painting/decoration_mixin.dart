import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import 'border_mix.dart';
import 'decoration_image_mix.dart';
import 'decoration_mix.dart';
import 'gradient_mix.dart';
import 'shadow_mix.dart';
import 'shape_border_mix.dart';

/// Mixin that provides convenient decoration methods for styles
mixin DecorationMixin<T extends Style<Object?>> {
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

}
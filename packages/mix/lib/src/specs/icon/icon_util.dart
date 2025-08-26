import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/wrapped_widget_spec.dart';
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shadow_util.dart';
import '../../variants/variant_util.dart';
import 'icon_attribute.dart';
import 'icon_spec.dart';

/// Provides mutable utility for icon styling with cascade notation support.
///
/// Supports the same API as [IconStyle] but maintains mutable internal state
/// enabling fluid styling: `$icon..color(Colors.blue)..size(24)..weight(400)`.
class IconSpecUtility extends StyleMutableBuilder<IconSpec> {
  late final color = ColorUtility<IconStyle>(
    (prop) => mutable.merge(IconStyle.create(color: prop)),
  );

  late final shadow = ShadowUtility<IconStyle>((v) => mutable.shadows([v]));

  late final textDirection = MixUtility(mutable.textDirection);

  late final on = OnContextVariantUtility<IconSpec, IconStyle>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating icon styling properties.
  @override
  @protected
  late final MutableIconStyle mutable;

  IconSpecUtility([IconStyle? attribute]) {
    mutable = MutableIconStyle(attribute ?? IconStyle());
  }

  IconStyle size(double v) => mutable.size(v);

  IconStyle weight(double v) => mutable.weight(v);

  IconStyle grade(double v) => mutable.grade(v);

  IconStyle opticalSize(double v) => mutable.opticalSize(v);

  IconStyle applyTextScaling(bool v) => mutable.applyTextScaling(v);

  IconStyle fill(double v) => mutable.fill(v);

  /// Applies multiple shadows to the icon.
  IconStyle shadows(List<ShadowMix> value) => mutable.shadows(value);

  /// Applies animation configuration to the icon styling.
  IconStyle animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is IconStyle) {
      return IconSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  WrappedWidgetSpec<IconSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [IconStyle] with all applied styling properties.
  @override
  IconStyle get value => mutable.value;
}

class MutableIconStyle extends IconStyle with Mutable<IconSpec, IconStyle> {
  MutableIconStyle(IconStyle style) {
    value = style;
  }
}

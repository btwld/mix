import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/widget_decorator_config.dart';
import '../../modifiers/widget_decorator_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shadow_util.dart';
import '../../variants/variant_util.dart';
import 'icon_attribute.dart';
import 'icon_spec.dart';

/// Provides mutable utility for icon styling with cascade notation support.
///
/// Supports the same API as [IconMix] but maintains mutable internal state
/// enabling fluid styling: `$icon..color(Colors.blue)..size(24)..weight(400)`.
class IconSpecUtility extends StyleMutableBuilder<IconSpec> {
  late final color = ColorUtility<IconMix>(
    (prop) => mutable.merge(IconMix.raw(color: prop)),
  );

  late final shadow = ShadowUtility<IconMix>((v) => mutable.shadows([v]));

  late final textDirection = MixUtility(mutable.textDirection);

  late final on = OnContextVariantUtility<IconSpec, IconMix>(
    (v) => mutable.variants([v]),
  );

  late final wrap = WidgetDecoratorUtility(
    (prop) => mutable.modifier(WidgetDecoratorConfig(decorators: [prop])),
  );

  /// Internal mutable state for accumulating icon styling properties.
  @override
  @protected
  late final MutableIconMix mutable;

  IconSpecUtility([IconMix? attribute]) {
    mutable = MutableIconMix(attribute ?? IconMix());
  }

  IconMix size(double v) => mutable.size(v);

  IconMix weight(double v) => mutable.weight(v);

  IconMix grade(double v) => mutable.grade(v);

  IconMix opticalSize(double v) => mutable.opticalSize(v);

  IconMix applyTextScaling(bool v) => mutable.applyTextScaling(v);

  IconMix fill(double v) => mutable.fill(v);

  /// Applies multiple shadows to the icon.
  IconMix shadows(List<ShadowMix> value) => mutable.shadows(value);

  /// Applies animation configuration to the icon styling.
  IconMix animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is IconMix) {
      return IconSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  IconSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [IconMix] with all applied styling properties.
  @override
  IconMix get value => mutable.value;
}

class MutableIconMix extends IconMix with Mutable<IconSpec, IconMix> {
  MutableIconMix(IconMix style) {
    value = style;
  }
}

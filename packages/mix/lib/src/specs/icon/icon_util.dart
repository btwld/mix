import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
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

/// Mutable utility class for icon styling using composition over inheritance.
///
/// Same API as IconMix but with mutable internal state
/// for cascade notation support: `$icon..color(Colors.blue)..size(24)..weight(400)`
class IconSpecUtility extends StyleMutableBuilder<IconSpec> {
  // ICON UTILITIES - Same as IconMix but return IconSpecUtility for cascade
  @override
  @protected
  late final MutableIconMix mix;

  late final color = ColorUtility<IconMix>(
    (prop) => mix.merge(IconMix.raw(color: prop)),
  );

  late final size = MixUtility(mix.size);

  late final weight = MixUtility(mix.weight);

  late final grade = MixUtility(mix.grade);

  late final opticalSize = MixUtility(mix.opticalSize);

  late final shadow = ShadowUtility<IconMix>((v) => mix.shadows([v]));

  late final textDirection = MixUtility(mix.textDirection);

  late final applyTextScaling = MixUtility(mix.applyTextScaling);

  late final fill = MixUtility(mix.fill);

  late final on = OnContextVariantUtility<IconSpec, IconMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
  );

  IconSpecUtility([IconMix? attribute]) {
    mix = MutableIconMix(attribute ?? IconMix());
  }

  // Instance method for multiple shadows
  IconMix shadows(List<ShadowMix> value) => mix.shadows(value);

  /// Animation
  IconMix animate(AnimationConfig animation) => mix.animate(animation);

  // StyleAttribute interface implementation

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(mix.merge(other.mix));
    }
    if (other is IconMix) {
      return IconSpecUtility(mix.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  IconSpec resolve(BuildContext context) {
    return mix.resolve(context);
  }
}

class MutableIconMix extends IconMix with Mutable<IconSpec, IconMix> {
  MutableIconMix([IconMix? attribute]) {
    merge(attribute);
  }
}

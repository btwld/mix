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
  late final MutableIconMix value;

  late final color = ColorUtility<IconMix>(
    (prop) => value.merge(IconMix.raw(color: prop)),
  );

  late final size = MixUtility(value.size);

  late final weight = MixUtility(value.weight);

  late final grade = MixUtility(value.grade);

  late final opticalSize = MixUtility(value.opticalSize);

  late final shadow = ShadowUtility<IconMix>((v) => value.shadows([v]));

  late final textDirection = MixUtility(value.textDirection);

  late final applyTextScaling = MixUtility(value.applyTextScaling);

  late final fill = MixUtility(value.fill);

  late final on = OnContextVariantUtility<IconSpec, IconMix>(
    (v) => value.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => value.modifier(ModifierConfig(modifiers: [prop])),
  );

  IconSpecUtility([IconMix? attribute]) {
    value = MutableIconMix(attribute ?? IconMix());
  }

  // Instance method for multiple shadows
  IconMix shadows(List<ShadowMix> value) => this.value.shadows(value);

  /// Animation
  IconMix animate(AnimationConfig animation) => value.animate(animation);

  // StyleAttribute interface implementation

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(value.merge(other.value));
    }
    if (other is IconMix) {
      return IconSpecUtility(value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  IconSpec resolve(BuildContext context) {
    return value.resolve(context);
  }
}

class MutableIconMix extends IconMix with Mutable<IconSpec, IconMix> {
  MutableIconMix([IconMix? attribute]) {
    merge(attribute);
  }
}

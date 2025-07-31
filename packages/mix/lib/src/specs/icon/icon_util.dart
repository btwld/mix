import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
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
class IconSpecUtility extends StyleAttributeBuilder<IconSpec> {
  // ICON UTILITIES - Same as IconMix but return IconSpecUtility for cascade

  late final color = ColorUtility<IconMix>(
    (prop) => style.merge(IconMix.raw(color: prop)),
  );

  late final size = MixUtility(style.size);

  late final weight = MixUtility(style.weight);

  late final grade = MixUtility(style.grade);

  late final opticalSize = MixUtility(style.opticalSize);

  late final shadow = ShadowUtility<IconMix>((v) => style.shadows([v]));

  late final textDirection = MixUtility(style.textDirection);

  late final applyTextScaling = MixUtility(style.applyTextScaling);

  late final fill = MixUtility(style.fill);

  late final on = OnContextVariantUtility<IconSpec, IconMix>(
    (v) => style.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => style.modifier(ModifierConfig(modifiers: [prop])),
  );

  // ignore: prefer_final_fields
  @override
  IconMix style;

  IconSpecUtility([IconMix? attribute]) : style = attribute ?? IconMix();

  // Instance method for multiple shadows
  IconMix shadows(List<ShadowMix> value) => style.shadows(value);

  /// Animation
  IconMix animate(AnimationConfig animation) => style.animate(animation);

  // StyleAttribute interface implementation

  @override
  IconSpecUtility merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is IconSpecUtility) {
      return IconSpecUtility(style.merge(other.style));
    }
    if (other is IconMix) {
      return IconSpecUtility(style.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  IconSpec resolve(BuildContext context) {
    return style.resolve(context);
  }
}

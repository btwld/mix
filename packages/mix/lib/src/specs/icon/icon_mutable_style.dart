import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style, VariantStyle;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../core/utility_widget_state_variant_mixin.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../properties/painting/color_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shadow_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'icon_spec.dart';
import 'icon_style.dart';

/// Provides mutable utility for icon styling with cascade notation support.
///
/// Supports the same API as [IconStyler] but maintains mutable internal state
/// enabling fluid styling: `$icon..color(Colors.blue)..size(24)..weight(400)`.
class IconMutableStyler extends StyleMutableBuilder<IconSpec>
    with
        UtilityVariantMixin<IconStyler, IconSpec>,
        UtilityWidgetStateVariantMixin<IconStyler, IconSpec> {
  late final color = ColorUtility<IconStyler>(
    (prop) => mutable.merge(IconStyler.create(color: prop)),
  );

  late final shadow = ShadowUtility<IconStyler>((v) => mutable.shadows([v]));

  late final textDirection = MixUtility(mutable.textDirection);

  @Deprecated(
    'Use IconStyler().onHovered() and similar methods directly instead. '
    'This property was deprecated after Mix v2.0.0.',
  )
  late final on = OnContextVariantUtility<IconSpec, IconStyler>(
    (v) => mutable.variants([v]),
  );

  @Deprecated(
    'Use IconStyler().wrap() method directly instead. '
    'This property was deprecated after Mix v2.0.0.',
  )
  late final wrap = WidgetModifierUtility(
    (prop) => mutable.wrap(WidgetModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating icon styling properties.
  @override
  @protected
  late final IconMutableState mutable;

  IconMutableStyler([IconStyler? attribute]) {
    mutable = IconMutableState(attribute ?? IconStyler());
  }

  IconStyler size(double v) => mutable.size(v);

  IconStyler weight(double v) => mutable.weight(v);

  IconStyler grade(double v) => mutable.grade(v);

  IconStyler opticalSize(double v) => mutable.opticalSize(v);

  IconStyler applyTextScaling(bool v) => mutable.applyTextScaling(v);

  IconStyler fill(double v) => mutable.fill(v);

  /// Applies multiple shadows to the icon.
  IconStyler shadows(List<ShadowMix> value) => mutable.shadows(value);

  /// Applies animation configuration to the icon styling.
  IconStyler animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  IconStyler withVariant(Variant variant, IconStyler style) {
    return mutable.variant(variant, style);
  }

  @override
  IconStyler withVariants(List<VariantStyle<IconSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  IconMutableStyler merge(Style<IconSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is IconMutableStyler) {
      return IconMutableStyler(mutable.merge(other.mutable.value));
    }
    if (other is IconStyler) {
      return IconMutableStyler(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<IconSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  IconStyler get currentValue => mutable.value;

  /// The accumulated [IconStyler] with all applied styling properties.
  @override
  IconStyler get value => mutable.value;
}

class IconMutableState extends IconStyler with Mutable<IconStyler, IconSpec> {
  IconMutableState(IconStyler style) {
    value = style;
  }
}

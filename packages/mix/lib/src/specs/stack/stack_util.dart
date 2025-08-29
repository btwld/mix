import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/style.dart' show VariantStyle;
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'stack_spec.dart';
import 'stack_style.dart';

/// Provides mutable utility for stack styling with cascade notation support.
///
/// Supports the same API as [StackStyle] but maintains mutable internal state
/// enabling fluid styling: `$stack..alignment(Alignment.center)..fit(StackFit.expand)`.
class StackSpecUtility extends StyleMutableBuilder<StackSpec>
    with UtilityVariantMixin<StackSpec, StackStyle> {
  late final alignment = MixUtility(mutable.alignment);

  late final fit = MixUtility(mutable.fit);

  late final textDirection = MixUtility(mutable.textDirection);

  late final clipBehavior = MixUtility(mutable.clipBehavior);

  @Deprecated(
    'Use direct methods like \$stack.onHovered() instead. '
    'Note: Returns StackStyle for consistency with other utility methods like animate().',
  )
  late final on = OnContextVariantUtility<StackSpec, StackStyle>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating stack styling properties.
  @override
  @protected
  late final MutableStackStyle mutable;

  StackSpecUtility([StackStyle? attribute]) {
    mutable = MutableStackStyle(attribute ?? StackStyle());
  }

  /// Applies animation configuration to the stack styling.
  StackStyle animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  StackStyle withVariant(Variant variant, StackStyle style) {
    return mutable.variant(variant, style);
  }

  @override
  StackStyle withVariants(List<VariantStyle<StackSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  StackSpecUtility merge(Style<StackSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is StackSpecUtility) {
      return StackSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is StackStyle) {
      return StackSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  WidgetSpec<StackSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  StackStyle get currentValue => mutable.value;

  /// The accumulated [StackStyle] with all applied styling properties.
  @override
  StackStyle get value => mutable.value;
}

class MutableStackStyle extends StackStyle with Mutable<StackSpec, StackStyle> {
  MutableStackStyle(StackStyle style) {
    value = style;
  }
}

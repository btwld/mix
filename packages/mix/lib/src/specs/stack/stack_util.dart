import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/wrapped_widget_spec.dart';
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'stack_attribute.dart';
import 'stack_spec.dart';

/// Provides mutable utility for stack styling with cascade notation support.
///
/// Supports the same API as [StackStyle] but maintains mutable internal state
/// enabling fluid styling: `$stack..alignment(Alignment.center)..fit(StackFit.expand)`.
class StackSpecUtility extends StyleMutableBuilder<StackSpec> {
  late final alignment = MixUtility(mutable.alignment);

  late final fit = MixUtility(mutable.fit);

  late final textDirection = MixUtility(mutable.textDirection);

  late final clipBehavior = MixUtility(mutable.clipBehavior);

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
  WrappedWidgetSpec<StackSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [StackStyle] with all applied styling properties.
  @override
  StackStyle get value => mutable.value;
}

class MutableStackStyle extends StackStyle with Mutable<StackSpec, StackStyle> {
  MutableStackStyle(StackStyle style) {
    value = style;
  }
}

import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'stack_attribute.dart';
import 'stack_spec.dart';

/// Mutable utility class for stack styling using composition over inheritance.
///
/// Same API as StackMix but with mutable internal state
/// for cascade notation support: `$stack..alignment(Alignment.center)..fit(StackFit.expand)`
class StackSpecUtility extends StyleMutableBuilder<StackSpec> {
  // STACK UTILITIES - Same as StackMix but return StackSpecUtility for cascade
  @override
  @protected
  late final MutableStackMix mix;

  late final alignment = MixUtility(mix.alignment);

  late final fit = MixUtility(mix.fit);

  late final textDirection = MixUtility(mix.textDirection);

  late final clipBehavior = MixUtility(mix.clipBehavior);

  late final on = OnContextVariantUtility<StackSpec, StackMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
  );

  StackSpecUtility([StackMix? attribute]) {
    mix = MutableStackMix(attribute ?? StackMix());
  }

  /// Animation
  StackMix animate(AnimationConfig animation) => mix.animate(animation);

  // StyleAttribute interface implementation

  @override
  StackSpecUtility merge(Style<StackSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is StackSpecUtility) {
      return StackSpecUtility(mix.merge(other.mix));
    }
    if (other is StackMix) {
      return StackSpecUtility(mix.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StackSpec resolve(BuildContext context) {
    return mix.resolve(context);
  }
}

class MutableStackMix extends StackMix with Mutable<StackSpec, StackMix> {
  MutableStackMix([StackMix? attribute]) {
    merge(attribute);
  }
}

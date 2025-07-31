import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
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
class StackSpecUtility extends StyleAttributeBuilder<StackSpec> {
  // STACK UTILITIES - Same as StackMix but return StackSpecUtility for cascade

  late final alignment = MixUtility(style.alignment);

  late final fit = MixUtility(style.fit);

  late final textDirection = MixUtility(style.textDirection);

  late final clipBehavior = MixUtility(style.clipBehavior);

  late final on = OnContextVariantUtility<StackSpec, StackMix>(
    (v) => style.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => style.modifier(ModifierConfig(modifiers: [prop])),
  );

  // ignore: prefer_final_fields
  @override
  StackMix style;

  StackSpecUtility([StackMix? attribute]) : style = attribute ?? StackMix();

  /// Animation
  StackMix animate(AnimationConfig animation) => style.animate(animation);

  // StyleAttribute interface implementation

  @override
  StackSpecUtility merge(Style<StackSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is StackSpecUtility) {
      return StackSpecUtility(style.merge(other.style));
    }
    if (other is StackMix) {
      return StackSpecUtility(style.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StackSpec resolve(BuildContext context) {
    return style.resolve(context);
  }
}

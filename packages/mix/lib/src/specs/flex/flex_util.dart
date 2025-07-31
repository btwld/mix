import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'flex_attribute.dart';
import 'flex_spec.dart';

/// Mutable utility class for flex styling using composition over inheritance.
///
/// Same API as FlexMix but with mutable internal state
/// for cascade notation support: `$flex..direction(Axis.horizontal)..gap(8)`
class FlexSpecUtility extends StyleMutableBuilder<FlexSpec> {
  // FLEX UTILITIES - Same as FlexMix but return FlexSpecUtility for cascade
  @override
  @protected
  late final MutableFlexMix mix;

  late final direction = MixUtility(mix.direction);

  late final mainAxisAlignment = MixUtility(mix.mainAxisAlignment);

  late final crossAxisAlignment = MixUtility(mix.crossAxisAlignment);

  late final mainAxisSize = MixUtility(mix.mainAxisSize);

  late final verticalDirection = MixUtility(mix.verticalDirection);

  late final textDirection = MixUtility(mix.textDirection);

  late final textBaseline = MixUtility(mix.textBaseline);

  late final clipBehavior = MixUtility(mix.clipBehavior);

  late final gap = MixUtility(mix.gap);

  late final on = OnContextVariantUtility<FlexSpec, FlexMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
  );

  FlexSpecUtility([FlexMix? attribute]) {
    mix = MutableFlexMix(attribute ?? FlexMix());
  }

  // Convenience methods
  FlexMix row() => mix.direction(Axis.horizontal);
  FlexMix column() => mix.direction(Axis.vertical);

  /// Animation
  FlexMix animate(AnimationConfig animation) => mix.animate(animation);

  // StyleAttribute interface implementation

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(mix.merge(other.mix));
    }
    if (other is FlexMix) {
      return FlexSpecUtility(mix.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return mix.resolve(context);
  }
}

class MutableFlexMix extends FlexMix with Mutable<FlexSpec, FlexMix> {
  MutableFlexMix([FlexMix? attribute]) {
    merge(attribute);
  }
}

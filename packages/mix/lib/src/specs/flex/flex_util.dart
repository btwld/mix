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
  late final MutableFlexMix value;

  late final direction = MixUtility(value.direction);

  late final mainAxisAlignment = MixUtility(value.mainAxisAlignment);

  late final crossAxisAlignment = MixUtility(value.crossAxisAlignment);

  late final mainAxisSize = MixUtility(value.mainAxisSize);

  late final verticalDirection = MixUtility(value.verticalDirection);

  late final textDirection = MixUtility(value.textDirection);

  late final textBaseline = MixUtility(value.textBaseline);

  late final clipBehavior = MixUtility(value.clipBehavior);

  late final on = OnContextVariantUtility<FlexSpec, FlexMix>(
    (v) => value.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => value.modifier(ModifierConfig(modifiers: [prop])),
  );

  FlexSpecUtility([FlexMix? attribute]) {
    value = MutableFlexMix(attribute ?? FlexMix());
  }

  FlexMix gap(double v) => value.gap(v);

  // Convenience methods
  FlexMix row() => value.direction(Axis.horizontal);
  FlexMix column() => value.direction(Axis.vertical);

  /// Animation
  FlexMix animate(AnimationConfig animation) => value.animate(animation);

  // StyleAttribute interface implementation

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(value.merge(other.value));
    }
    if (other is FlexMix) {
      return FlexSpecUtility(value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return value.resolve(context);
  }
}

class MutableFlexMix extends FlexMix with Mutable<FlexSpec, FlexMix> {
  MutableFlexMix(FlexMix style) {
    accumulated = style;
  }
}

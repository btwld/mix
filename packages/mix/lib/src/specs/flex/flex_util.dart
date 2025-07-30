import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
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
class FlexSpecUtility extends StyleAttributeBuilder<FlexSpec> {
  // FLEX UTILITIES - Same as FlexMix but return FlexSpecUtility for cascade

  late final direction = PropUtility(mix.direction);

  late final mainAxisAlignment = PropUtility(mix.mainAxisAlignment);

  late final crossAxisAlignment = PropUtility(mix.crossAxisAlignment);

  late final mainAxisSize = PropUtility(mix.mainAxisSize);

  late final verticalDirection = PropUtility(mix.verticalDirection);

  late final textDirection = PropUtility(mix.textDirection);

  late final textBaseline = PropUtility(mix.textBaseline);

  late final clipBehavior = PropUtility(mix.clipBehavior);

  late final gap = PropUtility(mix.gap);

  late final on = OnContextVariantUtility<FlexSpec, FlexMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
  );

  // ignore: prefer_final_fields
  @override
  FlexMix mix;

  FlexSpecUtility([FlexMix? attribute]) : mix = attribute ?? FlexMix();


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

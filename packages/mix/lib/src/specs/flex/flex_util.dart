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

  late final direction = MixUtility(style.direction);

  late final mainAxisAlignment = MixUtility(style.mainAxisAlignment);

  late final crossAxisAlignment = MixUtility(style.crossAxisAlignment);

  late final mainAxisSize = MixUtility(style.mainAxisSize);

  late final verticalDirection = MixUtility(style.verticalDirection);

  late final textDirection = MixUtility(style.textDirection);

  late final textBaseline = MixUtility(style.textBaseline);

  late final clipBehavior = MixUtility(style.clipBehavior);

  late final gap = MixUtility(style.gap);

  late final on = OnContextVariantUtility<FlexSpec, FlexMix>(
    (v) => style.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => style.modifier(ModifierConfig(modifiers: [prop])),
  );

  // ignore: prefer_final_fields
  @override
  FlexMix style;

  FlexSpecUtility([FlexMix? attribute]) : style = attribute ?? FlexMix();

  // Convenience methods
  FlexMix row() => style.direction(Axis.horizontal);
  FlexMix column() => style.direction(Axis.vertical);

  /// Animation
  FlexMix animate(AnimationConfig animation) => style.animate(animation);

  // StyleAttribute interface implementation

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(style.merge(other.style));
    }
    if (other is FlexMix) {
      return FlexSpecUtility(style.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return style.resolve(context);
  }
}

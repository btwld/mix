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

/// Provides mutable utility for flex styling with cascade notation support.
///
/// Supports the same API as [FlexMix] but maintains mutable internal state
/// enabling fluid styling: `$flex..direction(Axis.horizontal)..gap(8)`.
class FlexSpecUtility extends StyleMutableBuilder<FlexSpec> {
  late final direction = MixUtility(mutable.direction);

  late final mainAxisAlignment = MixUtility(mutable.mainAxisAlignment);

  late final crossAxisAlignment = MixUtility(mutable.crossAxisAlignment);

  late final mainAxisSize = MixUtility(mutable.mainAxisSize);

  late final verticalDirection = MixUtility(mutable.verticalDirection);

  late final textDirection = MixUtility(mutable.textDirection);

  late final textBaseline = MixUtility(mutable.textBaseline);

  late final clipBehavior = MixUtility(mutable.clipBehavior);

  late final on = OnContextVariantUtility<FlexSpec, FlexMix>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.modifier(WidgetDecoratorConfig(decorators: [prop])),
  );

  /// Internal mutable state for accumulating flex styling properties.
  @override
  @protected
  late final MutableFlexMix mutable;

  FlexSpecUtility([FlexMix? attribute]) {
    mutable = MutableFlexMix(attribute ?? FlexMix());
  }

  FlexMix gap(double v) => mutable.gap(v);

  /// Sets flex direction to horizontal (row layout).
  FlexMix row() => mutable.direction(Axis.horizontal);

  /// Sets flex direction to vertical (column layout).
  FlexMix column() => mutable.direction(Axis.vertical);

  /// Applies animation configuration to the flex styling.
  FlexMix animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is FlexMix) {
      return FlexSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [FlexMix] with all applied styling properties.
  @override
  FlexMix get value => mutable.value;
}

class MutableFlexMix extends FlexMix with Mutable<FlexSpec, FlexMix> {
  MutableFlexMix(FlexMix style) {
    value = style;
  }
}

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
/// Supports the same API as [FlexStyle] but maintains mutable internal state
/// enabling fluid styling: `$flex..direction(Axis.horizontal)..spacing(8)`.
class FlexSpecUtility extends StyleMutableBuilder<FlexSpec> {
  late final direction = MixUtility(mutable.direction);

  late final mainAxisAlignment = MixUtility(mutable.mainAxisAlignment);

  late final crossAxisAlignment = MixUtility(mutable.crossAxisAlignment);

  late final mainAxisSize = MixUtility(mutable.mainAxisSize);

  late final verticalDirection = MixUtility(mutable.verticalDirection);

  late final textDirection = MixUtility(mutable.textDirection);

  late final textBaseline = MixUtility(mutable.textBaseline);

  late final clipBehavior = MixUtility(mutable.clipBehavior);

  late final on = OnContextVariantUtility<FlexSpec, FlexStyle>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating flex styling properties.
  @override
  @protected
  late final MutableFlexStyle mutable;

  FlexSpecUtility([FlexStyle? attribute]) {
    mutable = MutableFlexStyle(attribute ?? FlexStyle());
  }

  /// Sets the spacing between children in the flex layout.
  FlexStyle spacing(double v) => mutable.spacing(v);

  /// Sets the gap between children in the flex layout.
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexStyle gap(double v) => mutable.spacing(v);

  /// Sets flex direction to horizontal (row layout).
  FlexStyle row() => mutable.direction(Axis.horizontal);

  /// Sets flex direction to vertical (column layout).
  FlexStyle column() => mutable.direction(Axis.vertical);

  /// Applies animation configuration to the flex styling.
  FlexStyle animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  FlexSpecUtility merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is FlexSpecUtility) {
      return FlexSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is FlexStyle) {
      return FlexSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [FlexStyle] with all applied styling properties.
  @override
  FlexStyle get value => mutable.value;
}

/// Mutable implementation of [FlexStyle] for efficient style accumulation.
///
/// Used internally by [FlexSpecUtility] to accumulate styling changes
/// without creating new instances for each modification.
class MutableFlexStyle extends FlexStyle with Mutable<FlexSpec, FlexStyle> {
  MutableFlexStyle(FlexStyle style) {
    value = style;
  }
}

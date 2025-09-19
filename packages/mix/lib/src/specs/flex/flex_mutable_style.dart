import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style, VariantStyle;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'flex_spec.dart';
import 'flex_style.dart';

/// Provides mutable utility for flex styling with cascade notation support.
///
/// Supports the same API as [FlexStyler] but maintains mutable internal state
/// enabling fluid styling: `$flex..direction(Axis.horizontal)..spacing(8)`.
class FlexMutableStyler extends StyleMutableBuilder<FlexSpec>
    with UtilityVariantMixin<FlexSpec, FlexStyler> {
  late final direction = MixUtility(mutable.direction);

  late final mainAxisAlignment = MixUtility(mutable.mainAxisAlignment);

  late final crossAxisAlignment = MixUtility(mutable.crossAxisAlignment);

  late final mainAxisSize = MixUtility(mutable.mainAxisSize);

  late final verticalDirection = MixUtility(mutable.verticalDirection);

  late final textDirection = MixUtility(mutable.textDirection);

  late final textBaseline = MixUtility(mutable.textBaseline);

  late final clipBehavior = MixUtility(mutable.clipBehavior);

  @Deprecated(
    'Use direct methods like \$flex.onHovered() instead. '
    'Note: Returns FlexStyle for consistency with other utility methods like animate().',
  )
  late final on = OnContextVariantUtility<FlexSpec, FlexStyler>(
    (v) => mutable.variants([v]),
  );

  late final wrap = WidgetModifierUtility(
    (prop) => mutable.wrap(WidgetModifierConfig(modifiers: [prop])),
  );

  /// Internal mutable state for accumulating flex styling properties.
  @override
  @protected
  late final FlexMutableState mutable;

  FlexMutableStyler([FlexStyler? attribute]) {
    mutable = FlexMutableState(attribute ?? FlexStyler());
  }

  /// Sets the spacing between children in the flex layout.
  FlexStyler spacing(double v) => mutable.spacing(v);

  /// Sets the gap between children in the flex layout.
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexStyler gap(double v) => mutable.spacing(v);

  /// Sets flex direction to horizontal (row layout).
  FlexStyler row() => mutable.direction(Axis.horizontal);

  /// Sets flex direction to vertical (column layout).
  FlexStyler column() => mutable.direction(Axis.vertical);

  /// Applies animation configuration to the flex styling.
  FlexStyler animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  FlexStyler withVariant(Variant variant, FlexStyler style) {
    return mutable.variant(variant, style);
  }

  @override
  FlexStyler withVariants(List<VariantStyle<FlexSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  FlexMutableStyler merge(Style<FlexSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is FlexMutableStyler) {
      return FlexMutableStyler(mutable.merge(other.mutable.value));
    }
    if (other is FlexStyler) {
      return FlexMutableStyler(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<FlexSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  FlexStyler get currentValue => mutable.value;

  /// The accumulated [FlexStyler] with all applied styling properties.
  @override
  FlexStyler get value => mutable.value;
}

/// Mutable implementation of [FlexStyler] for efficient style accumulation.
///
/// Used internally by [FlexMutableStyler] to accumulate styling changes
/// without creating new instances for each modification.
class FlexMutableState extends FlexStyler with Mutable<FlexSpec, FlexStyler> {
  FlexMutableState(FlexStyler style) {
    value = style;
  }
}

import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style, VariantStyle, WidgetModifierMix;
import '../../core/style_spec.dart';
import '../../core/utility.dart';
import '../../core/utility_variant_mixin.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'box_spec.dart';
import 'box_style.dart';

/// Provides mutable utility for box styling with cascade notation support.
///
/// Supports the same API as [BoxStyler] but maintains mutable internal state
/// enabling fluid styling: `$box..color.red()..width(100)`.
class BoxMutableStyler extends StyleMutableBuilder<BoxSpec>
    with UtilityVariantMixin<BoxSpec, BoxStyler> {
  late final padding = EdgeInsetsGeometryUtility<BoxStyler>(
    (prop) => mutable.merge(BoxStyler.create(padding: Prop.mix(prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<BoxStyler>(
    (prop) => mutable.merge(BoxStyler.create(margin: Prop.mix(prop))),
  );

  late final constraints = BoxConstraintsUtility<BoxStyler>(
    (prop) => mutable.merge(BoxStyler.create(constraints: Prop.mix(prop))),
  );

  late final decoration = DecorationUtility<BoxStyler>(
    (prop) => mutable.merge(BoxStyler.create(decoration: Prop.mix(prop))),
  );

  @Deprecated(
    'Use direct methods like \$box.onHovered() instead. '
    'Note: Returns BoxStyle for consistency with other utility methods like animate().',
  )
  late final on = OnContextVariantUtility<BoxSpec, BoxStyler>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (WidgetModifierMix prop) => mutable.wrap(WidgetModifierConfig(widgetModifiers: [prop])),
  );

  /// Convenience accessors for commonly used decoration properties.
  late final border = decoration.box.border;
  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape;
  late final shadow = decoration.box.boxShadow;

  /// Convenience accessors for commonly used constraint properties.
  late final width = constraints.width;
  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight;

  /// Direct accessors for transformation and alignment properties.
  late final transform = MixUtility(mutable.transform);
  late final clipBehavior = MixUtility(mutable.clipBehavior);
  late final alignment = MixUtility(mutable.alignment);

  /// Internal mutable state for accumulating box styling properties.
  @override
  @protected
  late final BoxMutableState mutable;

  BoxMutableStyler([BoxStyler? attribute]) {
    mutable = BoxMutableState(attribute ?? BoxStyler());
  }

  /// Applies animation configuration to the box styling.
  BoxStyler animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  BoxStyler withVariant(Variant variant, BoxStyler style) {
    return mutable.variant(variant, style);
  }

  @override
  BoxStyler withVariants(List<VariantStyle<BoxSpec>> variants) {
    return mutable.variants(variants);
  }

  @override
  BoxMutableStyler merge(Style<BoxSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is BoxMutableStyler) {
      return BoxMutableStyler(mutable.merge(other.mutable.value));
    }
    if (other is BoxStyler) {
      return BoxMutableStyler(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  @override
  BoxStyler get currentValue => mutable.value;

  /// The accumulated [BoxStyler] with all applied styling properties.
  @override
  BoxStyler get value => mutable.value;
}

/// Mutable implementation of [BoxStyler] for efficient style accumulation.
///
/// Used internally by [BoxMutableStyler] to accumulate styling changes
/// without creating new instances for each modification.
class BoxMutableState extends BoxStyler with Mutable<BoxSpec, BoxStyler> {
  BoxMutableState(BoxStyler style) {
    value = style;
  }
}
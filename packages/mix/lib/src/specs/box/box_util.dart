import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant_util.dart';
import 'box_attribute.dart';
import 'box_spec.dart';

/// Provides mutable utility for box styling with cascade notation support.
///
/// Supports the same API as [BoxStyle] but maintains mutable internal state
/// enabling fluid styling: `$box..color.red()..width(100)`.
class BoxSpecUtility extends StyleMutableBuilder<BoxWidgetSpec> {
  late final padding = EdgeInsetsGeometryUtility<BoxStyle>(
    (prop) => mutable.merge(BoxStyle.create(padding: Prop.mix(prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<BoxStyle>(
    (prop) => mutable.merge(BoxStyle.create(margin: Prop.mix(prop))),
  );

  late final constraints = BoxConstraintsUtility<BoxStyle>(
    (prop) => mutable.merge(BoxStyle.create(constraints: Prop.mix(prop))),
  );

  late final decoration = DecorationUtility<BoxStyle>(
    (prop) => mutable.merge(BoxStyle.create(decoration: Prop.mix(prop))),
  );

  late final on = OnContextVariantUtility<BoxWidgetSpec, BoxStyle>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
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
  late final transformAlignment = MixUtility(mutable.transformAlignment);
  late final clipBehavior = MixUtility(mutable.clipBehavior);
  late final alignment = MixUtility(mutable.alignment);

  /// Internal mutable state for accumulating box styling properties.
  @override
  @protected
  late final MutableBoxMix mutable;

  BoxSpecUtility([BoxStyle? attribute]) {
    mutable = MutableBoxMix(attribute ?? BoxStyle());
  }

  /// Applies animation configuration to the box styling.
  BoxStyle animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  BoxSpecUtility merge(Style<BoxWidgetSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is BoxSpecUtility) {
      return BoxSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is BoxStyle) {
      return BoxSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  BoxWidgetSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [BoxStyle] with all applied styling properties.
  @override
  BoxStyle get value => mutable.value;
}

/// Mutable implementation of [BoxStyle] for efficient style accumulation.
///
/// Used internally by [BoxSpecUtility] to accumulate styling changes
/// without creating new instances for each modification.
class MutableBoxMix extends BoxStyle with Mutable<BoxWidgetSpec, BoxStyle> {
  MutableBoxMix(BoxStyle style) {
    value = style;
  }
}

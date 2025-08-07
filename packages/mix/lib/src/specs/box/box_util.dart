import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../modifiers/widget_modifier_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant_util.dart';
import 'box_attribute.dart';
import 'box_spec.dart';

/// Provides mutable utility for box styling with cascade notation support.
///
/// Supports the same API as [BoxMix] but maintains mutable internal state
/// enabling fluid styling: `$box..color.red()..width(100)`.
class BoxSpecUtility extends StyleMutableBuilder<BoxSpec> {
  late final padding = EdgeInsetsGeometryUtility<BoxMix>(
    (prop) => mutable.merge(BoxMix.create(padding: MixProp(prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<BoxMix>(
    (prop) => mutable.merge(BoxMix.create(margin: MixProp(prop))),
  );

  late final constraints = BoxConstraintsUtility<BoxMix>(
    (prop) => mutable.merge(BoxMix.create(constraints: MixProp(prop))),
  );

  late final decoration = DecorationUtility<BoxMix>(
    (prop) => mutable.merge(BoxMix.create(decoration: MixProp(prop))),
  );

  late final on = OnContextVariantUtility<BoxSpec, BoxMix>(
    (v) => mutable.variants([v]),
  );

  late final wrap = WidgetModifierUtility(
    (prop) =>
        mutable.wrap(WidgetModifierConfig(modifiers: [prop])),
  );

  // Convenience accessors for commonly used properties
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;

  late final color = decoration.box.color;

  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape;
  late final width = constraints.width;
  late final height = constraints.height;
  late final minWidth = constraints.minWidth;

  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight;

  late final transform = MixUtility(mutable.transform);
  late final transformAlignment = MixUtility(mutable.transformAlignment);
  late final clipBehavior = MixUtility(mutable.clipBehavior);
  late final alignment = MixUtility(mutable.alignment);

  /// Internal mutable state for accumulating box styling properties.
  @override
  @protected
  late final MutableBoxMix mutable;

  BoxSpecUtility([BoxMix? attribute]) {
    mutable = MutableBoxMix(attribute ?? BoxMix());
  }

  /// Applies animation configuration to the box styling.
  BoxMix animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  BoxSpecUtility merge(Style<BoxSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is BoxSpecUtility) {
      return BoxSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is BoxMix) {
      return BoxSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  BoxSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [BoxMix] with all applied styling properties.
  @override
  BoxMix get value => mutable.value;
}

class MutableBoxMix extends BoxMix with Mutable<BoxSpec, BoxMix> {
  MutableBoxMix(BoxMix style) {
    value = style;
  }
}

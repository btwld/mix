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

/// Mutable utility class for box styling using composition over inheritance.
///
/// Same API as BoxMix but with mutable internal state
/// for cascade notation support: `$box..color.red()..width(100)`
class BoxSpecUtility extends StyleMutableBuilder<BoxSpec> {
  // BOX UTILITIES - Same as BoxMix but return BoxSpecUtility for cascade
  @override
  @protected
  late final MutableBoxMix mix;

  late final padding = EdgeInsetsGeometryUtility<BoxMix>(
    (prop) => mix.merge(BoxMix.raw(padding: MixProp(prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<BoxMix>(
    (prop) => mix.merge(BoxMix.raw(margin: MixProp(prop))),
  );

  late final constraints = BoxConstraintsUtility<BoxMix>(
    (prop) => mix.merge(BoxMix.raw(constraints: MixProp(prop))),
  );

  late final decoration = DecorationUtility<BoxMix>(
    (prop) => mix.merge(BoxMix.raw(decoration: MixProp(prop))),
  );

  late final on = OnContextVariantUtility<BoxSpec, BoxMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
  );

  // FLATTENED ACCESS - Same as BoxMix
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
  late final transform = MixUtility(mix.transform);

  late final transformAlignment = MixUtility(mix.transformAlignment);

  late final clipBehavior = MixUtility(mix.clipBehavior);

  late final alignment = MixUtility(mix.alignment);

  BoxSpecUtility([BoxMix? attribute]) {
    mix = MutableBoxMix(attribute ?? BoxMix());
  }

  /// Animation
  BoxMix animate(AnimationConfig animation) => mix.animate(animation);

  // StyleAttribute interface implementation

  @override
  BoxSpecUtility merge(Style<BoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is BoxSpecUtility) {
      return BoxSpecUtility(mix.merge(other.mix));
    }
    if (other is BoxMix) {
      return BoxSpecUtility(mix.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  BoxSpec resolve(BuildContext context) {
    return mix.resolve(context);
  }
}

class MutableBoxMix extends BoxMix with Mutable<BoxSpec, BoxMix> {
  MutableBoxMix([BoxMix? attribute]) {
    merge(attribute);
  }
}

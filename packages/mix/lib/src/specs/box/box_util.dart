import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
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
class BoxSpecUtility extends StyleAttributeBuilder<BoxSpec> {
  // SAME UTILITIES AS BoxMix - but return BoxSpecUtility for cascade

  late final padding = EdgeInsetsGeometryUtility<BoxMix>(style.padding);

  late final margin = EdgeInsetsGeometryUtility<BoxMix>(style.margin);

  late final constraints = BoxConstraintsUtility<BoxMix>(style.constraints);

  late final decoration = DecorationUtility<BoxMix>(style.decoration);

  late final on = OnContextVariantUtility<BoxSpec, BoxMix>(
    (v) => style.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => style.modifier(ModifierConfig(modifiers: [prop])),
  );

  // FLATTENED ACCESS - Same as BoxMix
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape =
      decoration.box.shape; // CONVENIENCE SHORTCUTS - Same as BoxMix
  late final width = constraints.width;

  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight =
      constraints.maxHeight; // PROP UTILITIES - Same as BoxMix
  late final transform = MixUtility(style.transform);

  late final transformAlignment = MixUtility(style.transformAlignment);

  late final clipBehavior = MixUtility(style.clipBehavior);

  late final alignment = MixUtility(style.alignment);

  // ignore: prefer_final_fields
  @override
  BoxMix style;

  BoxSpecUtility([BoxMix? attribute]) : style = attribute ?? BoxMix();

  /// Animation
  BoxMix animate(AnimationConfig animation) => style.animate(animation);

  // StyleAttribute interface implementation

  @override
  BoxSpecUtility merge(Style<BoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is BoxSpecUtility) {
      return BoxSpecUtility(style.merge(other.style));
    }
    if (other is BoxMix) {
      return BoxSpecUtility(style.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  BoxSpec resolve(BuildContext context) {
    return style.resolve(context);
  }
}

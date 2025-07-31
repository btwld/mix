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
import '../box/box_attribute.dart';
import '../flex/flex_attribute.dart';
import 'flexbox_attribute.dart';
import 'flexbox_spec.dart';

/// Mutable utility class for flexbox styling using composition over inheritance.
///
/// Same API as FlexBoxMix but with mutable internal state
/// for cascade notation support: `$flexbox..color.red()..width(100)`
class FlexBoxSpecUtility extends StyleAttributeBuilder<FlexBoxSpec> {
  // BOX UTILITIES - Same as BoxSpecUtility but return FlexBoxSpecUtility for cascade

  late final padding = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => style.box(BoxMix(padding: prop)),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => style.box(BoxMix(margin: prop)),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxMix>(
    (prop) => style.box(BoxMix(constraints: prop)),
  );

  late final decoration = DecorationUtility<FlexBoxMix>(
    (prop) => style.box(BoxMix(decoration: prop)),
  );

  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxMix>(
    (v) => style.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => style.modifier(ModifierConfig(modifiers: [prop])),
  );

  // FLATTENED ACCESS - Same as BoxSpecUtility but for FlexBox
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape; // BOX CONVENIENCE SHORTCUTS
  late final width = constraints.width;

  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight; // BOX PROP UTILITIES
  late final transform = MixUtility<FlexBoxMix, Matrix4>(
    (prop) => style.box(BoxMix(transform: prop)),
  );

  late final transformAlignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => style.box(BoxMix(transformAlignment: prop)),
  );

  late final clipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => style.box(BoxMix(clipBehavior: prop)),
  );

  late final alignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => style.box(BoxMix(alignment: prop)),
  );

  // FLEX UTILITIES
  late final direction = MixUtility<FlexBoxMix, Axis>(
    (prop) => style.flex(FlexMix(direction: prop)),
  );

  late final mainAxisAlignment = MixUtility<FlexBoxMix, MainAxisAlignment>(
    (prop) => style.flex(FlexMix(mainAxisAlignment: prop)),
  );

  late final crossAxisAlignment = MixUtility<FlexBoxMix, CrossAxisAlignment>(
    (prop) => style.flex(FlexMix(crossAxisAlignment: prop)),
  );

  late final mainAxisSize = MixUtility<FlexBoxMix, MainAxisSize>(
    (prop) => style.flex(FlexMix(mainAxisSize: prop)),
  );

  late final verticalDirection = MixUtility<FlexBoxMix, VerticalDirection>(
    (prop) => style.flex(FlexMix(verticalDirection: prop)),
  );

  late final flexTextDirection = MixUtility<FlexBoxMix, TextDirection>(
    (prop) => style.flex(FlexMix(textDirection: prop)),
  );

  late final textBaseline = MixUtility<FlexBoxMix, TextBaseline>(
    (prop) => style.flex(FlexMix(textBaseline: prop)),
  );

  late final flexClipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => style.flex(FlexMix(clipBehavior: prop)),
  );

  late final gap = MixUtility<FlexBoxMix, double>(
    (prop) => style.flex(FlexMix(gap: prop)),
  );

  // ignore: prefer_final_fields
  @override
  FlexBoxMix style;

  FlexBoxSpecUtility([FlexBoxMix? attribute])
    : style = attribute ?? const FlexBoxMix();

  /// Animation
  FlexBoxMix animate(AnimationConfig animation) => style.animate(animation);

  // StyleAttribute interface implementation

  @override
  FlexBoxSpecUtility merge(Style<FlexBoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(style.merge(other.style));
    }
    if (other is FlexBoxMix) {
      return FlexBoxSpecUtility(style.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return style.resolve(context);
  }
}

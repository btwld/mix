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
    (prop) => mix.box(BoxMix(padding: prop)),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => mix.box(BoxMix(margin: prop)),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxMix>(
    (prop) => mix.box(BoxMix(constraints: prop)),
  );

  late final decoration = DecorationUtility<FlexBoxMix>(
    (prop) => mix.box(BoxMix(decoration: prop)),
  );

  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxMix>(
    (v) => mix.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mix.modifier(ModifierConfig(modifiers: [prop])),
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
    (prop) => mix.box(BoxMix(transform: prop)),
  );

  late final transformAlignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => mix.box(BoxMix(transformAlignment: prop)),
  );

  late final clipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => mix.box(BoxMix(clipBehavior: prop)),
  );

  late final alignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => mix.box(BoxMix(alignment: prop)),
  );

  // FLEX UTILITIES
  late final direction = MixUtility<FlexBoxMix, Axis>(
    (prop) => mix.flex(FlexMix(direction: prop)),
  );

  late final mainAxisAlignment = MixUtility<FlexBoxMix, MainAxisAlignment>(
    (prop) => mix.flex(FlexMix(mainAxisAlignment: prop)),
  );

  late final crossAxisAlignment = MixUtility<FlexBoxMix, CrossAxisAlignment>(
    (prop) => mix.flex(FlexMix(crossAxisAlignment: prop)),
  );

  late final mainAxisSize = MixUtility<FlexBoxMix, MainAxisSize>(
    (prop) => mix.flex(FlexMix(mainAxisSize: prop)),
  );

  late final verticalDirection = MixUtility<FlexBoxMix, VerticalDirection>(
    (prop) => mix.flex(FlexMix(verticalDirection: prop)),
  );

  late final flexTextDirection = MixUtility<FlexBoxMix, TextDirection>(
    (prop) => mix.flex(FlexMix(textDirection: prop)),
  );

  late final textBaseline = MixUtility<FlexBoxMix, TextBaseline>(
    (prop) => mix.flex(FlexMix(textBaseline: prop)),
  );

  late final flexClipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => mix.flex(FlexMix(clipBehavior: prop)),
  );

  late final gap = MixUtility<FlexBoxMix, double>(
    (prop) => mix.flex(FlexMix(gap: prop)),
  );

  // ignore: prefer_final_fields
  @override
  FlexBoxMix mix;

  FlexBoxSpecUtility([FlexBoxMix? attribute])
    : mix = attribute ?? const FlexBoxMix();

  /// Animation
  FlexBoxMix animate(AnimationConfig animation) => mix.animate(animation);

  // StyleAttribute interface implementation

  @override
  FlexBoxSpecUtility merge(Style<FlexBoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(mix.merge(other.mix));
    }
    if (other is FlexBoxMix) {
      return FlexBoxSpecUtility(mix.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return mix.resolve(context);
  }
}

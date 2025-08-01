import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
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
class FlexBoxSpecUtility extends StyleMutableBuilder<FlexBoxSpec> {
  // BOX UTILITIES - Same as BoxSpecUtility but return FlexBoxSpecUtility for cascade
  @override
  @protected
  late final MutableFlexBoxMix value;

  late final padding = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(padding: prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(margin: prop))),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxMix>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(constraints: prop))),
  );

  late final decoration = DecorationUtility<FlexBoxMix>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(decoration: prop))),
  );

  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxMix>(
    (v) => value.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => value.modifier(ModifierConfig(modifiers: [prop])),
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
    (prop) => value.merge(FlexBoxMix.box(BoxMix(transform: prop))),
  );

  late final transformAlignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(transformAlignment: prop))),
  );

  late final clipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(clipBehavior: prop))),
  );

  late final alignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => value.merge(FlexBoxMix.box(BoxMix(alignment: prop))),
  );

  // FLEX UTILITIES
  late final direction = MixUtility<FlexBoxMix, Axis>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(direction: prop))),
  );

  late final mainAxisAlignment = MixUtility<FlexBoxMix, MainAxisAlignment>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(mainAxisAlignment: prop))),
  );

  late final crossAxisAlignment = MixUtility<FlexBoxMix, CrossAxisAlignment>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(crossAxisAlignment: prop))),
  );

  late final mainAxisSize = MixUtility<FlexBoxMix, MainAxisSize>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(mainAxisSize: prop))),
  );

  late final verticalDirection = MixUtility<FlexBoxMix, VerticalDirection>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(verticalDirection: prop))),
  );

  late final flexTextDirection = MixUtility<FlexBoxMix, TextDirection>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(textDirection: prop))),
  );

  late final textBaseline = MixUtility<FlexBoxMix, TextBaseline>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(textBaseline: prop))),
  );

  late final flexClipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => value.merge(FlexBoxMix.flex(FlexMix(clipBehavior: prop))),
  );

  FlexBoxSpecUtility([FlexBoxMix? attribute]) {
    value = MutableFlexBoxMix(attribute ?? const FlexBoxMix());
  }

  FlexBoxMix gap(double v) => value.merge(FlexBoxMix.flex(FlexMix(gap: v)));

  /// Animation
  FlexBoxMix animate(AnimationConfig animation) => value.animate(animation);

  // StyleAttribute interface implementation

  @override
  FlexBoxSpecUtility merge(Style<FlexBoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(value.merge(other.value));
    }
    if (other is FlexBoxMix) {
      return FlexBoxSpecUtility(value.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return value.resolve(context);
  }
}

class MutableFlexBoxMix extends FlexBoxMix
    with Mutable<FlexBoxSpec, FlexBoxMix> {
  MutableFlexBoxMix([FlexBoxMix? accumulated]) {
    this.accumulated = accumulated ?? const FlexBoxMix();
  }
}

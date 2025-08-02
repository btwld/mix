import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/widget_decorator_config.dart';
import '../../modifiers/widget_decorator_util.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant_util.dart';
import '../box/box_attribute.dart';
import '../flex/flex_attribute.dart';
import 'flexbox_attribute.dart';
import 'flexbox_spec.dart';

/// Provides mutable utility for flexbox styling with cascade notation support.
///
/// Combines box and flex styling capabilities. Supports the same API as [FlexBoxMix]
/// but maintains mutable internal state enabling fluid styling: `$flexbox..color.red()..width(100)`.
class FlexBoxSpecUtility extends StyleMutableBuilder<FlexBoxSpec> {
  late final padding = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(padding: prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxMix>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(margin: prop))),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxMix>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(constraints: prop))),
  );

  late final decoration = DecorationUtility<FlexBoxMix>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(decoration: prop))),
  );

  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxMix>(
    (v) => mutable.variants([v]),
  );

  late final wrap = WidgetDecoratorUtility(
    (prop) => mutable.modifier(WidgetDecoratorConfig(decorators: [prop])),
  );

  // Box decoration convenience accessors
  late final border = decoration.box.border;

  late final borderRadius = decoration.box.borderRadius;

  late final color = decoration.box.color;

  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape;

  // Box constraint convenience accessors
  late final width = constraints.width;
  late final height = constraints.height;
  late final minWidth = constraints.minWidth;

  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight;

  // Box transformation utilities
  late final transform = MixUtility<FlexBoxMix, Matrix4>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(transform: prop))),
  );
  late final transformAlignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(transformAlignment: prop))),
  );
  late final clipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(clipBehavior: prop))),
  );

  late final alignment = MixUtility<FlexBoxMix, AlignmentGeometry>(
    (prop) => mutable.merge(FlexBoxMix.box(BoxMix(alignment: prop))),
  );

  // Flex layout utilities
  late final direction = MixUtility<FlexBoxMix, Axis>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(direction: prop))),
  );

  late final mainAxisAlignment = MixUtility<FlexBoxMix, MainAxisAlignment>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(mainAxisAlignment: prop))),
  );

  late final crossAxisAlignment = MixUtility<FlexBoxMix, CrossAxisAlignment>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(crossAxisAlignment: prop))),
  );

  late final mainAxisSize = MixUtility<FlexBoxMix, MainAxisSize>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(mainAxisSize: prop))),
  );

  late final verticalDirection = MixUtility<FlexBoxMix, VerticalDirection>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(verticalDirection: prop))),
  );

  late final flexTextDirection = MixUtility<FlexBoxMix, TextDirection>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(textDirection: prop))),
  );

  late final textBaseline = MixUtility<FlexBoxMix, TextBaseline>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(textBaseline: prop))),
  );

  late final flexClipBehavior = MixUtility<FlexBoxMix, Clip>(
    (prop) => mutable.merge(FlexBoxMix.flex(FlexMix(clipBehavior: prop))),
  );

  /// Internal mutable state for accumulating flexbox styling properties.
  @override
  @protected
  late final MutableFlexBoxMix mutable;

  FlexBoxSpecUtility([FlexBoxMix? attribute]) {
    mutable = MutableFlexBoxMix(attribute ?? const FlexBoxMix());
  }

  FlexBoxMix gap(double v) => mutable.merge(FlexBoxMix.flex(FlexMix(gap: v)));

  /// Applies animation configuration to the flexbox styling.
  FlexBoxMix animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  FlexBoxSpecUtility merge(Style<FlexBoxSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is FlexBoxMix) {
      return FlexBoxSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [FlexBoxMix] with all applied styling properties.
  @override
  FlexBoxMix get value => mutable.value;
}

class MutableFlexBoxMix extends FlexBoxMix
    with Mutable<FlexBoxSpec, FlexBoxMix> {
  MutableFlexBoxMix(FlexBoxMix style) {
    value = style;
  }
}

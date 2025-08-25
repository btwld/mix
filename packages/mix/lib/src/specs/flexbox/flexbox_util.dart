import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/spec_utility.dart' show Mutable, StyleMutableBuilder;
import '../../core/style.dart' show Style;
import '../../core/utility.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/flex_properties_mix.dart';
import '../../properties/layout/constraints_util.dart';
import '../../properties/layout/edge_insets_geometry_util.dart';
import '../../properties/painting/decoration_util.dart';
import '../../variants/variant_util.dart';
import '../container/container_attribute.dart';
import 'flexbox_attribute.dart';
import 'flexbox_spec.dart';

/// Provides mutable utility for flexbox styling with cascade notation support.
///
/// Combines container and flex styling capabilities. Supports the same API as [FlexBoxStyle]
/// but maintains mutable internal state enabling fluid styling: `$flexbox..color.red()..width(100)`.
class FlexBoxSpecUtility extends StyleMutableBuilder<FlexBoxWidgetSpec> {
  late final padding = EdgeInsetsGeometryUtility<FlexBoxStyle>(
    (prop) =>
        mutable.merge(FlexBoxStyle.container(ContainerSpecMix(padding: prop))),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxStyle>(
    (prop) =>
        mutable.merge(FlexBoxStyle.container(ContainerSpecMix(margin: prop))),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxStyle>(
    (prop) => mutable.merge(
      FlexBoxStyle.container(ContainerSpecMix(constraints: prop)),
    ),
  );

  late final decoration = DecorationUtility<FlexBoxStyle>(
    (prop) => mutable.merge(
      FlexBoxStyle.container(ContainerSpecMix(decoration: prop)),
    ),
  );

  late final on = OnContextVariantUtility<FlexBoxWidgetSpec, FlexBoxStyle>(
    (v) => mutable.variants([v]),
  );

  late final wrap = ModifierUtility(
    (prop) => mutable.wrap(ModifierConfig(modifiers: [prop])),
  );

  /// Container decoration convenience accessors.
  late final border = decoration.box.border;
  late final borderRadius = decoration.box.borderRadius;
  late final color = decoration.box.color;
  late final gradient = decoration.box.gradient;
  late final shape = decoration.box.shape;

  /// Container constraint convenience accessors.
  late final width = constraints.width;
  late final height = constraints.height;
  late final minWidth = constraints.minWidth;
  late final maxWidth = constraints.maxWidth;
  late final minHeight = constraints.minHeight;
  late final maxHeight = constraints.maxHeight;

  /// Container transformation utilities.
  late final transform = MixUtility<FlexBoxStyle, Matrix4>(
    (prop) => mutable.merge(
      FlexBoxStyle.container(ContainerSpecMix(transform: prop)),
    ),
  );
  late final transformAlignment = MixUtility<FlexBoxStyle, AlignmentGeometry>(
    (prop) => mutable.merge(
      FlexBoxStyle.container(ContainerSpecMix(transformAlignment: prop)),
    ),
  );
  late final clipBehavior = MixUtility<FlexBoxStyle, Clip>(
    (prop) => mutable.merge(
      FlexBoxStyle.container(ContainerSpecMix(clipBehavior: prop)),
    ),
  );

  late final alignment = MixUtility<FlexBoxStyle, AlignmentGeometry>(
    (prop) => mutable.merge(
      FlexBoxStyle.container(ContainerSpecMix(alignment: prop)),
    ),
  );

  /// Flex layout utilities.
  late final direction = MixUtility<FlexBoxStyle, Axis>(
    (prop) =>
        mutable.merge(FlexBoxStyle.flex(FlexPropertiesMix(direction: prop))),
  );

  late final mainAxisAlignment = MixUtility<FlexBoxStyle, MainAxisAlignment>(
    (prop) => mutable.merge(
      FlexBoxStyle.flex(FlexPropertiesMix(mainAxisAlignment: prop)),
    ),
  );

  late final crossAxisAlignment = MixUtility<FlexBoxStyle, CrossAxisAlignment>(
    (prop) => mutable.merge(
      FlexBoxStyle.flex(FlexPropertiesMix(crossAxisAlignment: prop)),
    ),
  );

  late final mainAxisSize = MixUtility<FlexBoxStyle, MainAxisSize>(
    (prop) =>
        mutable.merge(FlexBoxStyle.flex(FlexPropertiesMix(mainAxisSize: prop))),
  );

  late final verticalDirection = MixUtility<FlexBoxStyle, VerticalDirection>(
    (prop) => mutable.merge(
      FlexBoxStyle.flex(FlexPropertiesMix(verticalDirection: prop)),
    ),
  );

  late final flexTextDirection = MixUtility<FlexBoxStyle, TextDirection>(
    (prop) => mutable.merge(
      FlexBoxStyle.flex(FlexPropertiesMix(textDirection: prop)),
    ),
  );

  late final textBaseline = MixUtility<FlexBoxStyle, TextBaseline>(
    (prop) =>
        mutable.merge(FlexBoxStyle.flex(FlexPropertiesMix(textBaseline: prop))),
  );

  late final flexClipBehavior = MixUtility<FlexBoxStyle, Clip>(
    (prop) =>
        mutable.merge(FlexBoxStyle.flex(FlexPropertiesMix(clipBehavior: prop))),
  );

  /// Internal mutable state for accumulating flexbox styling properties.
  @override
  @protected
  late final MutableFlexBoxStyle mutable;

  FlexBoxSpecUtility([FlexBoxStyle? attribute]) {
    mutable = MutableFlexBoxStyle(attribute ?? const FlexBoxStyle.create());
  }

  /// Sets the spacing between children in the flex layout.
  FlexBoxStyle spacing(double v) =>
      mutable.merge(FlexBoxStyle.flex(FlexPropertiesMix(spacing: v)));

  /// Sets the gap between children in the flex layout.
  /// @deprecated Use spacing instead.
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyle gap(double v) =>
      mutable.merge(FlexBoxStyle.flex(FlexPropertiesMix(spacing: v)));

  /// Applies animation configuration to the flexbox styling.
  FlexBoxStyle animate(AnimationConfig animation) => mutable.animate(animation);

  @override
  FlexBoxSpecUtility merge(Style<FlexBoxWidgetSpec>? other) {
    if (other == null) return this;
    // Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(mutable.merge(other.mutable.value));
    }
    if (other is FlexBoxStyle) {
      return FlexBoxSpecUtility(mutable.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexBoxWidgetSpec resolve(BuildContext context) {
    return mutable.resolve(context);
  }

  /// The accumulated [FlexBoxStyle] with all applied styling properties.
  @override
  FlexBoxStyle get value => mutable.value;
}

/// Mutable implementation of [FlexBoxStyle] for efficient style accumulation.
///
/// Used internally by [FlexBoxSpecUtility] to accumulate styling changes
/// without creating new instances for each modification.
class MutableFlexBoxStyle extends FlexBoxStyle
    with Mutable<FlexBoxWidgetSpec, FlexBoxStyle> {
  MutableFlexBoxStyle(FlexBoxStyle style) {
    value = style;
  }
}

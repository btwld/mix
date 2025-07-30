import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/prop.dart';
import '../../core/spec_utility.dart' show StyleAttributeBuilder;
import '../../core/style.dart' show Style, VariantStyleAttribute;
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

  late final padding = EdgeInsetsGeometryUtility<FlexBoxSpecUtility>(
    (prop) => buildProps(boxPadding: prop),
  );

  late final margin = EdgeInsetsGeometryUtility<FlexBoxSpecUtility>(
    (prop) => buildProps(boxMargin: prop),
  );

  late final constraints = BoxConstraintsUtility<FlexBoxSpecUtility>(
    (prop) => buildProps(boxConstraints: prop),
  );

  late final decoration = DecorationUtility<FlexBoxSpecUtility>(
    (prop) => buildProps(boxDecoration: prop),
  );

  late final on = OnContextVariantUtility<FlexBoxSpec, FlexBoxSpecUtility>(
    (v) => buildProps(variants: [v]),
  );

  late final wrap = ModifierUtility<FlexBoxSpecUtility>(
    (prop) => buildProps(modifierConfig: ModifierConfig.modifier(prop)),
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
  late final transform = PropUtility<FlexBoxSpecUtility, Matrix4>(
    (prop) => buildProps(boxTransform: prop),
  );

  late final transformAlignment =
      PropUtility<FlexBoxSpecUtility, AlignmentGeometry>(
        (prop) => buildProps(boxTransformAlignment: prop),
      );

  late final clipBehavior = PropUtility<FlexBoxSpecUtility, Clip>(
    (prop) => buildProps(boxClipBehavior: prop),
  );

  late final alignment = PropUtility<FlexBoxSpecUtility, AlignmentGeometry>(
    (prop) => buildProps(boxAlignment: prop),
  );

  // FLEX UTILITIES
  late final direction = PropUtility<FlexBoxSpecUtility, Axis>(
    (prop) => buildProps(flexDirection: prop),
  );

  late final mainAxisAlignment =
      PropUtility<FlexBoxSpecUtility, MainAxisAlignment>(
        (prop) => buildProps(flexMainAxisAlignment: prop),
      );

  late final crossAxisAlignment =
      PropUtility<FlexBoxSpecUtility, CrossAxisAlignment>(
        (prop) => buildProps(flexCrossAxisAlignment: prop),
      );

  late final mainAxisSize = PropUtility<FlexBoxSpecUtility, MainAxisSize>(
    (prop) => buildProps(flexMainAxisSize: prop),
  );

  late final verticalDirection =
      PropUtility<FlexBoxSpecUtility, VerticalDirection>(
        (prop) => buildProps(flexVerticalDirection: prop),
      );

  late final flexTextDirection = PropUtility<FlexBoxSpecUtility, TextDirection>(
    (prop) => buildProps(flexTextDirection: prop),
  );

  late final textBaseline = PropUtility<FlexBoxSpecUtility, TextBaseline>(
    (prop) => buildProps(flexTextBaseline: prop),
  );

  late final flexClipBehavior = PropUtility<FlexBoxSpecUtility, Clip>(
    (prop) => buildProps(flexClipBehavior: prop),
  );

  late final gap = PropUtility<FlexBoxSpecUtility, double>(
    (prop) => buildProps(flexGap: prop),
  );

  FlexBoxMix _baseAttribute;

  FlexBoxSpecUtility([FlexBoxMix? attribute])
    : _baseAttribute = attribute ?? const FlexBoxMix();

  @protected
  FlexBoxSpecUtility buildProps({
    // Box properties
    Prop<AlignmentGeometry>? boxAlignment,
    MixProp<EdgeInsetsGeometry>? boxPadding,
    MixProp<EdgeInsetsGeometry>? boxMargin,
    MixProp<BoxConstraints>? boxConstraints,
    MixProp<Decoration>? boxDecoration,
    MixProp<Decoration>? boxForegroundDecoration,
    Prop<Matrix4>? boxTransform,
    Prop<AlignmentGeometry>? boxTransformAlignment,
    Prop<Clip>? boxClipBehavior,
    // Flex properties
    Prop<Axis>? flexDirection,
    Prop<MainAxisAlignment>? flexMainAxisAlignment,
    Prop<CrossAxisAlignment>? flexCrossAxisAlignment,
    Prop<MainAxisSize>? flexMainAxisSize,
    Prop<VerticalDirection>? flexVerticalDirection,
    Prop<TextDirection>? flexTextDirection,
    Prop<TextBaseline>? flexTextBaseline,
    Prop<Clip>? flexClipBehavior,
    Prop<double>? flexGap,
    // Common properties
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<FlexBoxSpec>>? variants,
  }) {
    BoxMix? boxMix;
    FlexMix? flexMix;

    // Create BoxMix if any box properties are provided
    if (boxAlignment != null ||
        boxPadding != null ||
        boxMargin != null ||
        boxConstraints != null ||
        boxDecoration != null ||
        boxForegroundDecoration != null ||
        boxTransform != null ||
        boxTransformAlignment != null ||
        boxClipBehavior != null) {
      boxMix = BoxMix.raw(
        alignment: boxAlignment,
        padding: boxPadding,
        margin: boxMargin,
        constraints: boxConstraints,
        decoration: boxDecoration,
        foregroundDecoration: boxForegroundDecoration,
        transform: boxTransform,
        transformAlignment: boxTransformAlignment,
        clipBehavior: boxClipBehavior,
      );
    }

    // Create FlexMix if any flex properties are provided
    if (flexDirection != null ||
        flexMainAxisAlignment != null ||
        flexCrossAxisAlignment != null ||
        flexMainAxisSize != null ||
        flexVerticalDirection != null ||
        flexTextDirection != null ||
        flexTextBaseline != null ||
        flexClipBehavior != null ||
        flexGap != null) {
      flexMix = FlexMix.raw(
        direction: flexDirection,
        mainAxisAlignment: flexMainAxisAlignment,
        crossAxisAlignment: flexCrossAxisAlignment,
        mainAxisSize: flexMainAxisSize,
        verticalDirection: flexVerticalDirection,
        textDirection: flexTextDirection,
        textBaseline: flexTextBaseline,
        clipBehavior: flexClipBehavior,
        gap: flexGap,
      );
    }

    final newAttribute = FlexBoxMix(
      box: boxMix,
      flex: flexMix,
      animation: animation,
      modifierConfig: modifierConfig,
      variants: variants,
    );
    _baseAttribute = _baseAttribute.merge(newAttribute);

    return this;
  }

  /// Animation
  FlexBoxSpecUtility animate(AnimationConfig animation) =>
      buildProps(animation: animation);

  // StyleAttribute interface implementation

  @override
  FlexBoxSpecUtility merge(Style<FlexBoxSpec>? other) {
    if (other == null) return this;
    // IMMUTABLE: Always create new instance (StyleAttribute contract)
    if (other is FlexBoxSpecUtility) {
      return FlexBoxSpecUtility(_baseAttribute.merge(other._baseAttribute));
    }
    if (other is FlexBoxMix) {
      return FlexBoxSpecUtility(_baseAttribute.merge(other));
    }

    throw FlutterError('Unsupported merge type: ${other.runtimeType}');
  }

  @override
  FlexBoxSpec resolve(BuildContext context) {
    return _baseAttribute.resolve(context);
  }

  /// Access to internal attribute
  @override
  FlexBoxMix get mix => _baseAttribute;
}

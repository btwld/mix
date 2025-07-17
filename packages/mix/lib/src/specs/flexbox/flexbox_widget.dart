// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/animated_spec_widget.dart';
import '../../core/factory/mix_provider.dart';
import '../../core/spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import '../box/box_spec.dart';
import '../box/box_widget.dart';
import '../flex/flex_spec.dart';
import '../flex/flex_widget.dart';
import 'flexbox_spec.dart';

/// A styled flex container widget combining box and flex capabilities.
///
/// Applies both [BoxSpec] and [FlexSpec] styling to create flexible layouts
/// with advanced styling through the Mix framework. Combines container and
/// flex properties for complex layouts.
///
/// Example:
/// ```dart
/// FlexBox(
///   direction: Axis.horizontal,
///   style: Style(
///     $flex.gap(8),
///     $box.padding.all(16),
///   ),
///   children: [Widget1(), Widget2()],
/// )
/// ```
class FlexBox extends StyledWidget {
  const FlexBox({
    super.style,
    super.key,
    super.inherit,
    required this.direction,
    this.children = const <Widget>[],
    super.orderOfModifiers = const [],
  });

  final List<Widget> children;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    // TODO: the support for FlexBoxSpec using BoxSpec and FlexSpec is a temporary
    // solution to not break the existing API. it should be implemented using only
    // FlexBoxSpec in the next major version.
    return SpecBuilder(
      inherit: inherit,
      style: style,
      orderOfModifiers: orderOfModifiers,
      builder: (context) {
        final mixData = MixProvider.of(context);

        final spec = mixData.attributeOf<FlexBoxSpecAttribute>()?.resolve(
          mixData,
        );

        final boxSpec = spec?.box ?? BoxSpec.of(context);
        final flexSpec = spec?.flex ?? FlexSpec.of(context);

        final newSpec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

        return FlexBoxSpecWidget(
          spec: newSpec,
          direction: direction,
          orderOfModifiers: orderOfModifiers,
          children: children,
        );
      },
    );
  }
}

class FlexBoxSpecWidget extends SpecWidget<FlexBoxSpec> {
  const FlexBoxSpecWidget({
    super.key,
    super.spec,
    this.children = const <Widget>[],
    required this.direction,
    this.orderOfModifiers = const [],
  });

  final List<Widget> children;
  final Axis direction;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context) {
    final spec = this.spec ?? const FlexBoxSpec();

    // TODO: Convert to a BoxSpecWidget and a FlexSpecWidget in the next major version.
    // it should be implemented following the same pattern as the others SpecWidgets.
    // This code must be like this to keep the existing animation API working.
    return RenderSpecModifiers(
      spec: spec,
      orderOfModifiers: orderOfModifiers,
      child: BoxSpecWidget(
        spec: spec.box,
        orderOfModifiers: orderOfModifiers,
        child: FlexSpecWidget(
          spec: spec.flex,
          direction: direction,
          children: children,
        ),
      ),
    );
  }
}

class AnimatedFlexBoxSpecWidget
    extends ImplicitlyAnimatedSpecWidget<FlexBoxSpec> {
  const AnimatedFlexBoxSpecWidget({
    super.key,
    required super.spec,
    this.children = const <Widget>[],
    required this.direction,
    this.orderOfModifiers = const [],
    super.curve,
    required super.duration,
    super.onEnd,
  });

  final List<Widget> children;
  final Axis direction;
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context, FlexBoxSpec animatedSpec) {
    return FlexBoxSpecWidget(
      spec: animatedSpec,
      direction: direction,
      orderOfModifiers: orderOfModifiers,
      children: children,
    );
  }
}

/// A horizontal flex container with `Style` for easy and consistent styling.
///
/// `HBox` is a specialized `FlexBox` designed for horizontal layouts, simplifying
/// the process of applying horizontal alignment with advanced styling via `Style`.
/// It's an efficient way to achieve consistent styling in horizontal arrangements.
///
/// Inherits all functionalities of `FlexBox`, optimized for horizontal layouts.
///
/// Example Usage:
/// ```dart
/// HBox(
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
class HBox extends FlexBox {
  const HBox({
    super.style,
    super.key,
    super.inherit,
    super.children = const <Widget>[],
  }) : super(direction: Axis.horizontal);
}

/// A vertical flex container that uses `Style` for streamlined styling.
///
/// `VBox` is a vertical counterpart to `HBox`, utilizing `Style` for efficient
/// and consistent styling in vertical layouts. It offers an easy way to manage
/// vertical alignment and styling in a cohesive manner.
///
/// Inherits the comprehensive styling and layout capabilities of `FlexBox`, tailored
/// for vertical orientations.
///
/// Example Usage:
/// ```dart
/// VBox(
///   style: yourStyle,
///   children: [Widget1(), Widget2()],
/// );
/// ```
class VBox extends FlexBox {
  const VBox({
    super.style,
    super.key,
    super.inherit,
    super.children = const <Widget>[],
  }) : super(direction: Axis.vertical);
}

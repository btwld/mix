// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import '../container/container_spec.dart';
import '../../properties/flex_properties.dart';
import 'flexbox_attribute.dart';
import 'flexbox_spec.dart';

/// Combines [Container] and [Flex] with Mix styling.
///
/// Applies both container and flex specifications for flexible layouts,
/// providing decoration, constraints, and flex layout in one widget.
class FlexBox extends StyleWidget<FlexBoxSpec> {
  const FlexBox({
    super.style = const FlexBoxMix.create(),
    super.key,
    required this.direction,
    this.children = const <Widget>[],
  });

  /// Child widgets to be arranged in the flex layout.
  final List<Widget> children;

  /// The main axis direction for the flex layout.
  final Axis direction;

  @override
  Widget build(BuildContext context, FlexBoxSpec spec) {
    return createFlexBoxSpecWidget(
      spec: spec,
      direction: direction,
      children: children,
    );
  }
}

/// Horizontal flex container with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.horizontal].
class HBox extends FlexBox {
  const HBox({
    super.style = const FlexBoxMix.create(),
    super.key,
    super.children = const <Widget>[],
  }) : super(direction: Axis.horizontal);
}

/// Vertical flex container with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.vertical].
class VBox extends FlexBox {
  const VBox({
    super.style = const FlexBoxMix.create(),
    super.key,
    super.children = const <Widget>[],
  }) : super(direction: Axis.vertical);
}

/// Creates a [Flex] widget from a [FlexProperties] and required parameters.
///
/// Applies all flex layout properties with appropriate default values
/// when specification properties are null.
Flex createFlexSpecWidget({
  required FlexProperties? spec,
  required Axis direction,
  List<Widget> children = const [],
}) {
  return Flex(
    direction: spec?.direction ?? direction,
    mainAxisAlignment: spec?.mainAxisAlignment ?? MainAxisAlignment.start,
    mainAxisSize: spec?.mainAxisSize ?? MainAxisSize.max,
    crossAxisAlignment: spec?.crossAxisAlignment ?? CrossAxisAlignment.center,
    textDirection: spec?.textDirection,
    verticalDirection: spec?.verticalDirection ?? VerticalDirection.down,
    textBaseline: spec?.textBaseline,
    clipBehavior: spec?.clipBehavior ?? Clip.none,
    spacing: spec?.spacing ?? 0.0,
    children: children,
  );
}

/// Creates a [Container] with [Flex] child from a [FlexBoxSpec].
///
/// Applies container styling as the outer container and flex layout as the inner
/// child widget, combining both specifications effectively.
Widget createFlexBoxSpecWidget({
  required FlexBoxSpec spec,
  required Axis direction,
  List<Widget> children = const [],
}) {
  final flexWidget = createFlexSpecWidget(
    spec: spec.flex,
    direction: direction,
    children: children,
  );

  if (spec.container != null) {
    return spec.container!.toContainer(child: flexWidget);
  }

  return flexWidget;
}

/// Extension to convert [FlexProperties] directly to a [Flex] widget.
extension FlexPropertiesWidget on FlexProperties {
  Flex call({required Axis direction, List<Widget> children = const []}) {
    return createFlexSpecWidget(
      spec: this,
      direction: direction,
      children: children,
    );
  }
}

/// Extension to convert [FlexBoxSpec] directly to a styled flex widget.
extension FlexBoxSpecWidget on FlexBoxSpec {
  Widget call({required Axis direction, List<Widget> children = const []}) {
    return createFlexBoxSpecWidget(
      spec: this,
      direction: direction,
      children: children,
    );
  }
}

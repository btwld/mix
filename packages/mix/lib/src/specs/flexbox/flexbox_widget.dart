// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import '../box/box_widget.dart';
import '../flex/flex_spec.dart';
import 'flexbox_spec.dart';
import 'flexbox_style.dart';

/// Combines [Container] and [Flex] with Mix styling.
///
/// Applies both box and flex specifications for flexible layouts,
/// providing decoration, constraints, and flex layout in one widget.
class FlexBox extends StyleWidget<FlexBoxSpec> {
  const FlexBox({
    super.style = const FlexBoxStyler.create(),
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
    return _createFlexBoxSpecWidget(
      spec: spec,
      direction: direction,
      children: children,
    );
  }
}

/// Horizontal flex box with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.horizontal].
class HBox extends FlexBox {
  const HBox({
    super.style = const FlexBoxStyler.create(),
    super.key,
    super.children = const <Widget>[],
  }) : super(direction: Axis.horizontal);
}

/// Vertical flex box with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.vertical].
class VBox extends FlexBox {
  const VBox({
    super.style = const FlexBoxStyler.create(),
    super.key,
    super.children = const <Widget>[],
  }) : super(direction: Axis.vertical);
}

/// Creates a [Flex] widget from a [FlexSpec] and required parameters.
///
/// Applies all flex layout properties with appropriate default values
/// when specification properties are null.
Flex _createFlexSpecWidget({
  required FlexSpec? spec,
  Axis? direction,
  List<Widget> children = const [],
}) {
  return Flex(
    direction: spec?.direction ?? direction ?? Axis.horizontal,
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

/// Creates a Box-styled container with [Flex] child from a [FlexBoxSpec].
///
/// Applies box styling as the outer container and flex layout as the inner
/// child widget, combining both specifications effectively.
Widget _createFlexBoxSpecWidget({
  required FlexBoxSpec spec,
  required Axis direction,
  List<Widget> children = const [],
}) {
  final flexWidget = _createFlexSpecWidget(
    spec: spec.flex?.spec,
    direction: direction,
    children: children,
  );

  if (spec.box != null) {
    return spec.box!.spec(child: flexWidget);
  }

  return flexWidget;
}

/// Extension to convert [FlexSpec] directly to a [Flex] widget.
extension FlexSpecWidget on FlexSpec {
  Flex call({Axis? direction, List<Widget> children = const []}) {
    return _createFlexSpecWidget(
      spec: this,
      direction: direction,
      children: children,
    );
  }
}

/// Extension to convert [FlexBoxSpec] directly to a styled flex widget.
extension FlexBoxSpecWidget on FlexBoxSpec {
  Widget call({required Axis direction, List<Widget> children = const []}) {
    return _createFlexBoxSpecWidget(
      spec: this,
      direction: direction,
      children: children,
    );
  }
}

extension FlexSpecWrappedWidget on StyleSpec<FlexSpec> {
  Widget call({Axis? direction, List<Widget> children = const []}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createFlexSpecWidget(
          spec: spec,
          direction: direction,
          children: children,
        );
      },
      wrappedSpec: this,
    );
  }
}

extension FlexBoxSpecWrappedWidget on StyleSpec<FlexBoxSpec> {
  Widget call({required Axis direction, List<Widget> children = const []}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createFlexBoxSpecWidget(
          spec: spec,
          direction: direction,
          children: children,
        );
      },
      wrappedSpec: this,
    );
  }
}

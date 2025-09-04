// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import '../box/box_widget.dart';
import '../flex/flex_spec.dart';
import 'flexbox_spec.dart';
import 'flexbox_style.dart';

@Deprecated('Use ColumnBox instead')
typedef VBox = ColumnBox;

@Deprecated('Use RowBox instead')
typedef HBox = RowBox;

/// Combines [Container] and [Flex] with Mix styling.
///
/// Applies both box and flex specifications for flexible layouts,
/// providing decoration, constraints, and flex layout in one widget.
class FlexBox extends StyleWidget<FlexBoxSpec> {
  const FlexBox({
    super.style = const FlexBoxStyler.create(),
    super.key,
    this.children = const <Widget>[],
  });

  /// Child widgets to be arranged in the flex layout.
  final List<Widget> children;

  /// Constrains the flex direction for RowBox/ColumnBox.
  /// When specified, prevents conflicting direction in style specs.
  Axis? get _forcedDirection => null;

  @override
  Widget build(BuildContext context, FlexBoxSpec spec) {
    return _createFlexBoxSpecWidget(
      spec: spec,
      forcedDirection: _forcedDirection,
      children: children,
    );
  }
}

/// Horizontal flex box with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.horizontal].
class RowBox extends FlexBox {
  const RowBox({
    super.style = const FlexBoxStyler.create(),
    super.key,
    super.children = const <Widget>[],
  });

  @override
  Axis get _forcedDirection => Axis.horizontal;
}

/// Vertical flex box with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.vertical].
class ColumnBox extends FlexBox {
  const ColumnBox({
    super.style = const FlexBoxStyler.create(),
    super.key,
    super.children = const <Widget>[],
  });

  @override
  Axis get _forcedDirection => Axis.vertical;
}

/// Creates a [Flex] widget from a [FlexSpec] and required parameters.
///
/// Applies all flex layout properties with appropriate default values
/// when specification properties are null.
Flex _createFlexSpecWidget({
  required FlexSpec? spec,
  Axis? forcedDirection,
  List<Widget> children = const [],
}) {
  final hasDirectionFromBothSources =
      forcedDirection != null && spec?.direction != null;
  final hasDirectionsConflict = forcedDirection != spec?.direction;

  assert(
    !(hasDirectionFromBothSources && hasDirectionsConflict),
    'Direction cannot be specified in the spec for RowBox (horizontal) or ColumnBox (vertical). Use FlexBox if you need dynamic direction control.',
  );

  return Flex(
    direction: spec?.direction ?? forcedDirection ?? Axis.horizontal,
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
  required Axis? forcedDirection,
  List<Widget> children = const [],
}) {
  final flexWidget = _createFlexSpecWidget(
    spec: spec.flex?.spec,
    forcedDirection: forcedDirection,
    children: children,
  );

  if (spec.box != null) {
    return spec.box!.createWidget(child: flexWidget);
  }

  return flexWidget;
}

/// Extension to convert [FlexSpec] directly to a [Flex] widget.
extension FlexSpecWidget on FlexSpec {
  /// Creates a [Flex] widget from this [FlexSpec].
  Flex createWidget({Axis? direction, List<Widget> children = const []}) {
    return _createFlexSpecWidget(
      spec: this,
      forcedDirection: direction,
      children: children,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Flex call({Axis? direction, List<Widget> children = const []}) {
    return createWidget(direction: direction, children: children);
  }
}

/// Extension to convert [FlexBoxSpec] directly to a styled flex widget.
extension FlexBoxSpecWidget on FlexBoxSpec {
  /// Creates a widget from this [FlexBoxSpec].
  Widget createWidget({required Axis direction, List<Widget> children = const []}) {
    return _createFlexBoxSpecWidget(
      spec: this,
      forcedDirection: direction,
      children: children,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget call({required Axis direction, List<Widget> children = const []}) {
    return createWidget(direction: direction, children: children);
  }
}

extension FlexSpecWrappedWidget on StyleSpec<FlexSpec> {
  /// Creates a widget that resolves this [StyleSpec<FlexSpec>] with context.
  Widget createWidget({Axis? direction, List<Widget> children = const []}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createFlexSpecWidget(
          spec: spec,
          forcedDirection: direction,
          children: children,
        );
      },
      styleSpec: this,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget call({Axis? direction, List<Widget> children = const []}) {
    return createWidget(direction: direction, children: children);
  }
}

extension FlexBoxSpecWrappedWidget on StyleSpec<FlexBoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<FlexBoxSpec>] with context.
  Widget createWidget({required Axis direction, List<Widget> children = const []}) {
    return StyleSpecBuilder(
      builder: (context, spec) {
        return _createFlexBoxSpecWidget(
          spec: spec,
          forcedDirection: direction,
          children: children,
        );
      },
      styleSpec: this,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget call({required Axis direction, List<Widget> children = const []}) {
    return createWidget(direction: direction, children: children);
  }
}

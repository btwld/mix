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
    super.styleSpec,
    super.key,
    this.children = const <Widget>[],
  });

  /// Builder pattern for `StyleSpec<FlexBoxSpec>` with custom builder function.
  static Widget builder(
    StyleSpec<FlexBoxSpec> styleSpec,
    Widget Function(BuildContext context, FlexBoxSpec spec) builder,
  ) {
    return StyleSpecBuilder<FlexBoxSpec>(
      builder: builder,
      styleSpec: styleSpec,
    );
  }

  /// Child widgets to be arranged in the flex layout.
  final List<Widget> children;

  /// Constrains the flex direction for RowBox/ColumnBox.
  /// When specified, prevents conflicting direction in style specs.
  Axis? get _forcedDirection => null;

  @override
  Widget build(BuildContext context, FlexBoxSpec spec) {
    final flexWidget = _createFlexSpecWidget(
      spec: spec.flex?.spec,
      forcedDirection: _forcedDirection,
      children: children,
    );

    if (spec.box != null) {
      return Box(styleSpec: spec.box!, child: flexWidget);
    }

    return flexWidget;
  }
}

/// Horizontal flex box with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.horizontal].
class RowBox extends FlexBox {
  const RowBox({
    super.style,
    super.styleSpec,
    super.key,
    super.children = const <Widget>[],
  });

  /// Builder pattern for `StyleSpec<FlexBoxSpec>` with custom builder function.
  static Widget builder(
    StyleSpec<FlexBoxSpec> styleSpec,
    Widget Function(BuildContext context, FlexBoxSpec spec) builder,
  ) {
    return StyleSpecBuilder<FlexBoxSpec>(
      builder: builder,
      styleSpec: styleSpec,
    );
  }

  @override
  Axis get _forcedDirection => Axis.horizontal;
}

/// Vertical flex box with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.vertical].
class ColumnBox extends FlexBox {
  const ColumnBox({
    super.style,
    super.styleSpec,
    super.key,
    super.children = const <Widget>[],
  });

  /// Builder pattern for `StyleSpec<FlexBoxSpec>` with custom builder function.
  static Widget builder(
    StyleSpec<FlexBoxSpec> styleSpec,
    Widget Function(BuildContext context, FlexBoxSpec spec) builder,
  ) {
    return StyleSpecBuilder<FlexBoxSpec>(
      builder: builder,
      styleSpec: styleSpec,
    );
  }

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




extension FlexBoxSpecWrappedWidget on StyleSpec<FlexBoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<FlexBoxSpec>] with context.
  @Deprecated(
    'Use FlexBox.builder(styleSpec, builder), RowBox.builder(styleSpec, builder), or ColumnBox.builder(styleSpec, builder) for custom logic, or styleSpec(direction: direction, children: children) for simple cases',
  )
  Widget createWidget({
    required Axis direction,
    List<Widget> children = const [],
  }) {
    return call(direction: direction, children: children);
  }

  /// Convenient shorthand for creating a FlexBox widget with this StyleSpec.
  Widget call({required Axis direction, List<Widget> children = const []}) {
    switch (direction) {
      case Axis.horizontal:
        return RowBox(styleSpec: this, children: children);
      case Axis.vertical:
        return ColumnBox(styleSpec: this, children: children);
    }
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

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

/// [FlexBox] combines Flutter's [Container] and [Flex] widgets with Mix styling.
///
/// It provides both box styling (decoration, padding, margins, transforms, constraints)
/// and flex layout capabilities (direction, alignment, spacing) in a single widget.
/// This makes it ideal for creating styled flex layouts without nesting multiple widgets.
///
/// For specific layouts, use [RowBox] for horizontal layouts or [ColumnBox] for vertical layouts.
///
/// You can use [FlexBoxStyler] to create styles with a fluent API. Example:
///
/// ```dart
/// final style = FlexBoxStyler()
///   .direction(Axis.horizontal)
///   .mainAxisAlignment(MainAxisAlignment.spaceBetween)
///   .crossAxisAlignment(CrossAxisAlignment.center)
///   .padding(16)
///   .spacing(12)
///   .color(Colors.grey.shade100)
///   .borderRounded(8);
///
/// FlexBox(
///   style: style,
///   children: [
///     StyledIcon(icon: Icons.star),
///     StyledText('Rating'),
///     StyledText('4.5'),
///   ],
/// )
/// ```
///
class FlexBox extends StyleWidget<FlexBoxSpec> {
  const FlexBox({
    super.style = const FlexBoxStyler.create(),
    super.styleSpec,
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

  @override
  Axis get _forcedDirection => .horizontal;
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

  @override
  Axis get _forcedDirection => .vertical;
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
    direction: spec?.direction ?? forcedDirection ?? .horizontal,
    mainAxisAlignment: spec?.mainAxisAlignment ?? .start,
    mainAxisSize: spec?.mainAxisSize ?? .max,
    crossAxisAlignment: spec?.crossAxisAlignment ?? .center,
    textDirection: spec?.textDirection,
    verticalDirection: spec?.verticalDirection ?? .down,
    textBaseline: spec?.textBaseline,
    clipBehavior: spec?.clipBehavior ?? .none,
    spacing: spec?.spacing ?? 0.0,
    children: children,
  );
}

extension FlexBoxSpecWrappedWidget on StyleSpec<FlexBoxSpec> {
  /// Creates a widget that resolves this [StyleSpec<FlexBoxSpec>] with context.
  @Deprecated(
    'Use RowBox(children: children, styleSpec: styleSpec) for horizontal or ColumnBox(children: children, styleSpec: styleSpec) for vertical instead',
  )
  Widget createWidget({
    required Axis direction,
    List<Widget> children = const [],
  }) {
    return call(direction: direction, children: children);
  }

  /// Convenient shorthand for creating a FlexBox widget with this StyleSpec.
  @Deprecated(
    'Use RowBox(children: children, styleSpec: styleSpec) for horizontal or ColumnBox(children: children, styleSpec: styleSpec) for vertical instead',
  )
  Widget call({required Axis direction, List<Widget> children = const []}) {
    switch (direction) {
      case .horizontal:
        return RowBox(styleSpec: this, children: children);
      case .vertical:
        return ColumnBox(styleSpec: this, children: children);
    }
  }
}

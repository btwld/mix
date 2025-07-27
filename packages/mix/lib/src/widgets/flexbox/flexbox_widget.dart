// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import '../box/box_spec.dart';
import '../flex/flex_spec.dart';
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
class FlexBox extends StyleWidget<FlexBoxSpec> {
  const FlexBox({
    super.style,
    super.key,

    required this.direction,
    this.children = const <Widget>[],
    super.orderOfModifiers,
  });

  final List<Widget> children;
  final Axis direction;

  @override
  Widget build(BuildContext context, FlexBoxSpec? spec) {
    final boxSpec = spec?.box;
    final flexSpec = spec?.flex;

    return Container(
      alignment: boxSpec?.alignment,
      padding: boxSpec?.padding,
      decoration: boxSpec?.decoration,
      foregroundDecoration: boxSpec?.foregroundDecoration,
      constraints: boxSpec?.constraints,
      margin: boxSpec?.margin,
      transform: boxSpec?.transform,
      transformAlignment: boxSpec?.transformAlignment,
      clipBehavior: boxSpec?.clipBehavior ?? Clip.none,
      child: Flex(
        direction: flexSpec?.direction ?? direction,
        mainAxisAlignment:
            flexSpec?.mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: flexSpec?.mainAxisSize ?? MainAxisSize.max,
        crossAxisAlignment:
            flexSpec?.crossAxisAlignment ?? CrossAxisAlignment.center,
        textDirection: flexSpec?.textDirection,
        verticalDirection:
            flexSpec?.verticalDirection ?? VerticalDirection.down,
        textBaseline: flexSpec?.textBaseline,
        clipBehavior: flexSpec?.clipBehavior ?? Clip.none,
        spacing: flexSpec?.gap ?? 0.0,
        children: children,
      ),
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
    super.style = const FlexBoxSpecAttribute(),
    super.key,

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
  const VBox({super.style, super.key, super.children = const <Widget>[]})
    : super(direction: Axis.vertical);
}

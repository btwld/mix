// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import 'flexbox_attribute.dart';
import 'flexbox_spec.dart';

/// Combines [Container] and [Flex] with Mix styling.
///
/// Applies both box and flex specifications for flexible layouts.
class FlexBox extends StyleWidget<FlexBoxSpec> {
  const FlexBox({
    super.style,
    super.key,
    required this.direction,
    this.children = const <Widget>[],
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

/// Horizontal flex container with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.horizontal].
class HBox extends FlexBox {
  const HBox({
    super.style = const FlexBoxMix(),
    super.key,

    super.children = const <Widget>[],
  }) : super(direction: Axis.horizontal);
}

/// Vertical flex container with Mix styling.
///
/// Shorthand for [FlexBox] with [Axis.vertical].
class VBox extends FlexBox {
  const VBox({super.style, super.key, super.children = const <Widget>[]})
    : super(direction: Axis.vertical);
}

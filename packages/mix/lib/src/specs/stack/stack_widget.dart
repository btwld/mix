import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import 'stack_box_spec.dart';

/// Combines [Container] and [Stack] with Mix styling.
///
/// Creates a stacked layout with box styling capabilities.
class ZBox extends StyleWidget<ZBoxSpec> {
  const ZBox({super.style, this.children = const <Widget>[], super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context, ZBoxSpec? spec) {
    final boxSpec = spec?.box;
    final stackSpec = spec?.stack;

    Widget stack = Stack(
      alignment: stackSpec?.alignment ?? AlignmentDirectional.topStart,
      textDirection: stackSpec?.textDirection,
      fit: stackSpec?.fit ?? StackFit.loose,
      clipBehavior: stackSpec?.clipBehavior ?? Clip.hardEdge,
      children: children,
    );

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
      child: stack,
    );
  }
}

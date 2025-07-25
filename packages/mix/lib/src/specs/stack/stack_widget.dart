import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/style_widget.dart';
import 'stack_box_spec.dart';

/// [ZBox] - A styled widget that combines the functionalities of [Box] and Stack.
///
/// This widget is designed to apply a `Style` to a stack layout, making it a combination
/// of a box and a stack. It is ideal for scenarios where you need to create a stacked layout
/// with specific styling and alignment, encapsulated within a box-like structure.
///
/// Parameters:
///   - [children]: The list of widgets to stack and style.
///   - [inherit]: Determines whether the [ZBox] should inherit styles from its ancestors.
///     Inherits from [StyleWidget].
///   - [key]: The key for the widget. Inherits from [StyleWidget].
///   - [style]: The [SpecStyle] to be applied. Inherits from [StyleWidget].
class ZBox extends StyleWidget<ZBoxSpec> {
  const ZBox({
    super.style,
    this.children = const <Widget>[],

    super.key,
    super.orderOfModifiers = const [],
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context, ZBoxSpec? spec) {
    final boxSpec = spec?.box;
    final stackSpec = spec?.stack;

    // Build the stack
    Widget stack = Stack(
      alignment: stackSpec?.alignment ?? AlignmentDirectional.topStart,
      textDirection: stackSpec?.textDirection,
      fit: stackSpec?.fit ?? StackFit.loose,
      clipBehavior: stackSpec?.clipBehavior ?? Clip.hardEdge,
      children: children,
    );

    // Wrap with Container for box styling
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

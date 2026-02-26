import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';

/// Handler for ScrollableNode.
///
/// Uses ScrollViewModifier wrapping via WidgetModifierConfig — does NOT
/// create a new Spec. This follows the freeze §5.5 handler strategy.
class ScrollableHandler extends NodeHandler<ScrollableNode> {
  const ScrollableHandler();

  @override
  Widget build(ScrollableNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final child = ctx.buildChild(node.child);
      final dir = ctx.resolveValue<String>(node.direction, context);
      final axis = dir == 'horizontal' ? Axis.horizontal : Axis.vertical;

      // Wrap with ScrollViewModifier via modifier factory
      final styler = BoxStyler().wrap(
        WidgetModifierConfig.modifier(
          ScrollViewModifierMix(scrollDirection: axis),
        ),
      );

      return Box(style: styler, child: child);
    });
  }
}

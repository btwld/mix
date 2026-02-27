import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../events/schema_event.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for PressableNode → Mix PressableBox widget.
///
/// PressableBox is a StatelessWidget whose `style` parameter takes
/// BoxStyler? (optional).
class PressableHandler extends NodeHandler<PressableNode> {
  const PressableHandler();

  @override
  Widget build(PressableNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final child = ctx.buildChild(node.child);

      // Build BoxStyler for press styling (hover/pressed variants)
      BoxStyler? styler;
      if (node.style != null) {
        styler = applyContainerStyle(BoxStyler(), node.style, ctx, context);
        styler = applyBoxVariants(styler, node.variants, ctx, context);
        styler = applyAnimation(styler, node.animation);
      }

      return wrapWithSemantics(
        PressableBox(
          style: styler,
          onPress: () {
            ctx.onEvent?.call(TapEvent(
              nodeId: node.nodeId,
              actionId: node.actionId,
            ));
          },
          child: child,
        ),
        node.semantics,
      );
    });
  }
}

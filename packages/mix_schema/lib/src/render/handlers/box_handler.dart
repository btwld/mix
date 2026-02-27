import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for BoxNode → Mix Box widget.
class BoxHandler extends NodeHandler<BoxNode> {
  const BoxHandler();

  @override
  Widget build(BoxNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = BoxStyler();
      styler = applyContainerStyle(styler, node.style, ctx, context);
      styler = applyBoxVariants(styler, node.variants, ctx, context);
      styler = applyBoxAnimation(styler, node.animation);

      final child = node.child != null ? ctx.buildChild(node.child!) : null;

      return wrapWithSemantics(
        Box(style: styler, child: child),
        node.semantics,
      );
    });
  }
}

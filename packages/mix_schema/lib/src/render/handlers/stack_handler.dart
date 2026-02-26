import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for StackNode → Mix StackBox widget.
class StackHandler extends NodeHandler<StackNode> {
  const StackHandler();

  @override
  Widget build(StackNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = StackBoxStyler();

      final alignment = ctx.resolveValue<String>(node.alignment, context);
      if (alignment != null) {
        styler = styler.alignment(parseAlignment(alignment));
      }

      // Container-level style
      styler =
          applyStackContainerStyle(styler, node.style, ctx, context);
      styler = applyStackVariants(styler, node.variants, ctx, context);
      styler = applyStackAnimation(styler, node.animation);

      final children = node.children.map((c) => ctx.buildChild(c)).toList();

      return StackBox(style: styler, children: children);
    });
  }
}

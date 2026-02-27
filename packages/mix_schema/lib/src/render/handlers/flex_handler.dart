import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for FlexNode → Mix FlexBox widget.
class FlexHandler extends NodeHandler<FlexNode> {
  const FlexHandler();

  @override
  Widget build(FlexNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = FlexBoxStyler();

      // Direction
      final dir = ctx.resolveValue<String>(node.direction, context);
      if (dir == 'row') {
        styler = styler.row();
      } else {
        styler = styler.column();
      }

      // Spacing
      final spacing = ctx.resolveValue<double>(node.spacing, context);
      if (spacing != null) styler = styler.spacing(spacing);

      // Alignment
      final cross =
          ctx.resolveValue<String>(node.crossAxisAlignment, context);
      if (cross != null) {
        styler = styler.crossAxisAlignment(parseCrossAxis(cross));
      }
      final main =
          ctx.resolveValue<String>(node.mainAxisAlignment, context);
      if (main != null) {
        styler = styler.mainAxisAlignment(parseMainAxis(main));
      }

      // Container-level style
      styler = applyFlexContainerStyle(styler, node.style, ctx, context);
      styler = applyFlexVariants(styler, node.variants, ctx, context);
      styler = applyAnimation(styler, node.animation);

      final children = node.children.map((c) => ctx.buildChild(c)).toList();

      return wrapWithSemantics(
        FlexBox(style: styler, children: children),
        node.semantics,
      );
    });
  }
}

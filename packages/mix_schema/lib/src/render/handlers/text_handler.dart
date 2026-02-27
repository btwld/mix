import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for TextNode → Mix StyledText widget.
class TextHandler extends NodeHandler<TextNode> {
  const TextHandler();

  @override
  Widget build(TextNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = TextStyler();
      styler = applyTextStyle(styler, node.style, ctx, context);
      styler = applyTextVariants(styler, node.variants, ctx, context);
      styler = applyAnimation(styler, node.animation);

      final text = ctx.resolveValue<String>(node.content, context) ?? '';

      return wrapWithSemantics(
        StyledText(text, style: styler),
        node.semantics,
      );
    });
  }
}

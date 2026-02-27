import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../render_context.dart';
import 'style_helpers.dart';
import 'styled_node_handler.dart';

/// Handler for TextNode → Mix StyledText widget.
class TextHandler extends StyledNodeHandler<TextNode, TextStyler> {
  const TextHandler();

  @override
  TextStyler createStyler() => TextStyler();

  @override
  TextStyler applyStyleMap(TextStyler s, Map<String, SchemaValue> style,
          RenderContext ctx, BuildContext context) =>
      applyTextStyle(s, style, ctx, context);

  @override
  Widget buildWidget(TextStyler styler, TextNode node, RenderContext ctx,
      BuildContext context) {
    final text = ctx.resolveValue<String>(node.content, context) ?? '';
    return StyledText(text, style: styler);
  }
}

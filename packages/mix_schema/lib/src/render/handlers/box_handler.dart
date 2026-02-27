import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../render_context.dart';
import 'style_helpers.dart';
import 'styled_node_handler.dart';

/// Handler for BoxNode → Mix Box widget.
class BoxHandler extends StyledNodeHandler<BoxNode, BoxStyler> {
  const BoxHandler();

  @override
  BoxStyler createStyler() => BoxStyler();

  @override
  BoxStyler applyStyleMap(BoxStyler s, Map<String, SchemaValue> style,
          RenderContext ctx, BuildContext context) =>
      applyContainerStyleMap(s, style, ctx, context);

  @override
  Widget buildWidget(
      BoxStyler styler, BoxNode node, RenderContext ctx, BuildContext context) {
    final child = node.child != null ? ctx.buildChild(node.child!) : null;
    return Box(style: styler, child: child);
  }
}

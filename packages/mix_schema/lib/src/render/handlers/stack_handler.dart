import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../render_context.dart';
import 'style_helpers.dart';
import 'styled_node_handler.dart';

/// Handler for StackNode → Mix StackBox widget.
class StackHandler extends StyledNodeHandler<StackNode, StackBoxStyler> {
  const StackHandler();

  @override
  StackBoxStyler createStyler() => StackBoxStyler();

  @override
  StackBoxStyler applyNodeProps(StackBoxStyler styler, StackNode node,
      RenderContext ctx, BuildContext context) {
    final alignment = ctx.resolveValue<String>(node.alignment, context);
    if (alignment != null) {
      styler = styler.alignment(parseAlignment(alignment));
    }
    return styler;
  }

  @override
  StackBoxStyler applyStyleMap(StackBoxStyler s,
          Map<String, SchemaValue> style, RenderContext ctx,
          BuildContext context) =>
      applyContainerStyleMap(s, style, ctx, context);

  @override
  Widget buildWidget(StackBoxStyler styler, StackNode node, RenderContext ctx,
      BuildContext context) {
    final children = node.children.map((c) => ctx.buildChild(c)).toList();
    return StackBox(style: styler, children: children);
  }
}

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../render_context.dart';
import 'style_helpers.dart';
import 'styled_node_handler.dart';

/// Handler for FlexNode → Mix FlexBox widget.
class FlexHandler extends StyledNodeHandler<FlexNode, FlexBoxStyler> {
  const FlexHandler();

  @override
  FlexBoxStyler createStyler() => FlexBoxStyler();

  @override
  FlexBoxStyler applyNodeProps(FlexBoxStyler styler, FlexNode node,
      RenderContext ctx, BuildContext context) {
    final dir = ctx.resolveValue<String>(node.direction, context);
    styler = dir == 'row' ? styler.row() : styler.column();

    final spacing = ctx.resolveValue<double>(node.spacing, context);
    if (spacing != null) styler = styler.spacing(spacing);

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

    return styler;
  }

  @override
  FlexBoxStyler applyStyleMap(FlexBoxStyler s, Map<String, SchemaValue> style,
          RenderContext ctx, BuildContext context) =>
      applyContainerStyleMap(s, style, ctx, context);

  @override
  Widget buildWidget(FlexBoxStyler styler, FlexNode node, RenderContext ctx,
      BuildContext context) {
    final children = node.children.map((c) => ctx.buildChild(c)).toList();
    return FlexBox(style: styler, children: children);
  }
}

import 'package:flutter/widgets.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';

/// Handler for WrapNode.
///
/// Uses Flutter Wrap directly — no Mix spec exists for this.
/// See freeze §5.5: "Use Flutter Wrap widget directly in handler"
class WrapHandler extends NodeHandler<WrapNode> {
  const WrapHandler();

  @override
  Widget build(WrapNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final spacing = ctx.resolveValue<double>(node.spacing, context) ?? 0;
      final runSpacing =
          ctx.resolveValue<double>(node.runSpacing, context) ?? 0;

      final children = node.children.map((c) => ctx.buildChild(c)).toList();

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: children,
      );
    });
  }
}

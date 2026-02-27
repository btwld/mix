import 'package:flutter/widgets.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import '../schema_data_context.dart';
import 'style_helpers.dart';

/// Handler for RepeatNode.
///
/// Control node — iterates data and renders template per item.
/// Creates a scoped SchemaDataContext for each iteration.
///
/// **Experimental**: Included ahead of Phase 2 schedule (freeze §10 Step 4).
/// API may change when streaming/patch support is added.
class RepeatHandler extends NodeHandler<RepeatNode> {
  const RepeatHandler();

  @override
  Widget build(RepeatNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final items = ctx.resolveValue<List>(node.items, context) ?? [];

      return wrapWithSemantics(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++)
              Builder(
                builder: (_) {
                  final parentData =
                      ctx.dataContext ?? SchemaDataContext.root();
                  final childData = parentData.child(
                    alias: node.itemAlias,
                    item: items[i],
                    index: i,
                  );

                  return ctx
                      .copyWith(dataContext: childData)
                      .buildChild(node.template);
                },
              ),
          ],
        ),
        node.semantics,
      );
    });
  }
}

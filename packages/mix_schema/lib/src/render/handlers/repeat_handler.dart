import 'package:flutter/widgets.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import '../schema_data_context.dart';

/// Handler for RepeatNode.
///
/// Control node — iterates data and renders template per item.
/// Creates a scoped SchemaDataContext for each iteration.
class RepeatHandler extends NodeHandler<RepeatNode> {
  const RepeatHandler();

  @override
  Widget build(RepeatNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      final items = ctx.resolveValue<List>(node.items, context) ?? [];

      return Column(
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
      );
    });
  }
}

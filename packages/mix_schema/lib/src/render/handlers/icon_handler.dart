import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for IconNode → Mix StyledIcon widget.
class IconHandler extends NodeHandler<IconNode> {
  const IconHandler();

  @override
  Widget build(IconNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = IconStyler();
      styler = applyIconStyle(styler, node.style, ctx, context);
      styler = applyIconVariants(styler, node.variants, ctx, context);
      styler = applyIconAnimation(styler, node.animation);

      final iconValue = ctx.resolveValue<dynamic>(node.icon, context);
      final iconData = resolveIconData(iconValue);

      return wrapWithSemantics(
        StyledIcon(icon: iconData, style: styler),
        node.semantics,
      );
    });
  }
}

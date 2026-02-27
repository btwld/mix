import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../render_context.dart';
import 'style_helpers.dart';
import 'styled_node_handler.dart';

/// Handler for IconNode → Mix StyledIcon widget.
class IconHandler extends StyledNodeHandler<IconNode, IconStyler> {
  const IconHandler();

  @override
  IconStyler createStyler() => IconStyler();

  @override
  IconStyler applyStyleMap(IconStyler s, Map<String, SchemaValue> style,
          RenderContext ctx, BuildContext context) =>
      applyIconStyle(s, style, ctx, context);

  @override
  Widget buildWidget(IconStyler styler, IconNode node, RenderContext ctx,
      BuildContext context) {
    final iconValue = ctx.resolveValue<dynamic>(node.icon, context);
    final iconData = resolveIconData(iconValue);
    return StyledIcon(icon: iconData, style: styler);
  }
}

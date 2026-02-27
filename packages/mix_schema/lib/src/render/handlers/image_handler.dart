import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../render_context.dart';
import 'style_helpers.dart';
import 'styled_node_handler.dart';

/// Handler for ImageNode → Mix StyledImage widget.
class ImageHandler extends StyledNodeHandler<ImageNode, ImageStyler> {
  const ImageHandler();

  @override
  ImageStyler createStyler() => ImageStyler();

  @override
  ImageStyler applyStyleMap(ImageStyler s, Map<String, SchemaValue> style,
          RenderContext ctx, BuildContext context) =>
      applyImageStyleMap(s, style, ctx, context);

  @override
  Widget buildWidget(ImageStyler styler, ImageNode node, RenderContext ctx,
      BuildContext context) {
    final src = ctx.resolveValue<String>(node.src, context) ?? '';
    return StyledImage(image: NetworkImage(src), style: styler);
  }
}

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Handler for ImageNode → Mix StyledImage widget.
class ImageHandler extends NodeHandler<ImageNode> {
  const ImageHandler();

  @override
  Widget build(ImageNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = ImageStyler();
      styler = _applyImageStyle(styler, node.style, ctx, context);
      styler = applyImageVariants(styler, node.variants, ctx, context);
      styler = applyImageAnimation(styler, node.animation);

      final src = ctx.resolveValue<String>(node.src, context) ?? '';

      return StyledImage(
        image: NetworkImage(src),
        style: styler,
      );
    });
  }

  ImageStyler _applyImageStyle(
    ImageStyler styler,
    Map<String, SchemaValue>? style,
    RenderContext ctx,
    BuildContext context,
  ) {
    if (style == null) return styler;

    for (final entry in style.entries) {
      final resolved = ctx.resolveValue<dynamic>(entry.value, context);
      if (resolved == null) continue;

      styler = switch (entry.key) {
        'width' => styler.width(_toDouble(resolved)),
        'height' => styler.height(_toDouble(resolved)),
        'fit' => styler.fit(_parseBoxFit(resolved as String)),
        _ => skipUnknown(styler, entry.key, ctx),
      };
    }
    return styler;
  }

  BoxFit _parseBoxFit(String value) => switch (value) {
        'contain' => BoxFit.contain,
        'cover' => BoxFit.cover,
        'fill' => BoxFit.fill,
        'fitWidth' => BoxFit.fitWidth,
        'fitHeight' => BoxFit.fitHeight,
        'none' => BoxFit.none,
        'scaleDown' => BoxFit.scaleDown,
        _ => BoxFit.contain,
      };
}

double _toDouble(dynamic v) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return 0.0;
}

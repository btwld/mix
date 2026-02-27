import 'package:flutter/widgets.dart';

import '../../ast/schema_node.dart';
import '../../ast/schema_values.dart';
import '../node_handler.dart';
import '../render_context.dart';
import 'style_helpers.dart';

/// Base class for handlers that follow the standard styler pattern:
/// create styler → apply node props → apply style map → apply variants
/// → animate → build widget → wrap with semantics.
///
/// Subclasses only need to provide their styler factory, style-map applier,
/// and widget builder. Override [applyNodeProps] for node-specific properties
/// like direction/spacing on FlexNode.
abstract class StyledNodeHandler<N extends SchemaNode, S>
    extends NodeHandler<N> {
  const StyledNodeHandler();

  /// Create a fresh styler instance.
  S createStyler();

  /// Apply node-specific properties (direction, spacing, alignment, etc.)
  /// before the generic style map. Default is a no-op.
  S applyNodeProps(
          S styler, N node, RenderContext ctx, BuildContext context) =>
      styler;

  /// Apply the style map entries to the styler.
  S applyStyleMap(S styler, Map<String, SchemaValue> style, RenderContext ctx,
      BuildContext context);

  /// Build the final widget from the configured styler and node.
  Widget buildWidget(
      S styler, N node, RenderContext ctx, BuildContext context);

  @override
  Widget build(N node, RenderContext ctx) {
    return Builder(builder: (context) {
      var styler = createStyler();
      styler = applyNodeProps(styler, node, ctx, context);

      if (node.style != null) {
        styler = applyStyleMap(styler, node.style!, ctx, context);
      }

      if (node.variants != null) {
        styler = applyVariants<S>(
          styler,
          node.variants,
          ctx,
          context,
          applyStyleMap,
          createStyler,
        );
      }

      styler = applyAnimation(styler, node.animation);

      return wrapWithSemantics(
        buildWidget(styler, node, ctx, context),
        node.semantics,
      );
    });
  }
}

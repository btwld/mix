import 'package:flutter/widgets.dart';

import '../ast/schema_node.dart';
import 'render_context.dart';

/// Base interface for AST node handlers.
///
/// Each handler knows how to build a Flutter widget from a specific
/// SchemaNode type.
abstract class NodeHandler<N extends SchemaNode> {
  const NodeHandler();

  Widget build(N node, RenderContext context);
}

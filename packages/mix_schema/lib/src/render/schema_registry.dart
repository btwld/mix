import '../ast/schema_node.dart';
import 'node_handler.dart';

/// Registry mapping SchemaNode types to their handlers.
class SchemaRegistry {
  final Map<Type, NodeHandler> _handlers;

  SchemaRegistry(this._handlers);

  /// Look up the handler for a node.
  NodeHandler? handlerFor(SchemaNode node) => _handlers[node.runtimeType];

  /// Register a handler for a node type.
  void register<N extends SchemaNode>(NodeHandler<N> handler) {
    _handlers[N] = handler;
  }
}

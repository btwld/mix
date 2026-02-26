import 'package:flutter/material.dart';

import '../ast/schema_node.dart';
import '../ast/ui_schema_root.dart';
import '../events/schema_event.dart';
import '../tokens/schema_token_resolver.dart';
import '../trust/schema_trust.dart';
import 'render_context.dart';
import 'schema_data_context.dart';
import 'schema_registry.dart';

/// Core renderer: walks the AST and dispatches to registered handlers.
class SchemaRenderer {
  final SchemaRegistry _registry;
  final SchemaTokenResolver _tokenResolver;

  SchemaRenderer({
    required SchemaRegistry registry,
    SchemaTokenResolver? tokenResolver,
  })  : _registry = registry,
        _tokenResolver = tokenResolver ?? const MixScopeTokenResolver();

  /// Public getter so SchemaEngine (and tests) can access the token resolver.
  SchemaTokenResolver get tokenResolver => _tokenResolver;

  /// Entry point: creates the RenderContext and starts the render walk.
  Widget render(
    UiSchemaRoot root, {
    SchemaTrust? trust,
    SchemaDataContext? dataContext,
    void Function(SchemaEvent)? onEvent,
  }) {
    final context = RenderContext(
      tokenResolver: _tokenResolver,
      trust: trust ?? root.trust,
      buildNode: _buildNode,
      dataContext: dataContext ??
          (root.environment?.data != null
              ? SchemaDataContext.root(root.environment!.data)
              : null),
      onEvent: onEvent,
    );
    return _buildNode(root.root, context);
  }

  Widget _buildNode(SchemaNode node, RenderContext context) {
    final handler = _registry.handlerFor(node);
    if (handler == null) {
      return _fallbackWidget(node);
    }
    return handler.build(node, context);
  }

  Widget _fallbackWidget(SchemaNode node) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(8),
      child: Text('Unsupported: ${node.runtimeType}'),
    );
  }
}

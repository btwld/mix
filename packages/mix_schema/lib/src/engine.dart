import 'package:flutter/widgets.dart';

import 'ast/schema_node.dart';
import 'adapters/a2ui_v08_adapter.dart';
import 'adapters/a2ui_v09_adapter.dart';
import 'adapters/wire_adapter.dart';
import 'ast/ui_schema_root.dart';
import 'components/component_registry.dart';
import 'events/schema_event.dart';
import 'render/schema_data_context.dart';
import 'render/schema_registry.dart';
import 'render/schema_renderer.dart';
import 'trust/schema_trust.dart';
import 'validate/default_validator.dart';
import 'validate/schema_validator.dart';

/// Public facade for the schema pipeline: adapt → validate → render.
class SchemaEngine {
  final Map<String, WireAdapter> _adapters;
  final SchemaValidator _validator;
  final SchemaRenderer _renderer;
  final ComponentRegistry _components;

  SchemaEngine({
    List<WireAdapter>? adapters,
    SchemaValidator? validator,
    SchemaRenderer? renderer,
    ComponentRegistry? components,
  })  : _adapters = {
          for (final a in (adapters ??
              const [A2uiV09Adapter(), A2uiV08Adapter()]))
            a.id: a,
        },
        _validator = validator ?? const DefaultSchemaValidator(),
        _renderer = renderer ??
            SchemaRenderer(registry: SchemaRegistry.defaults()),
        _components = components ?? ComponentRegistry.defaults();

  /// Adapt a wire payload to canonical AST.
  AdaptResult adapt(
    Object wirePayload, {
    required String adapterId,
    SchemaTrust trust = SchemaTrust.standard,
  }) {
    final adapter = _adapters[adapterId];
    if (adapter == null) {
      throw ArgumentError('Unknown adapter: $adapterId');
    }
    return adapter.adapt(wirePayload, AdaptContext(trust: trust));
  }

  /// Validate a canonical AST.
  ValidationResult validate(UiSchemaRoot root, {SchemaTrust? trust}) {
    return _validator.validate(
      root,
      ValidationContext(trust: trust ?? root.trust),
    );
  }

  /// Build a Flutter widget tree from canonical AST.
  Widget build(
    UiSchemaRoot root, {
    void Function(SchemaEvent)? onEvent,
    SchemaDataContext? dataContext,
  }) {
    return _renderer.render(
      root,
      trust: root.trust,
      onEvent: onEvent,
      dataContext: dataContext,
    );
  }

  /// Expand a high-level component into AST nodes.
  SchemaNode? expandComponent(
    String componentType,
    Map<String, dynamic> props,
    String nodeId,
  ) {
    return _components.expand(componentType, props, nodeId);
  }
}

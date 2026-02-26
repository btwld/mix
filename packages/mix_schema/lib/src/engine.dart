import 'package:flutter/widgets.dart';

import 'adapters/a2ui_v09_adapter.dart';
import 'adapters/wire_adapter.dart';
import 'ast/ui_schema_root.dart';
import 'events/schema_event.dart';
import 'render/schema_data_context.dart';
import 'render/schema_registry.dart';
import 'render/schema_renderer.dart';
import 'trust/schema_trust.dart';
import 'validate/default_validator.dart';
import 'validate/diagnostics.dart';
import 'validate/schema_validator.dart';

/// Public facade for the schema pipeline: adapt → validate → render.
class SchemaEngine {
  final Map<String, WireAdapter> _adapters;
  final SchemaValidator _validator;
  final SchemaRenderer _renderer;

  SchemaEngine({
    List<WireAdapter>? adapters,
    SchemaValidator? validator,
    SchemaRenderer? renderer,
  })  : _adapters = {
          for (final a in (adapters ??
              const [A2uiV09Adapter()]))
            a.id: a,
        },
        _validator = validator ?? const DefaultSchemaValidator(),
        _renderer = renderer ??
            SchemaRenderer(registry: SchemaRegistry.defaults());

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
  ///
  /// Automatically validates the schema before rendering. If validation
  /// produces errors, throws a [SchemaValidationException] unless
  /// [skipValidation] is true.
  Widget build(
    UiSchemaRoot root, {
    void Function(SchemaEvent)? onEvent,
    SchemaDataContext? dataContext,
    bool skipValidation = false,
  }) {
    if (!skipValidation) {
      final result = validate(root);
      if (!result.isValid) {
        throw SchemaValidationException(result.diagnostics);
      }
    }

    return _renderer.render(
      root,
      trust: root.trust,
      onEvent: onEvent,
      dataContext: dataContext,
    );
  }
}

/// Thrown when [SchemaEngine.build] encounters validation errors.
class SchemaValidationException implements Exception {
  final List<SchemaDiagnostic> diagnostics;

  const SchemaValidationException(this.diagnostics);

  @override
  String toString() {
    final errors = diagnostics
        .where((d) => d.severity == DiagnosticSeverity.error)
        .map((d) => '  - ${d.message}')
        .join('\n');
    return 'SchemaValidationException: schema has validation errors:\n$errors';
  }
}

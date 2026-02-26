import 'package:flutter/widgets.dart';

import '../ast/ui_schema_root.dart';
import '../events/schema_event.dart';
import '../trust/schema_trust.dart';
import '../validate/diagnostics.dart';
import 'schema_scope.dart';

/// Drop-in widget for rendering a schema.
///
/// Looks up SchemaEngine from SchemaScope, validates, and renders.
/// Provides error callback for validation failures.
class SchemaWidget extends StatelessWidget {
  final UiSchemaRoot schema;
  final SchemaTrust? trust;
  final void Function(SchemaEvent)? onEvent;
  final Widget Function(List<SchemaDiagnostic>)? onError;

  const SchemaWidget({
    super.key,
    required this.schema,
    this.trust,
    this.onEvent,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    final engine = SchemaScope.engineOf(context);

    // Engine.build() auto-validates. If an error callback is provided,
    // we pre-validate to show errors instead of throwing.
    if (onError != null) {
      final validation = engine.validate(schema, trust: trust);
      if (!validation.isValid) {
        return onError!(validation.diagnostics);
      }
    }

    return engine.build(schema, onEvent: onEvent);
  }
}

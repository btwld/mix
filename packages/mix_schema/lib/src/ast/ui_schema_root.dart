import 'schema_node.dart';
import 'schema_values.dart';
import '../trust/schema_trust.dart';

/// Root container for a canonical UI schema.
///
/// Every schema has identity, version, a root node, and a trust level.
final class UiSchemaRoot {
  final String id;
  final String schemaVersion; // "0.1"
  final SchemaNode root;
  final SchemaTrust trust;
  final SchemaEnvironment? environment;

  const UiSchemaRoot({
    required this.id,
    required this.schemaVersion,
    required this.root,
    required this.trust,
    this.environment,
  });
}

/// Environment data provided alongside the schema.
final class SchemaEnvironment {
  final Map<String, dynamic>? data; // initial data context
  final Map<String, dynamic>? state; // initial local state
  final Map<String, SchemaValue>? tokens; // token overrides
  final List<String>? breakpoints; // breakpoint names in order

  const SchemaEnvironment({
    this.data,
    this.state,
    this.tokens,
    this.breakpoints,
  });
}

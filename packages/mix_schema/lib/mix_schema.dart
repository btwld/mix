/// Schema-driven UI rendering for Mix.
///
/// Bridges AI agent protocols with Mix's styling system:
/// ```
/// External protocols in → Canonical AST in the middle → Mix renderer out
/// ```
library mix_schema;

// AST — public types consumers create and inspect
export 'src/ast/schema_node.dart'; // includes SchemaSemantics
export 'src/ast/schema_values.dart';
export 'src/ast/ui_schema_root.dart';

// Adapters — wire protocol adapter + data types
export 'src/adapters/a2ui_v09_adapter.dart';
export 'src/adapters/wire_adapter.dart'; // AdaptContext, AdaptResult

// Validation — result types + diagnostics
export 'src/validate/diagnostics.dart';
export 'src/validate/schema_validator.dart'; // ValidationContext, ValidationResult

// Trust — trust level enum + capability matrix
export 'src/trust/capability_matrix.dart' show SchemaTrust;

// Events — public types for event handling
export 'src/events/schema_event.dart';

// Render — consumer-facing widgets only
export 'src/render/schema_renderer.dart';
export 'src/render/schema_scope.dart';
export 'src/render/schema_widget.dart';

// Engine — public API facade
export 'src/engine.dart';

/// Schema-driven UI rendering for Mix.
///
/// Bridges AI agent protocols with Mix's styling system:
/// ```
/// External protocols in → Canonical AST in the middle → Mix renderer out
/// ```
library mix_schema;

// AST — public types consumers create and inspect
export 'src/ast/schema_node.dart';
export 'src/ast/schema_semantics.dart';
export 'src/ast/schema_values.dart';
export 'src/ast/ui_schema_root.dart';

// Adapters — public: consumers may implement custom adapters
export 'src/adapters/a2ui_v09_adapter.dart';
export 'src/adapters/wire_adapter.dart';

// Validation — public interface + result types only
export 'src/validate/diagnostics.dart';
export 'src/validate/schema_validator.dart';

// Trust — trust level enum
export 'src/trust/schema_trust.dart';

// Events — public types for event handling
export 'src/events/schema_event.dart';

// Render — consumer-facing widgets only
export 'src/render/schema_renderer.dart';
export 'src/render/schema_scope.dart';
export 'src/render/schema_widget.dart';

// Engine — public API facade
export 'src/engine.dart';

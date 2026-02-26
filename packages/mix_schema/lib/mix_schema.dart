/// Schema-driven UI rendering for Mix.
///
/// Bridges AI agent protocols with Mix's styling system:
/// ```
/// External protocols in → Canonical AST in the middle → Mix renderer out
/// ```
library mix_schema;

// AST
export 'src/ast/schema_node.dart';
export 'src/ast/schema_semantics.dart';
export 'src/ast/schema_values.dart';
export 'src/ast/ui_schema_root.dart';

// Adapters
export 'src/adapters/a2ui_v08_adapter.dart';
export 'src/adapters/a2ui_v09_adapter.dart';
export 'src/adapters/wire_adapter.dart';

// Validation
export 'src/validate/default_validator.dart';
export 'src/validate/diagnostics.dart';
export 'src/validate/schema_validator.dart';
export 'src/validate/semantic_rules.dart';
export 'src/validate/structural_rules.dart';
export 'src/validate/trust_rules.dart';

// Trust
export 'src/trust/capability_matrix.dart';
export 'src/trust/schema_trust.dart';

// Events & Actions
export 'src/events/schema_action.dart';
export 'src/events/schema_event.dart';

// Render
export 'src/render/node_handler.dart';
export 'src/render/render_context.dart';
export 'src/render/schema_data_context.dart';
export 'src/render/schema_registry.dart';
export 'src/render/schema_renderer.dart';
export 'src/render/schema_scope.dart';
export 'src/render/schema_widget.dart';

// Tokens
export 'src/tokens/schema_token_resolver.dart';

// Components
export 'src/components/component_registry.dart';

// Engine (public API facade)
export 'src/engine.dart';

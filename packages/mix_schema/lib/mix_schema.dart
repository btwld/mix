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
export 'src/adapters/wire_adapter.dart';

// Validation
export 'src/validate/diagnostics.dart';
export 'src/validate/schema_validator.dart';

// Trust
export 'src/trust/capability_matrix.dart';
export 'src/trust/schema_trust.dart';

// Events & Actions
export 'src/events/schema_action.dart';
export 'src/events/schema_event.dart';

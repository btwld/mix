import '../ast/ui_schema_root.dart';
import 'diagnostics.dart';
import 'schema_validator.dart';
import 'semantic_rules.dart';
import 'structural_rules.dart';
import 'trust_rules.dart';

/// Default validator composing structural, trust, and semantic rules.
///
/// See freeze §7.1: two validation layers:
/// 1. Structural (shape-level)
/// 2. Runtime (cross-field/catalog/trust-aware, including semantic checks)
class DefaultSchemaValidator implements SchemaValidator {
  final StructuralRules _structural;
  final TrustRules _trust;
  final SemanticRules _semantic;

  const DefaultSchemaValidator({
    StructuralRules structural = const StructuralRules(),
    TrustRules trust = const TrustRules(),
    SemanticRules semantic = const SemanticRules(),
  })  : _structural = structural,
        _trust = trust,
        _semantic = semantic;

  @override
  ValidationResult validate(UiSchemaRoot root, ValidationContext context) {
    final diagnostics = <SchemaDiagnostic>[];

    // Layer 1: Structural rules
    diagnostics.addAll(_structural.validate(root.root));

    // Layer 2: Trust rules
    diagnostics.addAll(
      _trust.validate(
        root.root,
        context.trust,
        maxDepthOverride: context.maxDepth,
        maxNodeCountOverride: context.maxNodeCount,
      ),
    );

    // Layer 3: Semantic rules
    diagnostics.addAll(_semantic.validate(root.root));

    final hasErrors =
        diagnostics.any((d) => d.severity == DiagnosticSeverity.error);

    return ValidationResult(
      isValid: !hasErrors,
      diagnostics: diagnostics,
    );
  }
}

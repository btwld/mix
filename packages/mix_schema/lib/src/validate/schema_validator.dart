import '../ast/ui_schema_root.dart';
import '../trust/schema_trust.dart';
import 'diagnostics.dart';

/// Interface for schema validation.
///
/// Two layers per freeze §7.1:
/// 1. Structural validation (shape-level)
/// 2. Runtime validation (cross-field/catalog/trust-aware)
abstract class SchemaValidator {
  ValidationResult validate(UiSchemaRoot root, ValidationContext context);
}

/// Context provided to validators.
final class ValidationContext {
  final SchemaTrust trust;
  final Set<String>? allowedActions; // null = use defaults
  final int? maxDepth; // null = use trust default
  final int? maxNodeCount; // null = use trust default

  const ValidationContext({
    required this.trust,
    this.allowedActions,
    this.maxDepth,
    this.maxNodeCount,
  });
}

/// Result of validation.
final class ValidationResult {
  final bool isValid;
  final List<SchemaDiagnostic> diagnostics;

  const ValidationResult({
    required this.isValid,
    this.diagnostics = const [],
  });
}

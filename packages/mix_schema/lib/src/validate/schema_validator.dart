import '../trust/capability_matrix.dart';
import 'diagnostics.dart';

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

import 'mix_schema_error.dart';

/// The result of validating a `mix_schema` payload.
final class MixSchemaValidationResult {
  /// Aggregated validation errors when [ok] is false.
  final List<MixSchemaError> errors;

  const MixSchemaValidationResult._({required this.errors});

  /// Creates a successful validation result.
  factory MixSchemaValidationResult.success() {
    return const MixSchemaValidationResult._(errors: []);
  }

  /// Creates a failed validation result with aggregated validation errors.
  factory MixSchemaValidationResult.failure(List<MixSchemaError> errors) {
    return MixSchemaValidationResult._(
      errors: List<MixSchemaError>.unmodifiable(errors),
    );
  }

  /// Whether validation succeeded without errors.
  bool get ok => errors.isEmpty;
}

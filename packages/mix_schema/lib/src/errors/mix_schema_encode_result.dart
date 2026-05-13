import 'mix_schema_error.dart';

/// The result of encoding a Mix runtime value into a `mix_schema` payload.
final class MixSchemaEncodeResult<T extends Object> {
  /// The encoded payload when [ok] is true.
  final T? value;

  /// Aggregated encode errors when [ok] is false.
  final List<MixSchemaError> errors;

  const MixSchemaEncodeResult._({required this.value, required this.errors});

  /// Creates a successful encode result with an encoded value.
  factory MixSchemaEncodeResult.success(T value) {
    return MixSchemaEncodeResult._(value: value, errors: const []);
  }

  /// Creates a failed encode result with aggregated errors.
  factory MixSchemaEncodeResult.failure(List<MixSchemaError> errors) {
    return MixSchemaEncodeResult._(
      value: null,
      errors: List<MixSchemaError>.unmodifiable(errors),
    );
  }

  /// Whether encoding succeeded without errors.
  bool get ok => errors.isEmpty;
}

import 'mix_schema_error.dart';

/// The result of decoding a `mix_schema` payload.
final class MixSchemaDecodeResult<T extends Object> {
  /// The decoded value when [ok] is true.
  final T? value;

  /// Aggregated decode errors when [ok] is false.
  final List<MixSchemaError> errors;

  const MixSchemaDecodeResult._({required this.value, required this.errors});

  /// Creates a successful decode result with a decoded value.
  factory MixSchemaDecodeResult.success(T value) {
    return MixSchemaDecodeResult._(value: value, errors: const []);
  }

  /// Creates a failed decode result with aggregated validation errors.
  factory MixSchemaDecodeResult.failure(List<MixSchemaError> errors) {
    return MixSchemaDecodeResult._(
      value: null,
      errors: List<MixSchemaError>.unmodifiable(errors),
    );
  }

  /// Whether decoding succeeded without errors.
  bool get ok => errors.isEmpty;
}

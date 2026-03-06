import 'mix_schema_error_code.dart';

/// A single stable validation or transform error reported by `mix_schema`.
final class MixSchemaError {
  final MixSchemaErrorCode code;

  final String path;
  final String message;
  final Object? value;
  const MixSchemaError({
    required this.code,
    required this.path,
    required this.message,
    this.value,
  });

  /// Serializes the error into the public wire shape.
  Map<String, Object?> toJson() {
    return {
      'code': code.wireValue,
      'path': path,
      'message': message,
      ...?switch (value) {
        final currentValue? => <String, Object?>{'value': currentValue},
        null => null,
      },
    };
  }
}

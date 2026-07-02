import 'package:ack/ack.dart';

/// Stable public error categories emitted by `mix_schema`.
enum MixSchemaErrorCode {
  /// Decoded value did not match the caller's requested Dart type.
  typeMismatch('type_mismatch'),

  /// A required payload field was absent.
  requiredField('required_field'),

  /// A payload contained a field not accepted by the schema.
  unknownField('unknown_field'),

  /// A string enum value was not in the supported wire vocabulary.
  invalidEnum('invalid_enum'),

  /// A scalar or structured value violated schema constraints.
  constraintViolation('constraint_violation'),

  /// A runtime value cannot be represented by the wire contract.
  unsupportedEncodeValue('unsupported_encode_value'),

  /// The root discriminator did not match any registered styler branch.
  unknownType('unknown_type'),

  /// A registry id was well formed but absent from the frozen registry.
  unknownRegistryId('unknown_registry_id'),

  /// A runtime identity value was not registered for encode.
  unknownRegistryValue('unknown_registry_value'),

  /// Ack reported a validation failure that did not map to a narrower code.
  validationFailed('validation_failed'),

  /// A decode or encode transform threw while processing a value.
  transformFailed('transform_failed');

  const MixSchemaErrorCode(this.wireValue);

  /// JSON-safe code emitted in [MixSchemaError.toJson].
  final String wireValue;
}

/// Path-qualified public schema error.
final class MixSchemaError {
  /// Creates an immutable schema error.
  const MixSchemaError({
    required this.code,
    required this.path,
    required this.message,
    this.value,
  });

  /// Stable category for this error.
  final MixSchemaErrorCode code;

  /// JSON Pointer-like path to the failing payload location.
  final String path;

  /// Human-readable explanation suitable for logs and diagnostics.
  final String message;

  /// Offending value when it is safe and useful to expose.
  final Object? value;

  /// Converts this error to a JSON-safe diagnostic map.
  JsonMap toJson() => {
    'code': code.wireValue,
    'path': path,
    'message': message,
    if (value != null) 'value': value,
  };

  @override
  String toString() => '${code.wireValue} at "$path": $message';
}

/// Result returned by [MixSchemaContract.validate].
sealed class MixSchemaValidationResult {
  const MixSchemaValidationResult();
}

/// Validation succeeded.
final class MixSchemaValidationSuccess extends MixSchemaValidationResult {
  /// Creates a validation success result.
  const MixSchemaValidationSuccess();
}

/// Validation failed with one or more path-qualified errors.
final class MixSchemaValidationFailure extends MixSchemaValidationResult {
  /// Creates a validation failure result.
  const MixSchemaValidationFailure(this.errors);

  /// Collected validation errors.
  final List<MixSchemaError> errors;
}

/// Result returned by [MixSchemaContract.decode].
sealed class MixSchemaDecodeResult<T extends Object> {
  const MixSchemaDecodeResult();
}

/// Decode succeeded with a value of type [T].
final class MixSchemaDecodeSuccess<T extends Object>
    extends MixSchemaDecodeResult<T> {
  /// Creates a decode success result.
  const MixSchemaDecodeSuccess(this.value);

  /// Decoded Mix styler or custom registered value.
  final T value;
}

/// Decode failed with one or more path-qualified errors.
final class MixSchemaDecodeFailure<T extends Object>
    extends MixSchemaDecodeResult<T> {
  /// Creates a decode failure result.
  const MixSchemaDecodeFailure(this.errors);

  /// Collected decode errors.
  final List<MixSchemaError> errors;
}

/// Result returned by [MixSchemaContract.encode].
sealed class MixSchemaEncodeResult {
  const MixSchemaEncodeResult();
}

/// Encode succeeded with a JSON payload.
final class MixSchemaEncodeSuccess extends MixSchemaEncodeResult {
  /// Creates an encode success result.
  const MixSchemaEncodeSuccess(this.value);

  /// Encoded JSON payload.
  final JsonMap value;
}

/// Encode failed with one or more path-qualified errors.
final class MixSchemaEncodeFailure extends MixSchemaEncodeResult {
  /// Creates an encode failure result.
  const MixSchemaEncodeFailure(this.errors);

  /// Collected encode errors.
  final List<MixSchemaError> errors;
}

/// Internal sentinel thrown by codecs for unsupported runtime values.
final class UnsupportedEncodeValueError implements Exception {
  /// Creates an unsupported-value sentinel.
  const UnsupportedEncodeValueError(this.value, this.reason);

  /// Runtime value that could not be represented.
  final Object? value;

  /// Explanation for why the value is unsupported.
  final String reason;

  @override
  String toString() => 'Unsupported encode value: $reason';
}

/// Internal sentinel thrown when a registry id cannot be resolved.
final class UnknownRegistryIdError implements Exception {
  /// Creates an unknown-id sentinel for [scope] and [id].
  const UnknownRegistryIdError(this.scope, this.id);

  /// Registry scope that was queried.
  final Object scope;

  /// Missing registry id.
  final String id;

  @override
  String toString() => 'Unknown registry id "$id" in $scope.';
}

/// Internal sentinel thrown when a runtime identity value is not registered.
final class UnknownRegistryValueError implements Exception {
  /// Creates an unknown-value sentinel for [scope] and [value].
  const UnknownRegistryValueError(this.scope, this.value);

  /// Registry scope searched during encode.
  final Object scope;

  /// Runtime value that had no registered id.
  final Object value;

  @override
  String toString() => 'Unknown registry value ${value.runtimeType} in $scope.';
}

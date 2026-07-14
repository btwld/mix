import '../contract/json_map.dart';

final Object _notJsonSafe = Object();

/// Stable public error categories emitted by `mix_protocol`.
enum MixProtocolErrorCode {
  /// A payload declares a wire format version this decoder cannot read.
  unsupportedVersion('unsupported_version'),

  /// A payload contains explicit JSON null where absence is required.
  nullForbidden('null_forbidden'),

  /// A payload exceeded the configured depth or node-count limit.
  limitExceeded('limit_exceeded'),

  /// Decoded value did not match the caller's requested Dart type.
  typeMismatch('type_mismatch'),

  /// A required payload field was absent.
  requiredField('required_field'),

  /// A payload contained a field not accepted by the schema.
  unknownField('unknown_field'),

  /// A string enum value was not in the supported wire vocabulary.
  invalidEnum('invalid_enum'),

  /// A token name did not match the v1 token-name grammar.
  invalidTokenName('invalid_token_name'),

  /// A scalar or structured value violated schema constraints.
  constraintViolation('constraint_violation'),

  /// A runtime value cannot be represented by the wire contract.
  unsupportedEncodeValue('unsupported_encode_value'),

  /// The runtime Mix surface and schema inventory disagree during encode.
  inventorySkew('inventory_skew'),

  /// The root discriminator did not match any built-in styler branch.
  unknownType('unknown_type'),

  /// An identity name was well formed but not resolved by decode options.
  unresolvedIdentityName('unresolved_identity_name'),

  /// A runtime identity value could not be named or encoded as a value form.
  unresolvedIdentityValue('unresolved_identity_value'),

  /// Ack reported a validation failure that did not map to a narrower code.
  validationFailed('validation_failed'),

  /// A decode or encode transform threw while processing a value.
  transformFailed('transform_failed');

  const MixProtocolErrorCode(this.wireValue);

  /// JSON-safe code emitted in [MixProtocolError.toJson].
  final String wireValue;
}

/// Severity for a protocol diagnostic.
enum MixProtocolDiagnosticSeverity {
  /// Fatal diagnostic returned in a failure result.
  error,

  /// Non-fatal diagnostic returned alongside a successful lenient decode.
  warning,
}

/// Path-qualified public protocol error.
final class MixProtocolError {
  /// Creates an immutable protocol error.
  const MixProtocolError({
    required this.code,
    required this.path,
    required this.message,
    this.value,
    this.severity = MixProtocolDiagnosticSeverity.error,
  });

  /// Stable category for this error.
  final MixProtocolErrorCode code;

  /// JSON Pointer-like path to the failing payload location.
  final String path;

  /// Human-readable explanation suitable for logs and diagnostics.
  final String message;

  /// Offending value when it is useful for in-process diagnostics.
  ///
  /// [toJson] omits this field when it is not recursively JSON-safe.
  final Object? value;

  /// Whether this diagnostic is fatal or advisory.
  final MixProtocolDiagnosticSeverity severity;

  /// Converts this error to a JSON-safe diagnostic map.
  JsonMap toJson() {
    final jsonValue = value == null
        ? _notJsonSafe
        : _jsonSafeDiagnosticValue(value, Set.identity());

    return {
      'code': code.wireValue,
      'severity': severity.name,
      'path': path,
      'message': message,
      if (!identical(jsonValue, _notJsonSafe)) 'value': jsonValue,
    };
  }

  @override
  String toString() => '${code.wireValue} at "$path": $message';
}

Object? _jsonSafeDiagnosticValue(Object? value, Set<Object> active) {
  if (value == null || value is String || value is bool || value is int) {
    return value;
  }
  if (value is double) return value.isFinite ? value : _notJsonSafe;

  if (value is List) {
    if (!active.add(value)) return _notJsonSafe;
    try {
      final output = <Object?>[];
      for (final item in value) {
        final jsonItem = _jsonSafeDiagnosticValue(item, active);
        if (identical(jsonItem, _notJsonSafe)) return _notJsonSafe;
        output.add(jsonItem);
      }
      return output;
    } finally {
      active.remove(value);
    }
  }

  if (value is Map) {
    if (!active.add(value)) return _notJsonSafe;
    try {
      final output = <String, Object?>{};
      for (final entry in value.entries) {
        final key = entry.key;
        if (key is! String) return _notJsonSafe;
        final jsonValue = _jsonSafeDiagnosticValue(entry.value, active);
        if (identical(jsonValue, _notJsonSafe)) return _notJsonSafe;
        output[key] = jsonValue;
      }
      return output;
    } finally {
      active.remove(value);
    }
  }

  return _notJsonSafe;
}

/// Result returned by a fallible Mix protocol operation.
sealed class MixProtocolResult<T extends Object> {
  MixProtocolResult({Iterable<MixProtocolError> warnings = const []})
    : warnings = List.unmodifiable(warnings);

  /// Non-fatal diagnostics collected while processing the operation.
  final List<MixProtocolError> warnings;
}

/// A successful protocol operation.
final class MixProtocolSuccess<T extends Object> extends MixProtocolResult<T> {
  /// Creates a success containing [value] and optional [warnings].
  MixProtocolSuccess(this.value, {super.warnings});

  /// Decoded runtime value or encoded JSON map.
  final T value;
}

/// A failed protocol operation.
final class MixProtocolFailure<T extends Object> extends MixProtocolResult<T> {
  /// Creates a failure with at least one path-qualified error.
  MixProtocolFailure(Iterable<MixProtocolError> errors, {super.warnings})
    : errors = List.unmodifiable(errors) {
    if (this.errors.isEmpty) {
      throw ArgumentError.value(errors, 'errors', 'Must not be empty.');
    }
  }

  /// Fatal diagnostics that prevented an output value.
  final List<MixProtocolError> errors;
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

/// Internal sentinel thrown for token names outside the v1 grammar.
final class InvalidTokenNameError implements Exception {
  /// Creates an invalid-token-name sentinel.
  const InvalidTokenNameError(this.name, this.fieldName);

  /// Invalid token name.
  final String name;

  /// Field where the token reference was found.
  final String fieldName;

  /// Explanation for why the name is invalid.
  String get reason =>
      'Field "$fieldName" references token "$name", which does not match '
      r'the [A-Za-z0-9_.-]{1,128} token-name grammar.';

  @override
  String toString() => reason;
}

/// Internal sentinel for schema errors that need a path below a transform root.
final class SchemaPathError implements Exception {
  /// Creates a path-qualified schema sentinel.
  const SchemaPathError({
    required this.code,
    required this.relativePath,
    required this.reason,
    this.value,
  });

  /// Public error code to emit.
  final MixProtocolErrorCode code;

  /// Path relative to the schema transform root.
  final String relativePath;

  /// Explanation for why the wire value is invalid.
  final String reason;

  /// Offending value, when useful to expose.
  final Object? value;

  @override
  String toString() => reason;
}

/// Internal sentinel thrown when codec coverage drifts from owner fields.
final class SchemaInventorySkewError implements Exception {
  /// Creates an inventory-skew sentinel.
  SchemaInventorySkewError({
    required this.owner,
    Iterable<String> missingFields = const [],
    Iterable<String> staleFields = const [],
    this.expectedFieldCount,
    this.actualFieldCount,
  }) : missingFields = Set.unmodifiable(missingFields),
       staleFields = Set.unmodifiable(staleFields);

  /// Owner type whose inventory did not match codec coverage.
  final String owner;

  /// Owner fields not consumed or explicitly marked unsupported by the codec.
  final Set<String> missingFields;

  /// Codec-declared fields no longer present on the owner inventory.
  final Set<String> staleFields;

  /// Number of owner fields the schema inventory expected, when known.
  final int? expectedFieldCount;

  /// Number of runtime owner fields observed, when known.
  final int? actualFieldCount;

  /// JSON-safe diagnostic value.
  JsonMap toJson() => {
    'owner': owner,
    if (missingFields.isNotEmpty) 'missingFields': missingFields.toList(),
    if (staleFields.isNotEmpty) 'staleFields': staleFields.toList(),
    if (expectedFieldCount != null) 'expectedFieldCount': expectedFieldCount,
    if (actualFieldCount != null) 'actualFieldCount': actualFieldCount,
  };

  @override
  String toString() {
    final parts = <String>[
      if (missingFields.isNotEmpty)
        'missing fields: ${missingFields.join(', ')}',
      if (staleFields.isNotEmpty) 'stale fields: ${staleFields.join(', ')}',
      if (expectedFieldCount != null && actualFieldCount != null)
        'field count: expected $expectedFieldCount, actual $actualFieldCount',
    ];

    return 'Schema inventory skew for $owner (${parts.join('; ')}).';
  }
}

/// Internal sentinel thrown when a named identity cannot be resolved.
final class UnresolvedIdentityNameError implements Exception {
  /// Creates an unresolved-name sentinel for [scope] and [name].
  const UnresolvedIdentityNameError(this.scope, this.name);

  /// Identity scope that was queried.
  final String scope;

  /// Missing identity name.
  final String name;

  @override
  String toString() => 'Unresolved $scope identity name "$name".';
}

/// Internal sentinel thrown when a runtime identity cannot be represented.
final class UnresolvedIdentityValueError implements Exception {
  /// Creates an unresolved-value sentinel for [scope] and [value].
  const UnresolvedIdentityValueError(this.scope, this.value);

  /// Identity scope searched during encode.
  final String scope;

  /// Runtime value that could not be represented.
  final Object value;

  @override
  String toString() => 'Unresolved $scope identity value ${value.runtimeType}.';
}

import 'mix_schema_error.dart';

/// Thrown when a registry lookup fails during schema transform.
final class RegistryLookupError implements Exception {
  final String scope;

  final String id;
  const RegistryLookupError(this.scope, this.id);

  @override
  String toString() => 'Unknown registry id "$id" in scope "$scope".';
}

/// Thrown when a registry value exists but its runtime type is incompatible.
final class RegistryTypeMismatchError implements Exception {
  final String scope;

  final String id;
  final String expectedType;
  final String actualType;
  const RegistryTypeMismatchError({
    required this.scope,
    required this.id,
    required this.expectedType,
    required this.actualType,
  });

  @override
  String toString() {
    return 'Registry value "$id" in scope "$scope" had type '
        '$actualType, expected $expectedType.';
  }
}

/// Thrown when a runtime value cannot be encoded because no registry id exists.
final class RegistryValueLookupError implements Exception {
  final String scope;

  final String expectedType;
  final Object value;
  const RegistryValueLookupError({
    required this.scope,
    required this.expectedType,
    required this.value,
  });

  @override
  String toString() {
    return 'No registry id found in scope "$scope" for $expectedType value.';
  }
}

/// Thrown when a runtime value is intentionally outside the encodable contract.
final class UnsupportedEncodeValueError implements Exception {
  final String reason;

  final Object? value;
  const UnsupportedEncodeValueError(this.reason, {this.value});

  @override
  String toString() => reason;
}

/// Thrown when a transform delegates to nested schema parsing and needs to
/// preserve the resulting path-specific validation errors.
final class NestedSchemaErrorsException implements Exception {
  final List<MixSchemaError> errors;

  const NestedSchemaErrorsException(this.errors);

  @override
  String toString() {
    return errors
        .map((error) => '${error.code.wireValue} at ${error.path}')
        .join(', ');
  }
}

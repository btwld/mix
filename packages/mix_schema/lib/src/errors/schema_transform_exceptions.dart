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

/// Thrown when a value is intentionally unsupported by the wire contract.
final class UnsupportedValueError implements Exception {
  final String reason;

  const UnsupportedValueError(this.reason);

  @override
  String toString() => reason;
}

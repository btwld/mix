/// Scope wire vocabulary. Matches the styler-type grammar so scope names stay
/// stable wire identifiers.
final RegExp kRegistryScopePattern = RegExp(r'^[a-z][a-z0-9_]*$');

/// Registry id grammar. Producer-facing ids stay bounded to a stable
/// alphabet that survives URL/JSON quoting without escaping.
final RegExp kRegistryIdPattern = RegExp(r'^[A-Za-z0-9._:-]+$');

/// Canonical maximum length for registry ids on the wire.
const int kMaxRegistryIdLength = 256;

void assertValidRegistryScope(String scope) {
  if (!kRegistryScopePattern.hasMatch(scope)) {
    throw ArgumentError.value(
      scope,
      'scope',
      'Registry scope must match ${kRegistryScopePattern.pattern}.',
    );
  }
}

void assertValidRegistryId(String id, {String name = 'id'}) {
  if (!kRegistryIdPattern.hasMatch(id)) {
    throw ArgumentError.value(
      id,
      name,
      'Registry id must match ${kRegistryIdPattern.pattern}.',
    );
  }

  if (id.length > kMaxRegistryIdLength) {
    throw ArgumentError.value(
      id,
      name,
      'Registry id must be at most $kMaxRegistryIdLength characters.',
    );
  }
}

/// Scope wire vocabulary. Matches the styler-type grammar so scope names stay
/// stable wire identifiers.
final RegExp kRegistryScopePattern = RegExp(r'^[a-z][a-z0-9_]*$');

/// Registry id grammar. Producer-facing ids stay bounded to a stable
/// alphabet that survives URL/JSON quoting without escaping.
final RegExp kRegistryIdPattern = RegExp(r'^[A-Za-z0-9._:-]+$');

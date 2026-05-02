/// Host-reference resolution.
///
/// `HostRef` is the spec's escape hatch for non-serializable surface —
/// custom shaders, custom clippers, etc. (spec.md §Host references).
/// Consumers wire their own [HostResolver] to bind opaque ids to runtime
/// values.
///
/// Per spec §Security Considerations, consumers SHOULD maintain an
/// allowlist of permitted host identifiers; any id absent from the
/// allowlist MUST fail with `host.unresolved`.
library;

/// Resolves a `HostRef` id to a runtime object.
///
/// Implementations control which ids are permitted. The
/// [AllowlistHostResolver] reference implementation matches spec
/// guidance.
abstract interface class HostResolver {
  /// Resolve [id] to a runtime object. Returns `null` when the id is
  /// not registered — callers raise `host.unresolved`.
  Object? resolve(String id);
}

/// Reference [HostResolver] backed by a fixed allowlist + bindings map.
class AllowlistHostResolver implements HostResolver {
  /// Build with [bindings] mapping every permitted id to its runtime
  /// value. Ids absent from [bindings] resolve to `null`.
  const AllowlistHostResolver(this.bindings);

  /// Permitted ids and their bound runtime values.
  final Map<String, Object> bindings;

  @override
  Object? resolve(String id) => bindings[id];
}

/// Empty resolver — never resolves anything. Useful for tests where
/// host references should never be consulted.
class EmptyHostResolver implements HostResolver {
  const EmptyHostResolver();

  @override
  Object? resolve(String id) => null;
}

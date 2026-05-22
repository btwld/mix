import 'registry_wire_grammar.dart';

/// Immutable runtime registry used during payload decoding.
final class FrozenRegistry<T extends Object> {
  /// The logical registry scope used on the wire.
  final String scope;

  final Map<String, T> _values;
  final Map<T, String> _reverseIndex;

  /// Validates [scope] and every id in [values] against the shared registry
  /// grammar. Construction fails fast so producers cannot ship a registry that
  /// would later be rejected at the wire boundary.
  factory FrozenRegistry({
    required String scope,
    required Map<String, T> values,
  }) {
    assertValidRegistryScope(scope);
    for (final id in values.keys) {
      assertValidRegistryId(id, name: 'values');
    }

    return FrozenRegistry._(
      scope: scope,
      values: values,
      reverseIndex: _buildReverseIndex(scope, values),
    );
  }

  FrozenRegistry._({
    required this.scope,
    required Map<String, T> values,
    required Map<T, String> reverseIndex,
  }) : _values = Map<String, T>.unmodifiable(values),
       _reverseIndex = Map<T, String>.unmodifiable(reverseIndex);

  /// All registered ids available in this frozen registry.
  Iterable<String> get ids => _values.keys;

  /// Looks up a registered value by id.
  T? lookup(String id) => _values[id];

  /// Looks up the registered id for [value], if one exists.
  String? keyOf(T value) => _reverseIndex[value];
}

Map<T, String> _buildReverseIndex<T extends Object>(
  String scope,
  Map<String, T> values,
) {
  final reverseIndex = <T, String>{};
  for (final entry in values.entries) {
    final existingId = reverseIndex[entry.value];
    if (existingId != null && existingId != entry.key) {
      throw StateError(
        'Registry "$scope" already indexes this value under "$existingId".',
      );
    }
    reverseIndex[entry.value] = entry.key;
  }

  return reverseIndex;
}

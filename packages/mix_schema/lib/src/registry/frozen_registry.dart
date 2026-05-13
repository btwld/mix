/// Immutable runtime registry used during payload decoding.
final class FrozenRegistry<T extends Object> {
  /// The logical registry scope used on the wire.
  final String scope;

  final Map<String, T> _values;
  final Map<T, String> _reverseIndex;
  FrozenRegistry({
    required this.scope,
    required Map<String, T> values,
    Map<T, String>? reverseIndex,
  }) : _values = Map<String, T>.unmodifiable(values),
       _reverseIndex = Map<T, String>.unmodifiable(
         reverseIndex ??
             {for (final entry in values.entries) entry.value: entry.key},
       );

  /// All registered ids available in this frozen registry.
  Iterable<String> get ids => _values.keys;

  /// Looks up a registered value by id.
  T? lookup(String id) => _values[id];

  /// Looks up the registered id for [value], if one exists.
  String? keyOf(T value) => _reverseIndex[value];
}

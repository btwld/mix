/// Immutable runtime registry used during payload decoding.
final class FrozenRegistry<T extends Object> {
  /// The logical registry scope used on the wire.
  final String scope;

  final Map<String, T> _values;
  FrozenRegistry({required this.scope, required Map<String, T> values})
    : _values = Map<String, T>.unmodifiable(values);

  /// All registered ids available in this frozen registry.
  Iterable<String> get ids => _values.keys;

  /// Looks up a registered value by id.
  T? lookup(String id) => _values[id];
}

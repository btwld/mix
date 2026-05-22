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
  FrozenRegistry({
    required this.scope,
    required Map<String, T> values,
    Map<T, String>? reverseIndex,
  }) : _values = Map<String, T>.unmodifiable(values),
       _reverseIndex = Map<T, String>.unmodifiable(
         reverseIndex ??
             {for (final entry in values.entries) entry.value: entry.key},
       ) {
    if (!kRegistryScopePattern.hasMatch(scope)) {
      throw ArgumentError.value(
        scope,
        'scope',
        'Registry scope must match ${kRegistryScopePattern.pattern}.',
      );
    }
    for (final id in values.keys) {
      if (!kRegistryIdPattern.hasMatch(id)) {
        throw ArgumentError.value(
          id,
          'values',
          'Registry id must match ${kRegistryIdPattern.pattern}.',
        );
      }
    }
  }

  /// All registered ids available in this frozen registry.
  Iterable<String> get ids => _values.keys;

  /// Looks up a registered value by id.
  T? lookup(String id) => _values[id];

  /// Looks up the registered id for [value], if one exists.
  String? keyOf(T value) => _reverseIndex[value];
}

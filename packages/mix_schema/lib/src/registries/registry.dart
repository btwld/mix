import 'frozen_registry.dart';

final class RegistryBuilder<T extends Object> {
  final String scope;
  final Map<String, T> _entries = <String, T>{};
  bool _isFrozen = false;
  FrozenRegistry<T>? _frozenRegistry;

  RegistryBuilder({required this.scope});

  bool get isFrozen => _isFrozen;

  void register(String id, T value) {
    if (_isFrozen) {
      throw StateError(
        'Registry "$scope" is frozen. Register before freeze only.',
      );
    }
    if (_entries.containsKey(id)) {
      throw StateError(
        'Duplicate id "$id" in registry scope "$scope". IDs must be unique per scope.',
      );
    }

    _entries[id] = value;
  }

  FrozenRegistry<T> freeze() {
    final existing = _frozenRegistry;
    if (existing != null) return existing;

    _isFrozen = true;
    final frozen = FrozenRegistry.fromEntries(_entries);
    _frozenRegistry = frozen;

    return frozen;
  }
}

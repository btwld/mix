import 'frozen_registry.dart';
import '../core/mix_schema_scope.dart';

/// Mutable builder used to register runtime values before decode starts.
final class RegistryBuilder<T extends Object> {
  /// The logical registry scope used on the wire.
  ///
  /// Built-in scopes should prefer [RegistryBuilder.builtIn].
  final String scope;

  final Map<String, T> _values = <String, T>{};
  bool _frozen = false;
  RegistryBuilder({required this.scope});

  /// Convenience constructor for built-in registry scopes.
  RegistryBuilder.builtIn({required MixSchemaScope scope})
    : this(scope: scope.wireValue);

  /// Registers a runtime value under the provided string id.
  void register(String id, T value) {
    if (_frozen) {
      throw StateError('Registry "$scope" is frozen.');
    }

    if (_values.containsKey(id)) {
      throw StateError('Registry "$scope" already contains id "$id".');
    }

    _values[id] = value;
  }

  /// Freezes the registry and returns an immutable runtime lookup view.
  FrozenRegistry<T> freeze() {
    if (_frozen) {
      throw StateError('Registry "$scope" is frozen.');
    }

    _frozen = true;

    return FrozenRegistry(scope: scope, values: _values);
  }
}

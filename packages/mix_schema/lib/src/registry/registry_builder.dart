import 'frozen_registry.dart';
import '../core/mix_schema_scope.dart';

/// Scope wire vocabulary. Matches the styler-type grammar so scope names stay
/// stable wire identifiers.
final RegExp _scopePattern = RegExp(r'^[a-z][a-z0-9_]*$');

/// Registry id grammar. Producer-facing ids stay bounded to a stable
/// alphabet that survives URL/JSON quoting without escaping.
final RegExp _idPattern = RegExp(r'^[A-Za-z0-9._:-]+$');

/// Mutable builder used to register runtime values before decode starts.
final class RegistryBuilder<T extends Object> {
  /// The logical registry scope used on the wire.
  ///
  /// Built-in scopes should prefer [RegistryBuilder.builtIn].
  final String scope;

  final Map<String, T> _values = <String, T>{};
  final Map<T, String> _reverseIndex = <T, String>{};
  bool _frozen = false;
  RegistryBuilder({required this.scope}) {
    if (!_scopePattern.hasMatch(scope)) {
      throw ArgumentError.value(
        scope,
        'scope',
        'Registry scope must match ${_scopePattern.pattern}.',
      );
    }
  }

  /// Convenience constructor for built-in registry scopes.
  RegistryBuilder.builtIn({required MixSchemaScope scope})
    : this(scope: scope.wireValue);

  /// Registers a runtime value under the provided string id.
  void register(String id, T value) {
    if (_frozen) {
      throw StateError('Registry "$scope" is frozen.');
    }

    if (!_idPattern.hasMatch(id)) {
      throw ArgumentError.value(
        id,
        'id',
        'Registry id must match ${_idPattern.pattern}.',
      );
    }

    if (_values.containsKey(id)) {
      throw StateError('Registry "$scope" already contains id "$id".');
    }

    final existingId = _reverseIndex[value];
    if (existingId != null && existingId != id) {
      throw StateError(
        'Registry "$scope" already indexes this value under "$existingId".',
      );
    }

    _values[id] = value;
    _reverseIndex[value] = id;
  }

  /// Freezes the registry and returns an immutable runtime lookup view.
  FrozenRegistry<T> freeze() {
    if (_frozen) {
      throw StateError('Registry "$scope" is frozen.');
    }

    _frozen = true;

    return FrozenRegistry(
      scope: scope,
      values: _values,
      reverseIndex: _reverseIndex,
    );
  }
}

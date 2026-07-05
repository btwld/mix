import 'package:flutter/widgets.dart';

import '../errors/mix_schema_error.dart';

/// Registry scopes used for runtime identity values in schema payloads.
enum MixSchemaScope {
  /// Flutter [IconData] values referenced by icon stylers.
  iconData('icon_data'),

  /// Flutter [ImageProvider] values referenced by image stylers.
  imageProvider('image_provider');

  const MixSchemaScope(this.wireValue);

  /// JSON-safe scope name used in diagnostics and documentation.
  final String wireValue;
}

/// Regular expression source for legal registry ids.
const registryIdPattern = r'^[A-Za-z0-9_-]{1,96}$';

final _idPattern = RegExp(registryIdPattern);

/// Returns whether [value] is a legal registry id.
bool isValidRegistryId(String value) => _idPattern.hasMatch(value);

/// Mutable registry builder used before a contract is frozen.
///
/// See [FrozenRegistry] for this registry chain's internal-legacy status.
final class RegistryBuilder {
  final Map<MixSchemaScope, Map<String, Object>> _values = {
    for (final scope in MixSchemaScope.values) scope: <String, Object>{},
  };
  bool _isFrozen = false;

  /// Registers [value] under [id] in [scope].
  ///
  /// Registry ids must match [registryIdPattern]. Registering the same id again
  /// in the same scope replaces the previous value.
  RegistryBuilder register<T extends Object>(
    MixSchemaScope scope,
    String id,
    T value,
  ) {
    _ensureMutable();
    if (!isValidRegistryId(id)) {
      throw ArgumentError.value(id, 'id', 'Invalid mix_schema registry id.');
    }
    _values[scope]![id] = value;

    return this;
  }

  /// Registers an [IconData] identity value.
  RegistryBuilder iconData(String id, IconData value) =>
      register(MixSchemaScope.iconData, id, value);

  /// Registers an [ImageProvider] identity value.
  RegistryBuilder imageProvider(String id, ImageProvider value) =>
      register(MixSchemaScope.imageProvider, id, value);

  /// Freezes this builder into an immutable lookup table.
  FrozenRegistry freeze() {
    _ensureMutable();
    _isFrozen = true;
    final values = <MixSchemaScope, Map<String, Object>>{
      for (final entry in _values.entries)
        entry.key: Map<String, Object>.unmodifiable(entry.value),
    };

    return FrozenRegistry._(
      Map<MixSchemaScope, Map<String, Object>>.unmodifiable(values),
    );
  }

  void _ensureMutable() {
    if (_isFrozen) {
      throw StateError('RegistryBuilder cannot be used after freeze.');
    }
  }
}

/// Immutable registry used by a frozen schema contract.
///
/// Internal legacy support only. [RegistryBuilder], `FrozenRegistry`, and
/// [MixSchemaScope] are not exported from `mix_schema.dart` and are not used
/// by any built-in codec. The shipped contract resolves identity values
/// through `MixSchemaIdentityContext` (see `identity_resolution.dart`), which
/// matches by `==`. [idFor] matches by `identical()` deliberately (see its
/// doc and the registry tests) — do not switch it to `==`.
final class FrozenRegistry {
  const FrozenRegistry._(this._values);

  final Map<MixSchemaScope, Map<String, Object>> _values;

  /// Looks up [id] in [scope] and casts it to [T].
  ///
  /// Throws [UnknownRegistryIdError] when the id is absent or has the wrong
  /// runtime type.
  T lookup<T extends Object>(MixSchemaScope scope, String id) {
    final value = _values[scope]?[id];
    if (value is T) return value;

    throw UnknownRegistryIdError(scope, id);
  }

  /// Returns the registered id for [value] in [scope].
  ///
  /// Registry values are matched by identity. Throws [UnknownRegistryValueError]
  /// when no registered value is identical to [value].
  String idFor<T extends Object>(MixSchemaScope scope, T value) {
    final entries = _values[scope]?.entries ?? const Iterable.empty();
    for (final entry in entries) {
      if (identical(entry.value, value)) {
        return entry.key;
      }
    }

    throw UnknownRegistryValueError(scope, value);
  }
}

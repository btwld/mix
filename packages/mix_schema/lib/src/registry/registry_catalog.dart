import '../errors/schema_transform_exceptions.dart';
import 'frozen_registry.dart';

final class RegistryCatalog {
  final Map<String, FrozenRegistry<Object>> _registries =
      <String, FrozenRegistry<Object>>{};

  RegistryCatalog(Iterable<FrozenRegistry<Object>> registries) {
    for (final registry in registries) {
      if (_registries.containsKey(registry.scope)) {
        throw StateError('Registry scope "${registry.scope}" is duplicated.');
      }

      _registries[registry.scope] = registry;
    }
  }

  T lookup<T extends Object>(String scope, String id) {
    final registry = _registries[scope];
    if (registry == null) {
      throw RegistryLookupError(scope, id);
    }

    final value = registry.lookup(id);
    if (value == null) {
      throw RegistryLookupError(scope, id);
    }

    if (value is! T) {
      throw RegistryTypeMismatchError(
        scope: scope,
        id: id,
        expectedType: '$T',
        actualType: '${value.runtimeType}',
      );
    }

    return value;
  }
}

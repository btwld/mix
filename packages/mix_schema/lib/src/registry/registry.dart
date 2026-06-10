import 'package:flutter/widgets.dart';

import '../errors/mix_schema_error.dart';

enum MixSchemaScope {
  animationOnEnd('animation_on_end'),
  iconData('icon_data'),
  imageProvider('image_provider'),
  contextVariantBuilder('context_variant_builder');

  const MixSchemaScope(this.wireValue);

  final String wireValue;
}

const registryIdPattern = r'^[A-Za-z0-9_-]{1,96}$';

final _idPattern = RegExp(registryIdPattern);

bool isValidRegistryId(String value) => _idPattern.hasMatch(value);

final class RegistryBuilder {
  final Map<MixSchemaScope, Map<String, Object>> _values = {
    for (final scope in MixSchemaScope.values) scope: <String, Object>{},
  };

  RegistryBuilder register<T extends Object>(
    MixSchemaScope scope,
    String id,
    T value,
  ) {
    if (!isValidRegistryId(id)) {
      throw ArgumentError.value(id, 'id', 'Invalid mix_schema registry id.');
    }
    _values[scope]![id] = value;

    return this;
  }

  RegistryBuilder animationOnEnd(String id, VoidCallback value) =>
      register(MixSchemaScope.animationOnEnd, id, value);

  RegistryBuilder iconData(String id, IconData value) =>
      register(MixSchemaScope.iconData, id, value);

  RegistryBuilder imageProvider(String id, ImageProvider value) =>
      register(MixSchemaScope.imageProvider, id, value);

  RegistryBuilder contextVariantBuilder<T extends Object>(
    String id,
    T Function(BuildContext) value,
  ) {
    return register(MixSchemaScope.contextVariantBuilder, id, value);
  }

  FrozenRegistry freeze() {
    return FrozenRegistry._({
      for (final entry in _values.entries)
        entry.key: Map.unmodifiable(entry.value),
    });
  }
}

final class FrozenRegistry {
  const FrozenRegistry._(this._values);

  final Map<MixSchemaScope, Map<String, Object>> _values;

  T lookup<T extends Object>(MixSchemaScope scope, String id) {
    final value = _values[scope]?[id];
    if (value is T) return value;

    throw UnknownRegistryIdError(scope, id);
  }

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

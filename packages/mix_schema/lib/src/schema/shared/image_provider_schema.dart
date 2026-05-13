import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../../core/mix_schema_scope.dart';
import '../../registry/registry_catalog.dart';

CodecSchema<String, ImageProvider<Object>> buildImageProviderSchema({
  required RegistryCatalog registries,
}) {
  const scope = MixSchemaScope.imageProvider;

  return Ack.codec<String, ImageProvider<Object>>(
    input: Ack.string(),
    output: Ack.instance<ImageProvider<Object>>(),
    decoder: (value) {
      return registries.lookup<ImageProvider<Object>>(scope.wireValue, value);
    },
    encoder: (value) {
      final key = registries.keyOf<ImageProvider<Object>>(
        scope.wireValue,
        value,
      );

      if (key == null) {
        throw ArgumentError('ImageProvider is not registered.');
      }

      return key;
    },
  );
}

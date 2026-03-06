import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../../core/mix_schema_scope.dart';
import '../../registry/registry_catalog.dart';

AckSchema<ImageProvider<Object>> buildImageProviderSchema({
  required RegistryCatalog registries,
}) {
  return Ack.string().transform<ImageProvider<Object>>((value) {
    return registries.lookup<ImageProvider<Object>>(
      MixSchemaScope.imageProvider.wireValue,
      value!,
    );
  });
}

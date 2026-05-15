import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../../contract/mix_schema_limits.dart';
import '../../registry/registry_catalog.dart';
import '../../registry/registry_value_codec.dart';

CodecSchema<String, ImageProvider<Object>> buildImageProviderCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  return registryValueCodec(
    registries: registries,
    scope: .imageProvider,
    limits: limits,
    valueLabel: 'ImageProvider',
  );
}

CodecSchema<String, IconData> buildIconDataCodec(
  RegistryCatalog registries, {
  required MixSchemaLimits limits,
}) {
  return registryValueCodec(
    registries: registries,
    scope: .iconData,
    limits: limits,
    valueLabel: 'IconData',
  );
}

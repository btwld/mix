import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';

import '../../registry/registry_catalog.dart';
import '../../registry/registry_value_codec.dart';

CodecSchema<String, ImageProvider<Object>> buildImageProviderCodec(
  RegistryCatalog registries,
) {
  return registryValueCodec(
    registries: registries,
    scope: .imageProvider,
    valueLabel: 'ImageProvider',
  );
}

CodecSchema<String, IconData> buildIconDataCodec(RegistryCatalog registries) {
  return registryValueCodec(
    registries: registries,
    scope: .iconData,
    valueLabel: 'IconData',
  );
}

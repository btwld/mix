import 'package:ack/ack.dart';

import 'registry.dart';

CodecSchema<String, T> registryValueCodec<T extends Object>(
  FrozenRegistry Function() registry,
  MixSchemaScope scope,
) {
  return Ack.string()
      .matches(
        registryIdPattern,
        message:
            'Registry id must be 1-96 characters using letters, digits, "_" or "-".',
      )
      .codec<T>(
        decode: (id) => registry().lookup<T>(scope, id),
        encode: (value) => registry().idFor(scope, value),
      );
}

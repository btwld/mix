import 'package:ack/ack.dart';

import '../contract/mix_schema_limits.dart';
import '../core/mix_schema_scope.dart';
import '../errors/schema_transform_exceptions.dart';
import 'registry_catalog.dart';

CodecSchema<String, T> registryValueCodec<T extends Object>({
  required RegistryCatalog registries,
  required MixSchemaScope scope,
  required MixSchemaLimits limits,
  required String valueLabel,
}) {
  return Ack.codec<String, String, T>(
    input: Ack.string().maxLength(limits.maxRegistryIdLength),
    output: Ack.instance<T>(),
    decode: (id) => registries.lookup<T>(scope.wireValue, id),
    encode: (value) {
      final key = registries.keyOf<T>(scope.wireValue, value);
      if (key == null) {
        throw RegistryValueLookupError(
          scope: scope.wireValue,
          expectedType: valueLabel,
          value: value,
        );
      }

      return key;
    },
  );
}

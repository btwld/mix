import 'package:ack/ack.dart';

import '../core/mix_schema_scope.dart';
import '../errors/schema_transform_exceptions.dart';
import 'registry_catalog.dart';
import 'registry_wire_grammar.dart';

/// Canonical maximum length for registry ids on the wire. The constraint is
/// declared on the codec input schema so it flows into exported JSON Schema
/// and is enforced uniformly across producers.
const int kMaxRegistryIdLength = 256;

CodecSchema<String, T> registryValueCodec<T extends Object>({
  required RegistryCatalog registries,
  required MixSchemaScope scope,
  required String valueLabel,
}) {
  return Ack.codec<String, String, T>(
    input: Ack.string()
        .matches(kRegistryIdPattern.pattern)
        .maxLength(kMaxRegistryIdLength),
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

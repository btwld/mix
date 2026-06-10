import 'package:ack/ack.dart';

import '../errors/mix_schema_error.dart';

AckSchema<JsonMap, Object> widenStylerBranch<T extends Object>(
  AckSchema<JsonMap, T> branch, {
  String? debugName,
}) {
  return Ack.codec<JsonMap, T, Object>(
    input: branch,
    decode: (value) => value,
    encode: (value) {
      if (value is T) return value;

      throw UnsupportedEncodeValueError(
        value,
        'Expected ${debugName ?? T.toString()}, got ${value.runtimeType}.',
      );
    },
    output: Ack.instance<Object>(),
  );
}

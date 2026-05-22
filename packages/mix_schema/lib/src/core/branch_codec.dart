import 'package:ack/ack.dart';

/// Builds a typed branch codec for use inside `Ack.discriminated(...)`.
///
/// `B` is the base runtime type advertised by the discriminator; `T` is the
/// concrete subtype this branch decodes and encodes. The output schema is
/// refined to `T` so unsupported subtypes surface as a schema-level
/// `unsupported_encode_value` error during discriminator dispatch rather than
/// a Dart cast error inside the encoder. The discriminator key `type` is
/// injected into the encoded payload automatically.
CodecSchema<JsonMap, B>
discriminatedBranchCodec<B extends Object, T extends B>({
  required String type,
  required ObjectSchema input,
  required T Function(JsonMap data) decode,
  required JsonMap Function(T value) encode,
}) {
  return Ack.codec<JsonMap, JsonMap, B>(
    input: input,
    output: Ack.instance<B>().refine(
      (value) => value is T,
      message: 'Expected $T.',
    ),
    decode: (data) => decode(data) as B,
    encode: (value) => {'type': type, ...encode(value as T)},
  );
}

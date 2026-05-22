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

/// Builds a typed branch codec that is also valid when used outside of an
/// enclosing discriminator.
///
/// Same shape as [discriminatedBranchCodec], but the `type` literal is also
/// injected into the codec's [ObjectSchema] input so the branch codec
/// independently validates payloads that carry their own `type` field. Use
/// this for codecs that are exported standalone (e.g. modifier and context
/// variant leaf codecs) and reused inside a higher-level discriminator.
///
/// [outputRefinement] is the predicate that gates encode of supported runtime
/// subtypes. It defaults to `value is T`; callers that need a richer check
/// (e.g. variant kind matching) can supply their own.
CodecSchema<JsonMap, B>
standaloneBranchCodec<B extends Object, T extends Object>({
  required String type,
  required ObjectSchema input,
  required T Function(JsonMap data) decode,
  required JsonMap Function(T value) encode,
  bool Function(B value)? outputRefinement,
  String? outputRefinementMessage,
}) {
  return Ack.codec<JsonMap, JsonMap, B>(
    input: input.copyWith(
      properties: {'type': Ack.literal(type), ...input.properties},
    ),
    output: Ack.instance<B>().refine(
      outputRefinement ?? (value) => value is T,
      message: outputRefinementMessage ?? 'Expected $T.',
    ),
    decode: (data) => decode(data) as B,
    encode: (value) => {'type': type, ...encode(value as T)},
  );
}

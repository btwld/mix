import 'package:ack/ack.dart';

/// Builds a discriminated-branch codec from primitive building blocks and
/// guarantees the discriminator `{'type': type}` is written on encode.
///
/// Use this when registering external styler codecs through
/// `MixSchemaContractBuilder.register`. The decoder is forwarded as-is —
/// Ack's `DiscriminatedObjectSchema` pre-routes by `type` before dispatching
/// to the branch. The `output` schema is forwarded when supplied so callers
/// can attach runtime-side refinements.
///
/// The discriminator is written last so a user-supplied [encode] returning a
/// map that already contains a `type` key cannot override the registered
/// discriminator.
CodecSchema<JsonMap, T> buildDiscriminatorInjectingCodec<T extends Object>({
  required String type,
  required ObjectSchema input,
  required T Function(JsonMap data) decode,
  required JsonMap Function(T value) encode,
  // ignore: avoid-dynamic, matches Ack.codec's `output` parameter type.
  AckSchema<dynamic, T>? output,
}) {
  return Ack.codec<JsonMap, JsonMap, T>(
    input: input,
    decode: decode,
    encode: (value) => {...encode(value), 'type': type},
    output: output,
  );
}

/// Sentinel prefix used by branch-codec output refinements to signal a
/// subtype rejection that should surface as `unsupported_encode_value`.
///
/// `SchemaErrorMapper._mapValidationMessage` recognizes this prefix and
/// routes the wire error code accordingly. Without the sentinel, Ack would
/// surface the failure as a generic `validation_failed`, which understates
/// the contract guarantee that unsupported runtime subtypes are not
/// representable on the wire.
const String kUnsupportedBranchSubtypePrefix = 'Unsupported encode subtype:';

/// Builds a typed branch codec for use inside `Ack.discriminated(...)`.
///
/// `B` is the base runtime type advertised by the discriminator; `T` is the
/// concrete subtype this branch decodes and encodes. The output schema is
/// refined to `T` so Ack's discriminated dispatch can pick the right branch
/// on encode. When a runtime value is not a `T`, every branch's refinement
/// fails and the schema error mapper surfaces a single
/// `unsupported_encode_value` error via [kUnsupportedBranchSubtypePrefix].
/// The discriminator key `type` is injected into the encoded payload
/// automatically.
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
      message:
          '$kUnsupportedBranchSubtypePrefix expected $T for branch '
          '"$type".',
    ),
    decode: (data) => decode(data) as B,
    encode: (value) => {...encode(value as T), 'type': type},
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
/// The output schema is refined to `T` so encode fails for runtime values
/// that are not representable by this branch. Failed refinements use the
/// [kUnsupportedBranchSubtypePrefix] sentinel so the schema error mapper
/// surfaces them as `unsupported_encode_value`. [outputRefinement] overrides
/// the default `value is T` check; callers that need a richer test (e.g.
/// variant kind matching) supply their own predicate and
/// [outputRefinementMessage]. The sentinel is force-prefixed onto any custom
/// [outputRefinementMessage] that does not already start with it, so the
/// mapper always routes through `unsupported_encode_value`.
///
/// The `T extends Object` bound (rather than `T extends B`) is intentional:
/// callers that branch on covariant generic types — e.g. `ModifierMix<S>`
/// where each subclass parameterizes over a different `S` — cannot satisfy
/// `T extends B` because Dart treats `ModifierMix` generics as invariant.
CodecSchema<JsonMap, B>
standaloneBranchCodec<B extends Object, T extends Object>({
  required String type,
  required ObjectSchema input,
  required T Function(JsonMap data) decode,
  required JsonMap Function(T value) encode,
  bool Function(B value)? outputRefinement,
  String? outputRefinementMessage,
}) {
  final messageBody =
      outputRefinementMessage ?? 'expected $T for branch "$type".';
  final message = messageBody.startsWith(kUnsupportedBranchSubtypePrefix)
      ? messageBody
      : '$kUnsupportedBranchSubtypePrefix $messageBody';

  return Ack.codec<JsonMap, JsonMap, B>(
    input: input.copyWith(
      properties: {'type': Ack.literal(type), ...input.properties},
    ),
    output: Ack.instance<B>().refine(
      outputRefinement ?? (value) => value is T,
      message: message,
    ),
    decode: (data) => decode(data) as B,
    encode: (value) => {...encode(value as T), 'type': type},
  );
}

import 'package:ack/ack.dart';

extension CodecSchemaTypedEncode<I extends Object, O extends Object>
    on CodecSchema<I, O> {
  /// Encodes [value] and narrows the result to the codec's boundary type [I].
  ///
  /// [AckSchema.encode] returns `Object?` to keep the base surface uniform,
  /// but a successful codec encode always produces an `I`. Use this when the
  /// caller wants a typed result without writing `as I` at every site.
  I encodeTyped(O value) => encode(value) as I;
}

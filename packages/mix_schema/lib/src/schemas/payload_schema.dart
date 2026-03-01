import 'package:ack/ack.dart';
import 'package:mix_schema/src/codecs/curve_codec.dart';
import 'package:mix_schema/src/contracts/styler_type.dart';

final _allowedStylerTypeValues = StylerType.values
    .map((type) => type.wire)
    .toList(growable: false);

final boxAnimationSchema = Ack.object(
  {
    'durationMs': Ack.int,
    'curve': Ack.enumString(CurveCodec.supportedCurveNames),
    'delayMs': Ack.int.nullable(),
    'onEnd': Ack.string.nullable(),
  },
  additionalProperties: false,
  required: ['durationMs', 'curve'],
);

final boxDataSchema = Ack.object({
  'clipBehavior': Ack.enumString([
    'none',
    'hardEdge',
    'antiAlias',
    'antiAliasWithSaveLayer',
  ]).nullable(),
  'animation': boxAnimationSchema.nullable(),
}, additionalProperties: false);

final payloadEnvelopeSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString(_allowedStylerTypeValues),
    'data': Ack.object({}, additionalProperties: true),
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final boxPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.box.wire]),
    'data': boxDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

Map<String, Object?> exportEnvelopeSchemaDefinition() {
  return OpenApiSchemaConverter(schema: payloadEnvelopeSchema).toSchema();
}

Map<String, Object?> exportBoxPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: boxPayloadSchema).toSchema();
}

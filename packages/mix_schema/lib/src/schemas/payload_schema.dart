import 'package:ack/ack.dart';

import '../contracts/styler_type.dart';
import 'dto_schemas.dart';

final _allowedStylerTypeValues = StylerType.values
    .map((type) => type.wire)
    .toList(growable: false);

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

Map<String, Object?> exportTextStyleSchemaDefinition() {
  return OpenApiSchemaConverter(schema: textStyleDtoSchema).toSchema();
}

Map<String, Object?> exportStrutStyleSchemaDefinition() {
  return OpenApiSchemaConverter(schema: strutStyleDtoSchema).toSchema();
}

Map<String, Object?> exportTextHeightBehaviorSchemaDefinition() {
  return OpenApiSchemaConverter(schema: textHeightBehaviorDtoSchema).toSchema();
}

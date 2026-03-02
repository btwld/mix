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

final textPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.text.wire]),
    'data': textDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final flexPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.flex.wire]),
    'data': flexDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final iconPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.icon.wire]),
    'data': iconDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final imagePayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.image.wire]),
    'data': imageDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final stackPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.stack.wire]),
    'data': stackDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final flexBoxPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.flexBox.wire]),
    'data': flexBoxDataSchema,
  },
  additionalProperties: false,
  required: ['schemaVersion', 'stylerType', 'data'],
);

final stackBoxPayloadSchema = Ack.object(
  {
    'schemaVersion': Ack.int,
    'stylerType': Ack.enumString([StylerType.stackBox.wire]),
    'data': stackBoxDataSchema,
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

Map<String, Object?> exportTextPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: textPayloadSchema).toSchema();
}

Map<String, Object?> exportFlexPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: flexPayloadSchema).toSchema();
}

Map<String, Object?> exportIconPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: iconPayloadSchema).toSchema();
}

Map<String, Object?> exportImagePayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: imagePayloadSchema).toSchema();
}

Map<String, Object?> exportStackPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: stackPayloadSchema).toSchema();
}

Map<String, Object?> exportFlexBoxPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: flexBoxPayloadSchema).toSchema();
}

Map<String, Object?> exportStackBoxPayloadSchemaDefinition() {
  return OpenApiSchemaConverter(schema: stackBoxPayloadSchema).toSchema();
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

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, FlexStyler> flexStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _flexStylerSchemaType(rootStyleSchema, registry).codec();
}

JsonMap encodeFlexStylerFields(
  FlexStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _flexStylerSchemaType(null, emptyFrozenRegistry).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : stylerMetadataFields,
  );
}

SchemaObject<FlexStyler> _flexStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final direction = propValueField<FlexStyler, Axis>(
    'direction',
    enumNameCodec(Axis.values),
    (value) => value.$direction,
  );
  final mainAxisAlignment = propValueField<FlexStyler, MainAxisAlignment>(
    'mainAxisAlignment',
    enumNameCodec(MainAxisAlignment.values),
    (value) => value.$mainAxisAlignment,
  );
  final crossAxisAlignment = propValueField<FlexStyler, CrossAxisAlignment>(
    'crossAxisAlignment',
    enumNameCodec(CrossAxisAlignment.values),
    (value) => value.$crossAxisAlignment,
  );
  final mainAxisSize = propValueField<FlexStyler, MainAxisSize>(
    'mainAxisSize',
    enumNameCodec(MainAxisSize.values),
    (value) => value.$mainAxisSize,
  );
  final verticalDirection = propValueField<FlexStyler, VerticalDirection>(
    'verticalDirection',
    enumNameCodec(VerticalDirection.values),
    (value) => value.$verticalDirection,
  );
  final textDirection = propValueField<FlexStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final textBaseline = propValueField<FlexStyler, TextBaseline>(
    'textBaseline',
    enumNameCodec(TextBaseline.values),
    (value) => value.$textBaseline,
  );
  final clipBehavior = propValueField<FlexStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );
  final spacing = propTokenValueField<FlexStyler, double>(
    'spacing',
    doubleTokenCodec(),
    (value) => value.$spacing,
  );
  final metadata = StylerMetadataFields<FlexStyler, FlexSpec>(
    rootStyleSchema: rootStyleSchema,
    registry: registry,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<FlexStyler>(
    inventoryOwner: 'FlexStyler',
    ownerFieldInventory: flexStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [
      direction,
      mainAxisAlignment,
      crossAxisAlignment,
      mainAxisSize,
      verticalDirection,
      textDirection,
      textBaseline,
      clipBehavior,
      spacing,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => FlexStyler.create(
      direction: direction.value(data),
      mainAxisAlignment: mainAxisAlignment.value(data),
      crossAxisAlignment: crossAxisAlignment.value(data),
      mainAxisSize: mainAxisSize.value(data),
      verticalDirection: verticalDirection.value(data),
      textDirection: textDirection.value(data),
      textBaseline: textBaseline.value(data),
      clipBehavior: clipBehavior.value(data),
      spacing: spacing.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

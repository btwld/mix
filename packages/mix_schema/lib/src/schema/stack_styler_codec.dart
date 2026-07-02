import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, StackStyler> stackStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _stackStylerSchemaType(rootStyleSchema, registry).codec();
}

JsonMap encodeStackStylerFields(
  StackStyler value, {
  bool includeStylerMetadata = true,
}) {
  return _stackStylerSchemaType(null, emptyFrozenRegistry).encodeFields(
    value,
    omit: includeStylerMetadata ? const {} : stylerMetadataFields,
  );
}

SchemaObject<StackStyler> _stackStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final alignment = mixField<StackStyler, Alignment, AlignmentGeometry>(
    'alignment',
    alignmentCodec(),
    (value) => value.$alignment,
  );
  final fit = valueField<StackStyler, StackFit>(
    'fit',
    enumNameCodec(StackFit.values),
    (value) => value.$fit,
  );
  final textDirection = valueField<StackStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final clipBehavior = valueField<StackStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    (value) => value.$clipBehavior,
  );
  final metadata = StylerMetadataFields<StackStyler, StackSpec>(
    rootStyleSchema: rootStyleSchema,
    registry: registry,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<StackStyler>(
    inventoryOwner: 'StackStyler',
    ownerFieldInventory: stackStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [alignment, fit, textDirection, clipBehavior, ...metadata.fields],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => StackStyler(
      alignment: alignment.value(data),
      fit: fit.value(data),
      textDirection: textDirection.value(data),
      clipBehavior: clipBehavior.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

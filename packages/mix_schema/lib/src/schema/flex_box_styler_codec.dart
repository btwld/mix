import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'flex_styler_codec.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, FlexBoxStyler> flexBoxStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _flexBoxStylerSchemaType(rootStyleSchema, registry).codec();
}

SchemaObject<FlexBoxStyler> _flexBoxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final alignment = derivedField<FlexBoxStyler, Alignment>(
    'alignment',
    alignmentCodec(),
    _boxField,
    inventoryName: 'box',
  );
  final padding = derivedField<FlexBoxStyler, EdgeInsetsMix>(
    'padding',
    edgeInsetsCodec(),
    _boxField,
    inventoryName: 'box',
  );
  final margin = derivedField<FlexBoxStyler, EdgeInsetsMix>(
    'margin',
    edgeInsetsCodec(),
    _boxField,
    inventoryName: 'box',
  );
  final constraints = derivedField<FlexBoxStyler, BoxConstraintsMix>(
    'constraints',
    boxConstraintsCodec(),
    _boxField,
    inventoryName: 'box',
  );
  final clipBehavior = derivedField<FlexBoxStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    _boxField,
    inventoryName: 'box',
  );
  final transform = derivedField<FlexBoxStyler, Matrix4>(
    'transform',
    matrix4Codec(),
    _boxField,
    inventoryName: 'box',
  );
  final transformAlignment = derivedField<FlexBoxStyler, Alignment>(
    'transformAlignment',
    alignmentCodec(),
    _boxField,
    inventoryName: 'box',
  );
  final decoration = derivedField<FlexBoxStyler, BoxDecorationMix>(
    'decoration',
    boxDecorationCodec(),
    _boxField,
    inventoryName: 'box',
  );
  final direction = derivedField<FlexBoxStyler, Axis>(
    'direction',
    enumNameCodec(Axis.values),
    _flexField,
    inventoryName: 'flex',
  );
  final mainAxisAlignment = derivedField<FlexBoxStyler, MainAxisAlignment>(
    'mainAxisAlignment',
    enumNameCodec(MainAxisAlignment.values),
    _flexField,
    inventoryName: 'flex',
  );
  final crossAxisAlignment = derivedField<FlexBoxStyler, CrossAxisAlignment>(
    'crossAxisAlignment',
    enumNameCodec(CrossAxisAlignment.values),
    _flexField,
    inventoryName: 'flex',
  );
  final mainAxisSize = derivedField<FlexBoxStyler, MainAxisSize>(
    'mainAxisSize',
    enumNameCodec(MainAxisSize.values),
    _flexField,
    inventoryName: 'flex',
  );
  final verticalDirection = derivedField<FlexBoxStyler, VerticalDirection>(
    'verticalDirection',
    enumNameCodec(VerticalDirection.values),
    _flexField,
    inventoryName: 'flex',
  );
  final textDirection = derivedField<FlexBoxStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    _flexField,
    inventoryName: 'flex',
  );
  final textBaseline = derivedField<FlexBoxStyler, TextBaseline>(
    'textBaseline',
    enumNameCodec(TextBaseline.values),
    _flexField,
    inventoryName: 'flex',
  );
  final flexClipBehavior = derivedField<FlexBoxStyler, Clip>(
    'flexClipBehavior',
    enumNameCodec(Clip.values),
    _flexField,
    readWire: 'clipBehavior',
    inventoryName: 'flex',
  );
  final spacing = derivedField<FlexBoxStyler, double>(
    'spacing',
    doubleTokenCodec(),
    _flexField,
    inventoryName: 'flex',
  );
  final metadata = StylerMetadataFields<FlexBoxStyler, FlexBoxSpec>(
    rootStyleSchema: rootStyleSchema,
    registry: registry,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<FlexBoxStyler>(
    inventoryOwner: 'FlexBoxStyler',
    ownerFieldInventory: flexBoxStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [
      alignment,
      padding,
      margin,
      constraints,
      clipBehavior,
      transform,
      transformAlignment,
      decoration,
      direction,
      mainAxisAlignment,
      crossAxisAlignment,
      mainAxisSize,
      verticalDirection,
      textDirection,
      textBaseline,
      flexClipBehavior,
      spacing,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => FlexBoxStyler(
      alignment: alignment.value(data),
      padding: padding.value(data),
      margin: margin.value(data),
      constraints: constraints.value(data),
      clipBehavior: clipBehavior.value(data),
      transform: transform.value(data),
      transformAlignment: transformAlignment.value(data),
      decoration: decoration.value(data),
      direction: direction.value(data),
      mainAxisAlignment: mainAxisAlignment.value(data),
      crossAxisAlignment: crossAxisAlignment.value(data),
      mainAxisSize: mainAxisSize.value(data),
      verticalDirection: verticalDirection.value(data),
      textDirection: textDirection.value(data),
      textBaseline: textBaseline.value(data),
      flexClipBehavior: flexClipBehavior.value(data),
      spacing: spacing.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

Object? _boxField(FlexBoxStyler value, String wire) {
  return encodedNestedStylerField<FlexBoxStyler, BoxStyler, BoxSpec>(
    value,
    wire,
    read: (value) => value.$box,
    encodeFields: encodeBoxStylerFields,
    fieldName: 'box',
  );
}

Object? _flexField(FlexBoxStyler value, String wire) {
  return encodedNestedStylerField<FlexBoxStyler, FlexStyler, FlexSpec>(
    value,
    wire,
    read: (value) => value.$flex,
    encodeFields: encodeFlexStylerFields,
    fieldName: 'flex',
  );
}

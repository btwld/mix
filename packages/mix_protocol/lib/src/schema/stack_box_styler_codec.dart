import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../contract/identity_resolution.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'stack_styler_codec.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, StackBoxStyler> stackBoxStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function()? identityContext,
}) {
  return _stackBoxStylerSchemaType(rootStyleSchema).codec();
}

SchemaObject<StackBoxStyler> _stackBoxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final alignment = derivedField<StackBoxStyler, Prop<AlignmentGeometry>>(
    'alignment',
    valueAsPropCodec<Alignment, AlignmentGeometry>(
      alignmentCodec(),
      fieldName: 'alignment',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final padding = derivedField<StackBoxStyler, Prop<EdgeInsetsGeometry>>(
    'padding',
    mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'padding',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final margin = derivedField<StackBoxStyler, Prop<EdgeInsetsGeometry>>(
    'margin',
    mixPropCodec<EdgeInsetsMix, EdgeInsetsGeometry>(
      edgeInsetsCodec(),
      fieldName: 'margin',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final constraints = derivedField<StackBoxStyler, Prop<BoxConstraints>>(
    'constraints',
    mixPropCodec<BoxConstraintsMix, BoxConstraints>(
      boxConstraintsCodec(),
      fieldName: 'constraints',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final clipBehavior = derivedField<StackBoxStyler, Prop<Clip>>(
    'clipBehavior',
    valuePropCodec<Clip>(enumNameCodec(Clip.values), fieldName: 'clipBehavior'),
    _boxField,
    inventoryName: 'box',
  );
  final transform = derivedField<StackBoxStyler, Prop<Matrix4>>(
    'transform',
    valuePropCodec<Matrix4>(matrix4Codec(), fieldName: 'transform'),
    _boxField,
    inventoryName: 'box',
  );
  final transformAlignment =
      derivedField<StackBoxStyler, Prop<AlignmentGeometry>>(
        'transformAlignment',
        valueAsPropCodec<Alignment, AlignmentGeometry>(
          alignmentCodec(),
          fieldName: 'transformAlignment',
        ),
        _boxField,
        inventoryName: 'box',
      );
  final decoration = derivedField<StackBoxStyler, Prop<Decoration>>(
    'decoration',
    mixPropCodec<BoxDecorationMix, Decoration>(
      boxDecorationCodec(),
      fieldName: 'decoration',
    ),
    _boxField,
    inventoryName: 'box',
  );
  final stackAlignment = derivedField<StackBoxStyler, Prop<AlignmentGeometry>>(
    'stackAlignment',
    valueAsPropCodec<Alignment, AlignmentGeometry>(
      alignmentCodec(),
      fieldName: 'stackAlignment',
    ),
    _stackField,
    readWire: 'alignment',
    inventoryName: 'stack',
  );
  final fit = derivedField<StackBoxStyler, Prop<StackFit>>(
    'fit',
    valuePropCodec<StackFit>(enumNameCodec(StackFit.values), fieldName: 'fit'),
    _stackField,
    inventoryName: 'stack',
  );
  final textDirection = derivedField<StackBoxStyler, Prop<TextDirection>>(
    'textDirection',
    valuePropCodec<TextDirection>(
      textDirectionCodec(),
      fieldName: 'textDirection',
    ),
    _stackField,
    inventoryName: 'stack',
  );
  final stackClipBehavior = derivedField<StackBoxStyler, Prop<Clip>>(
    'stackClipBehavior',
    valuePropCodec<Clip>(
      enumNameCodec(Clip.values),
      fieldName: 'stackClipBehavior',
    ),
    _stackField,
    readWire: 'clipBehavior',
    inventoryName: 'stack',
  );
  final metadata = StylerMetadataFields<StackBoxStyler, StackBoxSpec>(
    rootStyleSchema: rootStyleSchema,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<StackBoxStyler>(
    inventoryOwner: 'StackBoxStyler',
    ownerFieldInventory: stackBoxStylerInventory,
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
      stackAlignment,
      fit,
      textDirection,
      stackClipBehavior,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => StackBoxStyler.create(
      box: Prop.mix(
        BoxStyler.create(
          alignment: alignment.value(data),
          padding: padding.value(data),
          margin: margin.value(data),
          constraints: constraints.value(data),
          clipBehavior: clipBehavior.value(data),
          transform: transform.value(data),
          transformAlignment: transformAlignment.value(data),
          decoration: decoration.value(data),
        ),
      ),
      stack: Prop.mix(
        StackStyler.create(
          alignment: stackAlignment.value(data),
          fit: fit.value(data),
          textDirection: textDirection.value(data),
          clipBehavior: stackClipBehavior.value(data),
        ),
      ),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

Object? _boxField(StackBoxStyler value, String wire) {
  return encodedNestedStylerField<StackBoxStyler, BoxStyler, BoxSpec>(
    value,
    wire,
    read: (value) => value.$box,
    encodeFields: encodeBoxStylerFields,
    fieldName: 'box',
  );
}

Object? _stackField(StackBoxStyler value, String wire) {
  return encodedNestedStylerField<StackBoxStyler, StackStyler, StackSpec>(
    value,
    wire,
    read: (value) => value.$stack,
    encodeFields: encodeStackStylerFields,
    fieldName: 'stack',
  );
}

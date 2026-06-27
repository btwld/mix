import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'schema_field.dart';
import 'stack_styler_codec.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, StackBoxStyler> stackBoxStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _stackBoxStylerSchemaType(rootStyleSchema, registry).codec();
}

SchemaObject<StackBoxStyler> _stackBoxStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final alignment = derivedField<StackBoxStyler, Alignment>(
    'alignment',
    alignmentCodec(),
    _boxField,
  );
  final padding = derivedField<StackBoxStyler, EdgeInsetsMix>(
    'padding',
    edgeInsetsCodec(),
    _boxField,
  );
  final margin = derivedField<StackBoxStyler, EdgeInsetsMix>(
    'margin',
    edgeInsetsCodec(),
    _boxField,
  );
  final constraints = derivedField<StackBoxStyler, BoxConstraintsMix>(
    'constraints',
    boxConstraintsCodec(),
    _boxField,
  );
  final clipBehavior = derivedField<StackBoxStyler, Clip>(
    'clipBehavior',
    enumNameCodec(Clip.values),
    _boxField,
  );
  final transform = derivedField<StackBoxStyler, Matrix4>(
    'transform',
    matrix4Codec(),
    _boxField,
  );
  final transformAlignment = derivedField<StackBoxStyler, Alignment>(
    'transformAlignment',
    alignmentCodec(),
    _boxField,
  );
  final decoration = derivedField<StackBoxStyler, BoxDecorationMix>(
    'decoration',
    boxDecorationCodec(),
    _boxField,
  );
  final stackAlignment = derivedField<StackBoxStyler, Alignment>(
    'stackAlignment',
    alignmentCodec(),
    _stackField,
    readWire: 'alignment',
  );
  final fit = derivedField<StackBoxStyler, StackFit>(
    'fit',
    enumNameCodec(StackFit.values),
    _stackField,
  );
  final textDirection = derivedField<StackBoxStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    _stackField,
  );
  final stackClipBehavior = derivedField<StackBoxStyler, Clip>(
    'stackClipBehavior',
    enumNameCodec(Clip.values),
    _stackField,
    readWire: 'clipBehavior',
  );
  final metadata = StylerMetadataFields<StackBoxStyler, StackBoxSpec>(
    rootStyleSchema: rootStyleSchema,
    registry: registry,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<StackBoxStyler>(
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
    build: (data) => StackBoxStyler(
      alignment: alignment.value(data),
      padding: padding.value(data),
      margin: margin.value(data),
      constraints: constraints.value(data),
      clipBehavior: clipBehavior.value(data),
      transform: transform.value(data),
      transformAlignment: transformAlignment.value(data),
      decoration: decoration.value(data),
      stackAlignment: stackAlignment.value(data),
      fit: fit.value(data),
      textDirection: textDirection.value(data),
      stackClipBehavior: stackClipBehavior.value(data),
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

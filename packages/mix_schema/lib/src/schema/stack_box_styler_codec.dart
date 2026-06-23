import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'stack_styler_codec.dart';
import 'variant_codec.dart';

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
    enumCodec(enumNames(Clip.values)),
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
    enumCodec(enumNames(StackFit.values)),
    _stackField,
  );
  final textDirection = derivedField<StackBoxStyler, TextDirection>(
    'textDirection',
    enumCodec(enumNames(TextDirection.values)),
    _stackField,
  );
  final stackClipBehavior = derivedField<StackBoxStyler, Clip>(
    'stackClipBehavior',
    enumCodec(enumNames(Clip.values)),
    _stackField,
    readWire: 'clipBehavior',
  );
  final variants = rootStyleSchema == null
      ? null
      : directField<StackBoxStyler, List<VariantStyle<StackBoxSpec>>>(
          'variants',
          Ack.list(variantCodec<StackBoxSpec>(rootStyleSchema)),
          (value) => value.$variants,
        );
  final modifiers = directField<StackBoxStyler, WidgetModifierConfig>(
    'modifiers',
    modifierConfigCodec(),
    (value) => value.$modifier,
  );
  final animation = directField<StackBoxStyler, AnimationConfig>(
    'animation',
    animationConfigCodec(registry: registry),
    (value) => value.$animation,
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
      ?variants,
      modifiers,
      animation,
    ],
    unsupportedFields: [
      if (variants == null)
        UnsupportedSchemaField<StackBoxStyler>(
          'variants',
          (value) => value.$variants,
        ),
    ],
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
      variants: variants?.value(data),
      modifier: modifiers.value(data),
      animation: animation.value(data),
    ),
  );
}

Object? _boxField(StackBoxStyler value, String wire) {
  final box = readProp<BoxStyler, StyleSpec<BoxSpec>>(value.$box, 'box');

  return box == null
      ? null
      : encodeBoxStylerFields(box, includeStylerMetadata: false)[wire];
}

Object? _stackField(StackBoxStyler value, String wire) {
  final stack = readProp<StackStyler, StyleSpec<StackSpec>>(
    value.$stack,
    'stack',
  );

  return stack == null
      ? null
      : encodeStackStylerFields(stack, includeStylerMetadata: false)[wire];
}

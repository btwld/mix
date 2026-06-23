import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'flex_styler_codec.dart';
import 'modifier_codec.dart';
import 'schema_field.dart';
import 'variant_codec.dart';

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
  );
  final padding = derivedField<FlexBoxStyler, EdgeInsetsMix>(
    'padding',
    edgeInsetsCodec(),
    _boxField,
  );
  final margin = derivedField<FlexBoxStyler, EdgeInsetsMix>(
    'margin',
    edgeInsetsCodec(),
    _boxField,
  );
  final constraints = derivedField<FlexBoxStyler, BoxConstraintsMix>(
    'constraints',
    boxConstraintsCodec(),
    _boxField,
  );
  final clipBehavior = derivedField<FlexBoxStyler, Clip>(
    'clipBehavior',
    enumCodec(enumNames(Clip.values)),
    _boxField,
  );
  final transform = derivedField<FlexBoxStyler, Matrix4>(
    'transform',
    matrix4Codec(),
    _boxField,
  );
  final transformAlignment = derivedField<FlexBoxStyler, Alignment>(
    'transformAlignment',
    alignmentCodec(),
    _boxField,
  );
  final decoration = derivedField<FlexBoxStyler, BoxDecorationMix>(
    'decoration',
    boxDecorationCodec(),
    _boxField,
  );
  final direction = derivedField<FlexBoxStyler, Axis>(
    'direction',
    enumCodec(enumNames(Axis.values)),
    _flexField,
  );
  final mainAxisAlignment = derivedField<FlexBoxStyler, MainAxisAlignment>(
    'mainAxisAlignment',
    enumCodec(enumNames(MainAxisAlignment.values)),
    _flexField,
  );
  final crossAxisAlignment = derivedField<FlexBoxStyler, CrossAxisAlignment>(
    'crossAxisAlignment',
    enumCodec(enumNames(CrossAxisAlignment.values)),
    _flexField,
  );
  final mainAxisSize = derivedField<FlexBoxStyler, MainAxisSize>(
    'mainAxisSize',
    enumCodec(enumNames(MainAxisSize.values)),
    _flexField,
  );
  final verticalDirection = derivedField<FlexBoxStyler, VerticalDirection>(
    'verticalDirection',
    enumCodec(enumNames(VerticalDirection.values)),
    _flexField,
  );
  final textDirection = derivedField<FlexBoxStyler, TextDirection>(
    'textDirection',
    enumCodec(enumNames(TextDirection.values)),
    _flexField,
  );
  final textBaseline = derivedField<FlexBoxStyler, TextBaseline>(
    'textBaseline',
    enumCodec(enumNames(TextBaseline.values)),
    _flexField,
  );
  final flexClipBehavior = derivedField<FlexBoxStyler, Clip>(
    'flexClipBehavior',
    enumCodec(enumNames(Clip.values)),
    _flexField,
    readWire: 'clipBehavior',
  );
  final spacing = derivedField<FlexBoxStyler, double>(
    'spacing',
    numberAsDoubleCodec(),
    _flexField,
  );
  final variants = rootStyleSchema == null
      ? null
      : directField<FlexBoxStyler, List<VariantStyle<FlexBoxSpec>>>(
          'variants',
          Ack.list(variantCodec<FlexBoxSpec>(rootStyleSchema)),
          (value) => value.$variants,
        );
  final modifiers = directField<FlexBoxStyler, WidgetModifierConfig>(
    'modifiers',
    modifierConfigCodec(),
    (value) => value.$modifier,
  );
  final animation = directField<FlexBoxStyler, AnimationConfig>(
    'animation',
    animationConfigCodec(registry: registry),
    (value) => value.$animation,
  );

  return SchemaObject<FlexBoxStyler>(
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
      ?variants,
      modifiers,
      animation,
    ],
    unsupportedFields: [
      if (variants == null)
        UnsupportedSchemaField<FlexBoxStyler>(
          'variants',
          (value) => value.$variants,
        ),
    ],
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
      variants: variants?.value(data),
      modifier: modifiers.value(data),
      animation: animation.value(data),
    ),
  );
}

Object? _boxField(FlexBoxStyler value, String wire) {
  final box = readProp<BoxStyler, StyleSpec<BoxSpec>>(value.$box, 'box');

  return box == null
      ? null
      : encodeBoxStylerFields(box, includeStylerMetadata: false)[wire];
}

Object? _flexField(FlexBoxStyler value, String wire) {
  final flex = readProp<FlexStyler, StyleSpec<FlexSpec>>(value.$flex, 'flex');

  return flex == null
      ? null
      : encodeFlexStylerFields(flex, includeStylerMetadata: false)[wire];
}

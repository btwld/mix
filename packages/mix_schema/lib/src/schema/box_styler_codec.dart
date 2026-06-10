import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';
import 'variant_codec.dart';

AckSchema<JsonMap, BoxStyler> boxStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'alignment': alignmentCodec().optional(),
    'padding': edgeInsetsCodec().optional(),
    'margin': edgeInsetsCodec().optional(),
    'constraints': boxConstraintsCodec().optional(),
    'clipBehavior': enumNameCodec(Clip.values).optional(),
    'decoration': boxDecorationCodec().optional(),
    if (rootStyleSchema != null)
      'variants': Ack.list(
        boxVariantCodec(rootStyleSchema, registry),
      ).optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<BoxStyler>(
    decode: (data) => BoxStyler(
      alignment: data['alignment'] as Alignment?,
      padding: data['padding'] as EdgeInsetsMix?,
      margin: data['margin'] as EdgeInsetsMix?,
      constraints: data['constraints'] as BoxConstraintsMix?,
      clipBehavior: data['clipBehavior'] as Clip?,
      decoration: data['decoration'] as BoxDecorationMix?,
      variants: data['variants'] as List<VariantStyle<BoxSpec>>?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: encodeBoxStylerFields,
  );
}

JsonMap encodeBoxStylerFields(
  BoxStyler value, {
  bool includeStylerMetadata = true,
}) {
  failIfPresent(value.$foregroundDecoration, 'foregroundDecoration');
  failIfPresent(value.$transform, 'transform');
  failIfPresent(value.$transformAlignment, 'transformAlignment');

  final encoded = {
    'alignment': singleAlignmentProp(value.$alignment, 'alignment'),
    'padding': singleMixProp<EdgeInsetsMix, EdgeInsetsGeometry>(
      value.$padding,
      'padding',
    ),
    'margin': singleMixProp<EdgeInsetsMix, EdgeInsetsGeometry>(
      value.$margin,
      'margin',
    ),
    'constraints': singleMixProp<BoxConstraintsMix, BoxConstraints>(
      value.$constraints,
      'constraints',
    ),
    'clipBehavior': singleValueProp(value.$clipBehavior, 'clipBehavior'),
    'decoration': singleMixProp<BoxDecorationMix, Decoration>(
      value.$decoration,
      'decoration',
    ),
    'variants': value.$variants,
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };

  if (includeStylerMetadata) return encoded;

  return Map<String, Object?>.from(encoded)
    ..remove('variants')
    ..remove('modifiers')
    ..remove('animation');
}

CodecSchema<JsonMap, BoxDecorationMix> boxDecorationCodec() {
  return Ack.object({'color': colorCodec().optional()}).codec<BoxDecorationMix>(
    decode: (data) => BoxDecorationMix(color: data['color'] as Color?),
    encode: (value) {
      failIfPresent(value.$border, 'decoration.border');
      failIfPresent(value.$borderRadius, 'decoration.borderRadius');
      failIfPresent(value.$shape, 'decoration.shape');
      failIfPresent(
        value.$backgroundBlendMode,
        'decoration.backgroundBlendMode',
      );
      failIfPresent(value.$image, 'decoration.image');
      failIfPresent(value.$gradient, 'decoration.gradient');
      failIfPresent(value.$boxShadow, 'decoration.boxShadow');

      return {'color': singleValueProp(value.$color, 'decoration.color')};
    },
  );
}

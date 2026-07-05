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
    'transform': matrix4Codec().optional(),
    'transformAlignment': alignmentCodec().optional(),
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
      transform: data['transform'] as Matrix4?,
      transformAlignment: data['transformAlignment'] as Alignment?,
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
    'transform': singleValueProp(value.$transform, 'transform'),
    'transformAlignment': singleAlignmentProp(
      value.$transformAlignment,
      'transformAlignment',
    ),
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
  return Ack.object({
    'color': colorCodec().optional(),
    'border': borderCodec().optional(),
    'borderRadius': borderRadiusCodec().optional(),
    'shape': enumNameCodec(BoxShape.values).optional(),
    'backgroundBlendMode': enumNameCodec(BlendMode.values).optional(),
    'boxShadow': Ack.list(boxShadowCodec()).optional(),
  }).codec<BoxDecorationMix>(
    decode: (data) => BoxDecorationMix(
      color: data['color'] as Color?,
      border: data['border'] as BorderMix?,
      borderRadius: data['borderRadius'] as BorderRadiusMix?,
      shape: data['shape'] as BoxShape?,
      backgroundBlendMode: data['backgroundBlendMode'] as BlendMode?,
      boxShadow: data['boxShadow'] as List<BoxShadowMix>?,
    ),
    encode: (value) {
      failIfPresent(value.$image, 'decoration.image');
      failIfPresent(value.$gradient, 'decoration.gradient');

      return {
        'color': singleValueProp(value.$color, 'decoration.color'),
        'border': singleMixProp<BorderMix, BoxBorder>(
          value.$border,
          'decoration.border',
        ),
        'borderRadius': singleMixProp<BorderRadiusMix, BorderRadiusGeometry>(
          value.$borderRadius,
          'decoration.borderRadius',
        ),
        'shape': singleValueProp(value.$shape, 'decoration.shape'),
        'backgroundBlendMode': singleValueProp(
          value.$backgroundBlendMode,
          'decoration.backgroundBlendMode',
        ),
        'boxShadow': _singleBoxShadowList(value),
      };
    },
  );
}

List<BoxShadowMix>? _singleBoxShadowList(BoxDecorationMix value) {
  final boxShadow = singleMixProp<BoxShadowListMix, List<BoxShadow>>(
    value.$boxShadow,
    'decoration.boxShadow',
  );

  return boxShadow?.items;
}

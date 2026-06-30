import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';
import 'stack_styler_codec.dart';

AckSchema<JsonMap, StackBoxStyler> stackBoxStylerCodec({
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
    'stackAlignment': alignmentCodec().optional(),
    'fit': enumNameCodec(StackFit.values).optional(),
    'textDirection': enumNameCodec(TextDirection.values).optional(),
    'stackClipBehavior': enumNameCodec(Clip.values).optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<StackBoxStyler>(
    decode: (data) => StackBoxStyler(
      alignment: data['alignment'] as Alignment?,
      padding: data['padding'] as EdgeInsetsMix?,
      margin: data['margin'] as EdgeInsetsMix?,
      constraints: data['constraints'] as BoxConstraintsMix?,
      clipBehavior: data['clipBehavior'] as Clip?,
      transform: data['transform'] as Matrix4?,
      transformAlignment: data['transformAlignment'] as Alignment?,
      decoration: data['decoration'] as BoxDecorationMix?,
      stackAlignment: data['stackAlignment'] as Alignment?,
      fit: data['fit'] as StackFit?,
      textDirection: data['textDirection'] as TextDirection?,
      stackClipBehavior: data['stackClipBehavior'] as Clip?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: _encodeStackBoxStyler,
  );
}

JsonMap _encodeStackBoxStyler(StackBoxStyler value) {
  failIfPresent(value.$variants, 'variants');

  final box = singleMixProp<BoxStyler, StyleSpec<BoxSpec>>(value.$box, 'box');
  final stack = singleMixProp<StackStyler, StyleSpec<StackSpec>>(
    value.$stack,
    'stack',
  );
  final boxFields = box == null
      ? <String, Object?>{}
      : encodeBoxStylerFields(box, includeStylerMetadata: false);
  final stackFields = stack == null
      ? <String, Object?>{}
      : encodeStackStylerFields(stack, includeStylerMetadata: false);

  return {
    ...boxFields,
    'stackAlignment': stackFields['alignment'],
    'fit': stackFields['fit'],
    'textDirection': stackFields['textDirection'],
    'stackClipBehavior': stackFields['clipBehavior'],
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };
}

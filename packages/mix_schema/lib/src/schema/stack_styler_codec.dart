import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';

AckSchema<JsonMap, StackStyler> stackStylerCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'alignment': alignmentCodec().optional(),
    'fit': enumNameCodec(StackFit.values).optional(),
    'textDirection': enumNameCodec(TextDirection.values).optional(),
    'clipBehavior': enumNameCodec(Clip.values).optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<StackStyler>(
    decode: (data) => StackStyler(
      alignment: data['alignment'] as Alignment?,
      fit: data['fit'] as StackFit?,
      textDirection: data['textDirection'] as TextDirection?,
      clipBehavior: data['clipBehavior'] as Clip?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: encodeStackStylerFields,
  );
}

JsonMap encodeStackStylerFields(
  StackStyler value, {
  bool includeStylerMetadata = true,
}) {
  failIfPresent(value.$variants, 'variants');

  final encoded = {
    'alignment': singleAlignmentProp(value.$alignment, 'alignment'),
    'fit': singleValueProp(value.$fit, 'fit'),
    'textDirection': singleValueProp(value.$textDirection, 'textDirection'),
    'clipBehavior': singleValueProp(value.$clipBehavior, 'clipBehavior'),
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };

  if (includeStylerMetadata) return encoded;

  return Map<String, Object?>.from(encoded)
    ..remove('modifiers')
    ..remove('animation');
}

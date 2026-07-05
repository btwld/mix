import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';

AckSchema<JsonMap, FlexStyler> flexStylerCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'direction': enumNameCodec(Axis.values).optional(),
    'mainAxisAlignment': enumNameCodec(MainAxisAlignment.values).optional(),
    'crossAxisAlignment': enumNameCodec(CrossAxisAlignment.values).optional(),
    'mainAxisSize': enumNameCodec(MainAxisSize.values).optional(),
    'verticalDirection': enumNameCodec(VerticalDirection.values).optional(),
    'textDirection': enumNameCodec(TextDirection.values).optional(),
    'textBaseline': enumNameCodec(TextBaseline.values).optional(),
    'clipBehavior': enumNameCodec(Clip.values).optional(),
    'spacing': numberAsDoubleCodec().optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<FlexStyler>(
    decode: (data) => FlexStyler(
      direction: data['direction'] as Axis?,
      mainAxisAlignment: data['mainAxisAlignment'] as MainAxisAlignment?,
      crossAxisAlignment: data['crossAxisAlignment'] as CrossAxisAlignment?,
      mainAxisSize: data['mainAxisSize'] as MainAxisSize?,
      verticalDirection: data['verticalDirection'] as VerticalDirection?,
      textDirection: data['textDirection'] as TextDirection?,
      textBaseline: data['textBaseline'] as TextBaseline?,
      clipBehavior: data['clipBehavior'] as Clip?,
      spacing: data['spacing'] as double?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: encodeFlexStylerFields,
  );
}

JsonMap encodeFlexStylerFields(
  FlexStyler value, {
  bool includeStylerMetadata = true,
}) {
  failIfPresent(value.$variants, 'variants');

  final encoded = {
    'direction': singleValueProp(value.$direction, 'direction'),
    'mainAxisAlignment': singleValueProp(
      value.$mainAxisAlignment,
      'mainAxisAlignment',
    ),
    'crossAxisAlignment': singleValueProp(
      value.$crossAxisAlignment,
      'crossAxisAlignment',
    ),
    'mainAxisSize': singleValueProp(value.$mainAxisSize, 'mainAxisSize'),
    'verticalDirection': singleValueProp(
      value.$verticalDirection,
      'verticalDirection',
    ),
    'textDirection': singleValueProp(value.$textDirection, 'textDirection'),
    'textBaseline': singleValueProp(value.$textBaseline, 'textBaseline'),
    'clipBehavior': singleValueProp(value.$clipBehavior, 'clipBehavior'),
    'spacing': singleValueProp(value.$spacing, 'spacing'),
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };

  if (includeStylerMetadata) return encoded;

  return Map<String, Object?>.from(encoded)
    ..remove('modifiers')
    ..remove('animation');
}

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import 'animation_codec.dart';
import 'box_styler_codec.dart';
import 'common_codecs.dart';
import 'flex_styler_codec.dart';
import 'modifier_codec.dart';

AckSchema<JsonMap, FlexBoxStyler> flexBoxStylerCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'alignment': alignmentCodec().optional(),
    'padding': edgeInsetsCodec().optional(),
    'margin': edgeInsetsCodec().optional(),
    'constraints': boxConstraintsCodec().optional(),
    'clipBehavior': enumNameCodec(Clip.values, debugName: 'Clip').optional(),
    'decoration': boxDecorationCodec().optional(),
    'direction': enumNameCodec(Axis.values, debugName: 'Axis').optional(),
    'mainAxisAlignment': enumNameCodec(
      MainAxisAlignment.values,
      debugName: 'MainAxisAlignment',
    ).optional(),
    'crossAxisAlignment': enumNameCodec(
      CrossAxisAlignment.values,
      debugName: 'CrossAxisAlignment',
    ).optional(),
    'mainAxisSize': enumNameCodec(
      MainAxisSize.values,
      debugName: 'MainAxisSize',
    ).optional(),
    'verticalDirection': enumNameCodec(
      VerticalDirection.values,
      debugName: 'VerticalDirection',
    ).optional(),
    'textDirection': enumNameCodec(
      TextDirection.values,
      debugName: 'TextDirection',
    ).optional(),
    'textBaseline': enumNameCodec(
      TextBaseline.values,
      debugName: 'TextBaseline',
    ).optional(),
    'flexClipBehavior': enumNameCodec(
      Clip.values,
      debugName: 'Clip',
    ).optional(),
    'spacing': numberAsDoubleCodec().optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<FlexBoxStyler>(
    decode: (data) => FlexBoxStyler(
      alignment: data['alignment'] as Alignment?,
      padding: data['padding'] as EdgeInsetsMix?,
      margin: data['margin'] as EdgeInsetsMix?,
      constraints: data['constraints'] as BoxConstraintsMix?,
      clipBehavior: data['clipBehavior'] as Clip?,
      decoration: data['decoration'] as BoxDecorationMix?,
      direction: data['direction'] as Axis?,
      mainAxisAlignment: data['mainAxisAlignment'] as MainAxisAlignment?,
      crossAxisAlignment: data['crossAxisAlignment'] as CrossAxisAlignment?,
      mainAxisSize: data['mainAxisSize'] as MainAxisSize?,
      verticalDirection: data['verticalDirection'] as VerticalDirection?,
      textDirection: data['textDirection'] as TextDirection?,
      textBaseline: data['textBaseline'] as TextBaseline?,
      flexClipBehavior: data['flexClipBehavior'] as Clip?,
      spacing: data['spacing'] as double?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: _encodeFlexBoxStyler,
  );
}

JsonMap _encodeFlexBoxStyler(FlexBoxStyler value) {
  _failIfPresent(value.$variants, 'variants');

  final box = singleMixProp<BoxStyler, StyleSpec<BoxSpec>>(value.$box, 'box');
  final flex = singleMixProp<FlexStyler, StyleSpec<FlexSpec>>(
    value.$flex,
    'flex',
  );
  final boxFields = box == null
      ? <String, Object?>{}
      : encodeBoxStylerFields(box, includeStylerMetadata: false);
  final flexFields = flex == null
      ? <String, Object?>{}
      : encodeFlexStylerFields(flex, includeStylerMetadata: false);

  return {
    ...boxFields,
    ...flexFields,
    'clipBehavior': boxFields['clipBehavior'],
    'flexClipBehavior': flexFields['clipBehavior'],
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };
}

void _failIfPresent(Object? value, String fieldName) {
  if (value == null) return;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" is not representable by this schema.',
  );
}

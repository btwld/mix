import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';

AckSchema<JsonMap, IconStyler> iconStylerCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'icon': registryValueCodecFrom<IconData>(
      registry,
      MixSchemaScope.iconData,
    ).optional(),
    'color': colorCodec().optional(),
    'size': numberAsDoubleCodec().optional(),
    'weight': numberAsDoubleCodec().optional(),
    'grade': numberAsDoubleCodec().optional(),
    'opticalSize': numberAsDoubleCodec().optional(),
    'textDirection': enumNameCodec(
      TextDirection.values,
      debugName: 'TextDirection',
    ).optional(),
    'applyTextScaling': Ack.boolean().optional(),
    'fill': numberAsDoubleCodec().optional(),
    'semanticsLabel': Ack.string().optional(),
    'opacity': numberAsDoubleCodec().optional(),
    'blendMode': enumNameCodec(
      BlendMode.values,
      debugName: 'BlendMode',
    ).optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<IconStyler>(
    decode: (data) => IconStyler(
      icon: data['icon'] as IconData?,
      color: data['color'] as Color?,
      size: data['size'] as double?,
      weight: data['weight'] as double?,
      grade: data['grade'] as double?,
      opticalSize: data['opticalSize'] as double?,
      textDirection: data['textDirection'] as TextDirection?,
      applyTextScaling: data['applyTextScaling'] as bool?,
      fill: data['fill'] as double?,
      semanticsLabel: data['semanticsLabel'] as String?,
      opacity: data['opacity'] as double?,
      blendMode: data['blendMode'] as BlendMode?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: _encodeIconStyler,
  );
}

JsonMap _encodeIconStyler(IconStyler value) {
  _failIfPresent(value.$variants, 'variants');
  _failIfPresent(value.$shadows, 'shadows');

  return {
    'icon': singleValueProp(value.$icon, 'icon'),
    'color': singleValueProp(value.$color, 'color'),
    'size': singleValueProp(value.$size, 'size'),
    'weight': singleValueProp(value.$weight, 'weight'),
    'grade': singleValueProp(value.$grade, 'grade'),
    'opticalSize': singleValueProp(value.$opticalSize, 'opticalSize'),
    'textDirection': singleValueProp(value.$textDirection, 'textDirection'),
    'applyTextScaling': singleValueProp(
      value.$applyTextScaling,
      'applyTextScaling',
    ),
    'fill': singleValueProp(value.$fill, 'fill'),
    'semanticsLabel': singleValueProp(value.$semanticsLabel, 'semanticsLabel'),
    'opacity': singleValueProp(value.$opacity, 'opacity'),
    'blendMode': singleValueProp(value.$blendMode, 'blendMode'),
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

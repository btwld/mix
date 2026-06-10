import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import 'common_codecs.dart';
import 'text_styler_codec.dart';

AckSchema<Object, WidgetModifierConfig> modifierConfigCodec() {
  return Ack.codec<Object, Object, WidgetModifierConfig>(
    input: Ack.list(modifierCodec()),
    decode: (value) =>
        WidgetModifierConfig.modifiers((value as List).cast<ModifierMix>()),
    encode: _encodeModifierConfig,
  );
}

AckSchema<JsonMap, ModifierMix> modifierCodec() {
  return Ack.discriminated<ModifierMix>(
    discriminatorKey: 'type',
    schemas: {
      'opacity': _opacityModifierCodec(),
      'blur': _blurModifierCodec(),
      'default_text_style': _defaultTextStyleModifierCodec(),
    },
  );
}

AckSchema<JsonMap, OpacityModifierMix> _opacityModifierCodec() {
  return Ack.object({
    'opacity': numberAsDoubleCodec(),
  }).codec<OpacityModifierMix>(
    decode: (data) => OpacityModifierMix(opacity: data['opacity']! as double),
    encode: (value) => {
      'opacity': singleValueProp(value.opacity, 'modifiers.opacity.opacity'),
    },
  );
}

AckSchema<JsonMap, BlurModifierMix> _blurModifierCodec() {
  return Ack.object({'sigma': numberAsDoubleCodec()}).codec<BlurModifierMix>(
    decode: (data) => BlurModifierMix(sigma: data['sigma']! as double),
    encode: (value) => {
      'sigma': singleValueProp(value.sigma, 'modifiers.blur.sigma'),
    },
  );
}

AckSchema<JsonMap, DefaultTextStyleModifierMix>
_defaultTextStyleModifierCodec() {
  return Ack.object({
    'style': textStyleMixCodec().optional(),
    'textAlign': textAlignCodec().optional(),
    'softWrap': Ack.boolean().optional(),
    'overflow': textOverflowCodec().optional(),
    'maxLines': Ack.integer().optional(),
  }).codec<DefaultTextStyleModifierMix>(
    decode: (data) => DefaultTextStyleModifierMix(
      style: data['style'] as TextStyleMix?,
      textAlign: data['textAlign'] as TextAlign?,
      softWrap: data['softWrap'] as bool?,
      overflow: data['overflow'] as TextOverflow?,
      maxLines: data['maxLines'] as int?,
    ),
    encode: _encodeDefaultTextStyleModifier,
  );
}

Object _encodeModifierConfig(WidgetModifierConfig value) {
  if (value.$orderOfModifiers?.isNotEmpty == true) {
    throw UnsupportedEncodeValueError(
      value.$orderOfModifiers,
      'Custom modifier order is not representable.',
    );
  }

  return value.$modifiers ?? const <ModifierMix>[];
}

JsonMap _encodeDefaultTextStyleModifier(DefaultTextStyleModifierMix value) {
  _failIfPresent(
    value.textWidthBasis,
    'modifiers.defaultTextStyle.textWidthBasis',
  );
  _failIfPresent(
    value.textHeightBehavior,
    'modifiers.defaultTextStyle.textHeightBehavior',
  );

  return {
    'style': singleMixProp<TextStyleMix, TextStyle>(
      value.style,
      'modifiers.defaultTextStyle.style',
    ),
    'textAlign': singleValueProp(
      value.textAlign,
      'modifiers.defaultTextStyle.textAlign',
    ),
    'softWrap': singleValueProp(
      value.softWrap,
      'modifiers.defaultTextStyle.softWrap',
    ),
    'overflow': singleValueProp(
      value.overflow,
      'modifiers.defaultTextStyle.overflow',
    ),
    'maxLines': singleValueProp(
      value.maxLines,
      'modifiers.defaultTextStyle.maxLines',
    ),
  };
}

void _failIfPresent(Object? value, String fieldName) {
  if (value == null) return;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" is not representable by this schema.',
  );
}

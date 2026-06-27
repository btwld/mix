import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import 'common_codecs.dart';
import 'text_styler_codec.dart';
import 'wire_discriminators.dart';

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
      modifierTypeOpacity: _opacityModifierCodec(),
      modifierTypeBlur: _blurModifierCodec(),
      modifierTypeFlexible: _flexibleModifierCodec(),
      modifierTypeDefaultTextStyle: _defaultTextStyleModifierCodec(),
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

AckSchema<JsonMap, FlexibleModifierMix> _flexibleModifierCodec() {
  return Ack.object({
    'flex': Ack.integer().optional(),
    'fit': enumCodec({
      'tight': FlexFit.tight,
      'loose': FlexFit.loose,
    }, debugName: 'FlexFit').optional(),
  }).codec<FlexibleModifierMix>(
    decode: (data) => FlexibleModifierMix(
      flex: data['flex'] as int?,
      fit: data['fit'] as FlexFit?,
    ),
    encode: (value) => {
      'flex': singleValueProp(value.flex, 'modifiers.flexible.flex'),
      'fit': singleValueProp(value.fit, 'modifiers.flexible.fit'),
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
  failIfPresent(
    value.textWidthBasis,
    'modifiers.defaultTextStyle.textWidthBasis',
  );
  failIfPresent(
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

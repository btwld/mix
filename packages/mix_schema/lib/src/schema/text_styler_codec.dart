import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';

AckSchema<JsonMap, TextStyler> textStylerCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'overflow': textOverflowCodec().optional(),
    'textAlign': textAlignCodec().optional(),
    'maxLines': Ack.integer().optional(),
    'style': textStyleMixCodec().optional(),
    'textDirection': textDirectionCodec().optional(),
    'softWrap': Ack.boolean().optional(),
    'selectionColor': colorCodec().optional(),
    'semanticsLabel': Ack.string().optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<TextStyler>(
    decode: (data) => TextStyler(
      overflow: data['overflow'] as TextOverflow?,
      textAlign: data['textAlign'] as TextAlign?,
      maxLines: data['maxLines'] as int?,
      style: data['style'] as TextStyleMix?,
      textDirection: data['textDirection'] as TextDirection?,
      softWrap: data['softWrap'] as bool?,
      selectionColor: data['selectionColor'] as Color?,
      semanticsLabel: data['semanticsLabel'] as String?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: _encodeTextStyler,
  );
}

JsonMap _encodeTextStyler(TextStyler value) {
  _failIfPresent(value.$strutStyle, 'strutStyle');
  _failIfPresent(value.$textScaler, 'textScaler');
  _failIfPresent(value.$textWidthBasis, 'textWidthBasis');
  _failIfPresent(value.$textHeightBehavior, 'textHeightBehavior');
  _failIfPresent(value.$textDirectives, 'textDirectives');
  _failIfPresent(value.$locale, 'locale');
  _failIfPresent(value.$variants, 'variants');

  return {
    'overflow': singleValueProp(value.$overflow, 'overflow'),
    'textAlign': singleValueProp(value.$textAlign, 'textAlign'),
    'maxLines': singleValueProp(value.$maxLines, 'maxLines'),
    'style': singleMixProp<TextStyleMix, TextStyle>(value.$style, 'style'),
    'textDirection': singleValueProp(value.$textDirection, 'textDirection'),
    'softWrap': singleValueProp(value.$softWrap, 'softWrap'),
    'selectionColor': singleValueProp(value.$selectionColor, 'selectionColor'),
    'semanticsLabel': singleValueProp(value.$semanticsLabel, 'semanticsLabel'),
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };
}

CodecSchema<JsonMap, TextStyleMix> textStyleMixCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'backgroundColor': colorCodec().optional(),
    'fontSize': numberAsDoubleCodec().optional(),
    'fontWeight': fontWeightCodec().optional(),
    'fontStyle': fontStyleCodec().optional(),
    'letterSpacing': numberAsDoubleCodec().optional(),
    'wordSpacing': numberAsDoubleCodec().optional(),
    'height': numberAsDoubleCodec().optional(),
    'fontFamily': Ack.string().optional(),
    'decoration': textDecorationCodec().optional(),
    'decorationColor': colorCodec().optional(),
    'decorationStyle': textDecorationStyleCodec().optional(),
    'decorationThickness': numberAsDoubleCodec().optional(),
  }).codec<TextStyleMix>(
    decode: (data) => TextStyleMix(
      color: data['color'] as Color?,
      backgroundColor: data['backgroundColor'] as Color?,
      fontSize: data['fontSize'] as double?,
      fontWeight: data['fontWeight'] as FontWeight?,
      fontStyle: data['fontStyle'] as FontStyle?,
      letterSpacing: data['letterSpacing'] as double?,
      wordSpacing: data['wordSpacing'] as double?,
      height: data['height'] as double?,
      fontFamily: data['fontFamily'] as String?,
      decoration: data['decoration'] as TextDecoration?,
      decorationColor: data['decorationColor'] as Color?,
      decorationStyle: data['decorationStyle'] as TextDecorationStyle?,
      decorationThickness: data['decorationThickness'] as double?,
    ),
    encode: _encodeTextStyle,
  );
}

JsonMap _encodeTextStyle(TextStyleMix value) {
  _failIfPresent(value.$debugLabel, 'style.debugLabel');
  _failIfPresent(value.$textBaseline, 'style.textBaseline');
  _failIfPresent(value.$foreground, 'style.foreground');
  _failIfPresent(value.$background, 'style.background');
  _failIfPresent(value.$inherit, 'style.inherit');
  _failIfPresent(value.$fontFamilyFallback, 'style.fontFamilyFallback');
  _failIfPresent(value.$fontFeatures, 'style.fontFeatures');
  _failIfPresent(value.$fontVariations, 'style.fontVariations');
  _failIfPresent(value.$shadows, 'style.shadows');

  return {
    'color': singleValueProp(value.$color, 'style.color'),
    'backgroundColor': singleValueProp(
      value.$backgroundColor,
      'style.backgroundColor',
    ),
    'fontSize': singleValueProp(value.$fontSize, 'style.fontSize'),
    'fontWeight': singleValueProp(value.$fontWeight, 'style.fontWeight'),
    'fontStyle': singleValueProp(value.$fontStyle, 'style.fontStyle'),
    'letterSpacing': singleValueProp(
      value.$letterSpacing,
      'style.letterSpacing',
    ),
    'wordSpacing': singleValueProp(value.$wordSpacing, 'style.wordSpacing'),
    'height': singleValueProp(value.$height, 'style.height'),
    'fontFamily': singleValueProp(value.$fontFamily, 'style.fontFamily'),
    'decoration': singleValueProp(value.$decoration, 'style.decoration'),
    'decorationColor': singleValueProp(
      value.$decorationColor,
      'style.decorationColor',
    ),
    'decorationStyle': singleValueProp(
      value.$decorationStyle,
      'style.decorationStyle',
    ),
    'decorationThickness': singleValueProp(
      value.$decorationThickness,
      'style.decorationThickness',
    ),
  };
}

CodecSchema<String, TextOverflow> textOverflowCodec() {
  return strictEnumCodec({
    'clip': TextOverflow.clip,
    'fade': TextOverflow.fade,
    'ellipsis': TextOverflow.ellipsis,
    'visible': TextOverflow.visible,
  }, debugName: 'TextOverflow');
}

CodecSchema<String, TextAlign> textAlignCodec() {
  return strictEnumCodec({
    'left': TextAlign.left,
    'right': TextAlign.right,
    'center': TextAlign.center,
    'justify': TextAlign.justify,
    'start': TextAlign.start,
    'end': TextAlign.end,
  }, debugName: 'TextAlign');
}

CodecSchema<String, TextDirection> textDirectionCodec() {
  return strictEnumCodec({
    'ltr': TextDirection.ltr,
    'rtl': TextDirection.rtl,
  }, debugName: 'TextDirection');
}

CodecSchema<String, FontWeight> fontWeightCodec() {
  return strictEnumCodec({
    'w100': FontWeight.w100,
    'w200': FontWeight.w200,
    'w300': FontWeight.w300,
    'w400': FontWeight.w400,
    'w500': FontWeight.w500,
    'w600': FontWeight.w600,
    'w700': FontWeight.w700,
    'w800': FontWeight.w800,
    'w900': FontWeight.w900,
  }, debugName: 'FontWeight');
}

CodecSchema<String, FontStyle> fontStyleCodec() {
  return strictEnumCodec({
    'normal': FontStyle.normal,
    'italic': FontStyle.italic,
  }, debugName: 'FontStyle');
}

CodecSchema<String, TextDecoration> textDecorationCodec() {
  return strictEnumCodec({
    'none': TextDecoration.none,
    'underline': TextDecoration.underline,
    'overline': TextDecoration.overline,
    'line_through': TextDecoration.lineThrough,
  }, debugName: 'TextDecoration');
}

CodecSchema<String, TextDecorationStyle> textDecorationStyleCodec() {
  return strictEnumCodec({
    'solid': TextDecorationStyle.solid,
    'double': TextDecorationStyle.double,
    'dotted': TextDecorationStyle.dotted,
    'dashed': TextDecorationStyle.dashed,
    'wavy': TextDecorationStyle.wavy,
  }, debugName: 'TextDecorationStyle');
}

void _failIfPresent(Object? value, String fieldName) {
  if (value == null) return;

  throw UnsupportedEncodeValueError(
    value,
    'Field "$fieldName" is not representable by this schema.',
  );
}

import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_protocol_error.dart';
import '../contract/identity_resolution.dart';
import 'common_codecs.dart';
import 'primitive_wire.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, TextStyler> textStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  MixProtocolIdentityContext Function()? identityContext,
}) {
  return _textStylerSchemaType(rootStyleSchema).codec();
}

SchemaObject<TextStyler> _textStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
) {
  final overflow = propValueField<TextStyler, TextOverflow>(
    'overflow',
    textOverflowCodec(),
    (value) => value.$overflow,
  );
  final strutStyle = propMixField<TextStyler, StrutStyleMix, StrutStyle>(
    'strutStyle',
    strutStyleMixCodec(),
    (value) => value.$strutStyle,
  );
  final textAlign = propValueField<TextStyler, TextAlign>(
    'textAlign',
    textAlignCodec(),
    (value) => value.$textAlign,
  );
  final textScaler = propValueField<TextStyler, TextScaler>(
    'textScaler',
    textScalerCodec(),
    (value) => value.$textScaler,
  );
  final maxLines = propValueField<TextStyler, int>(
    'maxLines',
    Ack.integer().min(1),
    (value) => value.$maxLines,
  );
  final style = propTokenMixField<TextStyler, TextStyleMix, TextStyle>(
    'style',
    textStyleMixCodec(),
    (value) => value.$style,
  );
  final textWidthBasis = propValueField<TextStyler, TextWidthBasis>(
    'textWidthBasis',
    enumNameCodec(TextWidthBasis.values),
    (value) => value.$textWidthBasis,
  );
  final textDirection = propValueField<TextStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final softWrap = propValueField<TextStyler, bool>(
    'softWrap',
    Ack.boolean(),
    (value) => value.$softWrap,
  );
  final selectionColor = propTokenValueField<TextStyler, Color>(
    'selectionColor',
    colorCodec(),
    (value) => value.$selectionColor,
  );
  final semanticsLabel = propValueField<TextStyler, String>(
    'semanticsLabel',
    Ack.string(),
    (value) => value.$semanticsLabel,
  );
  final locale = propValueField<TextStyler, Locale>(
    'locale',
    localeCodec(),
    (value) => value.$locale,
  );
  final textHeightBehavior =
      propMixField<TextStyler, TextHeightBehaviorMix, TextHeightBehavior>(
        'textHeightBehavior',
        textHeightBehaviorCodec(),
        (value) => value.$textHeightBehavior,
      );
  final textDirectives = directField<TextStyler, List<Directive<String>>>(
    'textDirectives',
    Ack.list(textDirectiveCodec()),
    (value) => value.$textDirectives,
  );
  final metadata = StylerMetadataFields<TextStyler, TextSpec>(
    rootStyleSchema: rootStyleSchema,
    readVariants: (value) => value.$variants,
    readModifier: (value) => value.$modifier,
    readAnimation: (value) => value.$animation,
  );

  return SchemaObject<TextStyler>(
    inventoryOwner: 'TextStyler',
    ownerFieldInventory: textStylerInventory,
    actualFieldCount: stylerFieldCount,
    fields: [
      overflow,
      strutStyle,
      textAlign,
      textScaler,
      maxLines,
      style,
      textWidthBasis,
      textDirection,
      softWrap,
      selectionColor,
      semanticsLabel,
      locale,
      textHeightBehavior,
      textDirectives,
      ...metadata.fields,
    ],
    unsupportedFields: [...metadata.unsupportedFields()],
    build: (data) => TextStyler.create(
      overflow: overflow.value(data),
      strutStyle: strutStyle.value(data),
      textAlign: textAlign.value(data),
      textScaler: textScaler.value(data),
      maxLines: maxLines.value(data),
      style: style.value(data),
      textWidthBasis: textWidthBasis.value(data),
      textDirection: textDirection.value(data),
      softWrap: softWrap.value(data),
      selectionColor: selectionColor.value(data),
      semanticsLabel: semanticsLabel.value(data),
      locale: locale.value(data),
      textHeightBehavior: textHeightBehavior.value(data),
      textDirectives: textDirectives.value(data),
      variants: metadata.variants?.value(data),
      modifier: metadata.modifiers.value(data),
      animation: metadata.animation.value(data),
    ),
  );
}

CodecSchema<Object, TextStyleMix> textStyleMixCodec() {
  return tokenizedCodec<TextStyle, TextStyleMix>(
    literal: _textStyleMixObjectCodec(),
    decodeToken: (data) => TextStyleToken(data[tokenReferenceKey]! as String),
    reference: (token) => (token as TextStyleToken).mix(),
  );
}

JsonMap textStyleMixLiteralJsonSchema() {
  return _textStyleMixObjectCodec().toJsonSchema();
}

CodecSchema<JsonMap, TextStyleMix> _textStyleMixObjectCodec() {
  return Ack.object({
    'color': valuePropCodec<Color>(
      colorCodec(),
      fieldName: 'style.color',
    ).optional(),
    'backgroundColor': valuePropCodec<Color>(
      colorCodec(),
      fieldName: 'style.backgroundColor',
    ).optional(),
    'fontSize': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'style.fontSize',
    ).optional(),
    'fontWeight': valuePropCodec<FontWeight>(
      fontWeightCodec(),
      fieldName: 'style.fontWeight',
    ).optional(),
    'fontStyle': valuePropCodec<FontStyle>(
      fontStyleCodec(),
      fieldName: 'style.fontStyle',
    ).optional(),
    'letterSpacing': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'style.letterSpacing',
    ).optional(),
    'debugLabel': valuePropCodec<String>(
      Ack.string(),
      fieldName: 'style.debugLabel',
    ).optional(),
    'wordSpacing': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'style.wordSpacing',
    ).optional(),
    'textBaseline': valuePropCodec<TextBaseline>(
      enumNameCodec(TextBaseline.values),
      fieldName: 'style.textBaseline',
    ).optional(),
    'height': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'style.height',
    ).optional(),
    'fontFamily': valuePropCodec<String>(
      Ack.string(),
      fieldName: 'style.fontFamily',
    ).optional(),
    'fontFamilyFallback': valuePropCodec<List<String>>(
      Ack.list(Ack.string()),
      fieldName: 'style.fontFamilyFallback',
    ).optional(),
    'fontFeatures': valuePropCodec<List<FontFeature>>(
      Ack.list(fontFeatureCodec()),
      fieldName: 'style.fontFeatures',
    ).optional(),
    'fontVariations': valuePropCodec<List<FontVariation>>(
      Ack.list(fontVariationCodec()),
      fieldName: 'style.fontVariations',
    ).optional(),
    'decoration': valuePropCodec<TextDecoration>(
      textDecorationCodec(),
      fieldName: 'style.decoration',
    ).optional(),
    'decorationColor': valuePropCodec<Color>(
      colorCodec(),
      fieldName: 'style.decorationColor',
    ).optional(),
    'decorationStyle': valuePropCodec<TextDecorationStyle>(
      textDecorationStyleCodec(),
      fieldName: 'style.decorationStyle',
    ).optional(),
    'decorationThickness': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'style.decorationThickness',
    ).optional(),
    'shadows': mixPropCodec<ShadowListMix, List<Shadow>>(
      _shadowListFieldCodec(),
      fieldName: 'style.shadows',
    ).optional(),
  }).codec<TextStyleMix>(
    decode: (data) => TextStyleMix.create(
      color: data['color'] as Prop<Color>?,
      backgroundColor: data['backgroundColor'] as Prop<Color>?,
      fontSize: data['fontSize'] as Prop<double>?,
      fontWeight: data['fontWeight'] as Prop<FontWeight>?,
      fontStyle: data['fontStyle'] as Prop<FontStyle>?,
      letterSpacing: data['letterSpacing'] as Prop<double>?,
      debugLabel: data['debugLabel'] as Prop<String>?,
      wordSpacing: data['wordSpacing'] as Prop<double>?,
      textBaseline: data['textBaseline'] as Prop<TextBaseline>?,
      height: data['height'] as Prop<double>?,
      fontFamily: data['fontFamily'] as Prop<String>?,
      fontFamilyFallback: data['fontFamilyFallback'] as Prop<List<String>>?,
      fontFeatures: data['fontFeatures'] as Prop<List<FontFeature>>?,
      fontVariations: data['fontVariations'] as Prop<List<FontVariation>>?,
      decoration: data['decoration'] as Prop<TextDecoration>?,
      decorationColor: data['decorationColor'] as Prop<Color>?,
      decorationStyle: data['decorationStyle'] as Prop<TextDecorationStyle>?,
      decorationThickness: data['decorationThickness'] as Prop<double>?,
      shadows: data['shadows'] as Prop<List<Shadow>>?,
    ),
    encode: _encodeTextStyle,
  );
}

JsonMap _encodeTextStyle(TextStyleMix value) {
  checkKnownFieldInventory(
    value,
    owner: 'TextStyleMix',
    fields: textStyleMixInventory,
  );
  failIfPresent(value.$foreground, 'style.foreground');
  failIfPresent(value.$background, 'style.background');
  failIfPresent(value.$inherit, 'style.inherit');

  return {
    'color': value.$color,
    'backgroundColor': value.$backgroundColor,
    'fontSize': value.$fontSize,
    'fontWeight': value.$fontWeight,
    'fontStyle': value.$fontStyle,
    'letterSpacing': value.$letterSpacing,
    'debugLabel': value.$debugLabel,
    'wordSpacing': value.$wordSpacing,
    'textBaseline': value.$textBaseline,
    'height': value.$height,
    'fontFamily': value.$fontFamily,
    'fontFamilyFallback': value.$fontFamilyFallback,
    'fontFeatures': value.$fontFeatures,
    'fontVariations': value.$fontVariations,
    'decoration': value.$decoration,
    'decorationColor': value.$decorationColor,
    'decorationStyle': value.$decorationStyle,
    'decorationThickness': value.$decorationThickness,
    'shadows': value.$shadows,
  };
}

CodecSchema<String, TextOverflow> textOverflowCodec() {
  return enumCodec({
    'clip': TextOverflow.clip,
    'fade': TextOverflow.fade,
    'ellipsis': TextOverflow.ellipsis,
    'visible': TextOverflow.visible,
  }, debugName: 'TextOverflow');
}

CodecSchema<String, TextAlign> textAlignCodec() {
  return enumCodec({
    'left': TextAlign.left,
    'right': TextAlign.right,
    'center': TextAlign.center,
    'justify': TextAlign.justify,
    'start': TextAlign.start,
    'end': TextAlign.end,
  }, debugName: 'TextAlign');
}

CodecSchema<Object, FontWeight> fontWeightCodec() {
  return tokenizedCodec<FontWeight, FontWeight>(
    literal: fontWeightLiteralCodec(),
    decodeToken: (data) => FontWeightToken(data[tokenReferenceKey]! as String),
    reference: (token) => token(),
  );
}

CodecSchema<String, FontWeight> fontWeightLiteralCodec() {
  return enumCodec(fontWeightWireValues, debugName: 'FontWeight');
}

CodecSchema<String, FontStyle> fontStyleCodec() {
  return enumCodec({
    'normal': FontStyle.normal,
    'italic': FontStyle.italic,
  }, debugName: 'FontStyle');
}

CodecSchema<String, TextDecoration> textDecorationCodec() {
  return enumCodec(textDecorationWireValues, debugName: 'TextDecoration');
}

CodecSchema<String, TextDecorationStyle> textDecorationStyleCodec() {
  return enumCodec({
    'solid': TextDecorationStyle.solid,
    'double': TextDecorationStyle.double,
    'dotted': TextDecorationStyle.dotted,
    'dashed': TextDecorationStyle.dashed,
    'wavy': TextDecorationStyle.wavy,
  }, debugName: 'TextDecorationStyle');
}

CodecSchema<JsonMap, StrutStyleMix> strutStyleMixCodec() {
  return Ack.object({
    'fontFamily': valuePropCodec<String>(
      Ack.string(),
      fieldName: 'strutStyle.fontFamily',
    ).optional(),
    'fontFamilyFallback': valuePropCodec<List<String>>(
      Ack.list(Ack.string()),
      fieldName: 'strutStyle.fontFamilyFallback',
    ).optional(),
    'fontSize': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'strutStyle.fontSize',
    ).optional(),
    'fontWeight': valuePropCodec<FontWeight>(
      fontWeightCodec(),
      fieldName: 'strutStyle.fontWeight',
    ).optional(),
    'fontStyle': valuePropCodec<FontStyle>(
      fontStyleCodec(),
      fieldName: 'strutStyle.fontStyle',
    ).optional(),
    'height': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'strutStyle.height',
    ).optional(),
    'leading': valuePropCodec<double>(
      doubleTokenCodec(),
      fieldName: 'strutStyle.leading',
    ).optional(),
    'forceStrutHeight': valuePropCodec<bool>(
      Ack.boolean(),
      fieldName: 'strutStyle.forceStrutHeight',
    ).optional(),
  }).codec<StrutStyleMix>(
    decode: (data) => StrutStyleMix.create(
      fontFamily: data['fontFamily'] as Prop<String>?,
      fontFamilyFallback: data['fontFamilyFallback'] as Prop<List<String>>?,
      fontSize: data['fontSize'] as Prop<double>?,
      fontWeight: data['fontWeight'] as Prop<FontWeight>?,
      fontStyle: data['fontStyle'] as Prop<FontStyle>?,
      height: data['height'] as Prop<double>?,
      leading: data['leading'] as Prop<double>?,
      forceStrutHeight: data['forceStrutHeight'] as Prop<bool>?,
    ),
    encode: _encodeStrutStyle,
  );
}

JsonMap _encodeStrutStyle(StrutStyleMix value) {
  checkKnownFieldInventory(
    value,
    owner: 'StrutStyleMix',
    fields: strutStyleMixInventory,
  );

  return {
    'fontFamily': value.$fontFamily,
    'fontFamilyFallback': value.$fontFamilyFallback,
    'fontSize': value.$fontSize,
    'fontWeight': value.$fontWeight,
    'fontStyle': value.$fontStyle,
    'height': value.$height,
    'leading': value.$leading,
    'forceStrutHeight': value.$forceStrutHeight,
  };
}

CodecSchema<JsonMap, TextScaler> textScalerCodec() {
  return Ack.object({'linear': nonNegativeDoubleCodec()}).codec<TextScaler>(
    decode: (data) => TextScaler.linear(data['linear']! as double),
    encode: _encodeTextScaler,
  );
}

JsonMap _encodeTextScaler(TextScaler value) {
  // TextScaler only exposes this compatibility getter for linear detection.
  // ignore: deprecated_member_use
  final factor = value.textScaleFactor;
  if (TextScaler.linear(factor) != value) {
    throw UnsupportedEncodeValueError(
      value,
      'Only linear TextScaler values are representable.',
    );
  }

  return {'linear': factor};
}

CodecSchema<JsonMap, FontFeature> fontFeatureCodec() {
  return Ack.object({
    'feature': Ack.string().minLength(4).maxLength(4),
    'value': Ack.integer().min(0),
  }).codec<FontFeature>(
    decode: (data) =>
        FontFeature(data['feature']! as String, data['value']! as int),
    encode: (value) => {'feature': value.feature, 'value': value.value},
  );
}

CodecSchema<JsonMap, FontVariation> fontVariationCodec() {
  return Ack.object({
    'axis': Ack.string().minLength(4).maxLength(4),
    'value': numberAsDoubleCodec(),
  }).codec<FontVariation>(
    decode: (data) =>
        FontVariation(data['axis']! as String, data['value']! as double),
    encode: (value) => {'axis': value.axis, 'value': value.value},
  );
}

CodecSchema<Object, ShadowListMix> _shadowListFieldCodec() {
  return shadowListMixCodec();
}

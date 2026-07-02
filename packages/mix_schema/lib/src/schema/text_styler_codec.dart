import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../errors/mix_schema_error.dart';
import '../registry/registry.dart';
import 'common_codecs.dart';
import 'primitive_wire.dart';
import 'schema_field.dart';
import 'styler_field_inventory.dart';
import 'styler_codec_helpers.dart';

AckSchema<JsonMap, TextStyler> textStylerCodec({
  AckSchema<JsonMap, Object>? rootStyleSchema,
  required FrozenRegistry Function() registry,
}) {
  return _textStylerSchemaType(rootStyleSchema, registry).codec();
}

SchemaObject<TextStyler> _textStylerSchemaType(
  AckSchema<JsonMap, Object>? rootStyleSchema,
  FrozenRegistry Function() registry,
) {
  final overflow = valueField<TextStyler, TextOverflow>(
    'overflow',
    textOverflowCodec(),
    (value) => value.$overflow,
  );
  final textAlign = valueField<TextStyler, TextAlign>(
    'textAlign',
    textAlignCodec(),
    (value) => value.$textAlign,
  );
  final maxLines = valueField<TextStyler, int>(
    'maxLines',
    Ack.integer(),
    (value) => value.$maxLines,
  );
  final style = tokenMixField<TextStyler, TextStyleMix, TextStyle>(
    'style',
    textStyleMixCodec(),
    (value) => value.$style,
  );
  final textDirection = valueField<TextStyler, TextDirection>(
    'textDirection',
    textDirectionCodec(),
    (value) => value.$textDirection,
  );
  final softWrap = valueField<TextStyler, bool>(
    'softWrap',
    Ack.boolean(),
    (value) => value.$softWrap,
  );
  final selectionColor = tokenValueField<TextStyler, Color>(
    'selectionColor',
    colorCodec(),
    (value) => value.$selectionColor,
  );
  final semanticsLabel = valueField<TextStyler, String>(
    'semanticsLabel',
    Ack.string(),
    (value) => value.$semanticsLabel,
  );
  final textHeightBehavior =
      mixField<TextStyler, TextHeightBehaviorMix, TextHeightBehavior>(
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
    registry: registry,
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
      textAlign,
      maxLines,
      style,
      textDirection,
      softWrap,
      selectionColor,
      semanticsLabel,
      textHeightBehavior,
      textDirectives,
      ...metadata.fields,
    ],
    unsupportedFields: [
      UnsupportedSchemaField<TextStyler>(
        'strutStyle',
        (value) => value.$strutStyle,
      ),
      UnsupportedSchemaField<TextStyler>(
        'textScaler',
        (value) => value.$textScaler,
      ),
      UnsupportedSchemaField<TextStyler>(
        'textWidthBasis',
        (value) => value.$textWidthBasis,
      ),
      UnsupportedSchemaField<TextStyler>('locale', (value) => value.$locale),
      ...metadata.unsupportedFields(),
    ],
    build: (data) => TextStyler(
      overflow: overflow.value(data),
      textAlign: textAlign.value(data),
      maxLines: maxLines.value(data),
      style: style.value(data),
      textDirection: textDirection.value(data),
      softWrap: softWrap.value(data),
      selectionColor: selectionColor.value(data),
      semanticsLabel: semanticsLabel.value(data),
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

CodecSchema<JsonMap, TextStyleMix> _textStyleMixObjectCodec() {
  return Ack.object({
    'color': colorCodec().optional(),
    'backgroundColor': colorCodec().optional(),
    'fontSize': doubleTokenCodec().optional(),
    'fontWeight': fontWeightCodec().optional(),
    'fontStyle': fontStyleCodec().optional(),
    'letterSpacing': doubleTokenCodec().optional(),
    'wordSpacing': doubleTokenCodec().optional(),
    'height': doubleTokenCodec().optional(),
    'fontFamily': Ack.string().optional(),
    'decoration': textDecorationCodec().optional(),
    'decorationColor': colorCodec().optional(),
    'decorationStyle': textDecorationStyleCodec().optional(),
    'decorationThickness': doubleTokenCodec().optional(),
    'shadows': _shadowListFieldCodec().optional(),
  }).codec<TextStyleMix>(
    decode: (data) => TextStyleMix.create(
      color: Prop.maybe(data['color'] as Color?),
      backgroundColor: Prop.maybe(data['backgroundColor'] as Color?),
      fontSize: Prop.maybe(data['fontSize'] as double?),
      fontWeight: Prop.maybe(data['fontWeight'] as FontWeight?),
      fontStyle: Prop.maybe(data['fontStyle'] as FontStyle?),
      letterSpacing: Prop.maybe(data['letterSpacing'] as double?),
      wordSpacing: Prop.maybe(data['wordSpacing'] as double?),
      height: Prop.maybe(data['height'] as double?),
      fontFamily: Prop.maybe(data['fontFamily'] as String?),
      decoration: Prop.maybe(data['decoration'] as TextDecoration?),
      decorationColor: Prop.maybe(data['decorationColor'] as Color?),
      decorationStyle: Prop.maybe(
        data['decorationStyle'] as TextDecorationStyle?,
      ),
      decorationThickness: Prop.maybe(data['decorationThickness'] as double?),
      shadows: _shadowListProp(data['shadows']),
    ),
    encode: _encodeTextStyle,
  );
}

JsonMap _encodeTextStyle(TextStyleMix value) {
  failIfPresent(value.$debugLabel, 'style.debugLabel');
  failIfPresent(value.$textBaseline, 'style.textBaseline');
  failIfPresent(value.$foreground, 'style.foreground');
  failIfPresent(value.$background, 'style.background');
  failIfPresent(value.$inherit, 'style.inherit');
  failIfPresent(value.$fontFamilyFallback, 'style.fontFamilyFallback');
  failIfPresent(value.$fontFeatures, 'style.fontFeatures');
  failIfPresent(value.$fontVariations, 'style.fontVariations');

  return {
    'color': singleValuePropWire(value.$color, 'style.color'),
    'backgroundColor': singleValuePropWire(
      value.$backgroundColor,
      'style.backgroundColor',
    ),
    'fontSize': singleValuePropWire(value.$fontSize, 'style.fontSize'),
    'fontWeight': singleValuePropWire(value.$fontWeight, 'style.fontWeight'),
    'fontStyle': singleValueProp(value.$fontStyle, 'style.fontStyle'),
    'letterSpacing': singleValuePropWire(
      value.$letterSpacing,
      'style.letterSpacing',
    ),
    'wordSpacing': singleValuePropWire(value.$wordSpacing, 'style.wordSpacing'),
    'height': singleValuePropWire(value.$height, 'style.height'),
    'fontFamily': singleValueProp(value.$fontFamily, 'style.fontFamily'),
    'decoration': singleValueProp(value.$decoration, 'style.decoration'),
    'decorationColor': singleValuePropWire(
      value.$decorationColor,
      'style.decorationColor',
    ),
    'decorationStyle': singleValueProp(
      value.$decorationStyle,
      'style.decorationStyle',
    ),
    'decorationThickness': singleValuePropWire(
      value.$decorationThickness,
      'style.decorationThickness',
    ),
    'shadows': _shadowListWire(value),
  };
}

Object? _shadowListWire(TextStyleMix value) {
  final shadows = singleMixPropWire<ShadowListMix, List<Shadow>>(
    value.$shadows,
    'style.shadows',
  );

  return switch (shadows) {
    null => null,
    JsonMap() => shadows,
    Prop<List<Shadow>>() => shadows,
    ShadowListMix() => shadows.items,
    _ => throw UnsupportedEncodeValueError(
      shadows,
      'Field "style.shadows" decoded to unsupported ${shadows.runtimeType}.',
    ),
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

AckSchema<Object, Object> _shadowListFieldCodec() {
  return Ack.anyOf([
    Ack.list(shadowCodec()),
    tokenReferenceCodec<List<Shadow>, ShadowListMix>(
      decodeToken: (data) => ShadowToken(data[tokenReferenceKey]! as String),
      reference: (token) => (token as ShadowToken).mix(),
    ),
  ]);
}

Prop<List<Shadow>>? _shadowListProp(Object? value) {
  return switch (value) {
    null => null,
    Prop<List<Shadow>>() => value,
    List<ShadowMix>() => Prop.mix(ShadowListMix(value)),
    _ => throw UnsupportedEncodeValueError(
      value,
      'TextStyle shadows decoded to unsupported ${value.runtimeType}.',
    ),
  };
}

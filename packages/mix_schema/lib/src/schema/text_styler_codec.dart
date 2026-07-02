import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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
  final style = mixField<TextStyler, TextStyleMix, TextStyle>(
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
  final selectionColor = valueField<TextStyler, Color>(
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
    'shadows': Ack.list(shadowCodec()).optional(),
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
      shadows: data['shadows'] as List<ShadowMix>?,
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
    'shadows': _singleShadowList(value),
  };
}

List<ShadowMix>? _singleShadowList(TextStyleMix value) {
  final shadows = singleMixProp<ShadowListMix, List<Shadow>>(
    value.$shadows,
    'style.shadows',
  );

  return shadows?.items;
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

CodecSchema<String, FontWeight> fontWeightCodec() {
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

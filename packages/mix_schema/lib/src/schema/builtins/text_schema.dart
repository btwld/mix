import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/prop_encode.dart';
import '../../errors/schema_transform_exceptions.dart';
import '../shared/shared_schemas.dart';
import '../styler_catalog.dart';
import '../styler_definition.dart';

StylerContract<TextSpec, TextStyler> buildTextStylerDefinition(
  StylerCatalog catalog,
) {
  return buildStylerCodecContract(
    catalog: catalog,
    type: .text,
    emptyStyle: TextStyler(),
    fields: {
      'overflow': textOverflowSchema.optional(),
      'strutStyle': strutStyleCodec.optional(),
      'textAlign': textAlignSchema.optional(),
      'textScaler': textScalerCodec.optional(),
      'maxLines': Ack.integer().min(1).optional(),
      'style': textStyleCodec.optional(),
      'textWidthBasis': textWidthBasisSchema.optional(),
      'textHeightBehavior': textHeightBehaviorCodec.optional(),
      'textDirection': textDirectionSchema.optional(),
      'softWrap': Ack.boolean().optional(),
      'textTransform': textTransformDirectiveSchema.optional(),
      'selectionColor': colorCodec.optional(),
      'semanticsLabel': Ack.string().optional(),
      'locale': localeCodec.optional(),
    },
    build: _decodeTextStyler,
    encodeFields: _encodeTextFields,
  );
}

TextStyler _decodeTextStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<TextSpec>>? variants,
}) {
  final textTransform = data['textTransform'] as Directive<String>?;

  return TextStyler(
    overflow: data['overflow'] as TextOverflow?,
    strutStyle: data['strutStyle'] as StrutStyleMix?,
    textAlign: data['textAlign'] as TextAlign?,
    textScaler: data['textScaler'] as TextScaler?,
    maxLines: data['maxLines'] as int?,
    style: data['style'] as TextStyleMix?,
    textWidthBasis: data['textWidthBasis'] as TextWidthBasis?,
    textHeightBehavior: data['textHeightBehavior'] as TextHeightBehaviorMix?,
    textDirection: data['textDirection'] as TextDirection?,
    softWrap: data['softWrap'] as bool?,
    textDirectives: textTransform == null ? null : [textTransform],
    selectionColor: data['selectionColor'] as Color?,
    semanticsLabel: data['semanticsLabel'] as String?,
    locale: data['locale'] as Locale?,
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}

JsonMap _encodeTextFields(TextStyler value) {
  final textDirectives = value.$textDirectives;
  Directive<String>? textTransform;
  if (textDirectives != null && textDirectives.isNotEmpty) {
    if (textDirectives.length != 1) {
      throw UnsupportedEncodeValueError(
        'Only one text transform directive can be encoded.',
        value: textDirectives,
      );
    }
    textTransform = textDirectives.single;
  }

  return optionalJsonMap([
    ('overflow', directPropValue(value.$overflow)),
    ('strutStyle', directPropMix<StrutStyleMix>(value.$strutStyle)),
    ('textAlign', directPropValue(value.$textAlign)),
    ('textScaler', directPropValue(value.$textScaler)),
    ('maxLines', directPropValue(value.$maxLines)),
    ('style', directPropMix<TextStyleMix>(value.$style)),
    ('textWidthBasis', directPropValue(value.$textWidthBasis)),
    (
      'textHeightBehavior',
      directPropMix<TextHeightBehaviorMix>(value.$textHeightBehavior),
    ),
    ('textDirection', directPropValue(value.$textDirection)),
    ('softWrap', directPropValue(value.$softWrap)),
    ('textTransform', textTransform),
    ('selectionColor', directPropValue(value.$selectionColor)),
    ('semanticsLabel', directPropValue(value.$semanticsLabel)),
    ('locale', directPropValue(value.$locale)),
  ]);
}

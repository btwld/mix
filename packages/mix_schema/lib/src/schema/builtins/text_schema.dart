import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<TextSpec, TextStyler> buildTextStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .text,
    emptyStyle: TextStyler(),
    fields: {
      'overflow': catalog.textOverflow.optional(),
      'strutStyle': catalog.strutStyle.optional(),
      'textAlign': catalog.textAlign.optional(),
      'textScaler': catalog.textScaler.optional(),
      'maxLines': Ack.integer().min(1).optional(),
      'style': catalog.textStyle.optional(),
      'textWidthBasis': catalog.textWidthBasis.optional(),
      'textHeightBehavior': catalog.textHeightBehavior.optional(),
      'textDirection': catalog.textDirection.optional(),
      'softWrap': Ack.boolean().optional(),
      'textTransform': catalog.textTransformDirective.optional(),
      'selectionColor': catalog.color.optional(),
      'semanticsLabel': Ack.string().optional(),
      'locale': catalog.locale.optional(),
    },
    build: (data, {animation, modifier, variants}) {
      final textTransform = data['textTransform'] as Directive<String>?;

      return TextStyler(
        overflow: data['overflow'] as TextOverflow?,
        strutStyle: data['strutStyle'] as StrutStyleMix?,
        textAlign: data['textAlign'] as TextAlign?,
        textScaler: data['textScaler'] as TextScaler?,
        maxLines: data['maxLines'] as int?,
        style: data['style'] as TextStyleMix?,
        textWidthBasis: data['textWidthBasis'] as TextWidthBasis?,
        textHeightBehavior:
            data['textHeightBehavior'] as TextHeightBehaviorMix?,
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
    },
  );
}

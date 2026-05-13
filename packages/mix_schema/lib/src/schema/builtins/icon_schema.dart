import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/json_map.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';
import 'styler_field_encoders.dart';

StylerContract<IconSpec, IconStyler> buildIconStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return buildStylerCodecContract(
    catalog: catalog,
    type: .icon,
    emptyStyle: IconStyler(),
    fields: {
      'color': catalog.color.optional(),
      'size': Ack.number().optional(),
      'weight': Ack.number().optional(),
      'grade': Ack.number().optional(),
      'opticalSize': Ack.number().optional(),
      'shadows': Ack.list(catalog.shadow).optional(),
      'textDirection': catalog.textDirection.optional(),
      'applyTextScaling': Ack.boolean().optional(),
      'fill': Ack.number().optional(),
      'semanticsLabel': Ack.string().optional(),
      'opacity': Ack.number()
          .refine(
            (value) => value >= 0 && value <= 1,
            message: 'Must be in [0, 1].',
          )
          .optional(),
      'blendMode': catalog.blendMode.optional(),
    },
    build: _decodeIconStyler,
    encodeFields: encodeIconFields,
  );
}

IconStyler _decodeIconStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<IconSpec>>? variants,
}) {
  return IconStyler(
    color: data['color'] as Color?,
    size: castDoubleOrNull(data['size']),
    weight: castDoubleOrNull(data['weight']),
    grade: castDoubleOrNull(data['grade']),
    opticalSize: castDoubleOrNull(data['opticalSize']),
    shadows: castListOrNull(data['shadows']),
    textDirection: data['textDirection'] as TextDirection?,
    applyTextScaling: data['applyTextScaling'] as bool?,
    fill: castDoubleOrNull(data['fill']),
    semanticsLabel: data['semanticsLabel'] as String?,
    opacity: castDoubleOrNull(data['opacity']),
    blendMode: data['blendMode'] as BlendMode?,
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}

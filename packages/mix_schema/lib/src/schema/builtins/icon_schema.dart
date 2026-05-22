import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../shared/shared_schemas.dart';
import '../styler_catalog.dart';
import '../styler_definition.dart';

StylerContract<IconSpec, IconStyler> buildIconStylerDefinition(
  StylerCatalog catalog,
) {
  return buildStylerCodecContract(
    catalog: catalog,
    type: .icon,
    emptyStyle: IconStyler(),
    fields: {
      'icon': catalog.iconDataCodec.optional(),
      'color': colorCodec.optional(),
      'size': doubleFromNum().optional(),
      'weight': doubleFromNum().optional(),
      'grade': doubleFromNum().optional(),
      'opticalSize': doubleFromNum().optional(),
      'shadows': Ack.list(shadowCodec).optional(),
      'textDirection': textDirectionSchema.optional(),
      'applyTextScaling': Ack.boolean().optional(),
      'fill': doubleFromNum().optional(),
      'semanticsLabel': Ack.string().optional(),
      'opacity': doubleFromNum()
          .refine(
            (value) => value >= 0 && value <= 1,
            message: 'Must be in [0, 1].',
          )
          .optional(),
      'blendMode': blendModeSchema.optional(),
    },
    build: _decodeIconStyler,
    encodeFields: _encodeIconFields,
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
    size: data['size'] as double?,
    weight: data['weight'] as double?,
    grade: data['grade'] as double?,
    opticalSize: data['opticalSize'] as double?,
    shadows: castListOrNull(data['shadows']),
    textDirection: data['textDirection'] as TextDirection?,
    applyTextScaling: data['applyTextScaling'] as bool?,
    fill: data['fill'] as double?,
    semanticsLabel: data['semanticsLabel'] as String?,
    opacity: data['opacity'] as double?,
    blendMode: data['blendMode'] as BlendMode?,
    icon: data['icon'] as IconData?,
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}

JsonMap _encodeIconFields(IconStyler value) {
  final ShadowListMix? shadows = directPropMix(value.$shadows);

  return optionalJsonMap([
    ('icon', directPropValue(value.$icon)),
    ('color', directPropValue(value.$color)),
    ('size', directPropValue(value.$size)),
    ('weight', directPropValue(value.$weight)),
    ('grade', directPropValue(value.$grade)),
    ('opticalSize', directPropValue(value.$opticalSize)),
    ('shadows', shadows?.items),
    ('textDirection', directPropValue(value.$textDirection)),
    ('applyTextScaling', directPropValue(value.$applyTextScaling)),
    ('fill', directPropValue(value.$fill)),
    ('semanticsLabel', directPropValue(value.$semanticsLabel)),
    ('opacity', directPropValue(value.$opacity)),
    ('blendMode', directPropValue(value.$blendMode)),
  ]);
}

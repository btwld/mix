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
  final ShadowListMix? shadows = propMix(value.$shadows);

  return optionalJsonMap([
    ('icon', propValue(value.$icon)),
    ('color', propValue(value.$color)),
    ('size', propValue(value.$size)),
    ('weight', propValue(value.$weight)),
    ('grade', propValue(value.$grade)),
    ('opticalSize', propValue(value.$opticalSize)),
    ('shadows', shadows?.items),
    ('textDirection', propValue(value.$textDirection)),
    ('applyTextScaling', propValue(value.$applyTextScaling)),
    ('fill', propValue(value.$fill)),
    ('semanticsLabel', propValue(value.$semanticsLabel)),
    ('opacity', propValue(value.$opacity)),
    ('blendMode', propValue(value.$blendMode)),
  ]);
}

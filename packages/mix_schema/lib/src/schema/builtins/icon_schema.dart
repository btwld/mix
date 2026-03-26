import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/json_casts.dart';
import '../../errors/schema_transform_exceptions.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

final AckSchema<Object> _unsupportedIconValueSchema = Ack.anyOf([
  Ack.integer(),
  Ack.string(),
]).transform<Object>((value) => value);

StylerDefinition<IconSpec, IconStyler> buildIconStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .icon,
    emptyStyle: IconStyler(),
    fields: {
      'color': catalog.color.optional(),
      'size': Ack.double().optional(),
      'weight': Ack.double().optional(),
      'grade': Ack.double().optional(),
      'opticalSize': Ack.double().optional(),
      'shadows': Ack.list(catalog.shadow).optional(),
      'textDirection': catalog.textDirection.optional(),
      'applyTextScaling': Ack.boolean().optional(),
      'fill': Ack.double().optional(),
      'semanticsLabel': Ack.string().optional(),
      'opacity': Ack.double().min(0).max(1).optional(),
      'blendMode': catalog.blendMode.optional(),
      'icon': _unsupportedIconValueSchema.optional(),
    },
    build: (data, {animation, modifier, variants}) {
      if (data.containsKey('icon') && data['icon'] != null) {
        throw const UnsupportedValueError(
          'IconStyler.icon is not representable in mix_schema v1.',
        );
      }

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
        animation: animation,
        modifier: modifier,
        variants: variants,
      );
    },
  );
}

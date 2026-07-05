import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../registry/registry.dart';
import '../registry/registry_value_codec.dart';
import 'animation_codec.dart';
import 'common_codecs.dart';
import 'modifier_codec.dart';

AckSchema<JsonMap, ImageStyler> imageStylerCodec({
  required FrozenRegistry Function() registry,
}) {
  return Ack.object({
    'image': registryValueCodecFrom<ImageProvider<Object>>(
      registry,
      MixSchemaScope.imageProvider,
    ).optional(),
    'width': numberAsDoubleCodec().optional(),
    'height': numberAsDoubleCodec().optional(),
    'color': colorCodec().optional(),
    'repeat': enumNameCodec(ImageRepeat.values).optional(),
    'fit': enumNameCodec(BoxFit.values).optional(),
    'alignment': alignmentCodec().optional(),
    'filterQuality': enumNameCodec(FilterQuality.values).optional(),
    'colorBlendMode': enumNameCodec(BlendMode.values).optional(),
    'semanticLabel': Ack.string().optional(),
    'excludeFromSemantics': Ack.boolean().optional(),
    'gaplessPlayback': Ack.boolean().optional(),
    'isAntiAlias': Ack.boolean().optional(),
    'matchTextDirection': Ack.boolean().optional(),
    'modifiers': modifierConfigCodec().optional(),
    'animation': animationConfigCodec(registry: registry).optional(),
  }).codec<ImageStyler>(
    decode: (data) => ImageStyler(
      image: data['image'] as ImageProvider<Object>?,
      width: data['width'] as double?,
      height: data['height'] as double?,
      color: data['color'] as Color?,
      repeat: data['repeat'] as ImageRepeat?,
      fit: data['fit'] as BoxFit?,
      alignment: data['alignment'] as Alignment?,
      filterQuality: data['filterQuality'] as FilterQuality?,
      colorBlendMode: data['colorBlendMode'] as BlendMode?,
      semanticLabel: data['semanticLabel'] as String?,
      excludeFromSemantics: data['excludeFromSemantics'] as bool?,
      gaplessPlayback: data['gaplessPlayback'] as bool?,
      isAntiAlias: data['isAntiAlias'] as bool?,
      matchTextDirection: data['matchTextDirection'] as bool?,
      modifier: data['modifiers'] as WidgetModifierConfig?,
      animation: data['animation'] as AnimationConfig?,
    ),
    encode: _encodeImageStyler,
  );
}

JsonMap _encodeImageStyler(ImageStyler value) {
  failIfPresent(value.$variants, 'variants');
  failIfPresent(value.$centerSlice, 'centerSlice');

  return {
    'image': singleValueProp(value.$image, 'image'),
    'width': singleValueProp(value.$width, 'width'),
    'height': singleValueProp(value.$height, 'height'),
    'color': singleValueProp(value.$color, 'color'),
    'repeat': singleValueProp(value.$repeat, 'repeat'),
    'fit': singleValueProp(value.$fit, 'fit'),
    'alignment': singleAlignmentProp(value.$alignment, 'alignment'),
    'filterQuality': singleValueProp(value.$filterQuality, 'filterQuality'),
    'colorBlendMode': singleValueProp(value.$colorBlendMode, 'colorBlendMode'),
    'semanticLabel': singleValueProp(value.$semanticLabel, 'semanticLabel'),
    'excludeFromSemantics': singleValueProp(
      value.$excludeFromSemantics,
      'excludeFromSemantics',
    ),
    'gaplessPlayback': singleValueProp(
      value.$gaplessPlayback,
      'gaplessPlayback',
    ),
    'isAntiAlias': singleValueProp(value.$isAntiAlias, 'isAntiAlias'),
    'matchTextDirection': singleValueProp(
      value.$matchTextDirection,
      'matchTextDirection',
    ),
    'modifiers': value.$modifier,
    'animation': value.$animation,
  };
}

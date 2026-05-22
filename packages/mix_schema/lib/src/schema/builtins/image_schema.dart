import 'package:ack/ack.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/numeric_codecs.dart';
import '../../core/prop_encode.dart';
import '../shared/shared_schemas.dart';
import '../styler_catalog.dart';
import '../styler_definition.dart';

StylerContract<ImageSpec, ImageStyler> buildImageStylerDefinition(
  StylerCatalog catalog,
) {
  final fields = <String, AckSchema<Object, Object>>{
    'image': catalog.imageProviderCodec,
    'width': doubleFromNum().optional(),
    'height': doubleFromNum().optional(),
    'color': colorCodec.optional(),
    'repeat': imageRepeatSchema.optional(),
    'fit': boxFitSchema.optional(),
    'alignment': alignmentCodec.optional(),
    'centerSlice': rectCodec.optional(),
    'filterQuality': filterQualitySchema.optional(),
    'colorBlendMode': blendModeSchema.optional(),
    'semanticLabel': Ack.string().optional(),
    'excludeFromSemantics': Ack.boolean().optional(),
    'gaplessPlayback': Ack.boolean().optional(),
    'isAntiAlias': Ack.boolean().optional(),
    'matchTextDirection': Ack.boolean().optional(),
  };

  return buildStylerCodecContract(
    catalog: catalog,
    type: .image,
    emptyStyle: ImageStyler(),
    fields: fields,
    variantStyleFields: {
      ...fields,
      'image': catalog.imageProviderCodec.optional(),
    },
    build: _decodeImageStyler,
    encodeFields: _encodeRequiredImageFields,
    encodeVariantStyleFields: _encodeOptionalImageFields,
  );
}

ImageStyler _decodeImageStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<ImageSpec>>? variants,
}) {
  return ImageStyler(
    image: data['image'] as ImageProvider<Object>?,
    width: data['width'] as double?,
    height: data['height'] as double?,
    color: data['color'] as Color?,
    repeat: data['repeat'] as ImageRepeat?,
    fit: data['fit'] as BoxFit?,
    alignment: data['alignment'] as AlignmentGeometry?,
    centerSlice: data['centerSlice'] as Rect?,
    filterQuality: data['filterQuality'] as FilterQuality?,
    colorBlendMode: data['colorBlendMode'] as BlendMode?,
    semanticLabel: data['semanticLabel'] as String?,
    excludeFromSemantics: data['excludeFromSemantics'] as bool?,
    gaplessPlayback: data['gaplessPlayback'] as bool?,
    isAntiAlias: data['isAntiAlias'] as bool?,
    matchTextDirection: data['matchTextDirection'] as bool?,
    animation: animation,
    modifier: modifier,
    variants: variants,
  );
}

JsonMap _encodeRequiredImageFields(ImageStyler value) {
  return {
    'image': requiredDirectPropValue(value.$image, 'image'),
    ..._encodeOptionalImageFields(value),
  };
}

JsonMap _encodeOptionalImageFields(ImageStyler value) {
  return {
    ...optionalJsonMap([
      ('image', directPropValue(value.$image)),
      ('width', directPropValue(value.$width)),
      ('height', directPropValue(value.$height)),
      ('color', directPropValue(value.$color)),
      ('repeat', directPropValue(value.$repeat)),
      ('fit', directPropValue(value.$fit)),
      ('alignment', directPropValue(value.$alignment)),
      ('centerSlice', directPropValue(value.$centerSlice)),
      ('filterQuality', directPropValue(value.$filterQuality)),
      ('colorBlendMode', directPropValue(value.$colorBlendMode)),
      ('semanticLabel', directPropValue(value.$semanticLabel)),
      ('excludeFromSemantics', directPropValue(value.$excludeFromSemantics)),
      ('gaplessPlayback', directPropValue(value.$gaplessPlayback)),
      ('isAntiAlias', directPropValue(value.$isAntiAlias)),
      ('matchTextDirection', directPropValue(value.$matchTextDirection)),
    ]),
  };
}

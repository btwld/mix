import 'package:ack/ack.dart';
import 'package:flutter/foundation.dart';
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
  return buildStylerCodecContract(
    catalog: catalog,
    type: .image,
    emptyStyle: ImageStyler(image: _TransparentImageProvider.instance),
    fields: {
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
    },
    build: _decodeImageStyler,
    encodeFields: _encodeImageFields,
  );
}

ImageStyler _decodeImageStyler(
  JsonMap data, {
  AnimationConfig? animation,
  WidgetModifierConfig? modifier,
  List<VariantStyle<ImageSpec>>? variants,
}) {
  return ImageStyler(
    image: data['image']! as ImageProvider<Object>,
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

JsonMap _encodeImageFields(ImageStyler value) {
  return {
    'image': requiredPropValue(value.$image, 'image'),
    ...optionalJsonMap([
      ('width', propValue(value.$width)),
      ('height', propValue(value.$height)),
      ('color', propValue(value.$color)),
      ('repeat', propValue(value.$repeat)),
      ('fit', propValue(value.$fit)),
      ('alignment', propValue(value.$alignment)),
      ('centerSlice', propValue(value.$centerSlice)),
      ('filterQuality', propValue(value.$filterQuality)),
      ('colorBlendMode', propValue(value.$colorBlendMode)),
      ('semanticLabel', propValue(value.$semanticLabel)),
      ('excludeFromSemantics', propValue(value.$excludeFromSemantics)),
      ('gaplessPlayback', propValue(value.$gaplessPlayback)),
      ('isAntiAlias', propValue(value.$isAntiAlias)),
      ('matchTextDirection', propValue(value.$matchTextDirection)),
    ]),
  };
}

final class _TransparentImageProvider
    extends ImageProvider<_TransparentImageProvider> {
  static const _TransparentImageProvider instance =
      _TransparentImageProvider._();

  const _TransparentImageProvider._();

  @override
  Future<_TransparentImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _TransparentImageProvider key,
    ImageDecoderCallback decode,
  ) {
    throw UnimplementedError('Placeholder image provider should never load.');
  }
}

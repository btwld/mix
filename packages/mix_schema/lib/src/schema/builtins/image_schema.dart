import 'package:ack/ack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/mix_schema_scope.dart';
import '../mix_schema_catalog.dart';
import '../styler_definition.dart';

StylerDefinition<ImageSpec, ImageStyler> buildImageStylerDefinition(
  MixSchemaCatalog catalog,
) {
  return StylerDefinition(
    type: .image,
    emptyStyle: ImageStyler(image: _TransparentImageProvider.instance),
    fields: {
      'image': Ack.string(),
      'width': Ack.double().optional(),
      'height': Ack.double().optional(),
      'color': catalog.color.optional(),
      'repeat': catalog.imageRepeat.optional(),
      'fit': catalog.boxFit.optional(),
      'alignment': catalog.alignment.optional(),
      'centerSlice': catalog.rect.optional(),
      'filterQuality': catalog.filterQuality.optional(),
      'colorBlendMode': catalog.blendMode.optional(),
      'semanticLabel': Ack.string().optional(),
      'excludeFromSemantics': Ack.boolean().optional(),
      'gaplessPlayback': Ack.boolean().optional(),
      'isAntiAlias': Ack.boolean().optional(),
      'matchTextDirection': Ack.boolean().optional(),
    },
    build: (data, {animation, modifier, variants}) {
      return ImageStyler(
        image: catalog.registries.lookup(
          MixSchemaScope.imageProvider.wireValue,
          data['image'] as String,
        ),
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
    },
  );
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

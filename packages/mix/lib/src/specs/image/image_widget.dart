import 'package:flutter/widgets.dart';

import '../../core/style_widget.dart';
import 'image_spec.dart';

class StyledImage extends StyleWidget<ImageSpec> {
  const StyledImage({
    super.key,
    super.style,

    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.image,
    this.opacity,
  });

  final ImageProvider<Object>? image;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context, ImageSpec? spec) {
    final imageProvider = _resolveImage(image, spec);
    
    return Image(
      image: imageProvider,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: spec?.semanticLabel,
      excludeFromSemantics: spec?.excludeFromSemantics ?? false,
      width: spec?.width,
      height: spec?.height,
      color: spec?.color,
      opacity: opacity,
      colorBlendMode: spec?.colorBlendMode,
      fit: spec?.fit,
      alignment: spec?.alignment ?? Alignment.center,
      repeat: spec?.repeat ?? ImageRepeat.noRepeat,
      centerSlice: spec?.centerSlice,
      matchTextDirection: spec?.matchTextDirection ?? false,
      gaplessPlayback: spec?.gaplessPlayback ?? false,
      isAntiAlias: spec?.isAntiAlias ?? false,
      filterQuality: spec?.filterQuality ?? FilterQuality.medium,
    );
  }
}

ImageProvider<Object> _resolveImage(ImageProvider<Object>? widgetImage, ImageSpec? spec) {
  final imageProvider = widgetImage ?? spec?.image;
  
  if (imageProvider == null) {
    throw FlutterError.fromParts([
      ErrorSummary('No ImageProvider found for StyledImage.'),
      ErrorDescription(
        'StyledImage requires an ImageProvider to be specified either through '
        'the widget\'s image parameter or through the style\'s image property.',
      ),
      ErrorHint(
        'To fix this, either:\n'
        '  - Pass an image parameter when creating the StyledImage\n'
        '  - Include an image property in your ImageMix style',
      ),
    ]);
  }
  
  return imageProvider;
}

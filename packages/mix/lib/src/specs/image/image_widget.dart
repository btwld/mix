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
    return Image(
      image: image!,
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

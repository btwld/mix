import 'package:flutter/widgets.dart';

import '../../core/styled_widget.dart';
import 'image_spec.dart';
import 'image_style.dart';

class StyledImage extends StyleWidget<ImageSpec> {
  const StyledImage({
    super.key,
    super.style = const ImageStyle(),

    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    required this.image,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.matchTextDirection = false,
    this.opacity,
    super.orderOfModifiers,
  });

  final ImageProvider<Object> image;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final bool matchTextDirection;
  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context, ImageSpec spec) {
    return Image(
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: spec.width,
      height: spec.height,
      color: spec.color,
      opacity: opacity,
      colorBlendMode: spec.colorBlendMode ?? BlendMode.clear,
      fit: spec.fit,
      alignment: spec.alignment ?? Alignment.center,
      repeat: spec.repeat ?? ImageRepeat.noRepeat,
      centerSlice: spec.centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: spec.filterQuality ?? FilterQuality.low,
    );
  }
}

import 'package:flutter/widgets.dart';

import '../../core/animated_spec_widget.dart';
import '../../core/spec_widget.dart';
import '../../core/styled_widget.dart';
import '../../internal/constants.dart';
import '../../modifiers/internal/render_widget_modifier.dart';
import 'image_spec.dart';

class StyledImage extends StyledWidget {
  const StyledImage({
    super.key,
    super.style,
    super.inherit = true,
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
    super.orderOfModifiers = const [],
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
  Widget build(BuildContext context) {
    return withMix(context, (context) {
      final spec = ImageSpec.of(context);

      return spec(
        image: image,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        matchTextDirection: matchTextDirection,
        opacity: opacity,
        orderOfModifiers: orderOfModifiers,
      );
    });
  }
}

class ImageSpecWidget extends SpecWidget<ImageSpec> {
  const ImageSpecWidget({
    super.key,
    this.orderOfModifiers = const [],
    super.spec,
    required this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.opacity,
    this.matchTextDirection = false,
  });

  final ImageProvider<Object> image;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final List<Type> orderOfModifiers;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final bool matchTextDirection;
  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context) {
    return RenderSpecModifiers(
      spec: spec ?? const ImageSpec(),
      orderOfModifiers: orderOfModifiers,
      child: Image(
        image: image,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        width: spec?.width,
        height: spec?.height,
        color: spec?.color,
        opacity: opacity,
        colorBlendMode: spec?.colorBlendMode ?? BlendMode.clear,
        fit: spec?.fit,
        alignment: spec?.alignment ?? Alignment.center,
        repeat: spec?.repeat ?? ImageRepeat.noRepeat,
        centerSlice: spec?.centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        filterQuality: spec?.filterQuality ?? FilterQuality.low,
      ),
    );
  }
}

class AnimatedImageSpecWidget extends ImplicitlyAnimatedSpecWidget<ImageSpec> {
  const AnimatedImageSpecWidget({
    required super.spec,
    required this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    super.key,
    super.duration = kDefaultAnimationDuration,
    super.curve = Curves.linear,
    super.onEnd,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.matchTextDirection = false,
    this.orderOfModifiers = const [],
    this.opacity,
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
  final List<Type> orderOfModifiers;

  @override
  Widget build(BuildContext context, ImageSpec animatedSpec) {
    return ImageSpecWidget(
      spec: animatedSpec,
      orderOfModifiers: orderOfModifiers,
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      opacity: opacity,
      matchTextDirection: matchTextDirection,
    );
  }
}

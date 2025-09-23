import 'package:flutter/widgets.dart';

import '../../core/style_builder.dart';
import '../../core/style_spec.dart';
import '../../core/style_widget.dart';
import 'image_spec.dart';
import 'image_style.dart';

/// A styled image widget using Mix framework.
///
/// Applies [ImageSpec] styling to create a customized [Image].
class StyledImage extends StyleWidget<ImageSpec> {
  const StyledImage({
    super.key,
    super.style = const ImageStyler.create(),
    super.spec,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.image,
    this.opacity,
  });

  /// Builder pattern for `StyleSpec<ImageSpec>` with custom builder function.
  static Widget builder(
    StyleSpec<ImageSpec> styleSpec,
    Widget Function(BuildContext context, ImageSpec spec) builder,
  ) {
    return StyleSpecBuilder<ImageSpec>(builder: builder, styleSpec: styleSpec);
  }

  /// The image to display.
  final ImageProvider<Object>? image;

  /// Builder for custom frame rendering.
  final ImageFrameBuilder? frameBuilder;

  /// Builder for loading state.
  final ImageLoadingBuilder? loadingBuilder;

  /// Builder for error state.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Animation for opacity changes.
  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context, ImageSpec spec) {
    final imageProvider = _resolveImage(image, spec);

    return Image(
      image: imageProvider,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: spec.semanticLabel,
      excludeFromSemantics: spec.excludeFromSemantics ?? false,
      width: spec.width,
      height: spec.height,
      color: spec.color,
      opacity: opacity,
      colorBlendMode: spec.colorBlendMode,
      fit: spec.fit,
      alignment: spec.alignment ?? Alignment.center,
      repeat: spec.repeat ?? ImageRepeat.noRepeat,
      centerSlice: spec.centerSlice,
      matchTextDirection: spec.matchTextDirection ?? false,
      gaplessPlayback: spec.gaplessPlayback ?? false,
      isAntiAlias: spec.isAntiAlias ?? false,
      filterQuality: spec.filterQuality ?? FilterQuality.medium,
    );
  }
}

/// Resolves the image provider from widget or spec.
/// Throws if no image provider is found.
ImageProvider<Object> _resolveImage(
  ImageProvider<Object>? widgetImage,
  ImageSpec spec,
) {
  final imageProvider = widgetImage ?? spec.image;

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

/// Extension to convert [ImageSpec] directly to a [StyledImage] widget.
extension ImageSpecWidget on ImageSpec {
  /// Creates a [StyledImage] widget from this [ImageSpec].
  @Deprecated(
    'Use StyledImage(spec: this, image: image, frameBuilder: frameBuilder, loadingBuilder: loadingBuilder, errorBuilder: errorBuilder, opacity: opacity) instead',
  )
  Widget createWidget({
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage(
      spec: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      image: image,
      opacity: opacity,
    );
  }

  @Deprecated(
    'Use StyledImage(spec: this, image: image, frameBuilder: frameBuilder, loadingBuilder: loadingBuilder, errorBuilder: errorBuilder, opacity: opacity) instead',
  )
  Widget call({
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return createWidget(
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}

extension ImageSpecWrappedWidget on StyleSpec<ImageSpec> {
  /// Creates a widget that resolves this [StyleSpec<ImageSpec>] with context.
  @Deprecated(
    'Use StyledImage.builder(styleSpec, builder) for custom logic, or styleSpec(image: image, frameBuilder: frameBuilder, loadingBuilder: loadingBuilder, errorBuilder: errorBuilder, opacity: opacity) for simple cases',
  )
  Widget createWidget({
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage.builder(this, (context, spec) {
      return StyledImage(
        spec: spec,
        frameBuilder: frameBuilder,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        image: image,
        opacity: opacity,
      );
    });
  }

  /// Convenient shorthand for creating a StyledImage widget with this StyleSpec.
  Widget call({
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return createWidget(
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class HeroImage extends StatelessWidget {
  final ImageProvider? image;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Animation<double>? opacity;

  const HeroImage({
    super.key,
    this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return const StyledImageBuilder().build(
      heroImageStyle,
      key: key,
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}

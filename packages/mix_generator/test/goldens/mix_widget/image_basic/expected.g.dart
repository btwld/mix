// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'input.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class HeroImage extends StatelessWidget {
  const HeroImage({
    super.key,
    this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.opacity,
  });

  final ImageProvider? image;

  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final Animation<double>? opacity;

  @override
  Widget build(BuildContext context) {
    return StyledImage(
      key: key,
      style: heroImageStyle,
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}

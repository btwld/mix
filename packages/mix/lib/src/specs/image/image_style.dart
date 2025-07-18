import '../../core/factory/style_mix.dart';
import 'image_spec.dart';

class ImageStyle extends Style<ImageSpec> {
  @override
  final ImageSpecAttribute attribute;

  const ImageStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates an empty ImageStyle
  const ImageStyle() : attribute = const ImageSpecAttribute.props();

  /// Creates an ImageStyle with the given attribute
  ImageStyle withAttribute(ImageSpecAttribute attribute) {
    return ImageStyle._(
      attribute: attribute,
      variants: variants,
      animation: animation,
      modifiers: modifiers,
    );
  }

  @override
  ImageStyle merge(ImageStyle? other) {
    return ImageStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

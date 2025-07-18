import '../../core/factory/style_mix.dart';
import 'icon_spec.dart';

class IconStyle extends StyleElement<IconSpec> {
  @override
  final IconSpecAttribute attribute;

  const IconStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates an empty IconStyle
  const IconStyle() : attribute = const IconSpecAttribute.props();

  /// Creates an IconStyle with the given attribute
  IconStyle withAttribute(IconSpecAttribute attribute) {
    return IconStyle._(
      attribute: attribute,
      variants: variants,
      animation: animation,
      modifiers: modifiers,
    );
  }

  @override
  IconStyle merge(IconStyle? other) {
    return IconStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

import '../../core/factory/style_mix.dart';
import 'text_spec.dart';

class TextStyling extends StyleElement<TextSpec> {
  @override
  final TextSpecAttribute attribute;

  const TextStyling._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates an empty TextStyle
  const TextStyling() : attribute = const TextSpecAttribute.props();

  /// Creates a TextStyle with the given attribute
  TextStyling withAttribute(TextSpecAttribute attribute) {
    return TextStyling._(
      attribute: attribute,
      variants: variants,
      animation: animation,
      modifiers: modifiers,
    );
  }

  @override
  TextStyling merge(TextStyling? other) {
    return TextStyling._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

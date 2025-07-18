import '../../core/factory/style_mix.dart';
import 'flexbox_spec.dart';

class FlexBoxStyle extends Style<FlexBoxSpec> {
  @override
  final FlexBoxSpecAttribute attribute;

  const FlexBoxStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates an empty FlexBoxStyle
  const FlexBoxStyle() : attribute = const FlexBoxSpecAttribute();

  /// Creates a FlexBoxStyle with the given attribute
  FlexBoxStyle withAttribute(FlexBoxSpecAttribute attribute) {
    return FlexBoxStyle._(
      attribute: attribute,
      variants: variants,
      animation: animation,
      modifiers: modifiers,
    );
  }

  @override
  FlexBoxStyle merge(FlexBoxStyle? other) {
    return FlexBoxStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

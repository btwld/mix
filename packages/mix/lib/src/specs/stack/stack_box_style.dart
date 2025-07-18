import '../../core/factory/style_mix.dart';
import 'stack_box_spec.dart';

class StackBoxStyle extends Style<StackBoxSpec> {
  @override
  final StackBoxSpecAttribute attribute;

  const StackBoxStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates an empty StackBoxStyle
  const StackBoxStyle() : attribute = const StackBoxSpecAttribute();

  /// Creates a StackBoxStyle with the given attribute
  StackBoxStyle withAttribute(StackBoxSpecAttribute attribute) {
    return StackBoxStyle._(
      attribute: attribute,
      variants: variants,
      animation: animation,
      modifiers: modifiers,
    );
  }

  @override
  StackBoxStyle merge(StackBoxStyle? other) {
    return StackBoxStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

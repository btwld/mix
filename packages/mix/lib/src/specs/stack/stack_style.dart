import '../../core/factory/style_mix.dart';
import 'stack_spec.dart';

class StackStyle extends StyleElement<StackSpec> {
  @override
  final StackSpecAttribute attribute;

  const StackStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates a StackStyle with the given attribute for testing and overrides
  const StackStyle.override({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  @override
  StackStyle merge(StackStyle? other) {
    return StackStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

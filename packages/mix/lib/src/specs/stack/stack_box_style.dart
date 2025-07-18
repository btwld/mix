import '../../core/factory/style_mix.dart';
import 'stack_box_spec.dart';

class ZBoxStyle extends Style<ZBoxSpec> {
  @override
  final StackBoxSpecAttribute attribute;

  const ZBoxStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  /// Creates an empty StackBoxStyle
  const ZBoxStyle() : attribute = const StackBoxSpecAttribute();

  /// Creates a StackBoxStyle with the given attribute
  @override
  ZBoxStyle withAttribute(StackBoxSpecAttribute attribute) {
    return ZBoxStyle._(
      attribute: attribute,
      variants: variants,
      animation: animation,
      modifiers: modifiers,
    );
  }

  @override
  ZBoxStyle merge(ZBoxStyle? other) {
    return ZBoxStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

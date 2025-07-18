import '../../core/factory/style_mix.dart';
import 'box_spec.dart';

class BoxStyle extends StyleElement<BoxSpec> {
  @override
  final BoxSpecAttribute attribute;

  const BoxStyle._({
    required this.attribute,
    super.variants,
    super.animation,
    super.modifiers,
  });

  @override
  BoxStyle merge(BoxStyle? other) {
    return BoxStyle._(
      attribute: attribute.merge(other?.attribute),
      variants: mergeVariantLists(variants, other?.variants),
      animation: other?.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

import '../../core/mix_element.dart';
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
      animation: animation ?? other?.animation,
      modifiers: mergeModifierLists(modifiers, other?.modifiers),
    );
  }

  @override
  List<Object?> get props => [attribute, variants, animation, modifiers];
}

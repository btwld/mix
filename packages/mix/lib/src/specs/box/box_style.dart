import '../../core/factory/style_mix.dart';
import 'box_spec.dart';

class BoxStyle extends Style<BoxSpec> {
  @override
  final BoxSpecAttribute attribute;

  const BoxStyle()
    : attribute = const BoxSpecAttribute.props(),
      super(variants: const [], animation: null, modifiers: const []);

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

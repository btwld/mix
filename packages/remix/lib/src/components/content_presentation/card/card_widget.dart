part of 'card.dart';

class Card extends StatelessWidget {
  const Card({
    super.key,
    required this.child,
    this.style,
    this.variants = const [],
  });

  /// The list of child widgets to be displayed inside the card.
  final Widget child;

  /// {@macro remix.component.style}
  final CardStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? context.remix.components.card;

    final configuration = SpecConfiguration(context, CardSpecUtility.self);

    return SpecBuilder(
      style: style.makeStyle(configuration).applyVariants(variants),
      builder: (context) {
        final spec = CardSpec.of(context);

        return spec.container(child: child);
      },
    );
  }
}

part of 'card.dart';

class RxCard extends StatelessWidget {
  const RxCard({
    super.key,
    required this.child,
    this.style,
    this.variants = const [],
  });

  /// The list of child widgets to be displayed inside the card.
  final Widget child;

  /// {@macro remix.component.style}
  final RxCardStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  RxCardStyle get _style =>
      RxCardStyle._default().merge(style ?? RxCardStyle());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: _style,
      builder: (context) {
        final spec = CardSpec.of(context);

        return spec.container(child: child);
      },
    );
  }
}

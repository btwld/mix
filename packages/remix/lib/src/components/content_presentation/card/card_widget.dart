part of 'card.dart';

/// A card component that displays a single child widget with customizable style and variants.
///
/// The [RxCard] is a flexible widget that can be used to encapsulate content within a styled container.
/// It supports various configurations such as applying style variants and custom styles to modify its appearance.
///
/// {@macro remix.component}
///
/// ## Example
///
/// ```dart
/// RxCard(
///   child: Text('Hello, World!'),
///   style: RxCardStyle(),
///   variants: [Variant.primary],
/// )
/// ```
///
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
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = CardSpec.of(context);

        return spec.container(child: child);
      },
    );
  }
}

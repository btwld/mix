part of 'callout.dart';

/// The [RxCallout] widget is used to display a message with an optional icon.
/// It can be customized using the [variants] and [style] parameters to fit different design needs.
///
/// ## Example
///
/// ```dart
/// RxCallout(
///   text: 'This is a callout message!',
///   icon: Icons.info,
///   variants: [Variant.warning],
///   style: RxCalloutStyle(),
/// )
/// ```
///
class RxCallout extends StatelessWidget {
  RxCallout({
    super.key,
    IconData? icon,
    required String text,
    this.variants = const [],
    this.style,
  }) : child = RxLabel(text, icon: icon);

  /// This constructor allows for more advanced customization by directly providing a [child] widget.
  const RxCallout.raw({
    super.key,
    this.variants = const [],
    this.style,
    required this.child,
  });

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final RxCalloutStyle? style;

  final Widget child;

  RxCalloutStyle get _style =>
      RxCalloutStyle._default().merge(style ?? RxCalloutStyle());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = CalloutSpec.of(context);

        return IconTheme(
          data: spec.icon,
          child: DefaultTextStyle(
            style: spec.textStyle,
            child: spec.container.box(child: child),
          ),
        );
      },
    );
  }
}

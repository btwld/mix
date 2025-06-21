part of 'label.dart';

enum IconPosition {
  start,
  end,
}

/// A customizable label component that supports icons and styling.
///
/// The [RxLabel] widget is designed to display text with optional icons.
/// It integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxLabel(
///   'Hello World',
///   icon: Icons.star,
///   variants: [Variant.primary],
///   style: RxLabelStyle(),
/// )
/// ```
class RxLabel extends StatelessWidget {
  /// Creates a Remix label.
  ///
  /// The [label] parameter is required.
  /// Other parameters allow customizing the label's appearance.
  const RxLabel(
    this.label, {
    super.key,
    this.icon,
    this.variants = const [],
    this.style,
    this.iconPosition = IconPosition.start,
  });

  /// The text to display in the label.
  final String label;

  /// Optional icon to display alongside the text.
  final IconData? icon;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  final IconPosition iconPosition;

  /// {@macro remix.component.style}
  final RxLabelStyle? style;

  RxLabelStyle get _style => RxLabelStyle().merge(style ?? RxLabelStyle());

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: Style(_style).applyVariants(variants),
      builder: (context) {
        final spec = LabelSpec.of(context);

        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spec.spacing,
          children: [
            if (icon != null && iconPosition == IconPosition.start)
              spec.icon(icon),
            spec.label(label),
            if (icon != null && iconPosition == IconPosition.end)
              spec.icon(icon),
          ],
        );
      },
    );
  }
}

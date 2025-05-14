part of 'label.dart';

/// A customizable label component that supports icons and styling.
/// The label integrates with the Mix styling system and follows Remix design patterns.
///
/// Example:
/// ```dart
/// RxLabel(
///   label: 'Hello',
///   icon: Icons.star,
///   style: LabelStyle(),
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
    required this.icon,
    this.style = const LabelStyle(),
  });

  /// The text to display in the label
  final String label;

  /// Optional icon to display above the text
  final IconData? icon;

  /// The style configuration for the label.
  ///
  /// Controls visual properties like colors, spacing, typography etc.
  final LabelStyle style;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      style: style.makeStyle(SpecConfiguration(context, LabelSpecUtility.self)),
      builder: (context) {
        final spec = LabelSpec.of(context);

        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spec.spacing,
          children: [
            if (icon != null) spec.icon(icon),
            spec.label(label),
          ],
        );
      },
    );
  }
}

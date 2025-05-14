part of '../segmented_control.dart';

/// A button widget used within [SegmentedControl] to represent a single segment.
///
/// The [SegmentButton] is designed to be used as a child of [SegmentedControl] and
/// represents one selectable segment within the control. It can display an optional
/// icon and/or text label.
///
/// The button's appearance are controlled by the [SegmentedControlSpec]
/// provided by the parent [SegmentedControl]. This includes styling for the container,
/// flex layout, icon, and text label.
///
/// Example usage:
/// ```dart
/// SegmentedControl(
///   buttons: [
///     SegmentButton(
///       icon: Icons.home,
///       text: 'Home',
///     ),
///     SegmentButton(
///       icon: Icons.settings,
///       text: 'Settings',
///     ),
///   ],
///   onIndexChanged: (index) {
///     // Handle segment selection
///   },
/// )
/// ```
class SegmentButton extends StatelessWidget {
  const SegmentButton({super.key, IconData? icon, this.text}) : iconData = icon;

  /// The icon data to display in the segment button.
  /// If null, no icon will be shown.
  final IconData? iconData;

  /// The text label to display in the segment button.
  /// If null, no text will be shown.
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
      inherit: true,
      builder: (context) {
        final item = SegmentedControlSpec.of(context).item;

        final container = item.container;
        final flex = item.flex;
        final icon = item.icon;
        final label = item.label;

        return container(
          child: flex(
            direction: Axis.horizontal,
            children: [
              if (iconData != null) icon(iconData),
              if (text != null) label(text!),
            ],
          ),
        );
      },
    );
  }
}

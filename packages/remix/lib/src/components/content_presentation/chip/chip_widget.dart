part of 'chip.dart';

/// A chip component that can be selected or deselected, with optional icons and a label.
///
/// The [RxChip] is a customizable widget that can be used to represent a choice or an action.
/// It supports various configurations such as enabling/disabling the chip, applying style variants,
/// and handling selection changes.
///
/// ## Example
///
/// ```dart
/// RxChip(
///   label: 'Option 1',
///   iconLeft: Icons.check,
///   selected: true,
///   onChanged: (bool isSelected) {
///     // Handle selection change
///   },
///   enabled: true,
///   variants: [Variant.primary],
///   style: RxChipStyle(),
/// )
/// ```
///
class RxChip extends StatefulWidget implements Disableable, Selectable {
  RxChip({
    super.key,
    this.selected = false,
    this.label,
    this.enabled = true,
    this.iconLeft,
    this.iconRight,
    this.variants = const [],
    this.focusNode,
    required this.onChanged,
    this.style,
  }) : child = _ChipBody(
          iconLeft: iconLeft,
          iconRight: iconRight,
          label: label,
        );

  /// Creates a Remix chip with custom content.
  ///
  /// This constructor allows for custom chip content beyond the default layout.
  ///
  /// Example:
  /// ```dart
  /// RxChip.raw(
  ///   child: Icon(Icons.star),
  ///   onChanged: (bool isSelected) {},
  ///   variants: [Variant.primary],
  ///   style: RxChipStyle(),
  /// )
  /// ```
  const RxChip.raw({
    super.key,
    this.selected = false,
    this.label,
    this.enabled = true,
    this.iconLeft,
    this.iconRight,
    this.variants = const [],
    this.focusNode,
    required this.child,
    required this.onChanged,
    this.style,
  });

  /// Whether the chip is selected or not.
  @override
  final bool selected;

  /// The child widget to display inside the chip.
  final Widget child;

  /// The text content displayed in the center of the component.
  final String? label;

  /// The icon displayed in the left side of the component.
  final IconData? iconLeft;

  /// The icon displayed in the right side of the component.
  final IconData? iconRight;

  /// {@macro remix.component.onChanged}
  final void Function(bool)? onChanged;

  /// {@macro remix.component.enabled}
  @override
  final bool enabled;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final RxChipStyle? style;

  /// {@macro remix.component.focusNode}
  final FocusNode? focusNode;

  @override
  State<RxChip> createState() => _RxChipState();
}

class _RxChipState extends State<RxChip>
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  RxChipStyle get _style =>
      RxChipStyle._default().merge(widget.style ?? RxChipStyle());

  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => widget.onChanged?.call(value ?? false),
      onHoverState: (state) {
        mixController.hovered = state;
      },
      onPressedState: (state) {
        mixController.pressed = state;
      },
      onFocusState: (state) {
        mixController.focused = state;
      },
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      child: RemixBuilder(
        builder: (context) {
          return widget.child;
        },
        style: Style(_style).applyVariants(widget.variants),
        controller: mixController,
      ),
    );
  }
}

class _ChipBody extends StatelessWidget {
  const _ChipBody({
    required this.iconLeft,
    required this.iconRight,
    required this.label,
  });

  final IconData? iconLeft;
  final IconData? iconRight;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final spec = ChipSpec.of(context);

    return spec.container(
      direction: Axis.horizontal,
      children: [
        if (iconLeft != null) spec.icon(iconLeft),
        if (label?.isNotEmpty == true) spec.label(label!),
        if (iconRight != null) spec.icon(iconRight),
      ],
    );
  }
}

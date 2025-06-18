part of 'chip.dart';

class RxChip extends StatefulWidget implements Disableable, Selectable {
  RxChip({
    super.key,
    this.selected = false,
    this.label,
    this.enabled = true,
    this.iconLeft,
    this.iconRight,
    this.variants = const [],
    required this.onChanged,
    this.style,
  }) : child = _ChipBody(
          iconLeft: iconLeft,
          iconRight: iconRight,
          label: label,
        );

  const RxChip.raw({
    super.key,
    this.selected = false,
    this.label,
    this.enabled = true,
    this.iconLeft,
    this.iconRight,
    this.variants = const [],
    required this.child,
    required this.onChanged,
    this.style,
  });

  /// Whether the chip is selected or not.
  @override
  final bool selected;

  final Widget child;

  /// The text content displayed in the center of the component.
  final String? label;

  /// The icon displayed in the left side of the component.
  final IconData? iconLeft;

  /// The icon displayed in the right side of the component.
  final IconData? iconRight;

  /// {@macro remix.component.onChanged}
  final void Function(bool)? onChanged;

  /// {@macro remix.component.disabled}
  @override
  final bool enabled;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final RxChipStyle? style;

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
      child: RemixBuilder(
        builder: (context) {
          return _ChipBody(
            iconLeft: widget.iconLeft,
            iconRight: widget.iconRight,
            label: widget.label,
          );
        },
        style: _style,
        mixController: mixController,
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

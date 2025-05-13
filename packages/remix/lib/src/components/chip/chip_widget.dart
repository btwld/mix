part of 'chip.dart';

class Chip extends StatefulWidget {
  const Chip({
    super.key,
    this.value = false,
    this.label,
    this.disabled = false,
    this.iconLeft,
    this.iconRight,
    this.variants = const [],
    required this.onChanged,
    this.style,
  });

  /// Whether the chip is selected or not.
  final bool value;

  /// The text content displayed in the center of the component.
  final String? label;

  /// The icon displayed in the left side of the component.
  final IconData? iconLeft;

  /// The icon displayed in the right side of the component.
  final IconData? iconRight;

  /// {@macro remix.component.onChanged}
  final void Function(bool)? onChanged;

  /// {@macro remix.component.disabled}
  final bool disabled;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro remix.component.style}
  final ChipStyle? style;

  @override
  State<Chip> createState() => _ChipState();
}

class _ChipState extends State<Chip> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController();
    _controller.selected = widget.value;
    _controller.disabled = widget.disabled;
  }

  @override
  void didUpdateWidget(Chip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (mounted) {
      if (oldWidget.value != widget.value) {
        _controller.selected = widget.value;
      }

      if (oldWidget.disabled != widget.disabled) {
        _controller.disabled = widget.disabled;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? context.remix.components.chip;
    final configuration = SpecConfiguration(context, ChipSpecUtility.self);

    return Pressable(
      enabled: !widget.disabled,
      onPress:
          widget.disabled ? null : () => widget.onChanged?.call(!widget.value),
      controller: _controller,
      child: SpecBuilder(
        style: style.makeStyle(configuration).applyVariants(widget.variants),
        builder: (context) {
          final spec = ChipSpec.of(context);

          return spec.container(
            direction: Axis.horizontal,
            children: [
              if (widget.iconLeft != null) spec.icon(widget.iconLeft),
              if (widget.label?.isNotEmpty == true) spec.label(widget.label!),
              if (widget.iconRight != null) spec.icon(widget.iconRight),
            ],
          );
        },
      ),
    );
  }
}

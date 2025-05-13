part of 'switch.dart';

class Switch extends StatefulWidget {
  const Switch({
    super.key,
    this.disabled = false,
    required this.value,
    required this.onChanged,
    this.style,
    this.variants = const [],
  });

  /// Whether the switch is on or off.
  final bool value;

  /// {@macro remix.component.onChanged}
  final ValueChanged<bool> onChanged;

  /// {@macro remix.component.style}
  final SwitchStyle? style;

  /// {@macro remix.component.disabled}
  final bool disabled;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController()
      ..selected = widget.value
      ..disabled = widget.disabled;
  }

  void _handleOnPress() => widget.onChanged(!widget.value);

  @override
  void didUpdateWidget(Switch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _controller.selected = widget.value;
    }

    if (oldWidget.disabled != widget.disabled) {
      _controller.disabled = widget.disabled;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? context.remix.components.switchComponent;

    final configuration = SpecConfiguration(context, SwitchSpecUtility.self);

    return Pressable(
      enabled: !widget.disabled,
      onPress: widget.disabled ? null : _handleOnPress,
      controller: _controller,
      child: SpecBuilder(
        style: style.makeStyle(configuration).applyVariants(widget.variants),
        builder: (context) {
          final spec = SwitchSpec.of(context);

          final containerWidget = spec.container;
          final indicatorWidget = spec.indicator;

          return containerWidget(child: indicatorWidget());
        },
      ),
    );
  }
}

part of 'radio.dart';

class Radio<T> extends StatefulWidget {
  const Radio({
    super.key,
    required this.value,
    required this.onChanged,
    required this.groupValue,
    this.disabled = false,
    this.style,
    this.variants = const [],
    required this.label,
  });

  /// The value associated with this radio button.
  ///
  /// This value is compared against [groupValue] to determine if this radio button
  /// is selected.
  final T value;

  /// {@macro remix.component.onChanged}
  final ValueChanged<T?> onChanged;

  /// The currently selected value for a group of radio buttons.
  ///
  /// When [value] matches [groupValue], this radio button is considered selected.
  final T? groupValue;

  /// The label text displayed next to the radio button.
  final String label;

  /// {@macro remix.component.disabled}
  final bool disabled;

  /// {@macro remix.component.style}
  final RadioStyle? style;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  bool get _selected => value == groupValue;

  @override
  State<Radio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<Radio<T>> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController()
      ..selected = widget._selected
      ..disabled = widget.disabled;
  }

  void _handleOnPress() {
    widget.onChanged(widget.value);
  }

  @override
  void didUpdateWidget(Radio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget._selected != widget._selected) {
      _controller.selected = widget._selected;
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
    final style = widget.style ?? context.remix.components.radio;
    final configuration = SpecConfiguration(context, RadioSpecUtility.self);

    return Pressable(
      enabled: !widget.disabled,
      onPress: widget.disabled ? null : _handleOnPress,
      controller: _controller,
      child: SpecBuilder(
        style: style.makeStyle(configuration).applyVariants(widget.variants),
        builder: (context) {
          final spec = RadioSpec.of(context);

          final ContainerWidget = spec.indicatorContainer;
          final IndicatorWidget = spec.indicator;
          final FlexWidget = spec.container;
          final TextWidget = spec.text;

          return FlexWidget(
            direction: Axis.horizontal,
            children: [
              ContainerWidget(child: IndicatorWidget()),
              TextWidget(widget.label),
            ],
          );
        },
      ),
    );
  }
}

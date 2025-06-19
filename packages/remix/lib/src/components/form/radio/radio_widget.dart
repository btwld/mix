part of 'radio.dart';

/// A customizable radio button group component that supports various styles and behaviors.
/// The radio button group integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxRadioGroup<Options>(
///   value: _value,
///   onChanged: (value) {
///     setState(() {
///       _value = value;
///     });
///   },
///   child: const Column(
///     spacing: 8,
///     mainAxisSize: MainAxisSize.min,
///     crossAxisAlignment: CrossAxisAlignment.start,
///     children: [
///       RxRadio(
///         label: 'Banana',
///         value: Options.banana,
///       ),
///       RxRadio(
///         label: 'Apple',
///         value: Options.apple,
///       ),
///       RxRadio(
///         label: 'Orange',
///         value: Options.orange,
///       ),
///     ],
///   ),
/// )
/// ```
class RxRadioGroup<T> extends StatefulWidget {
  const RxRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.enabled = true,
    this.style,
  });

  final T? value;

  /// The callback function that is called when the radio button is tapped.
  final ValueChanged<T?>? onChanged;

  /// The child widget that contains the radio button.
  final Widget child;

  /// {@macro remix.component.enabled}
  final bool enabled;

  /// {@macro remix.component.style}
  final RxRadioStyle? style;

  @override
  State<RxRadioGroup<T>> createState() => _RxRadioGroupState<T>();
}

class _RxRadioGroupState<T> extends State<RxRadioGroup<T>> {
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant RxRadioGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  RxRadioStyle get _style =>
      RxRadioStyle._default().merge(widget.style ?? RxRadioStyle());

  @override
  Widget build(BuildContext context) {
    return StyleScope<RxRadioStyle>(
      style: _style,
      child: NakedRadioGroup<T>(
        groupValue: _value,
        onChanged: (value) {
          setState(() {
            _value = value;
          });
          widget.onChanged?.call(value);
        },
        enabled: widget.enabled,
        child: widget.child,
      ),
    );
  }
}

class RxRadio<T> extends StatefulWidget implements Disableable {
  const RxRadio({
    super.key,
    required this.value,
    this.enabled = true,
    this.focusNode,
    this.enableHapticFeedback = true,
    required this.label,
  });

  final T value;
  final String label;
  @override
  final bool enabled;
  final FocusNode? focusNode;
  final bool enableHapticFeedback;

  @override
  State<RxRadio<T>> createState() => _RxRadioState<T>();
}

class _RxRadioState<T> extends State<RxRadio<T>>
    with MixControllerMixin, DisableableMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final group = NakedRadioGroupScope.of<T>(context);
    mixController.selected = widget.value == group.groupValue;
    mixController.disabled = !widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    final style = StyleScope.of<RxRadioStyle>(context)!;

    return NakedRadio<T>(
      value: widget.value,
      onHoverState: (state) {
        setState(() {
          mixController.hovered = state;
        });
      },
      onPressedState: (state) {
        setState(() {
          mixController.pressed = state;
        });
      },
      onFocusState: (state) {
        setState(() {
          mixController.focused = state;
        });
      },
      enabled: widget.enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: RemixBuilder(
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
        style: Style(style),
        controller: mixController,
      ),
    );
  }
}

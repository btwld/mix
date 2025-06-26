part of 'switch.dart';

/// A customizable switch component that supports various styles and behaviors.
/// The switch integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RxSwitch(
///   selected: true,
///   onChanged: (value) {
///     print('Switch toggled: $value');
///   },
///   style: RxSwitchStyle(),
/// )
/// ```

class RxSwitch extends StatefulWidget implements Disableable, Selectable {
  const RxSwitch({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.style,
    this.variants = const [],
    this.enableHapticFeedback = true,
    this.focusNode,
  });

  /// Whether the switch is on or off.
  @override
  final bool selected;

  /// {@macro remix.component.onChanged}
  final ValueChanged<bool> onChanged;

  /// {@macro remix.component.style}
  final RxSwitchStyle? style;

  /// {@macro remix.component.disabled}
  @override
  final bool enabled;

  /// {@macro remix.component.variants}
  final List<Variant> variants;

  /// {@macro naked.component.enableHapticFeedback}
  final bool enableHapticFeedback;

  /// {@macro remix.component.focusNode}
  final FocusNode? focusNode;

  @override
  State<RxSwitch> createState() => _RxSwitchState();
}

class _RxSwitchState extends State<RxSwitch>
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  RxSwitchStyle get _style =>
      RxSwitchStyle._default().merge(widget.style ?? RxSwitchStyle());

  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => widget.onChanged(value ?? false),
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
      enableHapticFeedback: true,
      focusNode: widget.focusNode,
      child: RemixBuilder(
        builder: (context) {
          final spec = SwitchSpec.of(context);

          final containerWidget = spec.container;
          final indicatorWidget = spec.indicator;

          return containerWidget(child: indicatorWidget());
        },
        style: Style(_style).applyVariants(widget.variants),
        controller: mixController,
      ),
    );
  }
}

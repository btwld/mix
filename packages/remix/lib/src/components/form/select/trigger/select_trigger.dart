part of '../select.dart';

@MixableSpec()
class SelectTriggerSpec extends Spec<SelectTriggerSpec>
    with _$SelectTriggerSpec, Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec label;
  final IconSpec icon;

  /// {@macro select_button_spec_of}
  static const of = _$SelectTriggerSpec.of;

  static const from = _$SelectTriggerSpec.from;

  const SelectTriggerSpec({
    FlexBoxSpec? container,
    IconSpec? icon,
    TextSpec? label,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        icon = icon ?? const IconSpec(),
        label = label ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

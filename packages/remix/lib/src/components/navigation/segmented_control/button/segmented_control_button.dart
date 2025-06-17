part of '../segmented_control.dart';

@MixableSpec()
class SegmentButtonSpec extends Spec<SegmentButtonSpec>
    with _$SegmentButtonSpec, Diagnosticable {
  final FlexSpec flex;
  final BoxSpec container;
  final IconSpec icon;
  final TextSpec label;

  /// {@macro segment_button_spec_of}
  static const of = _$SegmentButtonSpec.of;

  static const from = _$SegmentButtonSpec.from;

  const SegmentButtonSpec({
    BoxSpec? container,
    FlexSpec? flex,
    IconSpec? icon,
    TextSpec? label,
    super.modifiers,
    super.animated,
  })  : flex = flex ?? const FlexSpec(),
        container = container ?? const BoxSpec(),
        icon = icon ?? const IconSpec(),
        label = label ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

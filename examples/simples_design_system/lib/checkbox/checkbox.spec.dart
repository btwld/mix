import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'checkbox.spec.g.dart';

@MixableSpec()
base class CheckboxSpec extends Spec<CheckboxSpec>
    with _$CheckboxSpec, Diagnosticable {
  final FlexBoxSpec container;
  final BoxSpec indicatorContainer;
  final IconSpec indicator;
  final TextSpec label;

  /// {@macro checkbox_spec_of}
  static const of = _$CheckboxSpec.of;

  static const from = _$CheckboxSpec.from;

  const CheckboxSpec({
    BoxSpec? indicatorContainer,
    IconSpec? indicator,
    FlexBoxSpec? container,
    TextSpec? label,
    super.modifiers,
    super.animated,
  })  : indicatorContainer = indicatorContainer ?? const BoxSpec(),
        indicator = indicator ?? const IconSpec(),
        container = container ?? const FlexBoxSpec(),
        label = label ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

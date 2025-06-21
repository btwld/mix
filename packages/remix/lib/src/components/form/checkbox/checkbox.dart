import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../helpers/mix_controller_mixin.dart';
import '../../../helpers/remix_builder.dart';

part 'checkbox.g.dart';
part 'checkbox_style.dart';
part 'checkbox_widget.dart';

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

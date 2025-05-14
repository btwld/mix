import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'button.spec.g.dart';

@MixableSpec()
class ButtonSpec extends Spec<ButtonSpec> with _$ButtonSpec, Diagnosticable {
  final FlexBoxSpec container;
  final IconSpec icon;
  final TextSpec label;

  /// {@macro button_spec_of}
  static const of = _$ButtonSpec.of;

  static const from = _$ButtonSpec.from;

  const ButtonSpec({
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

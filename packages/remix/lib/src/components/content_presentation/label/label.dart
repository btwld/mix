import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'label.g.dart';
part 'label_style.dart';
part 'label_widget.dart';

@MixableSpec()
base class LabelSpec extends Spec<LabelSpec> with _$LabelSpec, Diagnosticable {
  final double spacing;
  final TextSpec label;
  final IconSpec icon;

  /// {@macro button_spec_of}
  static const of = _$LabelSpec.of;

  static const from = _$LabelSpec.from;

  const LabelSpec({
    double? spacing,
    IconSpec? icon,
    TextSpec? label,
    super.modifiers,
    super.animated,
  })  : spacing = spacing ?? 8,
        icon = icon ?? const IconSpec(),
        label = label ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

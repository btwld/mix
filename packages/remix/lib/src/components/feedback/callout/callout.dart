import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/spec_style.dart';

part 'callout.g.dart';
part 'callout_style.dart';
part 'callout_widget.dart';

@MixableSpec()
base class CalloutSpec extends Spec<CalloutSpec> with _$CalloutSpec {
  final FlexBoxSpec container;
  final IconSpec icon;
  final TextSpec text;

  /// {@macro callout_spec_of}
  static const of = _$CalloutSpec.of;

  static const from = _$CalloutSpec.from;

  const CalloutSpec({
    FlexBoxSpec? container,
    IconSpec? icon,
    TextSpec? text,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        icon = icon ?? const IconSpec(),
        text = text ?? const TextSpec();
}

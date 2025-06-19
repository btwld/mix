import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../content_presentation/label/label.dart';

part 'callout.g.dart';
part 'callout_style.dart';
part 'callout_widget.dart';

@MixableSpec()
base class CalloutSpec extends Spec<CalloutSpec> with _$CalloutSpec {
  final FlexBoxSpec container;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData icon;

  final TextStyle textStyle;

  /// {@macro callout_spec_of}
  static const of = _$CalloutSpec.of;

  static const from = _$CalloutSpec.from;

  const CalloutSpec({
    FlexBoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        icon = icon ?? const IconThemeData(),
        textStyle = textStyle ?? const TextStyle();
}

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked/naked.dart';

import '../../../mix/attributes/icon_theme_data.dart';
import '../../helpers/mix_controller_mixin.dart';
import '../../helpers/remix_builder.dart';
import '../label/label.dart';
import '../spinner/spinner.dart';

part 'button.g.dart';
part 'button_style.dart';
part 'button_widget.dart';

@MixableSpec()
class ButtonSpec extends Spec<ButtonSpec> with _$ButtonSpec, Diagnosticable {
  final BoxSpec container;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [
      MixableFieldUtility(
        type: 'IconThemeDataUtility',
      ),
    ],
  )
  final IconThemeData icon;
  final TextStyle textStyle;

  @MixableField(dto: MixableFieldType(type: 'SpinnerSpecAttribute'))
  final SpinnerSpec spinner;

  /// {@macro button_spec_of}
  static const of = _$ButtonSpec.of;

  static const from = _$ButtonSpec.from;

  const ButtonSpec({
    BoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    super.modifiers,
    SpinnerSpec? spinner,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        icon = icon ?? const IconThemeData(),
        textStyle = textStyle ?? const TextStyle(),
        spinner = spinner ?? const SpinnerSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

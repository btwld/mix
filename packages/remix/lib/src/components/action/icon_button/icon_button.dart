import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/component_builder.dart';
import '../../feedback/spinner/spinner.dart';

part 'icon_button.g.dart';
part 'icon_button_style.dart';
part 'icon_button_widget.dart';

@MixableSpec()
class IconButtonSpec extends Spec<IconButtonSpec>
    with _$IconButtonSpec, Diagnosticable {
  final BoxSpec container;
  final IconSpec icon;

  @MixableField(dto: MixableFieldType(type: 'SpinnerSpecAttribute'))
  final SpinnerSpec spinner;

  /// {@macro icon_button_spec_of}
  static const of = _$IconButtonSpec.of;

  static const from = _$IconButtonSpec.from;

  const IconButtonSpec({
    BoxSpec? container,
    IconSpec? icon,
    super.modifiers,
    SpinnerSpec? spinner,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        icon = icon ?? const IconSpec(),
        spinner = spinner ?? const SpinnerSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

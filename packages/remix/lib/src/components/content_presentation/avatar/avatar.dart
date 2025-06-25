import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../../helpers/utility_extension.dart';

part 'avatar.g.dart';
part 'avatar_style.dart';
part 'avatar_widget.dart';

@MixableSpec()
base class AvatarSpec extends Spec<AvatarSpec> with _$AvatarSpec {
  final BoxSpec container;
  final TextStyle textStyle;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData icon;

  /// {@macro avatar_spec_of}
  static const of = _$AvatarSpec.of;

  static const from = _$AvatarSpec.from;

  const AvatarSpec({
    BoxSpec? container,
    TextStyle? textStyle,
    IconThemeData? icon,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        textStyle = textStyle ?? const TextStyle(),
        icon = icon ?? const IconThemeData();
}

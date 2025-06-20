import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/attributes/icon_theme_data.dart';
import '../../content_presentation/label/label.dart';

part 'badge.g.dart';
part 'badge_style.dart';
part 'badge_widget.dart';

@MixableSpec(methods: GeneratedSpecMethods.skipLerp)
base class BadgeSpec extends Spec<BadgeSpec> with _$BadgeSpec {
  final BoxSpec container;

  @MixableField(
    dto: MixableFieldType(type: 'IconThemeDataDto'),
    utilities: [MixableFieldUtility(type: 'IconThemeDataUtility')],
  )
  final IconThemeData icon;
  final TextStyle textStyle;

  /// {@macro badge_spec_of}
  static const of = _$BadgeSpec.of;

  static const from = _$BadgeSpec.from;

  const BadgeSpec({
    BoxSpec? container,
    IconThemeData? icon,
    TextStyle? textStyle,
    super.animated,
  })  : container = container ?? const BoxSpec(),
        icon = icon ?? const IconThemeData(),
        textStyle = textStyle ?? const TextStyle();

  @override
  BadgeSpec lerp(BadgeSpec? other, double t) {
    if (other == null) return _$this;

    return BadgeSpec(
      container: _$this.container.lerp(other.container, t),
      icon: IconThemeData.lerp(_$this.icon, other.icon, t),
      textStyle:
          MixHelpers.lerpTextStyle(_$this.textStyle, other.textStyle, t)!,
      animated: _$this.animated ?? other.animated,
    );
  }
}

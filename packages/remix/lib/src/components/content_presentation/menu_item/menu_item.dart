import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../../core/theme/remix_theme.dart';
import '../../../helpers/component_builder.dart';
import '../../../helpers/spec_style.dart';

part 'menu_item.g.dart';
part 'menu_item_style.dart';
part 'menu_item_widget.dart';

@MixableSpec()
class MenuItemSpec extends Spec<MenuItemSpec>
    with _$MenuItemSpec, Diagnosticable {
  final FlexBoxSpec container;
  final FlexBoxSpec titleSubtitleContainer;
  final IconSpec icon;
  final TextSpec title;
  final TextSpec subtitle;

  /// {@macro menu_item_spec_of}
  static const of = _$MenuItemSpec.of;

  static const from = _$MenuItemSpec.from;

  const MenuItemSpec({
    FlexBoxSpec? container,
    FlexBoxSpec? titleSubtitleContainer,
    IconSpec? icon,
    TextSpec? title,
    TextSpec? subtitle,
    super.modifiers,
    super.animated,
  })  : container = container ?? const FlexBoxSpec(),
        titleSubtitleContainer = titleSubtitleContainer ?? const FlexBoxSpec(),
        icon = icon ?? const IconSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }
}

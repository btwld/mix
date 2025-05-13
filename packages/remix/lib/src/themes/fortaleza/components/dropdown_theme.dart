import 'package:mix/mix.dart';

import '../../../components/utility/dropdown_menu/dropdown_menu.dart';
import '../tokens.dart';

class FortalezaDropdownMenuStyle extends DropdownMenuStyle {
  const FortalezaDropdownMenuStyle();

  @override
  Style makeStyle(SpecConfiguration<DropdownMenuSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final baseThemeOverrides = Style(
      $.menu.container.chain
        ..color.$neutral(1)
        ..border.all.color.$neutral(6)
        ..wrap.intrinsicWidth()
        ..padding.all.$space2(),
      $.item.container.padding.horizontal.$space3(),
      $.item.text.style.color.$neutral(12),
      spec.on.hover($.item.container.color.$neutral(4)),
    );

    return Style.create([baseStyle(), baseThemeOverrides()])
        .animate(duration: const Duration(milliseconds: 100));
  }
}

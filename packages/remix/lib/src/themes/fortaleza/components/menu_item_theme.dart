import 'package:mix/mix.dart';

import '../../../components/content_presentation/menu_item/menu_item.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaMenuItemStyle extends MenuItemStyle {
  const FortalezaMenuItemStyle();

  @override
  Style makeStyle(SpecConfiguration<MenuItemSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final titleSubtitleLayout = $.titleSubtitleContainer.flex.gap.$space1();

    final title = $.title
      ..style.$text2()
      ..style.color.resetDirectives()
      ..style.color.$neutral(12);

    final subtitle = $.subtitle
      ..style.$text1()
      ..style.color.resetDirectives()
      ..style.color.$neutral(9);

    final container = $.container
      ..padding.all.$space3()
      ..padding.right.$space4()
      ..borderRadius.all.$radius2()
      ..flex.gap.$space3();

    final icon = $.icon.color.$neutral(11);

    final hovered = $.container.color.$accent(3);

    final disabled = $
      ..title.style.color.$neutral(9)
      ..subtitle.style.color.$neutral(8)
      ..icon.color.$neutral(8);

    return Style.create([
      baseStyle,
      titleSubtitleLayout,
      container,
      title,
      subtitle,
      icon,
      spec.on.hover(hovered),
      spec.on.disabled(disabled),
    ]).animate(duration: const Duration(milliseconds: 100));
  }
}

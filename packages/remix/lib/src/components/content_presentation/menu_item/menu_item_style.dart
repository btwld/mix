part of 'menu_item.dart';

class MenuItemStyle extends SpecStyle<MenuItemSpecUtility> {
  const MenuItemStyle();

  @override
  Style makeStyle(SpecConfiguration<MenuItemSpecUtility> spec) {
    final $ = spec.utilities;

    final titleSubtitleContainer = $.titleSubtitleContainer.chain
      ..flex.mainAxisAlignment.start()
      ..flex.crossAxisAlignment.start()
      ..flex.mainAxisSize.min()
      ..wrap.expanded()
      ..flex.gap(4.0);

    final title = $.title.style.fontSize(14.0);

    final subtitle = $.subtitle.chain
      ..style.fontSize(12.0)
      ..style.color.grey.shade600()
      ..maxLines(2);

    final container = $.container.chain
      ..flex.gap(12)
      ..padding(12)
      ..borderRadius(12);

    final icon = $.icon.chain
      ..size(20)
      ..color.black87();

    final disabled = spec.on.disabled(
      $.title.style.color.grey.shade600(),
      $.subtitle.style.color.grey.shade400(),
    );

    return Style.create([
      titleSubtitleContainer,
      container,
      title,
      subtitle,
      icon,
      spec.on.disabled(disabled),
    ]);
  }
}

class MenuItemDarkStyle extends MenuItemStyle {
  const MenuItemDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<MenuItemSpecUtility> spec) {
    final $ = spec.utilities;

    final disabled = spec.on.disabled(
      $.title.style.color.grey.shade400(),
      $.subtitle.style.color.grey.shade700(),
    );

    return Style.create([
      super.makeStyle(spec).call(),
      $.title.style.color.white(),
      $.icon.color.white(),
      spec.on.disabled(disabled),
    ]);
  }
}

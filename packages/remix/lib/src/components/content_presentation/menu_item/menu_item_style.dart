part of 'menu_item.dart';

class RxMenuItemStyle extends MenuItemSpecUtility<MenuItemSpecAttribute> {
  RxMenuItemStyle() : super((v) => v);

  factory RxMenuItemStyle._default() {
    return RxMenuItemStyle()
      ..titleSubtitleContainer.flex.crossAxisAlignment.start()
      ..titleSubtitleContainer.flex.mainAxisSize.min()
      ..titleSubtitleContainer.wrap.expanded()
      ..titleSubtitleContainer.flex.gap(2.0)
      ..container.flex.gap(12)
      ..container.padding(12)
      ..subtitle.style.fontSize(12.0)
      ..subtitle.style.color.grey.shade600()
      ..subtitle.maxLines(2);
  }

  @override
  RxMenuItemStyle merge(RxMenuItemStyle other) {
    return super.merge(other) as RxMenuItemStyle;
  }
}

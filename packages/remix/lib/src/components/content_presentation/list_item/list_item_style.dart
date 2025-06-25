part of 'list_item.dart';

class RxListItemStyle extends ListItemSpecUtility<ListItemSpecAttribute> {
  RxListItemStyle() : super((v) => v);

  factory RxListItemStyle._default() {
    return RxListItemStyle()
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
  RxListItemStyle merge(RxListItemStyle other) {
    return super.merge(other) as RxListItemStyle;
  }
}

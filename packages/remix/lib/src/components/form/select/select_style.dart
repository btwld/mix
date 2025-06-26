part of 'select.dart';

class RxSelectStyle extends SelectSpecUtility<SelectSpecAttribute> {
  RxSelectStyle() : super((v) => v);

  factory RxSelectStyle._default() {
    return RxSelectStyle()
      ..trigger.container.flex.mainAxisSize.min()
      ..trigger.container.color.white()
      ..trigger.container.padding(8)
      ..trigger.container.padding.left(12)
      ..trigger.container.borderRadius.all(8)
      ..trigger.container.flex.gap(12)
      ..trigger.container.border.color.grey.shade300()
      ..trigger.icon.size(18)
      ..menuContainer.color.white()
      ..menuContainer.maxWidth(200)
      ..menuContainer.padding.all(8)
      ..menuContainer.borderRadius.all(8)
      ..menuContainer.border.color.grey.shade300()
      ..item.container.flex.mainAxisAlignment.spaceBetween()
      ..item.icon.size(16)
      ..item.textStyle.color.grey.shade700()
      ..item.container.padding.horizontal(8)
      ..item.container.padding.vertical(8)
      ..item.container.borderRadius(4)
      ..item.icon.color.grey.withOpacity(0)
      ..on.selected(
        RxSelectStyle()
          ..item.icon.color.grey.withOpacity(1)
          ..item.container.color.grey.shade100(),
      );
  }

  @override
  RxSelectStyle merge(RxSelectStyle other) {
    return super.merge(other) as RxSelectStyle;
  }
}

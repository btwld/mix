part of 'checkbox.dart';

class RxCheckboxStyle extends CheckboxSpecUtility<CheckboxSpecAttribute> {
  RxCheckboxStyle() : super((v) => v);

  factory RxCheckboxStyle._default() {
    return RxCheckboxStyle()
      ..indicatorContainer.borderRadius(4)
      ..indicatorContainer.border.all.color.black()
      ..indicator.size(16)
      ..indicator.color.black()
      ..label.style.color.black()
      ..label.style.fontSize(14)
      ..container.flex.mainAxisSize.min()
      ..container.flex.gap(8)
      ..indicator.wrap.opacity(0)
      ..on.selected(RxCheckboxStyle()..indicator.wrap.opacity(1));
  }

  @override
  RxCheckboxStyle merge(RxCheckboxStyle other) {
    return super.merge(other) as RxCheckboxStyle;
  }
}

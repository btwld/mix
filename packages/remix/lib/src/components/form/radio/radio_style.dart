part of 'radio.dart';

class RxRadioStyle extends RadioSpecUtility<RadioSpecAttribute> {
  RxRadioStyle() : super((v) => v);

  factory RxRadioStyle._default() {
    return RxRadioStyle()
      ..indicatorContainer.padding.all(3)
      ..indicatorContainer.border.all.color.grey.shade500()
      ..indicatorContainer.shape.circle()
      ..indicator.size(8)
      ..indicator.shape.circle()
      ..indicator.color.black()
      ..text.style.color.black()
      ..text.style.fontSize(14)
      ..text.textHeightBehavior.heightToFirstAscent.off()
      ..container.flex.mainAxisSize.min()
      ..container.flex.gap(8)
      ..indicator.wrap.opacity(0)
      ..on.selected(RxRadioStyle()..indicator.wrap.opacity(1));
  }

  @override
  RxRadioStyle merge(RxRadioStyle other) {
    return super.merge(other) as RxRadioStyle;
  }
}

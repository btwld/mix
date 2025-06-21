part of 'label.dart';

class RxLabelStyle extends LabelSpecUtility<LabelSpecAttribute> {
  RxLabelStyle() : super((v) => v);

  @override
  RxLabelStyle merge(RxLabelStyle other) {
    return super.merge(other) as RxLabelStyle;
  }
}

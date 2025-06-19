part of 'slider.dart';

class RxSliderStyle extends SliderSpecUtility {
  RxSliderStyle() : super((v) => v);

  factory RxSliderStyle._default() {
    return RxSliderStyle()
      ..thumb.shape.circle.side.color.black()
      ..thumb.shape.circle.side.width(2)
      ..thumb.color.white()
      ..thumb.size(24)
      ..baseTrack.color.grey.shade300()
      ..activeTrack.color.black()
      ..division.color.black26();
  }

  @override
  RxSliderStyle merge(covariant RxSliderStyle other) {
    return super.merge(other) as RxSliderStyle;
  }
}

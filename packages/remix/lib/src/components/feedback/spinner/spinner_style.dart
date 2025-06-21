// ignore_for_file: avoid-unnecessary-call

part of 'spinner.dart';

class RxSpinnerStyle extends SpinnerSpecUtility<SpinnerSpecAttribute> {
  RxSpinnerStyle() : super((v) => v);

  factory RxSpinnerStyle._default() {
    return RxSpinnerStyle()
      ..color.black()
      ..style.solid()
      ..size.call(24)
      ..strokeWidth.call(1.5);
  }

  @override
  RxSpinnerStyle merge(RxSpinnerStyle other) {
    return super.merge(other) as RxSpinnerStyle;
  }
}

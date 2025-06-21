part of 'button.dart';

class RxButtonStyle extends ButtonSpecUtility<ButtonSpecAttribute> {
  RxButtonStyle() : super((v) => v);

  factory RxButtonStyle._default() {
    final style = RxButtonStyle()
      ..container.color.black()
      ..container.padding(10)
      ..container.borderRadius(8)
      ..icon.color.white()
      ..icon.size(18);

    return style;
  }

  @override
  RxButtonStyle merge(RxButtonStyle other) {
    return super.merge(other) as RxButtonStyle;
  }
}

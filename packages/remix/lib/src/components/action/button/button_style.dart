part of 'button.dart';

class RxButtonStyle extends ButtonSpecUtility<ButtonSpecAttribute> {
  @protected
  RxButtonStyle.internal() : super((v) => v);

  factory RxButtonStyle() {
    final style = RxButtonStyle.internal()
      ..container.color.black()
      ..container.padding(10)
      ..container.borderRadius(8)
      ..icon.color.white()
      ..icon.size(18);

    return style;
  }
}

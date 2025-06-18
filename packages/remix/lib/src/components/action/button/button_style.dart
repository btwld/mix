part of 'button.dart';

extension type const RxButtonStyle._(ButtonSpecUtility<ButtonSpecAttribute> _)
    implements ButtonSpecUtility<ButtonSpecAttribute> {
  factory RxButtonStyle() {
    final initial = ButtonSpecUtility.self
      ..container.color.black()
      ..container.padding(10)
      ..container.borderRadius(8)
      ..icon.color.white()
      ..icon.size(18);

    return RxButtonStyle._(initial);
  }
}

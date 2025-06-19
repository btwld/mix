part of 'switch.dart';

class RxSwitchStyle extends SwitchSpecUtility {
  RxSwitchStyle() : super((v) => v);

  factory RxSwitchStyle._default() {
    return RxSwitchStyle()
      ..container.color.grey.shade300()
      ..container.borderRadius(99)
      ..container.padding.all(2)
      ..container.alignment.centerLeft()
      ..container.height(24)
      ..container.width(44)
      ..container.animated.spring(stiffness: 100, dampingRatio: 1)
      ..indicator.color.white()
      ..indicator.shape.circle()
      ..indicator.width(20)
      ..on.selected(
        RxSwitchStyle()
          ..container.alignment.bottomRight()
          ..container.color.greenAccent.shade700(),
      );
  }

  @override
  RxSwitchStyle merge(covariant RxSwitchStyle other) {
    return super.merge(other) as RxSwitchStyle;
  }
}

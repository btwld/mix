part of 'divider.dart';

class RxDividerStyle extends DividerSpecUtility {
  RxDividerStyle() : super((v) => v);

  factory RxDividerStyle._default() {
    return RxDividerStyle()
      ..container.color.grey.shade300()
      ..container.borderRadius(99)
      ..container.height(1)
      ..container.width.infinity();
  }

  @override
  RxDividerStyle merge(covariant RxDividerStyle other) {
    return super.merge(other) as RxDividerStyle;
  }
}

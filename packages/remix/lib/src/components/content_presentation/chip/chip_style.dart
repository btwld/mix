part of 'chip.dart';

class RxChipStyle extends ChipSpecUtility<ChipSpecAttribute> {
  RxChipStyle() : super((v) => v);

  factory RxChipStyle._default() {
    return RxChipStyle()
      ..container.borderRadius(8)
      ..container.color.white()
      ..container.border.color.grey.shade300()
      ..container.padding.vertical(6)
      ..container.padding.horizontal(8)
      ..container.flex.mainAxisSize.min()
      ..container.flex.gap(4)
      ..container.animated.easeInOut(100.ms)
      ..container.height(32)
      ..icon.size(18)
      ..label.fontSize(14)
      ..on.selected(RxChipStyle()..container.color.grey.shade200());
  }

  @override
  RxChipStyle merge(RxChipStyle other) {
    return super.merge(other) as RxChipStyle;
  }
}

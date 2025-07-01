part of 'tooltip.dart';

class RxTooltipStyle extends TooltipSpecUtility<TooltipSpecAttribute> {
  RxTooltipStyle() : super((v) => v);

  factory RxTooltipStyle._default() {
    return RxTooltipStyle()
      ..container.color.black.withOpacity(0.8)
      ..container.padding(10)
      ..container.borderRadius(8)
      ..animated.duration(100.ms)
      ..on.hover(RxTooltipStyle()..container.color.red());
  }

  @override
  RxTooltipStyle merge(RxTooltipStyle other) {
    return super.merge(other) as RxTooltipStyle;
  }
}

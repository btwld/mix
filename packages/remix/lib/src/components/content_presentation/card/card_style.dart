part of 'card.dart';

class RxCardStyle extends CardSpecUtility<CardSpecAttribute> {
  RxCardStyle() : super((v) => v);

  factory RxCardStyle._default() {
    final style = RxCardStyle()
      ..container.borderRadius(8)
      ..container.color.white()
      ..container.border.all.color.black12()
      ..container.padding.all(16);

    return style;
  }

  @override
  RxCardStyle merge(RxCardStyle other) {
    return super.merge(other) as RxCardStyle;
  }
}

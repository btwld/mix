// ignore_for_file: camel_case_types

part of 'badge.dart';

class RxBadgeStyle extends BadgeSpecUtility {
  RxBadgeStyle() : super((v) => v);

  factory RxBadgeStyle._default() {
    return RxBadgeStyle()
      ..container.color.grey.shade200()
      ..container.borderRadius.all(10)
      ..container.padding.horizontal(10)
      ..container.padding.vertical(2)
      ..textStyle.color.grey.shade800()
      ..textStyle.height(1.1)
      ..icon.size(16);
  }

  @override
  RxBadgeStyle merge(covariant RxBadgeStyle other) {
    return super.merge(other) as RxBadgeStyle;
  }
}

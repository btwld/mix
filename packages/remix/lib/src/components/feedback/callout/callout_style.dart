// ignore_for_file: camel_case_types

part of 'callout.dart';

class RxCalloutStyle extends CalloutSpecUtility<CalloutSpecAttribute> {
  RxCalloutStyle() : super((v) => v);

  factory RxCalloutStyle._default() {
    return RxCalloutStyle()
      ..container.borderRadius(6)
      ..container.color.white()
      ..container.padding(12)
      ..container.border.all.color.grey.shade300()
      ..container.flex.mainAxisSize.min()
      ..container.flex.gap(8)
      ..icon.color.black()
      ..icon.size(16)
      ..textStyle.color.black()
      ..textStyle.fontWeight.w500();
  }

  @override
  RxCalloutStyle merge(RxCalloutStyle other) {
    return super.merge(other) as RxCalloutStyle;
  }
}

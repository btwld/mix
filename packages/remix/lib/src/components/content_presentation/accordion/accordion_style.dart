part of 'accordion.dart';

class RxAccordionStyle extends AccordionSpecUtility<AccordionSpecAttribute> {
  RxAccordionStyle() : super((v) => v);

  factory RxAccordionStyle._default() {
    final style = RxAccordionStyle()
      ..itemContainer.margin.bottom(12)
      ..itemContainer.border.all.color.grey.shade300()
      ..itemContainer.borderRadius.circular(12)
      ..headerContainer.padding(12)
      ..contentContainer.width.infinity()
      ..contentContainer.padding(12)
      ..contentContainer.padding.top(0)
      ..contentContainer.color.transparent()
      ..titleStyle.fontSize(14)
      ..titleStyle.fontWeight.w500()
      ..titleStyle.color.grey.shade800()
      ..contentStyle.fontSize(14)
      ..contentStyle.fontWeight.w400()
      ..contentStyle.color.grey.shade800();

    return style;
  }

  @override
  RxAccordionStyle merge(RxAccordionStyle other) {
    return super.merge(other) as RxAccordionStyle;
  }
}

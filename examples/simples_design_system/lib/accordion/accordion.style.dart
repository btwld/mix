part of 'accordion.dart';

class SimpleAccordionStyle extends AccordionStyle {
  const SimpleAccordionStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final c = spec.utilities;

    final mainContainer = Style(
      c.container.chain
        ..flex.mainAxisSize.min()
        ..flex.mainAxisAlignment.start()
        ..flex.crossAxisAlignment.start()
        ..color.white()
        ..border.color.grey.shade300()
        ..border.width(1)
        ..shape.roundedRectangle.borderRadius(8)
        ..clipBehavior.hardEdge()
        ..shape.roundedRectangle.side.color.grey.shade300()
        ..constraints.minWidth(200),
    );

    final contentContainer = Style(
      c.contentContainer.chain
        ..color.grey.shade50()
        ..border.top.width(1)
        ..border.top.color.grey.shade300()
        ..padding(12),
    );

    final headerContainer = Style(
      c.headerContainer.chain
        ..color.transparent()
        ..padding(12),
    );

    return Style(
      mainContainer(),
      contentContainer(),
      headerContainer(),
    );
  }
}

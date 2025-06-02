part of 'accordion.dart';

class AccordionStyle extends SpecStyle<AccordionSpecUtility> {
  const AccordionStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final $ = spec.utilities;

    final flexContainerStyle = [
      $.container
        ..flex.mainAxisSize.min()
        ..clipBehavior.antiAlias()
        ..border.bottom.color.grey.shade400(),
    ];

    final headerStyle = [
      $.header.container
        ..flex.gap(6)
        ..width.infinity()
        ..padding.vertical(16)
        ..color.transparent(),
      $.header
        ..leadingIcon.size(18)
        ..trailingIcon.wrap.transform.rotate(0)
        ..trailingIcon.size(18),
      $.header.text
        ..style.fontSize(16)
        ..style.letterSpacing(0.4)
        ..style.fontWeight.w600()
        ..style.decoration.none(),
      spec.on.hover($.header.text.style.decoration.underline()),
      spec.on.selected($.header.trailingIcon.wrap.transform.rotate.d180()),
    ];

    accordion.leadingIcon.size(18);

    accordion.titleStyle
      ..fontSize(14)
      ..color.black()
      ..letterSpacing(0.4)
      ..fontWeight.w500();

    accordion.contentStyle.color.black();

    accordion.contentContainer
      ..color.white()
      ..padding.bottom(16)
      ..width.infinity();

    accordion.itemContainer.border.bottom.color.grey();

    return Style.create([
      ...headerStyle,
      ...contentStyle,
      $.itemContainer.border.bottom.color.grey(),
      $on.focus($.headerContainer.color.red()),
      disabled,
    ]).animate(duration: const Duration(milliseconds: 200));
  }
}

class AccordionDarkStyle extends AccordionStyle {
  const AccordionDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec),
      $.container.border.bottom.color.grey.shade700(),
      $.header.text.style.color.white(),
      $.header.trailingIcon.color.white(),
    ]);
  }
}

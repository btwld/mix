part of 'accordion.dart';

class AccordionStyle extends SpecStyle<AccordionSpecUtility> {
  const AccordionStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final $ = spec.utilities;

    final flexContainerStyle = [
      $.container.chain
        ..flex.mainAxisSize.min()
        ..clipBehavior.antiAlias()
        ..border.bottom.color.grey.shade400(),
    ];

    final headerStyle = [
      $.header.container.chain
        ..flex.gap(6)
        ..width.infinity()
        ..padding.vertical(16)
        ..color.transparent(),
      $.header.chain
        ..leadingIcon.size(18)
        ..trailingIcon.wrap.transform.rotate(0)
        ..trailingIcon.size(18),
      $.header.text.chain
        ..style.fontSize(16)
        ..style.letterSpacing(0.4)
        ..style.fontWeight.w600()
        ..style.decoration.none(),
      spec.on.hover($.header.text.style.decoration.underline()),
      spec.on.selected($.header.trailingIcon.wrap.transform.rotate.d180()),
    ];

    return Style.create([...flexContainerStyle, ...headerStyle]);
  }
}

class AccordionDarkStyle extends AccordionStyle {
  const AccordionDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.container.border.bottom.color.grey.shade700(),
      $.header.text.style.color.white(),
      $.header.trailingIcon.color.white(),
    ]);
  }
}

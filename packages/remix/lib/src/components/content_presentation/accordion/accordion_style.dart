part of 'accordion.dart';

class AccordionStyle extends SpecStyle<AccordionSpecUtility> {
  const AccordionStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final $ = spec.utilities;

    final headerStyle = [
      $.headerContainer.chain
        ..padding.vertical(16)
        ..color.white(),
      $.leadingIcon.size(18),
      $.titleStyle.fontSize(14),
      $.titleStyle.letterSpacing(0.4),
      $.titleStyle.fontWeight.w500(),
      spec.on.hover($.titleStyle.decoration.underline()),
    ];

    final contentStyle = [
      $.contentContainer.chain
        ..color.white()
        ..padding.bottom(16)
        ..width.infinity(),
    ];

    final disabled = $on.disabled(
      $.titleStyle.color.grey.shade600(),
      $.headerContainer.color.grey.shade200(),
    );

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
      super.makeStyle(spec).call(),
      $.itemContainer.border.bottom.color.grey.shade700(),
      // $.title.style.color.white(),
      $.leadingIcon.color.white(),
    ]);
  }
}

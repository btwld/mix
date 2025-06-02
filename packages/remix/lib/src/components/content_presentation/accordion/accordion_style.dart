part of 'accordion.dart';

class AccordionStyle extends SpecStyle<AccordionSpecUtility> {
  const AccordionStyle();

  @override
  Style buildStyle(StyleSheet<AccordionSpecUtility> style) {
    return style((accordion) {
      accordion.headerContainer
        ..padding.vertical(16)
        ..color.white();

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

      style.variant(const OnHoverVariant(), (accordion) {
        accordion.titleStyle.decoration.underline();
      });

      style.variant(const OnFocusedVariant(), (accordion) {
        accordion.headerContainer.color.red();
      });

      style.variant(const OnDisabledVariant(), (accordion) {
        accordion.titleStyle.color.grey.shade600();
        accordion.headerContainer.color.grey.shade200();
      });

      style.variant(const OnBrightnessVariant(Brightness.dark), (accordion) {
        accordion
          ..leadingIcon.color.white()
          ..itemContainer.border.bottom.color.grey.shade700();
      });
    }).animate(duration: const Duration(milliseconds: 200));
  }
}

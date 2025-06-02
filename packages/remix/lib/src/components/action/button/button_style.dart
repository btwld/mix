part of 'button.dart';

class RxButtonStyle extends SpecStyle<ButtonSpecUtility> {
  const RxButtonStyle();

  @override
  Style buildStyle(StyleSheet<ButtonSpecUtility> style) {
    return style((button) {
      button.container.chain
        ..borderRadius(6)
        ..color.black()
        ..padding.vertical(8)
        ..padding.horizontal(12);

      button.icon
        ..size(18)
        ..color.white();

      button.textStyle
        ..fontSize(14)
        ..height(1.5)
        ..color.white()
        ..fontWeight.w500();

      button.spinner.chain
        ..strokeWidth(0.9)
        ..size(15)
        ..color.white();

      style.variant(const OnPressVariant(), (button) {
        button.container.color.blue();
      });

      style.variant(const OnHoverVariant(), (button) {
        button.container.color.red();
      });

      style.variant(const OnFocusedVariant(), (button) {
        button.container.color.green();
      });
    }).animate();
  }
}

class RxIconButtonStyle extends RxButtonStyle {
  const RxIconButtonStyle();

  @override
  Style buildStyle(StyleSheet<ButtonSpecUtility> style) {
    return style((button) {
      button.container.chain
        ..borderRadius(6)
        ..color.black()
        ..padding(8);

      button.icon
        ..size(18)
        ..color.white();

      style.variant(const OnDisabledVariant(), (button) {
        button.container.color.grey.shade400();
      });

      style.variant(const OnBrightnessVariant(Brightness.dark), (button) {
        button.container.color.white();
        button.textStyle.color.black();
      });
    }).animate();
  }
}

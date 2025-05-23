part of 'checkbox.dart';

class SimpleCheckboxStyle extends CheckboxStyle {
  const SimpleCheckboxStyle();

  @override
  Style makeStyle(SpecConfiguration<CheckboxSpecUtility> spec) {
    final c = spec.utilities;
    final structure = Style(
      c.container.chain
        ..flex.mainAxisSize.min()
        ..flex.gap(8),
    );

    final indicatorContainer = Style(
      c.indicatorContainer.chain
        ..padding(1)
        ..color.black()
        ..borderRadius(4)
        ..border.color.black()
        ..border.width(1)
        ..color.white(),
      $on.selected(
        c.indicatorContainer.color.black(),
      ),
    );

    final indicator = Style(
      c.indicator.chain
        ..color.white()
        ..size(15),
    );

    final label = Style(
      c.label.chain
        ..color.black()
        ..fontSize(14)
        ..fontWeight.w500,
    );
    return Style(
      structure(),
      indicatorContainer(),
      indicator(),
      label(),
    );
  }
}

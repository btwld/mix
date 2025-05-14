part of 'checkbox.dart';

class CheckboxStyle extends SpecStyle<CheckboxSpecUtility> {
  const CheckboxStyle();

  @override
  Style makeStyle(SpecConfiguration<CheckboxSpecUtility> spec) {
    final $ = spec.utilities;

    final indicatorContainerStyle = [
      $.indicatorContainer.chain
        ..borderRadius(4)
        ..border.all.color.black(),
      spec.on.selected($.indicatorContainer.color.black()),
    ];

    final indicatorStyle = [
      $.indicator.chain
        ..size(16)
        ..color.white()
        ..wrap.opacity(0),
      spec.on.selected(
        $.indicator.wrap.opacity(1),
        $.indicator.color.white(),
      ),
    ];

    final labelStyle = $.label.chain
      ..style.color.black()
      ..style.fontSize(14)
      ..style.fontWeight.w500()
      ..textHeightBehavior.heightToFirstAscent.off();

    final containerStyle = $.container.flex.chain
      ..crossAxisAlignment.center()
      ..mainAxisAlignment.start()
      ..mainAxisSize.min()
      ..gap(8);

    final disabledStyle = spec.on.disabled(
      $.indicatorContainer.border.all.color.grey(),
      $.label.style.color.grey(),
      spec.on.selected($.indicatorContainer.color.grey()),
    );

    return Style.create([
      ...indicatorContainerStyle,
      ...indicatorStyle,
      labelStyle,
      containerStyle,
      disabledStyle,
    ]);
  }
}

class CheckboxDarkStyle extends CheckboxStyle {
  const CheckboxDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<CheckboxSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.indicatorContainer.border.all.color.white(),
      $.indicator.color.black(),
      $.label.style.color.white(),
      spec.on.selected(
        $.indicatorContainer.color.white(),
        $.indicator.color.black(),
      ),
    ]);
  }
}

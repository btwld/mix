part of 'radio.dart';

class RadioStyle extends SpecStyle<RadioSpecUtility> {
  const RadioStyle();

  @override
  Style makeStyle(SpecConfiguration<RadioSpecUtility> spec) {
    final $ = spec.utilities;

    final indicatorContainerStyle = [
      $.indicatorContainer.chain
        ..borderRadius(99)
        ..alignment.center()
        ..size(14)
        ..border.all.width(1)
        ..border.all.color.black(),
      spec.on.disabled($.indicatorContainer.border.color.black45()),
    ];

    final indicatorStyle = [
      $.indicator.chain
        ..borderRadius(99)
        ..color.black()
        ..wrap.padding.all(2)
        ..wrap.opacity(0)
        ..wrap.scale(0.5),
      spec.on.selected($.indicator.wrap.opacity(1), $.indicator.wrap.scale(1)),
      spec.on.disabled($.indicator.color.black45()),
    ];

    final textStyle = $.text.chain
      ..style.fontSize(14)
      ..style.height(1)
      ..style.fontWeight.w500()
      ..textHeightBehavior.heightToFirstAscent.off();

    final containerStyle = $.container.chain
      ..flex.row()
      ..flex.mainAxisSize.min()
      ..flex.mainAxisAlignment.start()
      ..flex.crossAxisAlignment.center()
      ..flex.gap(8);

    final disabledStyle = spec.on.disabled($.text.style.color.grey());

    return Style.create([
      ...indicatorContainerStyle,
      ...indicatorStyle,
      textStyle,
      containerStyle,
      disabledStyle,
    ]);
  }
}

class RadioDarkStyle extends RadioStyle {
  const RadioDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<RadioSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.indicatorContainer.border.all.color.white(),
      $.indicator.color.white(),
      $.text.style.color.white(),
      spec.on.disabled(
        $.indicatorContainer.border.all.color.white30(),
        $.indicator.color.white30(),
      ),
    ]);
  }
}

// ignore_for_file: camel_case_types

part of 'badge.dart';

class BadgeStyle extends SpecStyle<BadgeSpecUtility> {
  const BadgeStyle();

  @override
  Style makeStyle(SpecConfiguration<BadgeSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container.chain
        ..color.black()
        ..borderRadius.all(10)
        ..padding.horizontal(10)
        ..padding.vertical(2),
    ];

    final labelStyle = [
      $.label.chain
        ..textHeightBehavior.heightToFirstAscent.off()
        ..textHeightBehavior.heightToLastDescent.on()
        ..textAlign.center()
        ..style.height(1.5)
        ..style.fontWeight.w500()
        ..style.fontSize(12)
        ..style.color.white(),
    ];

    return Style.create([...containerStyle, ...labelStyle]);
  }
}

class BadgeDarkStyle extends BadgeStyle {
  const BadgeDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<BadgeSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([
      super.makeStyle(spec).call(),
      $.container.color.white(),
      $.label.style.color.black(),
    ]);
  }
}

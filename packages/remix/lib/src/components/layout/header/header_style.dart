part of 'header.dart';

class HeaderStyle extends SpecStyle<HeaderSpecUtility> {
  const HeaderStyle();

  @override
  Style makeStyle(SpecConfiguration<HeaderSpecUtility> spec) {
    final $ = spec.utilities;

    final textStyle = [
      $.titleGroup.chain
        ..crossAxisAlignment.start()
        ..mainAxisAlignment.start()
        ..mainAxisSize.min()
        ..gap(4),
      $.title.chain
        ..style.bold()
        ..fontSize(18),
      $.subtitle.chain
        ..fontSize(14)
        ..color.grey.shade800(),
    ];

    final containerStyle = [
      $.container.chain
        ..padding(20)
        ..height(88)
        ..color.white()
        ..flex.crossAxisAlignment.center(),
    ];

    return Style.create([...textStyle, ...containerStyle]);
  }
}

class HeaderDarkStyle extends HeaderStyle {
  const HeaderDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<HeaderSpecUtility> spec) {
    final $ = spec.utilities;

    final textStyle = [
      $.title.color.white(),
      $.subtitle.color.grey.shade200(),
    ];

    final containerStyle = [$.container.color.black()];

    return Style.create([
      super.makeStyle(spec).call(),
      ...textStyle,
      ...containerStyle,
    ]);
  }
}

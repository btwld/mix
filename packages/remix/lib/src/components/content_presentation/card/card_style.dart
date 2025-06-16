part of 'card.dart';

class CardStyle extends SpecStyle<CardSpecUtility> {
  const CardStyle();

  @override
  Style makeStyle(SpecConfiguration<CardSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container
        ..borderRadius(4)
        ..color.white()
        ..border.all.color.black12()
        ..padding.all(8),
    ];

    return Style.create([...containerStyle]);
  }
}

class CardDarkStyle extends CardStyle {
  const CardDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<CardSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = [
      $.container
        ..color.black()
        ..border.all.color.white30(),
    ];

    return Style.create([super.makeStyle(spec), ...containerStyle]);
  }
}

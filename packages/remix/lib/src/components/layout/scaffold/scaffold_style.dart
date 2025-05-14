part of 'scaffold.dart';

class ScaffoldStyle extends SpecStyle<ScaffoldSpecUtility> {
  const ScaffoldStyle();

  @override
  Style makeStyle(SpecConfiguration<ScaffoldSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([$.container.color(const Color(0xFFFFFFFF))]);
  }
}

class ScaffoldDarkStyle extends ScaffoldStyle {
  const ScaffoldDarkStyle();

  @override
  Style makeStyle(SpecConfiguration<ScaffoldSpecUtility> spec) {
    final $ = spec.utilities;

    return Style.create([$.container.color(const Color(0xFF000000))]);
  }
}

import 'package:mix/mix.dart';

import '../../../components/layout/header/header.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaHeaderStyle extends HeaderStyle {
  const FortalezaHeaderStyle();

  @override
  Style makeStyle(SpecConfiguration<HeaderSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final containerStyle = Style(
      $.container
        ..padding.all.$space4()
        ..color.$neutral(2),
    );

    final textStyle = Style(
      $.titleGroup.gap(0),
      $.title
        ..style.$text4()
        ..style.color.$neutral(12),
      $.subtitle
        ..style.$text2()
        ..style.color.$neutral(11),
    );

    return Style.create([baseStyle, containerStyle, textStyle]);
  }
}

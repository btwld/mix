import 'package:mix/mix.dart';

import '../../../components/feedback/dialog/dialog.dart';
import '../tokens.dart';

class FortalezaDialogStyle extends DialogStyle {
  const FortalezaDialogStyle();

  @override
  Style makeStyle(SpecConfiguration<DialogSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = $.container
      ..padding.all.$space4()
      ..borderRadius.all.$radius2()
      ..border.all.color.$neutral(6)
      ..color.$neutral(1);

    final titleStyle = $.title
      ..style.$text5()
      ..style.color.$neutral(12);

    final descriptionStyle = $.description
      ..style.$text2()
      ..style.color.$neutral(9);

    return Style.create(
      [super.makeStyle(spec), containerStyle, titleStyle, descriptionStyle],
    );
  }
}

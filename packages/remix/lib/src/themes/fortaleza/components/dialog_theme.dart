import 'package:mix/mix.dart';

import '../../../components/feedback/dialog/dialog.dart';
import '../tokens.dart';

class FortalezaDialogStyle extends DialogStyle {
  const FortalezaDialogStyle();

  @override
  Style makeStyle(SpecConfiguration<DialogSpecUtility> spec) {
    final $ = spec.utilities;

    final containerStyle = $.container.chain
      ..padding.all.$space4()
      ..borderRadius.all.$radius2()
      ..border.all.color.$neutral(6)
      ..color.$neutral(1);

    final titleStyle = $.title.chain
      ..style.$text5()
      ..style.color.$neutral(12);

    final descriptionStyle = $.description.chain
      ..style.$text2()
      ..style.color.$neutral(9);

    return Style.create(
      [
        super.makeStyle(spec).call(),
        containerStyle,
        titleStyle,
        descriptionStyle,
      ],
    );
  }
}

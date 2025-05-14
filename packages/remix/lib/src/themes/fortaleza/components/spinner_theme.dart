import 'package:mix/mix.dart';

import '../../../components/feedback/spinner/spinner.dart';
import '../tokens.dart';

class FortalezaSpinnerStyle extends SpinnerStyle {
  static const soft = Variant('for.spinner.soft');

  const FortalezaSpinnerStyle();

  static List<Variant> get variants => [soft];

  @override
  Style makeStyle(SpecConfiguration<SpinnerSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final softVariant = Style($.color.$accent(8));

    return Style.create(
      [baseStyle(), $.color.$accent(), $.style.solid(), soft(softVariant())],
    );
  }
}

import 'package:mix/mix.dart';

import '../../../components/feedback/progress/progress.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaProgressStyle extends ProgressStyle {
  static const soft = Variant('for.progress.soft');

  const FortalezaProgressStyle();

  static List<Variant> get variants => [soft];

  @override
  Style makeStyle(SpecConfiguration<ProgressSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final baseOverrides = Style(
      $.container.clipBehavior.hardEdge(),
      $.track.color.$neutral(3),
      $.fill.color.$accent(9),
      $.outerContainer
        ..clipBehavior.hardEdge()
        ..shapeDecoration.shape.roundedRectangle()
        ..border.width(1)
        ..border.color.$neutralAlpha(4),
    );

    final softVariant = Style(
      $.track.color.$neutral(4),
      $.fill.color.$accent(8),
      $.outerContainer.border.style.none(),
    );

    return Style.create([baseStyle, baseOverrides, soft(softVariant)]);
  }
}

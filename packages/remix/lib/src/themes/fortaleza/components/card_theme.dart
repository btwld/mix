import 'package:mix/mix.dart';

import '../../../components/content_presentation/card/card.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaCardStyle extends CardStyle {
  static const ghost = Variant('ghost');

  const FortalezaCardStyle();

  static List<Variant> get variants => [ghost];

  @override
  Style makeStyle(SpecConfiguration<CardSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final surfaceVariant = Style(
      $.container
        ..padding.all.$space3()
        ..borderRadius.all.$radius2()
        ..border.all.color.$neutral(6)
        ..color.$neutral(1),
      spec.on.hover($.container.border.color.$neutral(8)),
    );

    final ghostVariant = Style(
      $.container
        ..border.none()
        ..color.$neutral(2)
        ..color.withOpacity(0),
      spec.on.hover($.container.color.withOpacity(1)),
    );

    return Style.create([baseStyle, surfaceVariant, ghost(ghostVariant)])
        .animate(duration: const Duration(milliseconds: 100));
  }
}

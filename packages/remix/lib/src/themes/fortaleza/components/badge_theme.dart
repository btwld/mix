import 'package:mix/mix.dart';

import '../../../components/utility/badge/badge.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaBadgeStyle extends BadgeStyle {
  static const soft = Variant('for.badge.soft');
  static const surface = Variant('for.badge.surface');
  static const outline = Variant('for.badge.outline');

  const FortalezaBadgeStyle();

  static List<Variant> get variants => [soft, surface, outline];

  @override
  Style makeStyle(SpecConfiguration<BadgeSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final baseStyleOverride = Style(
      $.container
        ..borderRadius.all.$radius1()
        ..padding.horizontal.$space2()
        ..padding.vertical.$space1()
        ..color.$accent(),
      $.label.style.color.$neutral(1),
    );

    final softVariant = Style(
      $.container.color.$accent(4),
      $.label.style.color.$accent(9),
    );

    final surfaceVariant = Style(
      $.container
        ..color.$accentAlpha(2)
        ..border.all.width(1)
        ..border.all.color.$accent(6),
      $.label.style.color.$accent(11),
    );

    final outlineVariant = Style(
      $.container
        ..color.transparent()
        ..border.width(1)
        ..border.color.$accent(8),
      $.label.style.color.$accent(11),
    );

    return Style.create(
      [
        baseStyle,
        baseStyleOverride,
        soft(softVariant),
        surface(surfaceVariant),
        outline(outlineVariant),
      ],
    );
  }
}

class FortalezaDarkBadgeStyle extends FortalezaBadgeStyle {
  const FortalezaDarkBadgeStyle();

  @override
  Style makeStyle(SpecConfiguration<BadgeSpecUtility> spec) {
    final $ = spec.utilities;
    final baseStyle = super.makeStyle(spec);

    final baseStyleOverride = Style($.label.style.color.$neutral(12));
    final soft = Style(
      $.container.color.$accent(3),
      $.label.style.color.$accent(11),
    );
    final surface = Style($.container.color.$accent(1));

    return Style.create([
      baseStyle,
      baseStyleOverride,
      FortalezaBadgeStyle.soft(soft),
      FortalezaBadgeStyle.surface(surface),
    ]);
  }
}

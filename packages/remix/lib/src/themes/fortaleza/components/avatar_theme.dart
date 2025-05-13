import 'package:mix/mix.dart';

import '../../../components/content_presentation/avatar/avatar.dart';
import '../tokens.dart';

class FortalezaAvatarStyle extends AvatarStyle {
  static const soft = Variant('avatar.soft');

  const FortalezaAvatarStyle();

  static List<Variant> get variants => [soft];

  @override
  Style makeStyle(SpecConfiguration<AvatarSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final solidVariant = Style(
      $.container.color.$accent(),
      $.fallback.style.color.$neutral(1),
    );

    final softVariant = Style(
      $.container.color.$accent(4),
      $.fallback.style.color.$accent(),
    );

    return Style.create([baseStyle(), solidVariant(), soft(softVariant())]);
  }
}

class FortalezaDarkAvatarStyle extends FortalezaAvatarStyle {
  const FortalezaDarkAvatarStyle();

  @override
  Style makeStyle(SpecConfiguration<AvatarSpecUtility> spec) {
    final $ = spec.utilities;
    final baseStyle = super.makeStyle(spec);

    final solid = Style($.fallback.style.color.$neutral(12));
    final soft = Style(
      $.container.color.$accent(3),
      $.fallback.style.color.$accent(11),
    );

    return Style.create([
      baseStyle(),
      solid(),
      FortalezaAvatarStyle.soft(soft()),
    ]);
  }
}

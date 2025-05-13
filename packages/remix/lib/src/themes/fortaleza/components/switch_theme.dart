import 'package:mix/mix.dart';

import '../../../components/form/switch/switch.dart';
import '../tokens.dart';

class FortalezaSwitchStyle extends SwitchStyle {
  static const soft = Variant('for.switch.soft');

  const FortalezaSwitchStyle();

  static List<Variant> get variants => [soft];

  @override
  Style makeStyle(SpecConfiguration<SwitchSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final baseThemeOverrides = Style(
      $.indicator.color.$neutral(1),
      $.container.chain
        ..padding.all(1)
        ..color.$neutral(4)
        ..border.all.width(1)
        ..border.all.color.$neutral(7),
      spec.on.disabled(
        $.container.chain
          ..color.$neutral(4)
          ..border.all.color.$neutral(7),
        $.indicator.color.$neutral(3),
      ),
      spec.on.selected(
        $.container.chain
          ..color.$accent(9)
          ..border.all.color.$accent(10),
      ),
    );

    final softVariant = Style(
      $.container.chain
        ..border.all.style.none()
        ..color.$neutral(6),
      $.indicator.color.$neutral(1),
      spec.on.selected($.container.color.$accent(6)),
      spec.on.disabled(
        $.container.color.$neutral(6),
        $.indicator.color.$neutral(4),
      ),
    );

    return Style.create(
      [baseStyle(), baseThemeOverrides(), soft(softVariant())],
    );
  }
}

class FortalezaDarkSwitchStyle extends FortalezaSwitchStyle {
  const FortalezaDarkSwitchStyle();

  @override
  Style makeStyle(SpecConfiguration<SwitchSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = Style(super.makeStyle(spec).call());

    final soft = Style(
      $.indicator.color.$neutral(12),
      $.container.chain
        ..color.$neutral(3)
        ..padding.all(1)
        ..border.color.$neutralAlpha(7)
        ..border.width(1.2),
      spec.on.selected($.container.color.$accent(8)),
      spec.on.disabled(
        $.container.color.$neutral(2),
        $.indicator.color.$neutral(4),
      ),
    );

    final baseThemeOverrides = Style(
      $.indicator.color.$neutral(12),
      spec.on.disabled(
        $.container.color.$neutral(4),
        $.indicator.color.$neutral(2),
      ),
    );

    return Style(
      baseStyle(),
      baseThemeOverrides(),
      FortalezaSwitchStyle.soft(soft()),
    );
  }
}

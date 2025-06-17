import 'package:flutter/animation.dart';
import 'package:mix/mix.dart';

import '../../../components/form/radio/radio.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaRadioStyle extends RadioStyle {
  static const soft = Variant('for.radio.soft');

  const FortalezaRadioStyle();

  static List<Variant> get variants => [soft];

  @override
  Style makeStyle(SpecConfiguration<RadioSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final surfaceVariant = Style(
      $.indicator.wrap.padding.all(3.5),
      $.indicatorContainer
        ..color.$neutral(1)
        ..border.width(1)
        ..border.color.$neutral(8),
      $.indicator..color.$white(),
      $.text.style.color.$neutral(12),
      spec.on.hover(
        $.indicatorContainer
          ..color.$accentAlpha(4)
          ..border.color.$accentAlpha(8),
      ),
      spec.on.selected(
        $.indicatorContainer
          ..border.none()
          ..color.$accent(9),
      ),
      (spec.on.selected &
          spec.on.hover)($.indicatorContainer.color.$accent(11)),
      (spec.on.disabled & spec.on.selected)(
        $.indicatorContainer
          ..color.$neutral(3)
          ..border.style.solid(),
      ),
    );

    final disabledVariant = Style(
      $.indicatorContainer
        ..color.$neutral(3)
        ..border.color.$neutral(5),
      $.indicator.color.$neutral(7),
    );

    final softVariant = Style(
      $.indicatorContainer.border.none(),
      $.indicatorContainer.color.$accent(4),
      $.indicator.color.$accent(10),
      spec.on.selected($.indicatorContainer.color.$accent(4)),
      spec.on.hover($.indicatorContainer.color.$accent(5)),
      (spec.on.hover & spec.on.selected)($.indicatorContainer.color.$accent(5)),
      spec.on.disabled(
        $.indicatorContainer.color.$neutral(3),
        $.indicatorContainer.border.color.black26(),
        $.indicator.color.$neutral(8),
      ),
    );

    return Style.create(
      [
        baseStyle,
        surfaceVariant,
        spec.on.disabled(disabledVariant),
        soft(softVariant),
      ],
    ).animate(
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}

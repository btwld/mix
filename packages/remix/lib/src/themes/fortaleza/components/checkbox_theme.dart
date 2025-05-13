import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../../components/form/checkbox/checkbox.dart';
import '../tokens.dart';

class FortalezaCheckboxStyle extends CheckboxStyle {
  static const soft = Variant('for.checkbox.soft');

  const FortalezaCheckboxStyle();

  static List<Variant> get variants => [soft];

  @override
  Style makeStyle(SpecConfiguration<CheckboxSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);
    final baseOverrides = Style(
      $.indicator.wrap.scale(0.5),
      $.indicatorContainer.chain
        ..border.all.width(0)
        ..border.all.style.none(),
      $.label.style.color.$neutral(12),
      spec.on.selected($.indicator.wrap.scale(0.9)),
    );

    final surfaceVariant = Style(
      $.indicatorContainer.chain
        ..border.strokeAlign(BorderSide.strokeAlignInside)
        ..border.color.$neutral(9)
        ..border.style.solid(),
      $.indicator.color.$white(),
      spec.on.hover($.indicatorContainer.color.$neutral(3)),
      spec.on.selected(
        $.indicatorContainer.chain
          ..color.transparent()
          ..border.width(0)
          ..border.style.none()
          ..color.$accent(9),
      ),
      (spec.on.hover &
          spec.on.selected)($.indicatorContainer.color.$accent(11)),
      spec.on.disabled(
        $.indicatorContainer.color.$neutral(3),
        $.indicatorContainer.border.all.color.$neutral(9),
        spec.on.selected(
          $.indicator.color.$neutral(8),
          $.indicatorContainer.chain
            ..color.$neutral(3)
            ..border.width(1)
            ..border.all.color.$neutral(8)
            ..border.all.style.solid(),
        ),
      ),
    );

    final softVariant = Style(
      $.indicatorContainer.border.style.none(),
      $.indicatorContainer.color.$accentAlpha(6),
      $.indicator.color.$accentAlpha(11),
      spec.on.hover($.indicatorContainer.color.$accentAlpha(5)),
      (spec.on.hover &
          spec.on.selected)($.indicatorContainer.color.$accentAlpha(5)),
      spec.on.selected(
        $.indicatorContainer.color.$accentAlpha(6),
        $.indicator.color.$accentAlpha(11),
      ),
      spec.on.disabled(
        $.indicatorContainer.color.$neutral(4),
        spec.on.selected($.indicatorContainer.color.$neutral(3)),
        spec.on.selected($.indicatorContainer.border.style.none()),
      ),
    );

    final disabledVariant = Style(
      $.indicatorContainer.chain
        ..color.$neutral(3)
        ..border.color.$neutral(5),
      $.indicator.color.$neutral(7),
      $.label.style.color.$neutral(9),
    );

    return Style.create(
      [
        baseStyle(),
        baseOverrides(),
        spec.on.disabled(disabledVariant()),
        $.indicatorContainer.border.style.none(),
        surfaceVariant(),
        soft(softVariant()),
      ],
    );
  }
}

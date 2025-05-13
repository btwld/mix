import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../../components/content_presentation/accordion/accordion.dart';
import '../tokens.dart';

class FortalezaAccordionStyle extends AccordionStyle {
  const FortalezaAccordionStyle();

  @override
  Style makeStyle(SpecConfiguration<AccordionSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final style = Style(
      // Container
      $.container.chain
        ..border.all.color.$neutral(2)
        ..shape.roundedRectangle.borderRadius(6)
        ..shape.roundedRectangle.side.width(1)
        ..shape.roundedRectangle.side.strokeAlign(BorderSide.strokeAlignOutside)
        ..shape.roundedRectangle.side.color.blue()
        ..border.all.color.$neutral(7)
        ..border.all.color.withOpacity(1)
        ..borderRadius.all.$radius2()
        ..color.$neutral(2),

      // Header
      $.header.chain
        ..container.padding.horizontal.$space4()
        ..text.style.fontWeight.w400()
        ..text.style.color.$neutral(12)
        ..trailingIcon.color.$neutral(10)
        ..container.color.$neutral(1)
        ..container.animated.curve.easeInCubic()
        ..container.animated.duration(const Duration(milliseconds: 100)),

      $.contentContainer.chain
        ..padding.all.$space3()
        ..border.style.none()
        ..border.top.color.$neutral(6)
        ..animated.curve.spring(stiffness: 100)
        ..animated.duration(const Duration(milliseconds: 250)),

      // Variants
      spec.on.selected($.contentContainer.border.top.style.solid()),
      spec.on.hover(
        $.header.container.color.$neutral(3),
        $.header.text.style.decoration.none(),
      ),
    );

    return Style.create([baseStyle(), style()]);
  }
}

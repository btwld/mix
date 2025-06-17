import 'package:mix/mix.dart';

import '../../../components/form/select/select.dart';
import '../../../helpers/spec_style.dart';
import '../tokens.dart';

class FortalezaSelectStyle extends SelectStyle {
  static const soft = Variant('for.select.soft');
  static const ghost = Variant('for.select.ghost');

  const FortalezaSelectStyle();

  static List<Variant> get variants => [soft, ghost];

  @override
  Style makeStyle(SpecConfiguration<SelectSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = super.makeStyle(spec);

    final baseThemeOverrides = Style(
      $.menu.autoWidth.on(),
      $.menu.container
        ..color.$neutral(1)
        ..border.all.color.$neutral(6)
        ..wrap.intrinsicWidth()
        ..padding.all.$space2(),
      $.button
        ..container.border.all.color.$neutral(6)
        ..container.color.$neutral(1)
        ..icon.color.$accentAlpha(12)
        ..container.flex.gap.$space1()
        ..container.flex.mainAxisSize.min(),
      $.item.container.padding.horizontal.$space3(),
      spec.on.disabled(
        $.button
          ..container.color.$neutral(2)
          ..container.border.all.color.$neutral(8)
          ..label.style.color.$neutral(11)
          ..icon.color.$neutral(9),
      ),
      spec.on.hover(
        $.button.container.border.all.color.$neutral(8),
        $.item.container.color.$accent(9),
        $.item.text.style.color.$white(),
      ),
    );

    final softVariant = Style(
      $.button.container
        ..color.$accent(3)
        ..border.none(),
      $.button.label.style.color.$accent(12),
      $.item.text.style.color.$accent(12),
      spec.on.hover(
        $.button.container.color.$accent(4),
        $.item
          ..container.color.$accent(4)
          ..text.style.color.$accent(12),
      ),
    );

    final ghostVariant = Style(
      $.button.container
        ..color.transparent()
        ..border.none(),
      spec.on.hover(
        $.button.container.color.$accent(4),
        $.item
          ..container.color.$accent(4)
          ..text.style.color.$accent(12),
      ),
      spec.on.disabled(
        $.button
          ..container.color.transparent()
          ..label.style.color.$neutral(11)
          ..icon.color.$neutral(9),
      ),
    );

    return Style.create(
      [
        baseStyle,
        baseThemeOverrides,
        soft(softVariant),
        ghost(ghostVariant),
      ],
    ).animate(duration: const Duration(milliseconds: 100));
  }
}

class FortalezaDarkSelectStyle extends FortalezaSelectStyle {
  const FortalezaDarkSelectStyle();

  @override
  Style makeStyle(SpecConfiguration<SelectSpecUtility> spec) {
    final $ = spec.utilities;

    final baseStyle = Style(super.makeStyle(spec));

    final baseThemeOverrides = Style(
      $.button
        ..label.style.color.$neutral(12)
        ..container.color.$neutral(1)
        ..container.border.all.color.$neutral(7),
      $.menu.container.color.$neutral(1),
      $.item.text.style.color.$neutral(12),
      spec.on.hover($.button.container.border.all.color.$neutral(8)),
    );

    final ghost = Style(
      $.button
        ..label.style.color.$accent(12)
        ..icon.color.$accent(12)
        ..container.color.transparent()
        ..container.border.all.color.$neutral(7),
      $.item.text.style.color.$neutral(12),
    );

    return Style.create([
      baseStyle,
      baseThemeOverrides,
      FortalezaSelectStyle.ghost(ghost),
    ]);
  }
}

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../../components/button/button.dart';
import '../tokens.dart';

class FortalezaButtonStyle extends ButtonStyle {
  static const soft = Variant('for.button.soft');
  static const outline = Variant('for.button.outline');
  static const surface = Variant('for.button.surface');
  static const ghost = Variant('for.button.ghost');

  final Color? color;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double? radius;

  const FortalezaButtonStyle({
    this.color,
    this.textStyle,
    this.padding,
    this.radius,
  });

  static List<Variant> get variants => [soft, outline, surface, ghost];

  @override
  Style makeStyle(SpecConfiguration<ButtonSpecUtility> spec) {
    final $ = spec.utilities;

    Style setColor() {
      final color = this.color ?? spec.context.$color.accent();

      final disabled = Style($.container.color.$neutral(4));

      final borderedDisabled = Style(
        disabled(),
        $.container.border.color.$neutral(7),
      );

      return Style.create([
        $.container.color(color),
        spec.on.hover($.container.color(color.withValues(alpha: 0.8))),
        soft(
          $.container.color(color.withValues(alpha: 0.1)),
          $.label.style.color(color),
          spec.on.hover($.container.color(color.withValues(alpha: 0.2))),
          spec.on.disabled(disabled()),
        ),
        outline(
          $.container.color.transparent(),
          $.container.border.color(color),
          $.label.style.color(color),
          spec.on.hover(
            $.label.style.color.withOpacity(0.8),
            $.container.color.transparent(),
          ),
          spec.on.disabled(borderedDisabled()),
        ),
        surface(
          $.container.color(color.withValues(alpha: 0.1)),
          $.container.border.color(color.withValues(alpha: 0.7)),
          $.label.style.color(color),
          spec.on.hover(
            $.container.color(color.withValues(alpha: 0.2)),
            $.container.border.color.withOpacity(0.8),
          ),
          spec.on.disabled(borderedDisabled()),
        ),
        ghost(
          $.container.color.transparent(),
          $.label.style.color(color),
          spec.on.hover($.container.color.withOpacity(0.1)),
        ),
      ]);
    }

    final baseOverrides = Style(
      super.makeStyle(spec).call(),
      $.container.chain
        ..padding.vertical.$space2()
        ..padding.horizontal.$space3()
        ..flex.gap.$space2(),
      $.label.style.$text2(),
      $.icon.size(14),
      $.spinner.size(14),
    );

    final onDisabledForeground = $on.disabled(
      $.container.color.$neutralAlpha(4),
      $.label.style.color.$neutral(8),
      $.icon.color.$neutral(8),
      $.spinner.color.$neutral(8),
    );

    final overrides = Style.create([
      if (textStyle != null) $.label.style.as(textStyle!),
      if (padding != null) $.container.padding.as(padding!),
      if (radius != null) $.container.borderRadius(radius!),
    ]);

    return Style.create(
      [
        baseOverrides(),
        setColor().call(),
        onDisabledForeground,
        overrides(),
      ],
    ).animate(duration: const Duration(milliseconds: 200));
  }
}

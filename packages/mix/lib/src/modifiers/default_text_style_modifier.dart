import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';

part 'default_text_style_modifier.g.dart';

/// Modifier that applies default text styling to its descendants.
///
/// Wraps the child in a [DefaultTextStyle] widget with the specified text properties.
@MixableModifier()
final class DefaultTextStyleModifier
    extends WidgetModifier<DefaultTextStyleModifier>
    with Diagnosticable, _$DefaultTextStyleModifierMethods {
  @override
  final TextStyle style;
  @override
  final TextAlign? textAlign;
  @override
  final bool softWrap;
  @override
  final TextOverflow overflow;
  @override
  final int? maxLines;
  @override
  final TextWidthBasis textWidthBasis;
  @override
  final TextHeightBehavior? textHeightBehavior;

  const DefaultTextStyleModifier({
    TextStyle? style,
    this.textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    this.maxLines,
    TextWidthBasis? textWidthBasis,
    this.textHeightBehavior,
  }) : style = style ?? const TextStyle(),
       softWrap = softWrap ?? true,
       overflow = overflow ?? .clip,
       textWidthBasis = textWidthBasis ?? .parent;

  @override
  Widget build(Widget child) {
    return DefaultTextStyle(
      style: style,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      child: child,
    );
  }
}

/// Utility class for applying default text style modifications.
///
/// Provides convenient methods for creating DefaultTextStyleModifierMix instances.
final class DefaultTextStyleModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, DefaultTextStyleModifierMix> {
  const DefaultTextStyleModifierUtility(super.utilityBuilder);
  T call({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return utilityBuilder(
      DefaultTextStyleModifierMix(
        style: TextStyleMix.maybeValue(style),
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: TextHeightBehaviorMix.maybeValue(
          textHeightBehavior,
        ),
      ),
    );
  }
}

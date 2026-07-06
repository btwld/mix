import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../core/helpers.dart';
import '../core/widget_modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';

part 'default_text_style_modifier.g.dart';

/// Modifier that applies default text styling to its descendants.
///
/// Wraps the child in a [DefaultTextStyle] widget with the specified text properties.
@MixableModifier(lerp: false)
final class DefaultTextStyleModifier with _$DefaultTextStyleModifier {
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
  DefaultTextStyleModifier lerp(DefaultTextStyleModifier? other, double t) {
    if (other == null) return this;

    return DefaultTextStyleModifier(
      style: MixOps.lerp(style, other.style, t)!,
      textAlign: MixOps.lerpSnap(textAlign, other.textAlign, t),
      softWrap: MixOps.lerpSnap(softWrap, other.softWrap, t)!,
      overflow: MixOps.lerpSnap(overflow, other.overflow, t)!,
      maxLines: MixOps.lerpSnap(maxLines, other.maxLines, t),
      textWidthBasis: MixOps.lerpSnap(textWidthBasis, other.textWidthBasis, t)!,
      textHeightBehavior: MixOps.lerpSnap(
        textHeightBehavior,
        other.textHeightBehavior,
        t,
      ),
    );
  }

  @override
  Widget build(Widget child) {
    return DefaultTextStyle.merge(
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

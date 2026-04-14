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
    with Diagnosticable {
  final TextStyle style;
  final TextAlign? textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int? maxLines;
  final TextWidthBasis textWidthBasis;
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
  DefaultTextStyleModifier copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyleModifier(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('style', style))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(FlagProperty('softWrap', value: softWrap, ifTrue: 'soft wrap'))
      ..add(EnumProperty<TextOverflow>('overflow', overflow))
      ..add(IntProperty('maxLines', maxLines))
      ..add(EnumProperty<TextWidthBasis>('textWidthBasis', textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', textHeightBehavior));
  }

  @override
  List<Object?> get props => [
    style,
    textAlign,
    softWrap,
    overflow,
    maxLines,
    textWidthBasis,
    textHeightBehavior,
  ];

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

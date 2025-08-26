import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/helpers.dart';
import '../core/modifier.dart';
import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../properties/typography/text_height_behavior_mix.dart';
import '../properties/typography/text_style_mix.dart';

/// Modifier that applies default text styling to its descendants.
///
/// Wraps the child in a [DefaultTextStyle] widget with the specified text properties.
final class DefaultTextStyleModifier extends Modifier<DefaultTextStyleModifier>
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
       overflow = overflow ?? TextOverflow.clip,
       textWidthBasis = textWidthBasis ?? TextWidthBasis.parent;

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

/// Mix class for applying default text style modifications.
///
/// This class allows for mixing and resolving default text style properties.
class DefaultTextStyleModifierMix
    extends ModifierMix<DefaultTextStyleModifier> {
  final Prop<TextStyle>? style;
  final Prop<TextAlign>? textAlign;
  final Prop<bool>? softWrap;
  final Prop<TextOverflow>? overflow;
  final Prop<int>? maxLines;
  final Prop<TextWidthBasis>? textWidthBasis;
  final Prop<TextHeightBehavior>? textHeightBehavior;

  const DefaultTextStyleModifierMix.create({
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  DefaultTextStyleModifierMix({
    TextStyleMix? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
  }) : this.create(
         style: Prop.maybeMix(style),
         textAlign: Prop.maybe(textAlign),
         softWrap: Prop.maybe(softWrap),
         overflow: Prop.maybe(overflow),
         maxLines: Prop.maybe(maxLines),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: Prop.maybeMix(textHeightBehavior),
       );

  @override
  DefaultTextStyleModifier resolve(BuildContext context) {
    return DefaultTextStyleModifier(
      style: MixOps.resolve(context, style),
      textAlign: MixOps.resolve(context, textAlign),
      softWrap: MixOps.resolve(context, softWrap),
      overflow: MixOps.resolve(context, overflow),
      maxLines: MixOps.resolve(context, maxLines),
      textWidthBasis: MixOps.resolve(context, textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, textHeightBehavior),
    );
  }

  @override
  DefaultTextStyleModifierMix merge(DefaultTextStyleModifierMix? other) {
    if (other == null) return this;

    return DefaultTextStyleModifierMix.create(
      style: MixOps.merge(style, other.style),
      textAlign: MixOps.merge(textAlign, other.textAlign),
      softWrap: MixOps.merge(softWrap, other.softWrap),
      overflow: MixOps.merge(overflow, other.overflow),
      maxLines: MixOps.merge(maxLines, other.maxLines),
      textWidthBasis: MixOps.merge(textWidthBasis, other.textWidthBasis),
      textHeightBehavior: MixOps.merge(
        textHeightBehavior,
        other.textHeightBehavior,
      ),
    );
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
}

/// Utility class for applying default text style modifications.
///
/// Provides convenient methods for creating DefaultTextStyleModifierMix instances.
final class DefaultTextStyleModifierUtility<T extends Style<Object?>>
    extends MixUtility<T, DefaultTextStyleModifierMix> {
  const DefaultTextStyleModifierUtility(super.builder);
  T call({
    TextStyle? style,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return builder(
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

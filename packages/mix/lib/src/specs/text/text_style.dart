import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../style/abstracts/styler.dart';
import '../../style/mixins/text_style_mixin.dart';
import 'text_mutable_style.dart';
import 'text_spec.dart';
import 'text_widget.dart';

part 'text_style.g.dart';

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
@MixableStyler()
class TextStyler extends MixStyler<TextStyler, TextSpec>
    with TextStyleMixin<TextStyler>, _$TextStylerMixin {
  @override
  final Prop<TextOverflow>? $overflow;
  @override
  final Prop<StrutStyle>? $strutStyle;
  @override
  final Prop<TextAlign>? $textAlign;
  @override
  final Prop<TextScaler>? $textScaler;
  @override
  final Prop<int>? $maxLines;
  @override
  final Prop<TextStyle>? $style;
  @override
  final Prop<TextWidthBasis>? $textWidthBasis;
  @override
  final Prop<TextHeightBehavior>? $textHeightBehavior;
  @override
  final Prop<TextDirection>? $textDirection;
  @override
  final Prop<bool>? $softWrap;
  @override
  final List<Directive<String>>? $textDirectives;
  @override
  final Prop<Color>? $selectionColor;
  @override
  final Prop<String>? $semanticsLabel;
  @override
  final Prop<Locale>? $locale;

  const TextStyler.create({
    Prop<TextOverflow>? overflow,
    Prop<StrutStyle>? strutStyle,
    Prop<TextAlign>? textAlign,
    Prop<TextScaler>? textScaler,
    Prop<int>? maxLines,
    Prop<TextStyle>? style,
    Prop<TextWidthBasis>? textWidthBasis,
    Prop<TextHeightBehavior>? textHeightBehavior,
    Prop<TextDirection>? textDirection,
    Prop<bool>? softWrap,
    List<Directive<String>>? textDirectives,
    Prop<Color>? selectionColor,
    Prop<String>? semanticsLabel,
    Prop<Locale>? locale,
    super.animation,
    super.modifier,
    super.variants,
  }) : $overflow = overflow,
       $strutStyle = strutStyle,
       $textAlign = textAlign,
       $textScaler = textScaler,
       $maxLines = maxLines,
       $style = style,
       $textWidthBasis = textWidthBasis,
       $textHeightBehavior = textHeightBehavior,
       $textDirection = textDirection,
       $softWrap = softWrap,
       $textDirectives = textDirectives,
       $selectionColor = selectionColor,
       $semanticsLabel = semanticsLabel,
       $locale = locale;

  TextStyler({
    TextOverflow? overflow,
    StrutStyleMix? strutStyle,
    TextAlign? textAlign,
    TextScaler? textScaler,
    int? maxLines,
    TextStyleMix? style,
    TextWidthBasis? textWidthBasis,
    TextHeightBehaviorMix? textHeightBehavior,
    TextDirection? textDirection,
    bool? softWrap,
    List<Directive<String>>? textDirectives,
    Color? selectionColor,
    String? semanticsLabel,
    Locale? locale,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<TextSpec>>? variants,
  }) : this.create(
         overflow: Prop.maybe(overflow),
         strutStyle: Prop.maybeMix(strutStyle),
         textAlign: Prop.maybe(textAlign),
         textScaler: Prop.maybe(textScaler),
         maxLines: Prop.maybe(maxLines),
         style: Prop.maybeMix(style),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: Prop.maybeMix(textHeightBehavior),
         textDirection: Prop.maybe(textDirection),
         softWrap: Prop.maybe(softWrap),
         textDirectives: textDirectives,
         selectionColor: Prop.maybe(selectionColor),
         semanticsLabel: Prop.maybe(semanticsLabel),
         locale: Prop.maybe(locale),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  // Factory constructors for dot-shorthand notation

  // Direct constructor params
  factory TextStyler.overflow(TextOverflow value) =>
      TextStyler().overflow(value);
  factory TextStyler.textAlign(TextAlign value) =>
      TextStyler().textAlign(value);
  factory TextStyler.maxLines(int value) => TextStyler().maxLines(value);
  factory TextStyler.softWrap(bool value) => TextStyler().softWrap(value);
  factory TextStyler.textDirection(TextDirection value) =>
      TextStyler().textDirection(value);
  factory TextStyler.style(TextStyleMix value) => TextStyler().style(value);
  factory TextStyler.strutStyle(StrutStyleMix value) =>
      TextStyler().strutStyle(value);
  factory TextStyler.textWidthBasis(TextWidthBasis value) =>
      TextStyler().textWidthBasis(value);
  factory TextStyler.textScaler(TextScaler value) =>
      TextStyler().textScaler(value);
  factory TextStyler.textHeightBehavior(TextHeightBehaviorMix value) =>
      TextStyler().textHeightBehavior(value);
  factory TextStyler.selectionColor(Color value) =>
      TextStyler().selectionColor(value);
  factory TextStyler.locale(Locale value) => TextStyler().locale(value);

  // TextStyleMixin convenience
  factory TextStyler.color(Color value) => TextStyler().color(value);
  factory TextStyler.fontSize(double value) => TextStyler().fontSize(value);
  factory TextStyler.fontWeight(FontWeight value) =>
      TextStyler().fontWeight(value);
  factory TextStyler.fontStyle(FontStyle value) =>
      TextStyler().fontStyle(value);
  factory TextStyler.letterSpacing(double value) =>
      TextStyler().letterSpacing(value);
  factory TextStyler.wordSpacing(double value) =>
      TextStyler().wordSpacing(value);
  factory TextStyler.height(double value) => TextStyler().height(value);
  factory TextStyler.fontFamily(String value) => TextStyler().fontFamily(value);
  factory TextStyler.decoration(TextDecoration value) =>
      TextStyler().decoration(value);
  factory TextStyler.backgroundColor(Color value) =>
      TextStyler().backgroundColor(value);
  factory TextStyler.textBaseline(TextBaseline value) =>
      TextStyler().textBaseline(value);
  factory TextStyler.decorationColor(Color value) =>
      TextStyler().decorationColor(value);
  factory TextStyler.decorationStyle(TextDecorationStyle value) =>
      TextStyler().decorationStyle(value);
  factory TextStyler.decorationThickness(double value) =>
      TextStyler().decorationThickness(value);
  factory TextStyler.fontFamilyFallback(List<String> value) =>
      TextStyler().fontFamilyFallback(value);
  factory TextStyler.shadows(List<ShadowMix> value) =>
      TextStyler().shadows(value);
  factory TextStyler.fontFeatures(List<FontFeature> value) =>
      TextStyler().fontFeatures(value);
  factory TextStyler.fontVariations(List<FontVariation> value) =>
      TextStyler().fontVariations(value);
  factory TextStyler.foreground(Paint value) => TextStyler().foreground(value);
  factory TextStyler.background(Paint value) => TextStyler().background(value);
  // Text directives
  factory TextStyler.textDirective(Directive<String> value) =>
      TextStyler().textDirective(value);
  factory TextStyler.directive(Directive<String> value) =>
      TextStyler().directive(value);
  factory TextStyler.uppercase() => TextStyler().uppercase();
  factory TextStyler.lowercase() => TextStyler().lowercase();
  factory TextStyler.capitalize() => TextStyler().capitalize();
  factory TextStyler.titlecase() => TextStyler().titlecase();
  factory TextStyler.sentencecase() => TextStyler().sentencecase();

  static TextMutableStyler get chain => .new(TextStyler());

  StyledText call(String text) {
    return StyledText(text, style: this);
  }

  /// Sets a text directive. It will be applied to the text before it is displayed.
  TextStyler textDirective(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  /// Adds a text directive
  TextStyler directive(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  /// Applies uppercase directive
  TextStyler uppercase() {
    return merge(
      TextStyler(textDirectives: [const UppercaseStringDirective()]),
    );
  }

  /// Applies lowercase directive
  TextStyler lowercase() {
    return merge(
      TextStyler(textDirectives: [const LowercaseStringDirective()]),
    );
  }

  /// Applies capitalize directive
  TextStyler capitalize() {
    return merge(
      TextStyler(textDirectives: [const CapitalizeStringDirective()]),
    );
  }

  /// Applies title case directive
  TextStyler titlecase() {
    return merge(
      TextStyler(textDirectives: [const TitleCaseStringDirective()]),
    );
  }

  /// Applies sentence case directive
  TextStyler sentencecase() {
    return merge(
      TextStyler(textDirectives: [const SentenceCaseStringDirective()]),
    );
  }

  /// Sets the widget modifier.
  TextStyler modifier(WidgetModifierConfig value) {
    return merge(TextStyler(modifier: value));
  }
}

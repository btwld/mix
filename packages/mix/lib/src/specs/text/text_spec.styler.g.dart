// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'text_widget.dart';

import 'text_spec.dart';

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
    super.variants,
    super.modifier,
    super.animation,
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
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory TextStyler.overflow(TextOverflow value) =>
      TextStyler().overflow(value);
  factory TextStyler.strutStyle(StrutStyleMix value) =>
      TextStyler().strutStyle(value);
  factory TextStyler.textAlign(TextAlign value) =>
      TextStyler().textAlign(value);
  factory TextStyler.textScaler(TextScaler value) =>
      TextStyler().textScaler(value);
  factory TextStyler.maxLines(int value) => TextStyler().maxLines(value);
  factory TextStyler.style(TextStyleMix value) => TextStyler().style(value);
  factory TextStyler.textWidthBasis(TextWidthBasis value) =>
      TextStyler().textWidthBasis(value);
  factory TextStyler.textHeightBehavior(TextHeightBehaviorMix value) =>
      TextStyler().textHeightBehavior(value);
  factory TextStyler.textDirection(TextDirection value) =>
      TextStyler().textDirection(value);
  factory TextStyler.softWrap(bool value) => TextStyler().softWrap(value);
  factory TextStyler.selectionColor(Color value) =>
      TextStyler().selectionColor(value);
  factory TextStyler.locale(Locale value) => TextStyler().locale(value);
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
  factory TextStyler.shadow(ShadowMix value) => TextStyler().shadow(value);
  factory TextStyler.shadows(List<ShadowMix> value) =>
      TextStyler().shadows(value);
  factory TextStyler.fontFeatures(List<FontFeature> value) =>
      TextStyler().fontFeatures(value);
  factory TextStyler.fontVariations(List<FontVariation> value) =>
      TextStyler().fontVariations(value);
  factory TextStyler.foreground(Paint value) => TextStyler().foreground(value);
  factory TextStyler.background(Paint value) => TextStyler().background(value);
  factory TextStyler.textDirective(Directive<String> value) =>
      TextStyler().textDirective(value);
  factory TextStyler.directive(Directive<String> value) =>
      TextStyler().directive(value);
  factory TextStyler.uppercase() => TextStyler().uppercase();
  factory TextStyler.lowercase() => TextStyler().lowercase();
  factory TextStyler.capitalize() => TextStyler().capitalize();
  factory TextStyler.titlecase() => TextStyler().titlecase();
  factory TextStyler.sentencecase() => TextStyler().sentencecase();

  TextStyler textDirective(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  TextStyler directive(Directive<String> value) {
    return merge(TextStyler(textDirectives: [value]));
  }

  TextStyler uppercase() {
    return merge(
      TextStyler(textDirectives: [const UppercaseStringDirective()]),
    );
  }

  TextStyler lowercase() {
    return merge(
      TextStyler(textDirectives: [const LowercaseStringDirective()]),
    );
  }

  TextStyler capitalize() {
    return merge(
      TextStyler(textDirectives: [const CapitalizeStringDirective()]),
    );
  }

  TextStyler titlecase() {
    return merge(
      TextStyler(textDirectives: [const TitleCaseStringDirective()]),
    );
  }

  TextStyler sentencecase() {
    return merge(
      TextStyler(textDirectives: [const SentenceCaseStringDirective()]),
    );
  }

  StyledText call(String text, {Key? key}) {
    return StyledText(text, key: key, style: this);
  }
}

mixin _$TextStylerMixin on Style<TextSpec>, Diagnosticable {
  Prop<TextOverflow>? get $overflow;
  Prop<StrutStyle>? get $strutStyle;
  Prop<TextAlign>? get $textAlign;
  Prop<TextScaler>? get $textScaler;
  Prop<int>? get $maxLines;
  Prop<TextStyle>? get $style;
  Prop<TextWidthBasis>? get $textWidthBasis;
  Prop<TextHeightBehavior>? get $textHeightBehavior;
  Prop<TextDirection>? get $textDirection;
  Prop<bool>? get $softWrap;
  List<Directive<String>>? get $textDirectives;
  Prop<Color>? get $selectionColor;
  Prop<String>? get $semanticsLabel;
  Prop<Locale>? get $locale;

  /// Sets the overflow.
  TextStyler overflow(TextOverflow value) {
    return merge(TextStyler(overflow: value));
  }

  /// Sets the strutStyle.
  TextStyler strutStyle(StrutStyleMix value) {
    return merge(TextStyler(strutStyle: value));
  }

  /// Sets the textAlign.
  TextStyler textAlign(TextAlign value) {
    return merge(TextStyler(textAlign: value));
  }

  /// Sets the textScaler.
  TextStyler textScaler(TextScaler value) {
    return merge(TextStyler(textScaler: value));
  }

  /// Sets the maxLines.
  TextStyler maxLines(int value) {
    return merge(TextStyler(maxLines: value));
  }

  /// Sets the style.
  TextStyler style(TextStyleMix value) {
    return merge(TextStyler(style: value));
  }

  /// Sets the textWidthBasis.
  TextStyler textWidthBasis(TextWidthBasis value) {
    return merge(TextStyler(textWidthBasis: value));
  }

  /// Sets the textHeightBehavior.
  TextStyler textHeightBehavior(TextHeightBehaviorMix value) {
    return merge(TextStyler(textHeightBehavior: value));
  }

  /// Sets the textDirection.
  TextStyler textDirection(TextDirection value) {
    return merge(TextStyler(textDirection: value));
  }

  /// Sets the softWrap.
  TextStyler softWrap(bool value) {
    return merge(TextStyler(softWrap: value));
  }

  /// Sets the selectionColor.
  TextStyler selectionColor(Color value) {
    return merge(TextStyler(selectionColor: value));
  }

  /// Sets the semanticsLabel.
  TextStyler semanticsLabel(String value) {
    return merge(TextStyler(semanticsLabel: value));
  }

  /// Sets the locale.
  TextStyler locale(Locale value) {
    return merge(TextStyler(locale: value));
  }

  /// Sets the animation configuration.
  TextStyler animate(AnimationConfig value) {
    return merge(TextStyler(animation: value));
  }

  /// Sets the style variants.
  TextStyler variants(List<VariantStyle<TextSpec>> value) {
    return merge(TextStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  TextStyler wrap(WidgetModifierConfig value) {
    return merge(TextStyler(modifier: value));
  }

  /// Sets the widget modifier.
  TextStyler modifier(WidgetModifierConfig value) {
    return merge(TextStyler(modifier: value));
  }

  /// Merges with another [TextStyler].
  @override
  TextStyler merge(TextStyler? other) {
    return TextStyler.create(
      overflow: MixOps.merge($overflow, other?.$overflow),
      strutStyle: MixOps.merge($strutStyle, other?.$strutStyle),
      textAlign: MixOps.merge($textAlign, other?.$textAlign),
      textScaler: MixOps.merge($textScaler, other?.$textScaler),
      maxLines: MixOps.merge($maxLines, other?.$maxLines),
      style: MixOps.merge($style, other?.$style),
      textWidthBasis: MixOps.merge($textWidthBasis, other?.$textWidthBasis),
      textHeightBehavior: MixOps.merge(
        $textHeightBehavior,
        other?.$textHeightBehavior,
      ),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      softWrap: MixOps.merge($softWrap, other?.$softWrap),
      textDirectives: MixOps.mergeList($textDirectives, other?.$textDirectives),
      selectionColor: MixOps.merge($selectionColor, other?.$selectionColor),
      semanticsLabel: MixOps.merge($semanticsLabel, other?.$semanticsLabel),
      locale: MixOps.merge($locale, other?.$locale),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<TextSpec>] using [context].
  @override
  StyleSpec<TextSpec> resolve(BuildContext context) {
    final spec = TextSpec(
      overflow: MixOps.resolve(context, $overflow),
      strutStyle: MixOps.resolve(context, $strutStyle),
      textAlign: MixOps.resolve(context, $textAlign),
      textScaler: MixOps.resolve(context, $textScaler),
      maxLines: MixOps.resolve(context, $maxLines),
      style: MixOps.resolve(context, $style),
      textWidthBasis: MixOps.resolve(context, $textWidthBasis),
      textHeightBehavior: MixOps.resolve(context, $textHeightBehavior),
      textDirection: MixOps.resolve(context, $textDirection),
      softWrap: MixOps.resolve(context, $softWrap),
      textDirectives: $textDirectives,
      selectionColor: MixOps.resolve(context, $selectionColor),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      locale: MixOps.resolve(context, $locale),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('overflow', $overflow))
      ..add(DiagnosticsProperty('strutStyle', $strutStyle))
      ..add(DiagnosticsProperty('textAlign', $textAlign))
      ..add(DiagnosticsProperty('textScaler', $textScaler))
      ..add(DiagnosticsProperty('maxLines', $maxLines))
      ..add(DiagnosticsProperty('style', $style))
      ..add(DiagnosticsProperty('textWidthBasis', $textWidthBasis))
      ..add(DiagnosticsProperty('textHeightBehavior', $textHeightBehavior))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('softWrap', $softWrap))
      ..add(DiagnosticsProperty('directives', $textDirectives))
      ..add(DiagnosticsProperty('selectionColor', $selectionColor))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('locale', $locale));
  }

  @override
  List<Object?> get props => [
    $overflow,
    $strutStyle,
    $textAlign,
    $textScaler,
    $maxLines,
    $style,
    $textWidthBasis,
    $textHeightBehavior,
    $textDirection,
    $softWrap,
    $textDirectives,
    $selectionColor,
    $semanticsLabel,
    $locale,
    $animation,
    $modifier,
    $variants,
  ];
}

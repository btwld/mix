import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'text_mix.dart';
import 'text_spec.dart';
import 'text_widget.dart';

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextStyling extends Style<TextSpec>
    with
        Diagnosticable,
        StyleModifierMixin<TextStyling, TextSpec>,
        StyleVariantMixin<TextStyling, TextSpec>,
        StyleAnimationMixin<TextSpec, TextStyling> {
  final Prop<TextOverflow>? $overflow;
  final Prop<StrutStyle>? $strutStyle;
  final Prop<TextAlign>? $textAlign;
  final Prop<TextScaler>? $textScaler;
  final Prop<int>? $maxLines;
  final Prop<TextStyle>? $style;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final Prop<TextHeightBehavior>? $textHeightBehavior;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $softWrap;
  final List<Directive<String>>? $textDirectives;
  final Prop<Color>? $selectionColor;
  final Prop<String>? $semanticsLabel;
  final Prop<Locale>? $locale;

  /// Factory for text color
  factory TextStyling.color(Color value) {
    return TextStyling(style: TextStyleMix(color: value));
  }

  /// Factory for font family
  factory TextStyling.fontFamily(String value) {
    return TextStyling(style: TextStyleMix(fontFamily: value));
  }

  /// Factory for font weight
  factory TextStyling.fontWeight(FontWeight value) {
    return TextStyling(style: TextStyleMix(fontWeight: value));
  }

  /// Factory for font style
  factory TextStyling.fontStyle(FontStyle value) {
    return TextStyling(style: TextStyleMix(fontStyle: value));
  }

  /// Factory for font size
  factory TextStyling.fontSize(double value) {
    return TextStyling(style: TextStyleMix(fontSize: value));
  }

  /// Factory for letter spacing
  factory TextStyling.letterSpacing(double value) {
    return TextStyling(style: TextStyleMix(letterSpacing: value));
  }

  /// Factory for word spacing
  factory TextStyling.wordSpacing(double value) {
    return TextStyling(style: TextStyleMix(wordSpacing: value));
  }

  /// Factory for text baseline
  factory TextStyling.textBaseline(TextBaseline value) {
    return TextStyling(style: TextStyleMix(textBaseline: value));
  }

  /// Factory for background color
  factory TextStyling.backgroundColor(Color value) {
    return TextStyling(style: TextStyleMix(backgroundColor: value));
  }

  /// Factory for text shadows
  factory TextStyling.shadows(List<ShadowMix> value) {
    return TextStyling(style: TextStyleMix(shadows: value));
  }

  /// Factory for font features
  factory TextStyling.fontFeatures(List<FontFeature> value) {
    return TextStyling(style: TextStyleMix(fontFeatures: value));
  }

  /// Factory for font variations
  factory TextStyling.fontVariations(List<FontVariation> value) {
    return TextStyling(style: TextStyleMix(fontVariations: value));
  }

  /// Factory for text decoration
  factory TextStyling.decoration(TextDecoration value) {
    return TextStyling(style: TextStyleMix(decoration: value));
  }

  /// Factory for decoration color
  factory TextStyling.decorationColor(Color value) {
    return TextStyling(style: TextStyleMix(decorationColor: value));
  }

  /// Factory for decoration style
  factory TextStyling.decorationStyle(TextDecorationStyle value) {
    return TextStyling(style: TextStyleMix(decorationStyle: value));
  }

  /// Factory for debug label
  factory TextStyling.debugLabel(String value) {
    return TextStyling(style: TextStyleMix(debugLabel: value));
  }

  /// Factory for line height
  factory TextStyling.height(double value) {
    return TextStyling(style: TextStyleMix(height: value));
  }

  /// Factory for foreground paint
  factory TextStyling.foreground(Paint value) {
    return TextStyling(style: TextStyleMix(foreground: value));
  }

  /// Factory for background paint
  factory TextStyling.background(Paint value) {
    return TextStyling(style: TextStyleMix(background: value));
  }

  /// Factory for decoration thickness
  factory TextStyling.decorationThickness(double value) {
    return TextStyling(style: TextStyleMix(decorationThickness: value));
  }

  /// Factory for font family fallback
  factory TextStyling.fontFamilyFallback(List<String> value) {
    return TextStyling(style: TextStyleMix(fontFamilyFallback: value));
  }

  /// Factory for text overflow
  factory TextStyling.overflow(TextOverflow value) {
    return TextStyling(overflow: value);
  }

  /// Factory for strut style
  factory TextStyling.strutStyle(StrutStyleMix value) {
    return TextStyling(strutStyle: value);
  }

  /// Factory for text alignment
  factory TextStyling.textAlign(TextAlign value) {
    return TextStyling(textAlign: value);
  }

  /// Factory for text scaler
  factory TextStyling.textScaler(TextScaler value) {
    return TextStyling(textScaler: value);
  }

  /// Factory for maximum lines
  factory TextStyling.maxLines(int value) {
    return TextStyling(maxLines: value);
  }

  /// Factory for text width basis
  factory TextStyling.textWidthBasis(TextWidthBasis value) {
    return TextStyling(textWidthBasis: value);
  }

  /// Factory for text height behavior
  factory TextStyling.textHeightBehavior(TextHeightBehaviorMix value) {
    return TextStyling(textHeightBehavior: value);
  }

  /// Factory for text direction
  factory TextStyling.textDirection(TextDirection value) {
    return TextStyling(textDirection: value);
  }

  /// Factory for soft wrap
  factory TextStyling.softWrap(bool value) {
    return TextStyling(softWrap: value);
  }

  /// Factory for text directive
  factory TextStyling.textDirectives(Directive<String> value) {
    return TextStyling(textDirectives: [value]);
  }

  /// Factory for uppercase directive
  factory TextStyling.uppercase() {
    return TextStyling.textDirectives(const UppercaseStringDirective());
  }

  /// Factory for lowercase directive
  factory TextStyling.lowercase() {
    return TextStyling.textDirectives(const LowercaseStringDirective());
  }

  /// Factory for capitalize directive
  factory TextStyling.capitalize() {
    return TextStyling.textDirectives(const CapitalizeStringDirective());
  }

  /// Factory for title case directive
  factory TextStyling.titleCase() {
    return TextStyling.textDirectives(const TitleCaseStringDirective());
  }

  /// Factory for sentence case directive
  factory TextStyling.sentenceCase() {
    return TextStyling.textDirectives(const SentenceCaseStringDirective());
  }

  /// Factory for selection color
  factory TextStyling.selectionColor(Color value) {
    return TextStyling(selectionColor: value);
  }

  /// Factory for semantics label
  factory TextStyling.semanticsLabel(String value) {
    return TextStyling(semanticsLabel: value);
  }

  /// Factory for locale
  factory TextStyling.locale(Locale value) {
    return TextStyling(locale: value);
  }

  /// Factory for text style
  factory TextStyling.style(TextStyleMix value) {
    return TextStyling(style: value);
  }

  /// Factory for animation
  factory TextStyling.animate(AnimationConfig animation) {
    return TextStyling(animation: animation);
  }

  /// Factory for variant
  factory TextStyling.variant(Variant variant, TextStyling value) {
    return TextStyling(variants: [VariantStyle(variant, value)]);
  }

  factory TextStyling.textDirective(Directive<String> value) {
    return TextStyling(textDirectives: [value]);
  }

  /// Factory for widget modifier
  factory TextStyling.modifier(ModifierConfig modifier) {
    return TextStyling(modifier: modifier);
  }

  /// Factory for widget modifier
  factory TextStyling.wrap(ModifierConfig value) {
    return TextStyling(modifier: value);
  }

  const TextStyling.create({
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

    super.inherit,
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

  TextStyling({
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
    ModifierConfig? modifier,
    List<VariantStyle<TextSpec>>? variants,
    bool? inherit,
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
         inherit: inherit,
       );

  /// Constructor that accepts a [TextSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextSpec] instances to [TextStyle].
  ///
  /// ```dart
  /// const spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextStyle.value(spec);
  /// ```
  TextStyling.value(TextSpec spec)
    : this(
        overflow: spec.overflow,
        strutStyle: StrutStyleMix.maybeValue(spec.strutStyle),
        textAlign: spec.textAlign,
        textScaler: spec.textScaler,
        maxLines: spec.maxLines,
        style: TextStyleMix.maybeValue(spec.style),
        textWidthBasis: spec.textWidthBasis,
        textHeightBehavior: TextHeightBehaviorMix.maybeValue(
          spec.textHeightBehavior,
        ),
        textDirection: spec.textDirection,
        softWrap: spec.softWrap,
        textDirectives: spec.textDirectives,
        selectionColor: spec.selectionColor,
        semanticsLabel: spec.semanticsLabel,
        locale: spec.locale,
      );

  /// Constructor that accepts a nullable [TextSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextStyle.value].
  ///
  /// ```dart
  /// const TextSpec? spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextStyle.maybeValue(spec); // Returns TextStyle or null
  /// ```
  static TextStyling? maybeValue(TextSpec? spec) {
    return spec != null ? TextStyling.value(spec) : null;
  }

  /// Static factory to create from [TextMix]
  static TextStyling from(TextMix mix) {
    return TextStyling.create(
      overflow: mix.$overflow,
      strutStyle: mix.$strutStyle,
      textAlign: mix.$textAlign,
      textScaler: mix.$textScaler,
      maxLines: mix.$maxLines,
      style: mix.$style,
      textWidthBasis: mix.$textWidthBasis,
      textHeightBehavior: mix.$textHeightBehavior,
      textDirection: mix.$textDirection,
      softWrap: mix.$softWrap,
      textDirectives: mix.$textDirectives,
      selectionColor: mix.$selectionColor,
      semanticsLabel: mix.$semanticsLabel,
      locale: mix.$locale,
    );
  }

  StyledText call(String text) {
    return StyledText(text, style: this);
  }

  TextStyling textDirective(Directive<String> value) {
    return merge(TextStyling.textDirectives(value));
  }

  /// Sets text overflow behavior
  TextStyling overflow(TextOverflow value) {
    return merge(TextStyling.overflow(value));
  }

  /// Sets strut style
  TextStyling strutStyle(StrutStyleMix value) {
    return merge(TextStyling.strutStyle(value));
  }

  /// Sets text alignment
  TextStyling textAlign(TextAlign value) {
    return merge(TextStyling.textAlign(value));
  }

  /// Sets text scaler
  TextStyling textScaler(TextScaler value) {
    return merge(TextStyling.textScaler(value));
  }

  /// Sets maximum number of lines
  TextStyling maxLines(int value) {
    return merge(TextStyling.maxLines(value));
  }

  /// Sets text style
  TextStyling style(TextStyleMix value) {
    return merge(TextStyling(style: value));
  }

  /// Sets text width basis
  TextStyling textWidthBasis(TextWidthBasis value) {
    return merge(TextStyling.textWidthBasis(value));
  }

  /// Sets text height behavior
  TextStyling textHeightBehavior(TextHeightBehaviorMix value) {
    return merge(TextStyling.textHeightBehavior(value));
  }

  /// Sets text direction
  TextStyling textDirection(TextDirection value) {
    return merge(TextStyling.textDirection(value));
  }

  /// Sets soft wrap behavior
  TextStyling softWrap(bool value) {
    return merge(TextStyling.softWrap(value));
  }

  /// Adds a text directive
  TextStyling directive(Directive<String> value) {
    return merge(TextStyling.textDirectives(value));
  }

  /// Sets text color
  TextStyling color(Color value) {
    return merge(TextStyling.color(value));
  }

  /// Sets font family
  TextStyling fontFamily(String value) {
    return merge(TextStyling.fontFamily(value));
  }

  /// Sets font weight
  TextStyling fontWeight(FontWeight value) {
    return merge(TextStyling.fontWeight(value));
  }

  /// Sets font style
  TextStyling fontStyle(FontStyle value) {
    return merge(TextStyling.fontStyle(value));
  }

  /// Sets font size
  TextStyling fontSize(double value) {
    return merge(TextStyling.fontSize(value));
  }

  /// Sets letter spacing
  TextStyling letterSpacing(double value) {
    return merge(TextStyling.letterSpacing(value));
  }

  /// Sets word spacing
  TextStyling wordSpacing(double value) {
    return merge(TextStyling.wordSpacing(value));
  }

  /// Sets text baseline
  TextStyling textBaseline(TextBaseline value) {
    return merge(TextStyling.textBaseline(value));
  }

  /// Sets background color
  TextStyling backgroundColor(Color value) {
    return merge(TextStyling.backgroundColor(value));
  }

  /// Sets text shadows
  TextStyling shadows(List<ShadowMix> value) {
    return merge(TextStyling.shadows(value));
  }

  /// Sets font features
  TextStyling fontFeatures(List<FontFeature> value) {
    return merge(TextStyling.fontFeatures(value));
  }

  /// Sets font variations
  TextStyling fontVariations(List<FontVariation> value) {
    return merge(TextStyling.fontVariations(value));
  }

  /// Sets text decoration
  TextStyling decoration(TextDecoration value) {
    return merge(TextStyling.decoration(value));
  }

  /// Sets decoration color
  TextStyling decorationColor(Color value) {
    return merge(TextStyling.decorationColor(value));
  }

  /// Sets decoration style
  TextStyling decorationStyle(TextDecorationStyle value) {
    return merge(TextStyling.decorationStyle(value));
  }

  /// Sets debug label
  TextStyling debugLabel(String value) {
    return merge(TextStyling.debugLabel(value));
  }

  /// Sets line height
  TextStyling height(double value) {
    return merge(TextStyling.height(value));
  }

  /// Sets foreground paint
  TextStyling foreground(Paint value) {
    return merge(TextStyling.foreground(value));
  }

  /// Sets background paint
  TextStyling background(Paint value) {
    return merge(TextStyling.background(value));
  }

  /// Sets selection color
  TextStyling selectionColor(Color value) {
    return merge(TextStyling.selectionColor(value));
  }

  /// Sets semantics label
  TextStyling semanticsLabel(String value) {
    return merge(TextStyling.semanticsLabel(value));
  }

  /// Sets locale
  TextStyling locale(Locale value) {
    return merge(TextStyling.locale(value));
  }

  /// Sets decoration thickness
  TextStyling decorationThickness(double value) {
    return merge(TextStyling.decorationThickness(value));
  }

  /// Sets font family fallback
  TextStyling fontFamilyFallback(List<String> value) {
    return merge(TextStyling.fontFamilyFallback(value));
  }

  /// Applies uppercase directive
  TextStyling uppercase() {
    return merge(TextStyling.uppercase());
  }

  /// Applies lowercase directive
  TextStyling lowercase() {
    return merge(TextStyling.lowercase());
  }

  /// Applies capitalize directive
  TextStyling capitalize() {
    return merge(TextStyling.capitalize());
  }

  /// Applies title case directive
  TextStyling titleCase() {
    return merge(TextStyling.titleCase());
  }

  /// Applies sentence case directive
  TextStyling sentenceCase() {
    return merge(TextStyling.sentenceCase());
  }

  TextStyling modifier(ModifierConfig value) {
    return merge(TextStyling(modifier: value));
  }

  /// Convenience method for animating the TextSpec
  @override
  TextStyling animate(AnimationConfig animation) {
    return merge(TextStyling.animate(animation));
  }

  @override
  TextStyling variants(List<VariantStyle<TextSpec>> variants) {
    return merge(TextStyling(variants: variants));
  }

  /// Resolves to [TextSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final textSpec = TextStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<TextSpec> resolve(BuildContext context) {
    final textSpec = TextSpec(
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
    
    return WidgetSpec(
      spec: textSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  /// Merges the properties of this [TextStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextStyling merge(TextStyling? other) {
    if (other == null) return this;

    return TextStyling.create(
      overflow: MixOps.merge($overflow, other.$overflow),
      strutStyle: MixOps.merge($strutStyle, other.$strutStyle),
      textAlign: MixOps.merge($textAlign, other.$textAlign),
      textScaler: MixOps.merge($textScaler, other.$textScaler),
      maxLines: MixOps.merge($maxLines, other.$maxLines),
      style: MixOps.merge($style, other.$style),
      textWidthBasis: MixOps.merge($textWidthBasis, other.$textWidthBasis),
      textHeightBehavior: MixOps.merge(
        $textHeightBehavior,
        other.$textHeightBehavior,
      ),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      softWrap: MixOps.merge($softWrap, other.$softWrap),
      textDirectives: MixOps.mergeList($textDirectives, other.$textDirectives),
      selectionColor: MixOps.merge($selectionColor, other.$selectionColor),
      semanticsLabel: MixOps.merge($semanticsLabel, other.$semanticsLabel),
      locale: MixOps.merge($locale, other.$locale),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
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
      ..add(DiagnosticsProperty('selectionColor', $selectionColor))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('locale', $locale))
      ..add(DiagnosticsProperty('directives', $textDirectives));
  }

  @override
  TextStyling variant(Variant variant, TextStyling style) {
    return merge(TextStyling(variants: [VariantStyle(variant, style)]));
  }

  @override
  TextStyling wrap(ModifierConfig value) {
    return modifier(value);
  }

  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextStyle] instances for equality.
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

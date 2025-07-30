import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/directive.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/typography/strut_style_mix.dart';
import '../../properties/typography/text_height_behavior_mix.dart';
import '../../properties/typography/text_style_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'text_spec.dart';

/// Represents the attributes of a [TextSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextSpec].
///
/// Use this class to configure the attributes of a [TextSpec] and pass it to
/// the [TextSpec] constructor.
class TextMix extends Style<TextSpec>
    with
        Diagnosticable,
        StyleModifierMixin<TextMix, TextSpec>,
        StyleVariantMixin<TextMix, TextSpec> {
  final Prop<TextOverflow>? $overflow;
  final MixProp<StrutStyle>? $strutStyle;
  final Prop<TextAlign>? $textAlign;
  final Prop<TextScaler>? $textScaler;
  final Prop<int>? $maxLines;
  final MixProp<TextStyle>? $style;
  final Prop<TextWidthBasis>? $textWidthBasis;
  final MixProp<TextHeightBehavior>? $textHeightBehavior;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $softWrap;
  final List<MixDirective<String>>? $directives;

  /// Factory for text color
  factory TextMix.color(Color value) {
    return TextMix(style: TextStyleMix(color: value));
  }

  /// Factory for font family
  factory TextMix.fontFamily(String value) {
    return TextMix(style: TextStyleMix(fontFamily: value));
  }

  /// Factory for font weight
  factory TextMix.fontWeight(FontWeight value) {
    return TextMix(style: TextStyleMix(fontWeight: value));
  }

  /// Factory for font style
  factory TextMix.fontStyle(FontStyle value) {
    return TextMix(style: TextStyleMix(fontStyle: value));
  }

  /// Factory for font size
  factory TextMix.fontSize(double value) {
    return TextMix(style: TextStyleMix(fontSize: value));
  }

  /// Factory for letter spacing
  factory TextMix.letterSpacing(double value) {
    return TextMix(style: TextStyleMix(letterSpacing: value));
  }

  /// Factory for word spacing
  factory TextMix.wordSpacing(double value) {
    return TextMix(style: TextStyleMix(wordSpacing: value));
  }

  /// Factory for text baseline
  factory TextMix.textBaseline(TextBaseline value) {
    return TextMix(style: TextStyleMix(textBaseline: value));
  }

  /// Factory for background color
  factory TextMix.backgroundColor(Color value) {
    return TextMix(style: TextStyleMix(backgroundColor: value));
  }

  /// Factory for text shadows
  factory TextMix.shadows(List<ShadowMix> value) {
    return TextMix(style: TextStyleMix(shadows: value));
  }

  /// Factory for font features
  factory TextMix.fontFeatures(List<FontFeature> value) {
    return TextMix(style: TextStyleMix(fontFeatures: value));
  }

  /// Factory for font variations
  factory TextMix.fontVariations(List<FontVariation> value) {
    return TextMix(style: TextStyleMix(fontVariations: value));
  }

  /// Factory for text decoration
  factory TextMix.decoration(TextDecoration value) {
    return TextMix(style: TextStyleMix(decoration: value));
  }

  /// Factory for decoration color
  factory TextMix.decorationColor(Color value) {
    return TextMix(style: TextStyleMix(decorationColor: value));
  }

  /// Factory for decoration style
  factory TextMix.decorationStyle(TextDecorationStyle value) {
    return TextMix(style: TextStyleMix(decorationStyle: value));
  }

  /// Factory for debug label
  factory TextMix.debugLabel(String value) {
    return TextMix(style: TextStyleMix(debugLabel: value));
  }

  /// Factory for line height
  factory TextMix.height(double value) {
    return TextMix(style: TextStyleMix(height: value));
  }

  /// Factory for foreground paint
  factory TextMix.foreground(Paint value) {
    return TextMix(style: TextStyleMix(foreground: value));
  }

  /// Factory for background paint
  factory TextMix.background(Paint value) {
    return TextMix(style: TextStyleMix(background: value));
  }

  /// Factory for decoration thickness
  factory TextMix.decorationThickness(double value) {
    return TextMix(style: TextStyleMix(decorationThickness: value));
  }

  /// Factory for font family fallback
  factory TextMix.fontFamilyFallback(List<String> value) {
    return TextMix(style: TextStyleMix(fontFamilyFallback: value));
  }

  /// Factory for text overflow
  factory TextMix.overflow(TextOverflow value) {
    return TextMix(overflow: value);
  }

  /// Factory for strut style
  factory TextMix.strutStyle(StrutStyleMix value) {
    return TextMix(strutStyle: value);
  }

  /// Factory for text alignment
  factory TextMix.textAlign(TextAlign value) {
    return TextMix(textAlign: value);
  }

  /// Factory for text scaler
  factory TextMix.textScaler(TextScaler value) {
    return TextMix(textScaler: value);
  }

  /// Factory for maximum lines
  factory TextMix.maxLines(int value) {
    return TextMix(maxLines: value);
  }

  /// Factory for text width basis
  factory TextMix.textWidthBasis(TextWidthBasis value) {
    return TextMix(textWidthBasis: value);
  }

  /// Factory for text height behavior
  factory TextMix.textHeightBehavior(TextHeightBehaviorMix value) {
    return TextMix(textHeightBehavior: value);
  }

  /// Factory for text direction
  factory TextMix.textDirection(TextDirection value) {
    return TextMix(textDirection: value);
  }

  /// Factory for soft wrap
  factory TextMix.softWrap(bool value) {
    return TextMix(softWrap: value);
  }

  /// Factory for text directive
  factory TextMix.directive(MixDirective<String> value) {
    return TextMix(directives: [value]);
  }

  /// Factory for uppercase directive
  factory TextMix.uppercase() {
    return TextMix.directive(const UppercaseStringDirective());
  }

  /// Factory for lowercase directive
  factory TextMix.lowercase() {
    return TextMix.directive(const LowercaseStringDirective());
  }

  /// Factory for capitalize directive
  factory TextMix.capitalize() {
    return TextMix.directive(const CapitalizeStringDirective());
  }

  /// Factory for title case directive
  factory TextMix.titleCase() {
    return TextMix.directive(const TitleCaseStringDirective());
  }

  /// Factory for sentence case directive
  factory TextMix.sentenceCase() {
    return TextMix.directive(const SentenceCaseStringDirective());
  }

  /// Factory for animation
  factory TextMix.animate(AnimationConfig animation) {
    return TextMix(animation: animation);
  }

  /// Factory for variant
  factory TextMix.variant(Variant variant, TextMix value) {
    return TextMix(variants: [VariantStyleAttribute(variant, value)]);
  }

  factory TextMix.contentModifier(MixDirective<String> value) {
    return TextMix(directives: [value]);
  }

  const TextMix.raw({
    Prop<TextOverflow>? overflow,
    MixProp<StrutStyle>? strutStyle,
    Prop<TextAlign>? textAlign,
    Prop<TextScaler>? textScaler,
    Prop<int>? maxLines,
    MixProp<TextStyle>? style,
    Prop<TextWidthBasis>? textWidthBasis,
    MixProp<TextHeightBehavior>? textHeightBehavior,
    Prop<TextDirection>? textDirection,
    Prop<bool>? softWrap,
    List<MixDirective<String>>? directives,
    super.animation,
    super.modifierConfig,
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
       $directives = directives;

  TextMix({
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
    List<MixDirective<String>>? directives,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<TextSpec>>? variants,
    bool? inherit,
  }) : this.raw(
         overflow: Prop.maybe(overflow),
         strutStyle: MixProp.maybe(strutStyle),
         textAlign: Prop.maybe(textAlign),
         textScaler: Prop.maybe(textScaler),
         maxLines: Prop.maybe(maxLines),
         style: MixProp.maybe(style),
         textWidthBasis: Prop.maybe(textWidthBasis),
         textHeightBehavior: MixProp.maybe(textHeightBehavior),
         textDirection: Prop.maybe(textDirection),
         softWrap: Prop.maybe(softWrap),
         directives: directives,
         animation: animation,
         modifierConfig: modifierConfig,
         variants: variants,
         inherit: inherit,
       );

  /// Constructor that accepts a [TextSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextSpec] instances to [TextMix].
  ///
  /// ```dart
  /// const spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextMix.value(spec);
  /// ```
  TextMix.value(TextSpec spec)
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
        directives: spec.directives,
      );

  /// Constructor that accepts a nullable [TextSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextMix.value].
  ///
  /// ```dart
  /// const TextSpec? spec = TextSpec(overflow: TextOverflow.ellipsis, maxLines: 2);
  /// final attr = TextMix.maybeValue(spec); // Returns TextMix or null
  /// ```
  static TextMix? maybeValue(TextSpec? spec) {
    return spec != null ? TextMix.value(spec) : null;
  }

  TextMix contentModifier(MixDirective<String> value) {
    return merge(TextMix.directive(value));
  }

  /// Sets text overflow behavior
  TextMix overflow(TextOverflow value) {
    return merge(TextMix.overflow(value));
  }

  /// Sets strut style
  TextMix strutStyle(StrutStyleMix value) {
    return merge(TextMix.strutStyle(value));
  }

  /// Sets text alignment
  TextMix textAlign(TextAlign value) {
    return merge(TextMix.textAlign(value));
  }

  /// Sets text scaler
  TextMix textScaler(TextScaler value) {
    return merge(TextMix.textScaler(value));
  }

  /// Sets maximum number of lines
  TextMix maxLines(int value) {
    return merge(TextMix.maxLines(value));
  }

  /// Sets text style
  TextMix style(TextStyleMix value) {
    return merge(TextMix(style: value));
  }

  /// Sets text width basis
  TextMix textWidthBasis(TextWidthBasis value) {
    return merge(TextMix.textWidthBasis(value));
  }

  /// Sets text height behavior
  TextMix textHeightBehavior(TextHeightBehaviorMix value) {
    return merge(TextMix.textHeightBehavior(value));
  }

  /// Sets text direction
  TextMix textDirection(TextDirection value) {
    return merge(TextMix.textDirection(value));
  }

  /// Sets soft wrap behavior
  TextMix softWrap(bool value) {
    return merge(TextMix.softWrap(value));
  }

  /// Adds a text directive
  TextMix directive(MixDirective<String> value) {
    return merge(TextMix.directive(value));
  }

  /// Sets text color
  TextMix color(Color value) {
    return merge(TextMix.color(value));
  }

  /// Sets font family
  TextMix fontFamily(String value) {
    return merge(TextMix.fontFamily(value));
  }

  /// Sets font weight
  TextMix fontWeight(FontWeight value) {
    return merge(TextMix.fontWeight(value));
  }

  /// Sets font style
  TextMix fontStyle(FontStyle value) {
    return merge(TextMix.fontStyle(value));
  }

  /// Sets font size
  TextMix fontSize(double value) {
    return merge(TextMix.fontSize(value));
  }

  /// Sets letter spacing
  TextMix letterSpacing(double value) {
    return merge(TextMix.letterSpacing(value));
  }

  /// Sets word spacing
  TextMix wordSpacing(double value) {
    return merge(TextMix.wordSpacing(value));
  }

  /// Sets text baseline
  TextMix textBaseline(TextBaseline value) {
    return merge(TextMix.textBaseline(value));
  }

  /// Sets background color
  TextMix backgroundColor(Color value) {
    return merge(TextMix.backgroundColor(value));
  }

  /// Sets text shadows
  TextMix shadows(List<ShadowMix> value) {
    return merge(TextMix.shadows(value));
  }

  /// Sets font features
  TextMix fontFeatures(List<FontFeature> value) {
    return merge(TextMix.fontFeatures(value));
  }

  /// Sets font variations
  TextMix fontVariations(List<FontVariation> value) {
    return merge(TextMix.fontVariations(value));
  }

  /// Sets text decoration
  TextMix decoration(TextDecoration value) {
    return merge(TextMix.decoration(value));
  }

  /// Sets decoration color
  TextMix decorationColor(Color value) {
    return merge(TextMix.decorationColor(value));
  }

  /// Sets decoration style
  TextMix decorationStyle(TextDecorationStyle value) {
    return merge(TextMix.decorationStyle(value));
  }

  /// Sets debug label
  TextMix debugLabel(String value) {
    return merge(TextMix.debugLabel(value));
  }

  /// Sets line height
  TextMix height(double value) {
    return merge(TextMix.height(value));
  }

  /// Sets foreground paint
  TextMix foreground(Paint value) {
    return merge(TextMix.foreground(value));
  }

  /// Sets background paint
  TextMix background(Paint value) {
    return merge(TextMix.background(value));
  }

  /// Sets decoration thickness
  TextMix decorationThickness(double value) {
    return merge(TextMix.decorationThickness(value));
  }

  /// Sets font family fallback
  TextMix fontFamilyFallback(List<String> value) {
    return merge(TextMix.fontFamilyFallback(value));
  }

  /// Applies uppercase directive
  TextMix uppercase() {
    return merge(TextMix.uppercase());
  }

  /// Applies lowercase directive
  TextMix lowercase() {
    return merge(TextMix.lowercase());
  }

  /// Applies capitalize directive
  TextMix capitalize() {
    return merge(TextMix.capitalize());
  }

  /// Applies title case directive
  TextMix titleCase() {
    return merge(TextMix.titleCase());
  }

  /// Applies sentence case directive
  TextMix sentenceCase() {
    return merge(TextMix.sentenceCase());
  }

  /// Convenience method for animating the TextSpec
  TextMix animate(AnimationConfig animation) {
    return merge(TextMix.animate(animation));
  }

  @override
  TextMix variants(List<VariantStyleAttribute<TextSpec>> variants) {
    return merge(TextMix(variants: variants));
  }

  @override
  TextMix modifier(ModifierConfig value) {
    return merge(TextMix(modifierConfig: value));
  }

  /// Resolves to [TextSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final textSpec = TextMix(...).resolve(context);
  /// ```
  @override
  TextSpec resolve(BuildContext context) {
    return TextSpec(
      overflow: MixHelpers.resolve(context, $overflow),
      strutStyle: MixHelpers.resolve(context, $strutStyle),
      textAlign: MixHelpers.resolve(context, $textAlign),
      textScaler: MixHelpers.resolve(context, $textScaler),
      maxLines: MixHelpers.resolve(context, $maxLines),
      style: MixHelpers.resolve(context, $style),
      textWidthBasis: MixHelpers.resolve(context, $textWidthBasis),
      textHeightBehavior: MixHelpers.resolve(context, $textHeightBehavior),
      textDirection: MixHelpers.resolve(context, $textDirection),
      softWrap: MixHelpers.resolve(context, $softWrap),
      directives: $directives,
    );
  }

  /// Merges the properties of this [TextMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextMix merge(TextMix? other) {
    if (other == null) return this;

    return TextMix.raw(
      overflow: MixHelpers.merge($overflow, other.$overflow),
      strutStyle: MixHelpers.merge($strutStyle, other.$strutStyle),
      textAlign: MixHelpers.merge($textAlign, other.$textAlign),
      textScaler: MixHelpers.merge($textScaler, other.$textScaler),
      maxLines: MixHelpers.merge($maxLines, other.$maxLines),
      style: MixHelpers.merge($style, other.$style),
      textWidthBasis: MixHelpers.merge($textWidthBasis, other.$textWidthBasis),
      textHeightBehavior: MixHelpers.merge(
        $textHeightBehavior,
        other.$textHeightBehavior,
      ),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      softWrap: MixHelpers.merge($softWrap, other.$softWrap),
      directives: MixHelpers.mergeList(
        $directives,
        other.$directives,
        strategy: ListMergeStrategy.append,
      ),
      animation: other.$animation ?? $animation,
      modifierConfig:
          $modifierConfig?.merge(other.$modifierConfig) ??
          other.$modifierConfig,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('overflow', $overflow, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('strutStyle', $strutStyle, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textAlign', $textAlign, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textScaler', $textScaler, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('maxLines', $maxLines, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('style', $style, defaultValue: null));
    properties.add(
      DiagnosticsProperty(
        'textWidthBasis',
        $textWidthBasis,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'textHeightBehavior',
        $textHeightBehavior,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('softWrap', $softWrap, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('directive', $directives, defaultValue: null),
    );

    properties.add(
      DiagnosticsProperty('directives', $directives, defaultValue: null),
    );
  }

  @override
  TextMix variant(Variant variant, TextMix style) {
    return merge(TextMix(variants: [VariantStyleAttribute(variant, style)]));
  }

  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextMix] instances for equality.
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
    $directives,
    $animation,
    $modifierConfig,
    $variants,
  ];
}

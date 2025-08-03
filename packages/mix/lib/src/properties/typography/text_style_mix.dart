import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../painting/shadow_mix.dart';

/// Mix-compatible representation of Flutter's [TextStyle] with comprehensive styling properties.
///
/// Provides text styling capabilities including font, color, decoration, spacing, and shadow
/// properties with resolvable tokens and merging capabilities for flexible text appearance.
@immutable
class TextStyleMix extends Mix<TextStyle> with Diagnosticable {
  // Simple properties use MixValue directly
  final Prop<Color>? $color;
  final Prop<Color>? $backgroundColor;
  final Prop<double>? $fontSize;
  final Prop<FontWeight>? $fontWeight;
  final Prop<FontStyle>? $fontStyle;
  final Prop<double>? $letterSpacing;
  final Prop<String>? $debugLabel;
  final Prop<double>? $wordSpacing;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<TextDecoration>? $decoration;
  final Prop<Color>? $decorationColor;
  final Prop<TextDecorationStyle>? $decorationStyle;
  final Prop<double>? $height;
  final Prop<double>? $decorationThickness;
  final Prop<String>? $fontFamily;
  final Prop<Paint>? $foreground;
  final Prop<Paint>? $background;
  final Prop<bool>? $inherit;

  // Lists of MixValues for simple types
  final List<Prop<String>>? $fontFamilyFallback;
  final List<Prop<FontFeature>>? $fontFeatures;
  final List<Prop<FontVariation>>? $fontVariations;

  // Lists of Mix types
  final List<MixProp<Shadow>>? $shadows;

  /// Factory for text color
  factory TextStyleMix.color(Color value) {
    return TextStyleMix(color: value);
  }

  /// Factory for background color
  factory TextStyleMix.backgroundColor(Color value) {
    return TextStyleMix(backgroundColor: value);
  }

  /// Factory for font size
  factory TextStyleMix.fontSize(double value) {
    return TextStyleMix(fontSize: value);
  }

  /// Factory for font weight
  factory TextStyleMix.fontWeight(FontWeight value) {
    return TextStyleMix(fontWeight: value);
  }

  /// Factory for font style
  factory TextStyleMix.fontStyle(FontStyle value) {
    return TextStyleMix(fontStyle: value);
  }

  /// Factory for letter spacing
  factory TextStyleMix.letterSpacing(double value) {
    return TextStyleMix(letterSpacing: value);
  }

  /// Factory for debug label
  factory TextStyleMix.debugLabel(String value) {
    return TextStyleMix(debugLabel: value);
  }

  /// Factory for word spacing
  factory TextStyleMix.wordSpacing(double value) {
    return TextStyleMix(wordSpacing: value);
  }

  /// Factory for text baseline
  factory TextStyleMix.textBaseline(TextBaseline value) {
    return TextStyleMix(textBaseline: value);
  }

  /// Factory for shadows
  factory TextStyleMix.shadows(List<ShadowMix> value) {
    return TextStyleMix(shadows: value);
  }

  /// Factory for font features
  factory TextStyleMix.fontFeatures(List<FontFeature> value) {
    return TextStyleMix(fontFeatures: value);
  }

  /// Factory for text decoration
  factory TextStyleMix.decoration(TextDecoration value) {
    return TextStyleMix(decoration: value);
  }

  /// Factory for decoration color
  factory TextStyleMix.decorationColor(Color value) {
    return TextStyleMix(decorationColor: value);
  }

  /// Factory for decoration style
  factory TextStyleMix.decorationStyle(TextDecorationStyle value) {
    return TextStyleMix(decorationStyle: value);
  }

  /// Factory for font variations
  factory TextStyleMix.fontVariations(List<FontVariation> value) {
    return TextStyleMix(fontVariations: value);
  }

  /// Factory for line height
  factory TextStyleMix.height(double value) {
    return TextStyleMix(height: value);
  }

  /// Factory for foreground paint
  factory TextStyleMix.foreground(Paint value) {
    return TextStyleMix(foreground: value);
  }

  /// Factory for background paint
  factory TextStyleMix.background(Paint value) {
    return TextStyleMix(background: value);
  }

  /// Factory for decoration thickness
  factory TextStyleMix.decorationThickness(double value) {
    return TextStyleMix(decorationThickness: value);
  }

  /// Factory for font family
  factory TextStyleMix.fontFamily(String value) {
    return TextStyleMix(fontFamily: value);
  }

  /// Factory for font family fallback
  factory TextStyleMix.fontFamilyFallback(List<String> value) {
    return TextStyleMix(fontFamilyFallback: value);
  }

  /// Factory for inherit
  factory TextStyleMix.inherit(bool value) {
    return TextStyleMix(inherit: value);
  }

  TextStyleMix({
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    String? debugLabel,
    double? wordSpacing,
    TextBaseline? textBaseline,
    List<ShadowMix>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    List<FontVariation>? fontVariations,
    double? height,
    Paint? foreground,
    Paint? background,
    double? decorationThickness,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    bool? inherit,
  }) : this.raw(
         color: Prop.maybe(color),
         backgroundColor: Prop.maybe(backgroundColor),
         fontSize: Prop.maybe(fontSize),
         fontWeight: Prop.maybe(fontWeight),
         fontStyle: Prop.maybe(fontStyle),
         letterSpacing: Prop.maybe(letterSpacing),
         debugLabel: Prop.maybe(debugLabel),
         wordSpacing: Prop.maybe(wordSpacing),
         textBaseline: Prop.maybe(textBaseline),
         shadows: shadows?.map(MixProp<Shadow>.new).toList(),
         fontFeatures: fontFeatures?.map(Prop.value).toList(),
         decoration: Prop.maybe(decoration),
         decorationColor: Prop.maybe(decorationColor),
         decorationStyle: Prop.maybe(decorationStyle),
         fontVariations: fontVariations?.map(Prop.value).toList(),
         height: Prop.maybe(height),
         foreground: Prop.maybe(foreground),
         background: Prop.maybe(background),
         decorationThickness: Prop.maybe(decorationThickness),
         fontFamily: Prop.maybe(fontFamily),
         fontFamilyFallback: fontFamilyFallback?.map(Prop.value).toList(),
         inherit: Prop.maybe(inherit),
       );

  const TextStyleMix.raw({
    Prop<Color>? color,
    Prop<Color>? backgroundColor,
    Prop<double>? fontSize,
    Prop<FontWeight>? fontWeight,
    Prop<FontStyle>? fontStyle,
    Prop<double>? letterSpacing,
    Prop<String>? debugLabel,
    Prop<double>? wordSpacing,
    Prop<TextBaseline>? textBaseline,
    List<MixProp<Shadow>>? shadows,
    List<Prop<FontFeature>>? fontFeatures,
    Prop<TextDecoration>? decoration,
    Prop<Color>? decorationColor,
    Prop<TextDecorationStyle>? decorationStyle,
    List<Prop<FontVariation>>? fontVariations,
    Prop<double>? height,
    Prop<Paint>? foreground,
    Prop<Paint>? background,
    Prop<double>? decorationThickness,
    Prop<String>? fontFamily,
    List<Prop<String>>? fontFamilyFallback,
    Prop<bool>? inherit,
  }) : $color = color,
       $backgroundColor = backgroundColor,
       $fontSize = fontSize,
       $fontWeight = fontWeight,
       $fontStyle = fontStyle,
       $letterSpacing = letterSpacing,
       $debugLabel = debugLabel,
       $wordSpacing = wordSpacing,
       $textBaseline = textBaseline,
       $shadows = shadows,
       $fontFeatures = fontFeatures,
       $decoration = decoration,
       $decorationColor = decorationColor,
       $decorationStyle = decorationStyle,
       $fontVariations = fontVariations,
       $height = height,
       $foreground = foreground,
       $background = background,
       $decorationThickness = decorationThickness,
       $fontFamily = fontFamily,
       $fontFamilyFallback = fontFamilyFallback,
       $inherit = inherit;

  /// Creates a [TextStyleMix] from an existing [TextStyle].
  TextStyleMix.value(TextStyle textStyle)
    : this(
        color: textStyle.color,
        backgroundColor: textStyle.backgroundColor,
        fontSize: textStyle.fontSize,
        fontWeight: textStyle.fontWeight,
        fontStyle: textStyle.fontStyle,
        letterSpacing: textStyle.letterSpacing,
        debugLabel: textStyle.debugLabel,
        wordSpacing: textStyle.wordSpacing,
        textBaseline: textStyle.textBaseline,
        shadows: textStyle.shadows?.map(ShadowMix.value).toList(),
        fontFeatures: textStyle.fontFeatures,
        decoration: textStyle.decoration,
        decorationColor: textStyle.decorationColor,
        decorationStyle: textStyle.decorationStyle,
        fontVariations: textStyle.fontVariations,
        height: textStyle.height,
        foreground: textStyle.foreground,
        background: textStyle.background,
        decorationThickness: textStyle.decorationThickness,
        fontFamily: textStyle.fontFamily,
        fontFamilyFallback: textStyle.fontFamilyFallback,
        inherit: textStyle.inherit,
      );

  /// Constructor that accepts a nullable [TextStyle] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextStyleMix.value].
  ///
  /// ```dart
  /// const TextStyle? textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
  /// final dto = TextStyleMix.maybeValue(textStyle); // Returns TextStyleMix or null
  /// ```
  static TextStyleMix? maybeValue(TextStyle? textStyle) {
    return textStyle != null ? TextStyleMix.value(textStyle) : null;
  }

  /// Sets text color
  TextStyleMix color(Color value) {
    return merge(TextStyleMix.color(value));
  }

  /// Sets background color
  TextStyleMix backgroundColor(Color value) {
    return merge(TextStyleMix.backgroundColor(value));
  }

  /// Sets font size
  TextStyleMix fontSize(double value) {
    return merge(TextStyleMix.fontSize(value));
  }

  /// Sets font weight
  TextStyleMix fontWeight(FontWeight value) {
    return merge(TextStyleMix.fontWeight(value));
  }

  /// Sets font style
  TextStyleMix fontStyle(FontStyle value) {
    return merge(TextStyleMix.fontStyle(value));
  }

  /// Sets letter spacing
  TextStyleMix letterSpacing(double value) {
    return merge(TextStyleMix.letterSpacing(value));
  }

  /// Sets debug label
  TextStyleMix debugLabel(String value) {
    return merge(TextStyleMix.debugLabel(value));
  }

  /// Sets word spacing
  TextStyleMix wordSpacing(double value) {
    return merge(TextStyleMix.wordSpacing(value));
  }

  /// Sets text baseline
  TextStyleMix textBaseline(TextBaseline value) {
    return merge(TextStyleMix.textBaseline(value));
  }

  /// Sets shadows
  TextStyleMix shadows(List<ShadowMix> value) {
    return merge(TextStyleMix.shadows(value));
  }

  /// Sets font features
  TextStyleMix fontFeatures(List<FontFeature> value) {
    return merge(TextStyleMix.fontFeatures(value));
  }

  /// Sets text decoration
  TextStyleMix decoration(TextDecoration value) {
    return merge(TextStyleMix.decoration(value));
  }

  /// Sets decoration color
  TextStyleMix decorationColor(Color value) {
    return merge(TextStyleMix.decorationColor(value));
  }

  /// Sets decoration style
  TextStyleMix decorationStyle(TextDecorationStyle value) {
    return merge(TextStyleMix.decorationStyle(value));
  }

  /// Sets font variations
  TextStyleMix fontVariations(List<FontVariation> value) {
    return merge(TextStyleMix.fontVariations(value));
  }

  /// Sets line height
  TextStyleMix height(double value) {
    return merge(TextStyleMix.height(value));
  }

  /// Sets foreground paint
  TextStyleMix foreground(Paint value) {
    return merge(TextStyleMix.foreground(value));
  }

  /// Sets background paint
  TextStyleMix background(Paint value) {
    return merge(TextStyleMix.background(value));
  }

  /// Sets decoration thickness
  TextStyleMix decorationThickness(double value) {
    return merge(TextStyleMix.decorationThickness(value));
  }

  /// Sets font family
  TextStyleMix fontFamily(String value) {
    return merge(TextStyleMix.fontFamily(value));
  }

  /// Sets font family fallback
  TextStyleMix fontFamilyFallback(List<String> value) {
    return merge(TextStyleMix.fontFamilyFallback(value));
  }

  /// Sets inherit
  TextStyleMix inherit(bool value) {
    return merge(TextStyleMix.inherit(value));
  }

  @override
  TextStyle resolve(BuildContext context) {
    return TextStyle(
      inherit: MixHelpers.resolve(context, $inherit) ?? true,
      color: MixHelpers.resolve(context, $color),
      backgroundColor: MixHelpers.resolve(context, $backgroundColor),
      fontSize: MixHelpers.resolve(context, $fontSize),
      fontWeight: MixHelpers.resolve(context, $fontWeight),
      fontStyle: MixHelpers.resolve(context, $fontStyle),
      letterSpacing: MixHelpers.resolve(context, $letterSpacing),
      wordSpacing: MixHelpers.resolve(context, $wordSpacing),
      textBaseline: MixHelpers.resolve(context, $textBaseline),
      height: MixHelpers.resolve(context, $height),
      foreground: MixHelpers.resolve(context, $foreground),
      background: MixHelpers.resolve(context, $background),
      // Resolve lists using helpers
      shadows: MixHelpers.resolveList(context, $shadows),
      fontFeatures: MixHelpers.resolveList(context, $fontFeatures),
      fontVariations: MixHelpers.resolveList(context, $fontVariations),
      decoration: MixHelpers.resolve(context, $decoration),
      decorationColor: MixHelpers.resolve(context, $decorationColor),
      decorationStyle: MixHelpers.resolve(context, $decorationStyle),
      decorationThickness: MixHelpers.resolve(context, $decorationThickness),
      debugLabel: MixHelpers.resolve(context, $debugLabel),
      fontFamily: MixHelpers.resolve(context, $fontFamily),
      fontFamilyFallback: MixHelpers.resolveList(context, $fontFamilyFallback),
    );
  }

  @override
  TextStyleMix merge(TextStyleMix? other) {
    if (other == null) return this;

    return TextStyleMix.raw(
      color: $color.tryMerge(other.$color),
      backgroundColor: $backgroundColor.tryMerge(other.$backgroundColor),
      fontSize: $fontSize.tryMerge(other.$fontSize),
      fontWeight: $fontWeight.tryMerge(other.$fontWeight),
      fontStyle: $fontStyle.tryMerge(other.$fontStyle),
      letterSpacing: $letterSpacing.tryMerge(other.$letterSpacing),
      debugLabel: $debugLabel.tryMerge(other.$debugLabel),
      wordSpacing: $wordSpacing.tryMerge(other.$wordSpacing),
      textBaseline: $textBaseline.tryMerge(other.$textBaseline),
      // Merge lists - default replace strategy (merge at index)
      shadows: $shadows.tryMerge(other.$shadows),
      fontFeatures: $fontFeatures.tryMerge(other.$fontFeatures),
      decoration: $decoration.tryMerge(other.$decoration),
      decorationColor: $decorationColor.tryMerge(other.$decorationColor),
      decorationStyle: $decorationStyle.tryMerge(other.$decorationStyle),
      fontVariations: $fontVariations.tryMerge(other.$fontVariations),
      height: $height.tryMerge(other.$height),
      foreground: $foreground.tryMerge(other.$foreground),
      background: $background.tryMerge(other.$background),
      decorationThickness: $decorationThickness.tryMerge(
        other.$decorationThickness,
      ),
      fontFamily: $fontFamily.tryMerge(other.$fontFamily),
      fontFamilyFallback: $fontFamilyFallback.tryMerge(
        other.$fontFamilyFallback,
      ),
      inherit: $inherit.tryMerge(other.$inherit),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', $color, defaultValue: null));
    properties.add(
      DiagnosticsProperty(
        'backgroundColor',
        $backgroundColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('fontSize', $fontSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('fontWeight', $fontWeight, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('fontStyle', $fontStyle, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('letterSpacing', $letterSpacing, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('wordSpacing', $wordSpacing, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textBaseline', $textBaseline, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('height', $height, defaultValue: null));
    properties.add(
      DiagnosticsProperty('decoration', $decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'decorationColor',
        $decorationColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'decorationStyle',
        $decorationStyle,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'decorationThickness',
        $decorationThickness,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('fontFamily', $fontFamily, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'fontFamilyFallback',
        $fontFamilyFallback,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('shadows', $shadows, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('fontFeatures', $fontFeatures, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'fontVariations',
        $fontVariations,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('foreground', $foreground, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('background', $background, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('debugLabel', $debugLabel, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('inherit', $inherit, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
    $color,
    $backgroundColor,
    $fontSize,
    $fontWeight,
    $fontStyle,
    $letterSpacing,
    $debugLabel,
    $wordSpacing,
    $textBaseline,
    $decoration,
    $decorationColor,
    $decorationStyle,
    $height,
    $decorationThickness,
    $fontFamily,
    $foreground,
    $background,
    $fontFamilyFallback,
    $fontFeatures,
    $fontVariations,
    $shadows,
    $inherit,
  ];
}

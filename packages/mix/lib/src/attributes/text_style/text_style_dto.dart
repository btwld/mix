// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [TextStyle] value.
@immutable
class TextStyleDto extends Mixable<TextStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging - always nullable internally
  final MixableProperty<Color> color;
  final MixableProperty<Color> backgroundColor;
  final MixableProperty<double> fontSize;
  final MixableProperty<FontWeight> fontWeight;
  final MixableProperty<FontStyle> fontStyle;
  final MixableProperty<double> letterSpacing;
  final MixableProperty<String> debugLabel;
  final MixableProperty<double> wordSpacing;
  final MixableProperty<TextBaseline> textBaseline;
  final MixableProperty<TextDecoration> decoration;
  final MixableProperty<Color> decorationColor;
  final MixableProperty<TextDecorationStyle> decorationStyle;
  final MixableProperty<double> height;
  final MixableProperty<double> decorationThickness;
  final MixableProperty<String> fontFamily;
  final MixableProperty<List<String>> fontFamilyFallback;
  final MixableProperty<List<FontFeature>> fontFeatures;
  final MixableProperty<List<FontVariation>> fontVariations;

  // All properties use MixableProperty
  final MixableProperty<Paint> foreground;
  final MixableProperty<Paint> background;
  final MixableProperty<List<Shadow>> shadows;

  // Private constructor accepts MixableProperty instances - all optional
  const TextStyleDto._({
    required this.color,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.letterSpacing,
    required this.debugLabel,
    required this.wordSpacing,
    required this.textBaseline,
    required this.decoration,
    required this.decorationColor,
    required this.decorationStyle,
    required this.height,
    required this.decorationThickness,
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.fontFeatures,
    required this.fontVariations,
    required this.foreground,
    required this.background,
    required this.shadows,
  });

  factory TextStyleDto({
    Mixable<Color>? color,
    Mixable<Color>? backgroundColor,
    Mixable<double>? fontSize,
    Mixable<FontWeight>? fontWeight,
    Mixable<FontStyle>? fontStyle,
    Mixable<double>? letterSpacing,
    Mixable<String>? debugLabel,
    Mixable<double>? wordSpacing,
    Mixable<TextBaseline>? textBaseline,
    Mixable<List<Shadow>>? shadows,
    Mixable<List<FontFeature>>? fontFeatures,
    Mixable<TextDecoration>? decoration,
    Mixable<Color>? decorationColor,
    Mixable<double>? decorationThickness,
    Mixable<String>? fontFamily,
    Mixable<List<String>>? fontFamilyFallback,
    Mixable<List<FontVariation>>? fontVariations,
    Mixable<Paint>? foreground,
    Mixable<Paint>? background,
    Mixable<TextDecorationStyle>? decorationStyle,
    Mixable<double>? height,
  }) {
    return TextStyleDto._(
      color: MixableProperty(color),
      backgroundColor: MixableProperty(backgroundColor),
      fontSize: MixableProperty(fontSize),
      fontWeight: MixableProperty(fontWeight),
      fontStyle: MixableProperty(fontStyle),
      letterSpacing: MixableProperty(letterSpacing),
      debugLabel: MixableProperty(debugLabel),
      wordSpacing: MixableProperty(wordSpacing),
      textBaseline: MixableProperty(textBaseline),
      decoration: MixableProperty(decoration),
      decorationColor: MixableProperty(decorationColor),
      decorationStyle: MixableProperty(decorationStyle),
      height: MixableProperty(height),
      decorationThickness: MixableProperty(decorationThickness),
      fontFamily: MixableProperty(fontFamily),
      fontFamilyFallback: MixableProperty(fontFamilyFallback),
      fontFeatures: MixableProperty(fontFeatures),
      fontVariations: MixableProperty(fontVariations),
      foreground: MixableProperty(foreground),
      background: MixableProperty(background),
      shadows: MixableProperty(shadows),
    );
  } // Default factory accepts raw values
  factory TextStyleDto.values({
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    String? debugLabel,
    double? wordSpacing,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
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
  }) {
    return TextStyleDto(
      color: .maybeValue(color),
      backgroundColor: .maybeValue(backgroundColor),
      fontSize: .maybeValue(fontSize),
      fontWeight: .maybeValue(fontWeight),
      fontStyle: .maybeValue(fontStyle),
      letterSpacing: .maybeValue(letterSpacing),
      debugLabel: .maybeValue(debugLabel),
      wordSpacing: .maybeValue(wordSpacing),
      textBaseline: .maybeValue(textBaseline),
      shadows: .maybeValue(shadows?.toList()),
      fontFeatures: .maybeValue(fontFeatures),
      decoration: .maybeValue(decoration),
      decorationColor: .maybeValue(decorationColor),
      decorationThickness: .maybeValue(decorationThickness),
      fontFamily: .maybeValue(fontFamily),
      fontFamilyFallback: .maybeValue(fontFamilyFallback),
      fontVariations: .maybeValue(fontVariations),
      foreground: .maybeValue(foreground),
      background: .maybeValue(background),
      decorationStyle: .maybeValue(decorationStyle),
      height: .maybeValue(height),
    );
  }

  // Factory from TextStyle
  factory TextStyleDto.from(TextStyle textStyle) {
    return TextStyleDto.values(
      color: textStyle.color,
      backgroundColor: textStyle.backgroundColor,
      fontSize: textStyle.fontSize,
      fontWeight: textStyle.fontWeight,
      fontStyle: textStyle.fontStyle,
      letterSpacing: textStyle.letterSpacing,
      debugLabel: textStyle.debugLabel,
      wordSpacing: textStyle.wordSpacing,
      textBaseline: textStyle.textBaseline,
      shadows: textStyle.shadows,
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
    );
  }



  @override
  TextStyle resolve(MixContext mix) {
    return TextStyle(
      color: color.resolve(mix),
      backgroundColor: backgroundColor.resolve(mix),
      fontSize: fontSize.resolve(mix),
      fontWeight: fontWeight.resolve(mix),
      fontStyle: fontStyle.resolve(mix),
      letterSpacing: letterSpacing.resolve(mix),
      wordSpacing: wordSpacing.resolve(mix),
      textBaseline: textBaseline.resolve(mix),
      height: height.resolve(mix),
      foreground: foreground.resolve(mix),
      background: background.resolve(mix),
      shadows: shadows.resolve(mix),
      fontFeatures: fontFeatures.resolve(mix),
      fontVariations: fontVariations.resolve(mix),
      decoration: decoration.resolve(mix),
      decorationColor: decorationColor.resolve(mix),
      decorationStyle: decorationStyle.resolve(mix),
      decorationThickness: decorationThickness.resolve(mix),
      debugLabel: debugLabel.resolve(mix),
      fontFamily: fontFamily.resolve(mix),
      fontFamilyFallback: fontFamilyFallback.resolve(mix),
    );
  }

  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other is! TextStyleDto) return this;

    return TextStyleDto._(
      color: color.merge(other.color),
      backgroundColor: backgroundColor.merge(other.backgroundColor),
      fontSize: fontSize.merge(other.fontSize),
      fontWeight: fontWeight.merge(other.fontWeight),
      fontStyle: fontStyle.merge(other.fontStyle),
      letterSpacing: letterSpacing.merge(other.letterSpacing),
      debugLabel: debugLabel.merge(other.debugLabel),
      wordSpacing: wordSpacing.merge(other.wordSpacing),
      textBaseline: textBaseline.merge(other.textBaseline),
      decoration: decoration.merge(other.decoration),
      decorationColor: decorationColor.merge(other.decorationColor),
      decorationStyle: decorationStyle.merge(other.decorationStyle),
      height: height.merge(other.height),
      decorationThickness: decorationThickness.merge(other.decorationThickness),
      fontFamily: fontFamily.merge(other.fontFamily),
      fontFamilyFallback: fontFamilyFallback.merge(other.fontFamilyFallback),
      fontFeatures: fontFeatures.merge(other.fontFeatures),
      fontVariations: fontVariations.merge(other.fontVariations),
      foreground: foreground.merge(other.foreground),
      background: background.merge(other.background),
      shadows: shadows.merge(other.shadows),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.addUsingDefault('background', background);
    properties.addUsingDefault('backgroundColor', backgroundColor);
    properties.addUsingDefault('color', color);
    properties.addUsingDefault('debugLabel', debugLabel);
    properties.addUsingDefault('decoration', decoration);
    properties.addUsingDefault('decorationColor', decorationColor);
    properties.addUsingDefault('decorationStyle', decorationStyle);
    properties.addUsingDefault('decorationThickness', decorationThickness);
    properties.addUsingDefault('fontFamily', fontFamily);
    properties.addUsingDefault('fontFamilyFallback', fontFamilyFallback);
    properties.addUsingDefault('fontVariations', fontVariations);
    properties.addUsingDefault('fontFeatures', fontFeatures);
    properties.addUsingDefault('fontSize', fontSize);
    properties.addUsingDefault('fontStyle', fontStyle);
    properties.addUsingDefault('fontWeight', fontWeight);
    properties.addUsingDefault('foreground', foreground);
    properties.addUsingDefault('height', height);
    properties.addUsingDefault('letterSpacing', letterSpacing);
    properties.addUsingDefault('shadows', shadows);
    properties.addUsingDefault('textBaseline', textBaseline);
    properties.addUsingDefault('wordSpacing', wordSpacing);
  }

  @override
  List<Object?> get props => [
    background,
    backgroundColor,
    color,
    debugLabel,
    decoration,
    decorationColor,
    decorationStyle,
    decorationThickness,
    fontFamily,
    fontFamilyFallback,
    fontFeatures,
    fontSize,
    fontStyle,
    fontVariations,
    fontWeight,
    foreground,
    height,
    letterSpacing,
    shadows,
    textBaseline,
    wordSpacing,
  ];
}

// Extension for easy conversion
extension TextStyleExt on TextStyle {
  TextStyleDto toDto() => TextStyleDto.from(this);
}

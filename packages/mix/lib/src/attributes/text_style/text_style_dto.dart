// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../core/mix_property.dart';
import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [TextStyle] value.
@immutable
class TextStyleDto extends Mix<TextStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging - always nullable internally
  final MixProp<Color> color;
  final MixProp<Color> backgroundColor;
  final MixProp<double> fontSize;
  final MixProp<FontWeight> fontWeight;
  final MixProp<FontStyle> fontStyle;
  final MixProp<double> letterSpacing;
  final MixProp<String> debugLabel;
  final MixProp<double> wordSpacing;
  final MixProp<TextBaseline> textBaseline;
  final MixProp<TextDecoration> decoration;
  final MixProp<Color> decorationColor;
  final MixProp<TextDecorationStyle> decorationStyle;
  final MixProp<double> height;
  final MixProp<double> decorationThickness;
  final MixProp<String> fontFamily;
  final MixProp<List<String>> fontFamilyFallback;
  final MixProp<List<FontFeature>> fontFeatures;
  final MixProp<List<FontVariation>> fontVariations;

  // All properties use MixableProperty
  final MixProp<Paint> foreground;
  final MixProp<Paint> background;
  final MixProp<List<Shadow>> shadows;

  // Main constructor accepts Mix values
  factory TextStyleDto({
    Mix<Color>? color,
    Mix<Color>? backgroundColor,
    Mix<double>? fontSize,
    Mix<FontWeight>? fontWeight,
    Mix<FontStyle>? fontStyle,
    Mix<double>? letterSpacing,
    Mix<String>? debugLabel,
    Mix<double>? wordSpacing,
    Mix<TextBaseline>? textBaseline,
    Mix<List<Shadow>>? shadows,
    Mix<List<FontFeature>>? fontFeatures,
    Mix<TextDecoration>? decoration,
    Mix<Color>? decorationColor,
    Mix<TextDecorationStyle>? decorationStyle,
    Mix<List<FontVariation>>? fontVariations,
    Mix<double>? height,
    Mix<Paint>? foreground,
    Mix<Paint>? background,
    Mix<double>? decorationThickness,
    Mix<String>? fontFamily,
    Mix<List<String>>? fontFamilyFallback,
  }) {
    return TextStyleDto._(
      color: MixProp(color),
      backgroundColor: MixProp(backgroundColor),
      fontSize: MixProp(fontSize),
      fontWeight: MixProp(fontWeight),
      fontStyle: MixProp(fontStyle),
      letterSpacing: MixProp(letterSpacing),
      debugLabel: MixProp(debugLabel),
      wordSpacing: MixProp(wordSpacing),
      textBaseline: MixProp(textBaseline),
      decoration: MixProp(decoration),
      decorationColor: MixProp(decorationColor),
      decorationStyle: MixProp(decorationStyle),
      height: MixProp(height),
      decorationThickness: MixProp(decorationThickness),
      fontFamily: MixProp(fontFamily),
      fontFamilyFallback: MixProp(fontFamilyFallback),
      fontFeatures: MixProp(fontFeatures),
      fontVariations: MixProp(fontVariations),
      foreground: MixProp(foreground),
      background: MixProp(background),
      shadows: MixProp(shadows),
    );
  }

  // Private constructor that accepts MixProp instances
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

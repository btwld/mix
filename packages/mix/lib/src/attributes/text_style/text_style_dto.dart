// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [TextStyle] value.
@immutable
class TextStyleDto extends Mix<TextStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging - always nullable internally
  final MixValue<Color>? color;
  final MixValue<Color>? backgroundColor;
  final MixValue<double>? fontSize;
  final MixValue<FontWeight>? fontWeight;
  final MixValue<FontStyle>? fontStyle;
  final MixValue<double>? letterSpacing;
  final MixValue<String>? debugLabel;
  final MixValue<double>? wordSpacing;
  final MixValue<TextBaseline>? textBaseline;
  final MixValue<TextDecoration>? decoration;
  final MixValue<Color>? decorationColor;
  final MixValue<TextDecorationStyle>? decorationStyle;
  final MixValue<double>? height;
  final MixValue<double>? decorationThickness;
  final MixValue<String>? fontFamily;
  final MixValue<List<String>>? fontFamilyFallback;
  final MixValue<List<FontFeature>>? fontFeatures;
  final MixValue<List<FontVariation>>? fontVariations;

  // All properties use MixableProperty
  final MixValue<Paint>? foreground;
  final MixValue<Paint>? background;
  final MixValue<List<Shadow>>? shadows;

  // Main constructor accepts MixProp values directly
  const TextStyleDto({
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.debugLabel,
    this.wordSpacing,
    this.textBaseline,
    this.shadows,
    this.fontFeatures,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.fontVariations,
    this.height,
    this.foreground,
    this.background,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
  });

  @override
  TextStyle resolve(MixContext mix) {
    return TextStyle(
      color: resolveProp(mix, color),
      backgroundColor: resolveProp(mix, backgroundColor),
      fontSize: resolveProp(mix, fontSize),
      fontWeight: resolveProp(mix, fontWeight),
      fontStyle: resolveProp(mix, fontStyle),
      letterSpacing: resolveProp(mix, letterSpacing),
      wordSpacing: resolveProp(mix, wordSpacing),
      textBaseline: resolveProp(mix, textBaseline),
      height: resolveProp(mix, height),
      foreground: resolveProp(mix, foreground),
      background: resolveProp(mix, background),
      shadows: resolveProp(mix, shadows),
      fontFeatures: resolveProp(mix, fontFeatures),
      fontVariations: resolveProp(mix, fontVariations),
      decoration: resolveProp(mix, decoration),
      decorationColor: resolveProp(mix, decorationColor),
      decorationStyle: resolveProp(mix, decorationStyle),
      decorationThickness: resolveProp(mix, decorationThickness),
      debugLabel: resolveProp(mix, debugLabel),
      fontFamily: resolveProp(mix, fontFamily),
      fontFamilyFallback: resolveProp(mix, fontFamilyFallback),
    );
  }

  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other is! TextStyleDto) return this;

    return TextStyleDto(
      color: mergeProp(color, other.color),
      backgroundColor: mergeProp(backgroundColor, other.backgroundColor),
      fontSize: mergeProp(fontSize, other.fontSize),
      fontWeight: mergeProp(fontWeight, other.fontWeight),
      fontStyle: mergeProp(fontStyle, other.fontStyle),
      letterSpacing: mergeProp(letterSpacing, other.letterSpacing),
      debugLabel: mergeProp(debugLabel, other.debugLabel),
      wordSpacing: mergeProp(wordSpacing, other.wordSpacing),
      textBaseline: mergeProp(textBaseline, other.textBaseline),
      shadows: mergeProp(shadows, other.shadows),
      fontFeatures: mergeProp(fontFeatures, other.fontFeatures),
      decoration: mergeProp(decoration, other.decoration),
      decorationColor: mergeProp(decorationColor, other.decorationColor),
      decorationStyle: mergeProp(decorationStyle, other.decorationStyle),
      fontVariations: mergeProp(fontVariations, other.fontVariations),
      height: mergeProp(height, other.height),
      foreground: mergeProp(foreground, other.foreground),
      background: mergeProp(background, other.background),
      decorationThickness: mergeProp(
        decorationThickness,
        other.decorationThickness,
      ),
      fontFamily: mergeProp(fontFamily, other.fontFamily),
      fontFamilyFallback: mergeProp(
        fontFamilyFallback,
        other.fontFamilyFallback,
      ),
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

// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [TextStyle] value.
@immutable
class TextStyleDto extends Mix<TextStyle> with Diagnosticable {
  // Properties use MixableProperty for cleaner merging - always nullable internally
  final MixProperty<Color> color;
  final MixProperty<Color> backgroundColor;
  final MixProperty<double> fontSize;
  final MixProperty<FontWeight> fontWeight;
  final MixProperty<FontStyle> fontStyle;
  final MixProperty<double> letterSpacing;
  final MixProperty<String> debugLabel;
  final MixProperty<double> wordSpacing;
  final MixProperty<TextBaseline> textBaseline;
  final MixProperty<TextDecoration> decoration;
  final MixProperty<Color> decorationColor;
  final MixProperty<TextDecorationStyle> decorationStyle;
  final MixProperty<double> height;
  final MixProperty<double> decorationThickness;
  final MixProperty<String> fontFamily;
  final MixProperty<List<String>> fontFamilyFallback;
  final MixProperty<List<FontFeature>> fontFeatures;
  final MixProperty<List<FontVariation>> fontVariations;

  // All properties use MixableProperty
  final MixProperty<Paint> foreground;
  final MixProperty<Paint> background;
  final MixProperty<List<Shadow>> shadows;

  // Main constructor accepts real values
  factory TextStyleDto({
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
    return TextStyleDto.raw(
      color: MixProperty.prop(color),
      backgroundColor: MixProperty.prop(backgroundColor),
      fontSize: MixProperty.prop(fontSize),
      fontWeight: MixProperty.prop(fontWeight),
      fontStyle: MixProperty.prop(fontStyle),
      letterSpacing: MixProperty.prop(letterSpacing),
      debugLabel: MixProperty.prop(debugLabel),
      wordSpacing: MixProperty.prop(wordSpacing),
      textBaseline: MixProperty.prop(textBaseline),
      decoration: MixProperty.prop(decoration),
      decorationColor: MixProperty.prop(decorationColor),
      decorationStyle: MixProperty.prop(decorationStyle),
      height: MixProperty.prop(height),
      decorationThickness: MixProperty.prop(decorationThickness),
      fontFamily: MixProperty.prop(fontFamily),
      fontFamilyFallback: MixProperty.prop(fontFamilyFallback?.toList()),
      fontFeatures: MixProperty.prop(fontFeatures?.toList()),
      fontVariations: MixProperty.prop(fontVariations?.toList()),
      foreground: MixProperty.prop(foreground),
      background: MixProperty.prop(background),
      shadows: MixProperty.prop(shadows?.toList()),
    );
  }

  // Factory that accepts MixableProperty instances
  const TextStyleDto.raw({
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

  // Factory from TextStyle
  factory TextStyleDto.from(TextStyle textStyle) {
    return TextStyleDto(
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

    return TextStyleDto.raw(
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

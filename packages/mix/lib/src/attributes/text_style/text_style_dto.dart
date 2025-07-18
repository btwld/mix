// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../internal/compare_mixin.dart';

@immutable
class TextStyleDto extends Mix<TextStyle> with EqualityMixin, Diagnosticable {
  // Simple properties use MixValue directly
  final Prop<Color>? color;
  final Prop<Color>? backgroundColor;
  final Prop<double>? fontSize;
  final Prop<FontWeight>? fontWeight;
  final Prop<FontStyle>? fontStyle;
  final Prop<double>? letterSpacing;
  final Prop<String>? debugLabel;
  final Prop<double>? wordSpacing;
  final Prop<TextBaseline>? textBaseline;
  final Prop<TextDecoration>? decoration;
  final Prop<Color>? decorationColor;
  final Prop<TextDecorationStyle>? decorationStyle;
  final Prop<double>? height;
  final Prop<double>? decorationThickness;
  final Prop<String>? fontFamily;
  final Prop<Paint>? foreground;
  final Prop<Paint>? background;

  // Lists of MixValues for simple types
  final List<Prop<String>>? fontFamilyFallback;
  final List<Prop<FontFeature>>? fontFeatures;
  final List<Prop<FontVariation>>? fontVariations;

  // Lists of Mix types (DTOs)
  final List<MixProp<Shadow, ShadowDto>>? shadows;

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
    List<ShadowDto>? shadows,
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
    return TextStyleDto.props(
      color: Prop.maybeValue(color),
      backgroundColor: Prop.maybeValue(backgroundColor),
      fontSize: Prop.maybeValue(fontSize),
      fontWeight: Prop.maybeValue(fontWeight),
      fontStyle: Prop.maybeValue(fontStyle),
      letterSpacing: Prop.maybeValue(letterSpacing),
      debugLabel: Prop.maybeValue(debugLabel),
      wordSpacing: Prop.maybeValue(wordSpacing),
      textBaseline: Prop.maybeValue(textBaseline),
      shadows: shadows?.map(MixProp<Shadow, ShadowDto>.fromValue).toList(),
      fontFeatures: fontFeatures?.map(Prop.fromValue).toList(),
      decoration: Prop.maybeValue(decoration),
      decorationColor: Prop.maybeValue(decorationColor),
      decorationStyle: Prop.maybeValue(decorationStyle),
      fontVariations: fontVariations?.map(Prop.fromValue).toList(),
      height: Prop.maybeValue(height),
      foreground: Prop.maybeValue(foreground),
      background: Prop.maybeValue(background),
      decorationThickness: Prop.maybeValue(decorationThickness),
      fontFamily: Prop.maybeValue(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Prop.fromValue).toList(),
    );
  }

  /// Constructor that accepts Prop values directly
  const TextStyleDto.props({
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

  /// Constructor that accepts a [TextStyle] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextStyle] instances to [TextStyleDto].
  ///
  /// ```dart
  /// const textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
  /// final dto = TextStyleDto.value(textStyle);
  /// ```
  factory TextStyleDto.value(TextStyle textStyle) {
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
      shadows: textStyle.shadows?.map(ShadowDto.value).toList(),
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

  /// Constructor that accepts a nullable [TextStyle] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [TextStyleDto.value].
  ///
  /// ```dart
  /// const TextStyle? textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
  /// final dto = TextStyleDto.maybeValue(textStyle); // Returns TextStyleDto or null
  /// ```
  static TextStyleDto? maybeValue(TextStyle? textStyle) {
    return textStyle != null ? TextStyleDto.value(textStyle) : null;
  }

  @override
  TextStyle resolve(BuildContext context) {
    return TextStyle(
      color: MixHelpers.resolve(context, color),
      backgroundColor: MixHelpers.resolve(context, backgroundColor),
      fontSize: MixHelpers.resolve(context, fontSize),
      fontWeight: MixHelpers.resolve(context, fontWeight),
      fontStyle: MixHelpers.resolve(context, fontStyle),
      letterSpacing: MixHelpers.resolve(context, letterSpacing),
      wordSpacing: MixHelpers.resolve(context, wordSpacing),
      textBaseline: MixHelpers.resolve(context, textBaseline),
      height: MixHelpers.resolve(context, height),
      foreground: MixHelpers.resolve(context, foreground),
      background: MixHelpers.resolve(context, background),
      // Resolve lists using helpers
      shadows: MixHelpers.resolveList(context, shadows),
      fontFeatures: MixHelpers.resolveList(context, fontFeatures),
      fontVariations: MixHelpers.resolveList(context, fontVariations),
      decoration: MixHelpers.resolve(context, decoration),
      decorationColor: MixHelpers.resolve(context, decorationColor),
      decorationStyle: MixHelpers.resolve(context, decorationStyle),
      decorationThickness: MixHelpers.resolve(context, decorationThickness),
      debugLabel: MixHelpers.resolve(context, debugLabel),
      fontFamily: MixHelpers.resolve(context, fontFamily),
      fontFamilyFallback: MixHelpers.resolveList(context, fontFamilyFallback),
    );
  }

  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other == null) return this;

    return TextStyleDto.props(
      color: MixHelpers.merge(color, other.color),
      backgroundColor: MixHelpers.merge(backgroundColor, other.backgroundColor),
      fontSize: MixHelpers.merge(fontSize, other.fontSize),
      fontWeight: MixHelpers.merge(fontWeight, other.fontWeight),
      fontStyle: MixHelpers.merge(fontStyle, other.fontStyle),
      letterSpacing: MixHelpers.merge(letterSpacing, other.letterSpacing),
      debugLabel: MixHelpers.merge(debugLabel, other.debugLabel),
      wordSpacing: MixHelpers.merge(wordSpacing, other.wordSpacing),
      textBaseline: MixHelpers.merge(textBaseline, other.textBaseline),
      // Merge lists - default to append strategy
      shadows: MixHelpers.mergeList(shadows, other.shadows),
      fontFeatures: MixHelpers.mergeList(fontFeatures, other.fontFeatures),
      decoration: MixHelpers.merge(decoration, other.decoration),
      decorationColor: MixHelpers.merge(decorationColor, other.decorationColor),
      decorationStyle: MixHelpers.merge(decorationStyle, other.decorationStyle),
      fontVariations: MixHelpers.mergeList(
        fontVariations,
        other.fontVariations,
      ),
      height: MixHelpers.merge(height, other.height),
      foreground: MixHelpers.merge(foreground, other.foreground),
      background: MixHelpers.merge(background, other.background),
      decorationThickness: MixHelpers.merge(
        decorationThickness,
        other.decorationThickness,
      ),
      fontFamily: MixHelpers.merge(fontFamily, other.fontFamily),
      fontFamilyFallback: MixHelpers.mergeList(
        fontFamilyFallback,
        other.fontFamilyFallback,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(
      DiagnosticsProperty(
        'backgroundColor',
        backgroundColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('fontSize', fontSize, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('fontWeight', fontWeight, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('fontStyle', fontStyle, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('letterSpacing', letterSpacing, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('wordSpacing', wordSpacing, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('textBaseline', textBaseline, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(
      DiagnosticsProperty('decoration', decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'decorationColor',
        decorationColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'decorationStyle',
        decorationStyle,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty(
        'decorationThickness',
        decorationThickness,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('fontFamily', fontFamily, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'fontFamilyFallback',
        fontFamilyFallback,
        defaultValue: null,
      ),
    );
    properties.add(DiagnosticsProperty('shadows', shadows, defaultValue: null));
    properties.add(
      DiagnosticsProperty('fontFeatures', fontFeatures, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('fontVariations', fontVariations, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('foreground', foreground, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('background', background, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('debugLabel', debugLabel, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [
    color,
    backgroundColor,
    fontSize,
    fontWeight,
    fontStyle,
    letterSpacing,
    debugLabel,
    wordSpacing,
    textBaseline,
    shadows,
    fontFeatures,
    decoration,
    decorationColor,
    decorationStyle,
    fontVariations,
    height,
    foreground,
    background,
    decorationThickness,
    fontFamily,
    fontFamilyFallback,
  ];
}

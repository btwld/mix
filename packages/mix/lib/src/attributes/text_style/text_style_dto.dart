// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

@immutable
class TextStyleDto extends Mix<TextStyle> with Diagnosticable {
  // Simple properties use MixValue directly
  final Mixable<Color>? color;
  final Mixable<Color>? backgroundColor;
  final Mixable<double>? fontSize;
  final Mixable<FontWeight>? fontWeight;
  final Mixable<FontStyle>? fontStyle;
  final Mixable<double>? letterSpacing;
  final Mixable<String>? debugLabel;
  final Mixable<double>? wordSpacing;
  final Mixable<TextBaseline>? textBaseline;
  final Mixable<TextDecoration>? decoration;
  final Mixable<Color>? decorationColor;
  final Mixable<TextDecorationStyle>? decorationStyle;
  final Mixable<double>? height;
  final Mixable<double>? decorationThickness;
  final Mixable<String>? fontFamily;
  final Mixable<Paint>? foreground;
  final Mixable<Paint>? background;

  // Lists of MixValues for simple types
  final List<Mixable<String>>? fontFamilyFallback;
  final List<Mixable<FontFeature>>? fontFeatures;
  final List<Mixable<FontVariation>>? fontVariations;

  // Lists of Mix types (DTOs)
  final List<MixableDto<ShadowDto, Shadow>>? shadows;

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
  TextStyle resolve(MixContext context) {
    return TextStyle(
      color: resolveValue(context, color),
      backgroundColor: resolveValue(context, backgroundColor),
      fontSize: resolveValue(context, fontSize),
      fontWeight: resolveValue(context, fontWeight),
      fontStyle: resolveValue(context, fontStyle),
      letterSpacing: resolveValue(context, letterSpacing),
      wordSpacing: resolveValue(context, wordSpacing),
      textBaseline: resolveValue(context, textBaseline),
      height: resolveValue(context, height),
      foreground: resolveValue(context, foreground),
      background: resolveValue(context, background),
      // Resolve lists using helpers
      shadows: resolveDtoList(context, shadows),
      fontFeatures: resolveList(context, fontFeatures),
      fontVariations: resolveList(context, fontVariations),
      decoration: resolveValue(context, decoration),
      decorationColor: resolveValue(context, decorationColor),
      decorationStyle: resolveValue(context, decorationStyle),
      decorationThickness: resolveValue(context, decorationThickness),
      debugLabel: resolveValue(context, debugLabel),
      fontFamily: resolveValue(context, fontFamily),
      fontFamilyFallback: resolveList(context, fontFamilyFallback),
    );
  }

  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other == null) return this;

    return TextStyleDto(
      color: mergeValue(color, other.color),
      backgroundColor: mergeValue(backgroundColor, other.backgroundColor),
      fontSize: mergeValue(fontSize, other.fontSize),
      fontWeight: mergeValue(fontWeight, other.fontWeight),
      fontStyle: mergeValue(fontStyle, other.fontStyle),
      letterSpacing: mergeValue(letterSpacing, other.letterSpacing),
      debugLabel: mergeValue(debugLabel, other.debugLabel),
      wordSpacing: mergeValue(wordSpacing, other.wordSpacing),
      textBaseline: mergeValue(textBaseline, other.textBaseline),
      // Merge lists - default to append strategy
      shadows: mergeDtoList(shadows, other.shadows),
      fontFeatures: mergeValueList(fontFeatures, other.fontFeatures),
      decoration: mergeValue(decoration, other.decoration),
      decorationColor: mergeValue(decorationColor, other.decorationColor),
      decorationStyle: mergeValue(decorationStyle, other.decorationStyle),
      fontVariations: mergeValueList(fontVariations, other.fontVariations),
      height: mergeValue(height, other.height),
      foreground: mergeValue(foreground, other.foreground),
      background: mergeValue(background, other.background),
      decorationThickness: mergeValue(
        decorationThickness,
        other.decorationThickness,
      ),
      fontFamily: mergeValue(fontFamily, other.fontFamily),
      fontFamilyFallback: mergeValueList(
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

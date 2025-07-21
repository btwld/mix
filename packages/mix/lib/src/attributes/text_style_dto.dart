// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

@immutable
class TextStyleDto extends Mix<TextStyle> with Diagnosticable {
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
  final List<MixProp<Shadow>>? shadows;

  TextStyleDto.only({
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
  }) : this(
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
         fontFeatures: fontFeatures?.map(Prop.new).toList(),
         decoration: Prop.maybe(decoration),
         decorationColor: Prop.maybe(decorationColor),
         decorationStyle: Prop.maybe(decorationStyle),
         fontVariations: fontVariations?.map(Prop.new).toList(),
         height: Prop.maybe(height),
         foreground: Prop.maybe(foreground),
         background: Prop.maybe(background),
         decorationThickness: Prop.maybe(decorationThickness),
         fontFamily: Prop.maybe(fontFamily),
         fontFamilyFallback: fontFamilyFallback?.map(Prop.new).toList(),
       );

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

  /// Constructor that accepts a [TextStyle] value and extracts its properties.
  ///
  /// This is useful for converting existing [TextStyle] instances to [TextStyleDto].
  ///
  /// ```dart
  /// const textStyle = TextStyle(color: Colors.blue, fontSize: 16.0);
  /// final dto = TextStyleDto.value(textStyle);
  /// ```
  TextStyleDto.value(TextStyle textStyle)
    : this.only(
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

    return TextStyleDto(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TextStyleDto &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.fontStyle == fontStyle &&
        other.letterSpacing == letterSpacing &&
        other.debugLabel == debugLabel &&
        other.wordSpacing == wordSpacing &&
        other.textBaseline == textBaseline &&
        other.decoration == decoration &&
        other.decorationColor == decorationColor &&
        other.decorationStyle == decorationStyle &&
        other.height == height &&
        other.decorationThickness == decorationThickness &&
        other.fontFamily == fontFamily &&
        other.foreground == foreground &&
        other.background == background &&
        listEquals(other.fontFamilyFallback, fontFamilyFallback) &&
        listEquals(other.fontFeatures, fontFeatures) &&
        listEquals(other.fontVariations, fontVariations) &&
        listEquals(other.shadows, shadows);
  }

  @override
  int get hashCode {
    return color.hashCode ^
        backgroundColor.hashCode ^
        fontSize.hashCode ^
        fontWeight.hashCode ^
        fontStyle.hashCode ^
        letterSpacing.hashCode ^
        debugLabel.hashCode ^
        wordSpacing.hashCode ^
        textBaseline.hashCode ^
        decoration.hashCode ^
        decorationColor.hashCode ^
        decorationStyle.hashCode ^
        height.hashCode ^
        decorationThickness.hashCode ^
        fontFamily.hashCode ^
        foreground.hashCode ^
        background.hashCode ^
        fontFamilyFallback.hashCode ^
        fontFeatures.hashCode ^
        fontVariations.hashCode ^
        shadows.hashCode;
  }
}

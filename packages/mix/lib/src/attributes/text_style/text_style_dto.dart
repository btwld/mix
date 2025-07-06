// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

/// A Data transfer object that represents a [TextStyle] value.
/// Can be either a direct value or a token reference.
@immutable
sealed class TextStyleDto extends Mixable<TextStyle> with Diagnosticable {
  const TextStyleDto._();

  factory TextStyleDto.value(TextStyle value) = ValueTextStyleDto.value;
  const factory TextStyleDto.token(MixableToken<TextStyle> token) =
      TokenTextStyleDto;
  const factory TextStyleDto.composite(List<TextStyleDto> items) =
      _CompositeTextStyleDto;

  const // Factory constructor delegates to ValueTextStyleDto
  factory TextStyleDto({
    ColorDto? color,
    ColorDto? backgroundColor,
    Mixable<double>? fontSize,
    Mixable<FontWeight>? fontWeight,
    Mixable<FontStyle>? fontStyle,
    Mixable<double>? letterSpacing,
    Mixable<String>? debugLabel,
    Mixable<double>? wordSpacing,
    Mixable<TextBaseline>? textBaseline,
    List<ShadowDto>? shadows,
    List<FontFeature>? fontFeatures,
    Mixable<TextDecoration>? decoration,
    ColorDto? decorationColor,
    Mixable<TextDecorationStyle>? decorationStyle,
    List<FontVariation>? fontVariations,
    Mixable<double>? height,
    Paint? foreground,
    Paint? background,
    Mixable<double>? decorationThickness,
    Mixable<String>? fontFamily,
    List<String>? fontFamilyFallback,
  }) = ValueTextStyleDto;

  // Convert resolved TextStyle back to DTO
  static ValueTextStyleDto fromValue(TextStyle style) {
    // Helper to reduce repetition

    return ValueTextStyleDto(
      background: style.background,
      backgroundColor: style.backgroundColor?.toDto(),
      color: style.color?.toDto(),
      debugLabel: Mixable.maybeValue(style.debugLabel),
      decoration: Mixable.maybeValue(style.decoration),
      decorationColor: style.decorationColor?.toDto(),
      decorationStyle: Mixable.maybeValue(style.decorationStyle),
      decorationThickness: Mixable.maybeValue(style.decorationThickness),
      fontFamily: Mixable.maybeValue(style.fontFamily),
      fontFamilyFallback: style.fontFamilyFallback,
      fontVariations: style.fontVariations,
      fontFeatures: style.fontFeatures,
      fontSize: Mixable.maybeValue(style.fontSize),
      fontStyle: Mixable.maybeValue(style.fontStyle),
      fontWeight: Mixable.maybeValue(style.fontWeight),
      foreground: style.foreground,
      height: Mixable.maybeValue(style.height),
      letterSpacing: Mixable.maybeValue(style.letterSpacing),
      shadows: style.shadows?.map((s) => s.toDto()).toList(),
      textBaseline: Mixable.maybeValue(style.textBaseline),
      wordSpacing: Mixable.maybeValue(style.wordSpacing),
    );
  }

  // Merges this TextStyleDto with another one
  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other == null) return this;

    return switch ((this, other)) {
      (ValueTextStyleDto a, ValueTextStyleDto b) => a._mergeWith(b),
      (_CompositeTextStyleDto(:var items), _) => TextStyleDto.composite([
        ...items,
        other,
      ]),
      (_, _CompositeTextStyleDto()) => other,
      _ => TextStyleDto.composite([this, other]),
    };
  }
}

final class ValueTextStyleDto extends TextStyleDto {
  final Mixable<String>? fontFamily;
  final Mixable<FontWeight>? fontWeight;
  final Mixable<FontStyle>? fontStyle;
  final Mixable<double>? fontSize;
  final Mixable<double>? letterSpacing;
  final Mixable<double>? wordSpacing;
  final Mixable<TextBaseline>? textBaseline;
  final ColorDto? color;
  final ColorDto? backgroundColor;
  final List<ShadowDto>? shadows;
  final List<FontFeature>? fontFeatures;
  final List<FontVariation>? fontVariations;
  final Mixable<TextDecoration>? decoration;
  final ColorDto? decorationColor;
  final Mixable<TextDecorationStyle>? decorationStyle;
  final Mixable<String>? debugLabel;
  final Mixable<double>? height;
  final Paint? foreground;
  final Paint? background;
  final Mixable<double>? decorationThickness;
  final List<String>? fontFamilyFallback;

  const ValueTextStyleDto({
    this.background,
    this.backgroundColor,
    this.color,
    this.debugLabel,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.fontFamily,
    this.fontFamilyFallback,
    this.fontVariations,
    this.fontFeatures,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.foreground,
    this.height,
    this.letterSpacing,
    this.shadows,
    this.textBaseline,
    this.wordSpacing,
  }) : super._();

  factory ValueTextStyleDto.value(TextStyle value) {
    // Reuse the fromValue logic
    return TextStyleDto.fromValue(value);
  }

  ValueTextStyleDto _mergeWith(ValueTextStyleDto other) {
    return ValueTextStyleDto(
      // Paint fields - other takes precedence (no merge method)
      background: other.background ?? background,
      // ColorDto fields - use merge
      backgroundColor:
          backgroundColor?.merge(other.backgroundColor) ??
          other.backgroundColor,
      color: color?.merge(other.color) ?? other.color,
      // Mixable fields - use merge
      debugLabel: debugLabel?.merge(other.debugLabel) ?? other.debugLabel,
      decoration: decoration?.merge(other.decoration) ?? other.decoration,
      decorationColor:
          decorationColor?.merge(other.decorationColor) ??
          other.decorationColor,

      decorationStyle:
          decorationStyle?.merge(other.decorationStyle) ??
          other.decorationStyle,
      decorationThickness:
          decorationThickness?.merge(other.decorationThickness) ??
          other.decorationThickness,
      fontFamily: fontFamily?.merge(other.fontFamily) ?? other.fontFamily,
      // List fields - other takes precedence
      fontFamilyFallback: other.fontFamilyFallback ?? fontFamilyFallback,
      fontVariations: other.fontVariations ?? fontVariations,
      fontFeatures: other.fontFeatures ?? fontFeatures,
      fontSize: fontSize?.merge(other.fontSize) ?? other.fontSize,
      fontStyle: fontStyle?.merge(other.fontStyle) ?? other.fontStyle,
      fontWeight: fontWeight?.merge(other.fontWeight) ?? other.fontWeight,
      foreground: other.foreground ?? foreground,

      height: height?.merge(other.height) ?? other.height,
      letterSpacing:
          letterSpacing?.merge(other.letterSpacing) ?? other.letterSpacing,
      shadows: other.shadows ?? shadows,
      textBaseline:
          textBaseline?.merge(other.textBaseline) ?? other.textBaseline,
      wordSpacing: wordSpacing?.merge(other.wordSpacing) ?? other.wordSpacing,
    );
  }

  @override
  TextStyle resolve(MixContext mix) {
    return TextStyle(
      color: color?.resolve(mix),
      backgroundColor: backgroundColor?.resolve(mix),
      fontSize: fontSize?.resolve(mix),
      fontWeight: fontWeight?.resolve(mix),
      fontStyle: fontStyle?.resolve(mix),
      letterSpacing: letterSpacing?.resolve(mix),
      wordSpacing: wordSpacing?.resolve(mix),
      textBaseline: textBaseline?.resolve(mix),
      height: height?.resolve(mix),
      foreground: foreground,
      background: background,
      shadows: shadows?.map((s) => s.resolve(mix)).toList(),
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration?.resolve(mix),
      decorationColor: decorationColor?.resolve(mix),
      decorationStyle: decorationStyle?.resolve(mix),
      decorationThickness: decorationThickness?.resolve(mix),
      debugLabel: debugLabel?.resolve(mix),
      fontFamily: fontFamily?.resolve(mix),
      fontFamilyFallback: fontFamilyFallback,
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

final class TokenTextStyleDto extends TextStyleDto {
  final MixableToken<TextStyle> token;

  const TokenTextStyleDto(this.token) : super._();

  @override
  TextStyle resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
  }

  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other == null) return this;

    // Create composite when merging with values
    return switch (other) {
      ValueTextStyleDto() => TextStyleDto.composite([this, other]),
      TokenTextStyleDto() => other, // Other token wins
      _CompositeTextStyleDto() => other, // Composite takes precedence
    };
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('token', token.name));
  }

  @override
  List<Object?> get props => [token];
}

@immutable
class _CompositeTextStyleDto extends TextStyleDto {
  final List<TextStyleDto> items;

  const _CompositeTextStyleDto(this.items) : super._();

  @override
  TextStyle resolve(MixContext mix) {
    if (items.isEmpty) return const TextStyle();

    // Process all items as DTOs
    ValueTextStyleDto? mergedDto;

    for (final item in items) {
      final currentDto = switch (item) {
        ValueTextStyleDto() => item,
        TokenTextStyleDto() => TextStyleDto.fromValue(item.resolve(mix)),
        _CompositeTextStyleDto() => TextStyleDto.fromValue(item.resolve(mix)),
      };

      // Merge with accumulated result
      mergedDto = mergedDto?._mergeWith(currentDto) ?? currentDto;
    }

    // Final resolution
    return mergedDto?.resolve(mix) ?? const TextStyle();
  }

  @override
  List<Object?> get props => [items];
}

// Extension for easy conversion
extension TextStyleExt on TextStyle {
  TextStyleDto toDto() => TextStyleDto.value(this);
}

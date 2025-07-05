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

  const factory TextStyleDto({
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
    return ValueTextStyleDto(
      background: style.background,
      backgroundColor: style.backgroundColor != null
          ? ColorDto.value(style.backgroundColor!)
          : null,
      color: style.color != null ? ColorDto.value(style.color!) : null,
      debugLabel:
          style.debugLabel != null ? Mixable.value(style.debugLabel!) : null,
      decoration:
          style.decoration != null ? Mixable.value(style.decoration!) : null,
      decorationColor: style.decorationColor != null
          ? ColorDto.value(style.decorationColor!)
          : null,
      decorationStyle: style.decorationStyle != null
          ? Mixable.value(style.decorationStyle!)
          : null,
      decorationThickness: style.decorationThickness != null
          ? Mixable.value(style.decorationThickness!)
          : null,
      fontFamily:
          style.fontFamily != null ? Mixable.value(style.fontFamily!) : null,
      fontFamilyFallback: style.fontFamilyFallback,
      fontVariations: style.fontVariations,
      fontFeatures: style.fontFeatures,
      fontSize: style.fontSize != null ? Mixable.value(style.fontSize!) : null,
      fontStyle:
          style.fontStyle != null ? Mixable.value(style.fontStyle!) : null,
      fontWeight:
          style.fontWeight != null ? Mixable.value(style.fontWeight!) : null,
      foreground: style.foreground,
      height: style.height != null ? Mixable.value(style.height!) : null,
      letterSpacing: style.letterSpacing != null
          ? Mixable.value(style.letterSpacing!)
          : null,
      // Note: shadows, fontFeatures, fontVariations, foreground, background, fontFamilyFallback
      // are kept as-is since they're not simple scalars
      shadows: style.shadows?.map((s) => s.toDto()).toList(),
      textBaseline: style.textBaseline != null
          ? Mixable.value(style.textBaseline!)
          : null,
      wordSpacing:
          style.wordSpacing != null ? Mixable.value(style.wordSpacing!) : null,
    );
  }

  // Merges this TextStyleDto with another one
  @override
  TextStyleDto merge(TextStyleDto? other) {
    if (other == null) return this;

    return switch ((this, other)) {
      (ValueTextStyleDto a, ValueTextStyleDto b) => a._mergeWith(b),
      (_CompositeTextStyleDto(:var items), _) =>
        TextStyleDto.composite([...items, other]),
      (_, _CompositeTextStyleDto()) => other,
      _ => TextStyleDto.composite([this, other]),
    };
  }
}

// TODO: Look for ways to consolidate TextStyleDto and TextStyleData
// If we remove TextStyle from tokens, it means we don't need a list of resolvable values
// to be resolved once we have a context. We can merge the values directly, simplifying the code,
// and this will allow more predictable behavior overall.
@MixableType(components: GeneratedPropertyComponents.none)
base class TextStyleData extends Mixable<TextStyle>
    with _$TextStyleData {
  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;
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
    return ValueTextStyleDto(
      background: value.background,
      backgroundColor: value.backgroundColor?.toDto(),
      color: value.color?.toDto(),
      debugLabel:
          value.debugLabel != null ? Mixable.value(value.debugLabel!) : null,
      decoration:
          value.decoration != null ? Mixable.value(value.decoration!) : null,
      decorationColor: value.decorationColor?.toDto(),
      decorationStyle: value.decorationStyle != null
          ? Mixable.value(value.decorationStyle!)
          : null,
      decorationThickness: value.decorationThickness != null
          ? Mixable.value(value.decorationThickness!)
          : null,
      fontFamily:
          value.fontFamily != null ? Mixable.value(value.fontFamily!) : null,
      fontFamilyFallback: value.fontFamilyFallback,
      fontVariations: value.fontVariations,
      fontFeatures: value.fontFeatures,
      fontSize: value.fontSize != null ? Mixable.value(value.fontSize!) : null,
      fontStyle:
          value.fontStyle != null ? Mixable.value(value.fontStyle!) : null,
      fontWeight:
          value.fontWeight != null ? Mixable.value(value.fontWeight!) : null,
      foreground: value.foreground,
      height: value.height != null ? Mixable.value(value.height!) : null,
      letterSpacing: value.letterSpacing != null
          ? Mixable.value(value.letterSpacing!)
          : null,
      shadows: value.shadows?.map((s) => s.toDto()).toList(),
      textBaseline: value.textBaseline != null
          ? Mixable.value(value.textBaseline!)
          : null,
      wordSpacing:
          value.wordSpacing != null ? Mixable.value(value.wordSpacing!) : null,
    );
  }

  ValueTextStyleDto _mergeWith(ValueTextStyleDto other) {
    return ValueTextStyleDto(
      background: other.background ?? background,
      backgroundColor: backgroundColor?.merge(other.backgroundColor) ??
          other.backgroundColor,
      color: color?.merge(other.color) ?? other.color,
      debugLabel: debugLabel?.merge(other.debugLabel) ?? other.debugLabel,
      decoration: decoration?.merge(other.decoration) ?? other.decoration,
      decorationColor: decorationColor?.merge(other.decorationColor) ??
          other.decorationColor,
      decorationStyle: decorationStyle?.merge(other.decorationStyle) ??
          other.decorationStyle,
      decorationThickness:
          decorationThickness?.merge(other.decorationThickness) ??
              other.decorationThickness,
      fontFamily: fontFamily?.merge(other.fontFamily) ?? other.fontFamily,
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
      // Non-scalar fields - other takes precedence
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
        color,
        backgroundColor,
        fontSize,
        fontWeight,
        fontStyle,
        letterSpacing,
        wordSpacing,
        textBaseline,
        decoration,
        decorationColor,
        decorationStyle,
        decorationThickness,
        fontFamily,
        height,
        debugLabel,
        shadows,
        fontFeatures,
        fontVariations,
        foreground,
        background,
        fontFamilyFallback,
      ];
}

@MixableType(
  components: GeneratedPropertyComponents.none,
  mergeLists: false,
)
final class TextStyleDto extends Mixable<TextStyle>
    with _$TextStyleDto {
  final List<TextStyleData> value;
  @MixableConstructor()
  const TextStyleDto._({this.value = const []});

  const TokenTextStyleDto(this.token) : super._();

  @override
  TextStyle resolve(MixContext mix) {
    return mix.scope.getToken(token, mix.context);
  }

  @override
  TextStyleDto merge(TextStyleDto? other) => other ?? this;

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

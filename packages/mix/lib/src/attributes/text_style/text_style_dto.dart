// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/diagnostic_properties_builder_ext.dart';

part 'text_style_dto.g.dart';

// TODO: Look for ways to consolidate TextStyleDto and TextStyleData
// If we remove TextStyle from tokens, it means we don't need a list of resolvable values
// to be resolved once we have a context. We can merge the values directly, simplifying the code,
// and this will allow more predictable behavior overall.
@MixableType(components: GeneratedPropertyComponents.none)
base class TextStyleData extends Mixable<TextStyle>
    with _$TextStyleData, Diagnosticable {
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
  final TextDecoration? decoration;
  final ColorDto? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final String? debugLabel;
  final double? height;
  final Paint? foreground;
  final Paint? background;
  final double? decorationThickness;
  final List<String>? fontFamilyFallback;

  const TextStyleData({
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
  });

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
}

@MixableType(
  components: GeneratedPropertyComponents.none,
  mergeLists: false,
)
final class TextStyleDto extends Mixable<TextStyle>
    with MixableTokenMixin<TextStyle>, _$TextStyleDto, Diagnosticable {
  final List<TextStyleData> value;
  @override
  final MixableToken<TextStyle>? token;

  @MixableConstructor()
  @protected
  const TextStyleDto.raw({this.value = const [], this.token});

  factory TextStyleDto.token(MixableToken<TextStyle> token) =>
      TextStyleDto.raw(token: token);

  factory TextStyleDto({
    ColorDto? color,
    ColorDto? backgroundColor,
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
    ColorDto? decorationColor,
    TextDecorationStyle? decorationStyle,
    List<FontVariation>? fontVariations,
    double? height,
    Paint? foreground,
    Paint? background,
    double? decorationThickness,
    String? fontFamily,
    List<String>? fontFamilyFallback,
  }) {
    return TextStyleDto.raw(value: [
      TextStyleData(
        background: background,
        backgroundColor: backgroundColor,
        color: color,
        debugLabel: debugLabel,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontVariations: fontVariations,
        fontFeatures: fontFeatures,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        foreground: foreground,
        height: height,
        letterSpacing: letterSpacing,
        shadows: shadows,
        textBaseline: textBaseline,
        wordSpacing: wordSpacing,
      ),
    ]);
  }

  /// Resolves this [TextStyleDto] to a [TextStyle].
  ///
  /// If a token is present, resolves it directly using the unified resolver system.
  /// Otherwise, processes the value list by merging all [TextStyleData] objects and resolving to a final [TextStyle].
  @override
  TextStyle resolve(MixContext mix) {
    // Check for token resolution first
    final tokenResult = super.resolve(mix);
    if (tokenResult != null) {
      return tokenResult;
    }

    final result = value.reduce((a, b) => a.merge(b)).resolve(mix);

    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    for (var e in value) {
      properties.add(
        DiagnosticsProperty(
          e.toStringShort(),
          e,
          expandableValue: true,
          style: DiagnosticsTreeStyle.whitespace,
        ),
      );
    }
  }
}

extension TextStyleExt on TextStyle {
  TextStyleDto toDto() {
    return TextStyleDto.raw(value: [_toData()]);
  }

  TextStyleData _toData() => TextStyleData(
        background: background,
        backgroundColor: backgroundColor?.toDto(),
        color: color?.toDto(),
        debugLabel: debugLabel,
        decoration: decoration,
        decorationColor: decorationColor?.toDto(),
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontVariations: fontVariations,
        fontFeatures: fontFeatures,
        fontSize: fontSize,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
        foreground: foreground,
        height: height,
        letterSpacing: letterSpacing,
        shadows: shadows?.map((e) => e.toDto()).toList(),
        textBaseline: textBaseline,
        wordSpacing: wordSpacing,
      );
}

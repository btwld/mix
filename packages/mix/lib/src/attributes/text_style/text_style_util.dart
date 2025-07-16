import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import '../shadow/shadow_dto.dart';
import 'text_style_dto.dart';

final class TextStyleUtility<T extends StyleElement>
    extends DtoUtility<T, TextStyleDto, TextStyle> {
  late final color = ColorUtility(
    (prop) => builder(TextStyleDto.props(color: prop)),
  );

  late final fontWeight = FontWeightUtility((v) => only(fontWeight: v));

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: v));

  late final decoration = TextDecorationUtility((v) => only(decoration: v));

  late final fontSize = FontSizeUtility((v) => only(fontSize: v));

  late final backgroundColor = ColorUtility(
    (prop) => builder(TextStyleDto.props(backgroundColor: prop)),
  );

  late final decorationColor = ColorUtility(
    (prop) => builder(TextStyleDto.props(decorationColor: prop)),
  );

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: v),
  );

  late final textBaseline = TextBaselineUtility((v) => only(textBaseline: v));

  late final fontFamily = FontFamilyUtility((v) => only(fontFamily: v));

  TextStyleUtility(super.builder)
    : super(
        valueToDto: (v) => TextStyleDto(
          color: v.color,
          backgroundColor: v.backgroundColor,
          fontSize: v.fontSize,
          fontWeight: v.fontWeight,
          fontStyle: v.fontStyle,
          letterSpacing: v.letterSpacing,
          debugLabel: v.debugLabel,
          wordSpacing: v.wordSpacing,
          textBaseline: v.textBaseline,
          shadows: v.shadows
              ?.map(
                (shadow) => ShadowDto(
                  blurRadius: shadow.blurRadius,
                  color: shadow.color,
                  offset: shadow.offset,
                ),
              )
              .toList(),
          fontFeatures: v.fontFeatures,
          decoration: v.decoration,
          decorationColor: v.decorationColor,
          decorationStyle: v.decorationStyle,
          fontVariations: v.fontVariations,
          height: v.height,
          foreground: v.foreground,
          background: v.background,
          decorationThickness: v.decorationThickness,
          fontFamily: v.fontFamily,
          fontFamilyFallback: v.fontFamilyFallback,
        ),
      );

  T token(MixToken<TextStyle> token) => throw UnimplementedError(
    'Token support needs implementation for whole TextStyle',
  );

  T height(double v) => call(height: v);

  T wordSpacing(double v) => call(wordSpacing: v);

  T letterSpacing(double v) => call(letterSpacing: v);

  T fontVariations(List<FontVariation> v) => call(fontVariations: v);

  T fontVariation(FontVariation v) => call(fontVariations: [v]);

  T shadows(List<Shadow> v) => call(shadows: v);

  T italic() => fontStyle.italic();

  T bold() => fontWeight.bold();

  T foreground(Paint v) => call(foreground: v);

  T background(Paint v) => call(background: v);

  T fontFeatures(List<FontFeature> v) => call(fontFeatures: v);

  T debugLabel(String v) => call(debugLabel: v);

  T decorationThickness(double v) => call(decorationThickness: v);

  T fontFamilyFallback(List<String> v) => call(fontFamilyFallback: v);

  T call({
    String? fontFamily,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    List<Shadow>? shadows,
    Color? color,
    Color? backgroundColor,
    List<FontVariation>? fontVariations,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
    String? debugLabel,
    List<String>? fontFamilyFallback,
    Paint? foreground,
    Paint? background,
    double? decorationThickness,
    Color? decorationColor,
    double? height,
  }) {
    return builder(
      TextStyleDto(
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        debugLabel: debugLabel,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        shadows: shadows
            ?.map(
              (shadow) => ShadowDto(
                blurRadius: shadow.blurRadius,
                color: shadow.color,
                offset: shadow.offset,
              ),
            )
            .toList(),
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontVariations: fontVariations,
        height: height,
        foreground: foreground,
        background: background,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }

  @override
  T only({
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    Color? backgroundColor,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    TextBaseline? textBaseline,
    List<FontVariation>? fontVariations,
    List<ShadowDto>? shadows,
    List<FontFeature>? fontFeatures,
    Paint? foreground,
    Paint? background,
    double? decorationThickness,
    List<String>? fontFamilyFallback,
    String? debugLabel,
    double? height,
    String? fontFamily,
  }) {
    return builder(
      TextStyleDto(
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        debugLabel: debugLabel,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontVariations: fontVariations,
        height: height,
        foreground: foreground,
        background: background,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
      ),
    );
  }
}

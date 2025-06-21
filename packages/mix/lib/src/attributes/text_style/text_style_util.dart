import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../theme/tokens/text_style_token.dart';
import '../color/color_dto.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import '../shadow/shadow_dto.dart';
import 'text_style_dto.dart';

final class TextStyleUtility<T extends StyleElement>
    extends DtoUtility<T, TextStyleDto, TextStyle> {
  late final color = ColorUtility((v) => only(color: v));

  late final fontWeight = FontWeightUtility((v) => only(fontWeight: v));

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: v));

  late final decoration = TextDecorationUtility((v) => only(decoration: v));

  late final fontSize = FontSizeUtility((v) => only(fontSize: v));

  late final backgroundColor = ColorUtility((v) => only(backgroundColor: v));

  late final decorationColor = ColorUtility((v) => only(decorationColor: v));

  late final shadow = ShadowUtility((v) => only(shadows: [v]));

  late final decorationStyle =
      TextDecorationStyleUtility((v) => only(decorationStyle: v));

  late final textBaseline = TextBaselineUtility((v) => only(textBaseline: v));

  late final fontFamily = FontFamilyUtility((v) => call(fontFamily: v));

  TextStyleUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  T height(double v) => only(height: v);

  T wordSpacing(double v) => only(wordSpacing: v);

  T letterSpacing(double v) => only(letterSpacing: v);

  T fontVariations(List<FontVariation> v) => only(fontVariations: v);

  T fontVariation(FontVariation v) => only(fontVariations: [v]);

  T shadows(List<Shadow> v) => only(shadows: v.map((e) => e.toDto()).toList());

  T italic() => fontStyle.italic();

  T bold() => fontWeight.bold();

  T foreground(Paint v) => call(foreground: v);

  T background(Paint v) => call(background: v);

  T fontFeatures(List<FontFeature> v) => call(fontFeatures: v);

  T debugLabel(String v) => call(debugLabel: v);

  T decorationThickness(double v) => call(decorationThickness: v);

  T fontFamilyFallback(List<String> v) => call(fontFamilyFallback: v);

  T ref(TextStyleToken token) => builder(TextStyleDto.ref(token));

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
    return only(
      color: color?.toDto(),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      backgroundColor: backgroundColor?.toDto(),
      decorationColor: decorationColor?.toDto(),
      decorationStyle: decorationStyle,
      textBaseline: textBaseline,
      fontVariations: fontVariations,
      shadows: shadows?.map((e) => e.toDto()).toList(),
      fontFeatures: fontFeatures,
      foreground: foreground,
      background: background,
      decorationThickness: decorationThickness,
      fontFamilyFallback: fontFamilyFallback,
      debugLabel: debugLabel,
      height: height,
      fontFamily: fontFamily,
    );
  }

  @override
  T only({
    ColorDto? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    ColorDto? backgroundColor,
    ColorDto? decorationColor,
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
    final textStyle = TextStyleDto(
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
    );

    return builder(textStyle);
  }
}

import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../theme/tokens/mix_token.dart';
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

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: v),
  );

  late final textBaseline = TextBaselineUtility((v) => only(textBaseline: v));

  late final fontFamily = FontFamilyUtility((v) => call(fontFamily: v));

  TextStyleUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  T token(MixableToken<TextStyle> token) => builder(TextStyleDto.token(token));

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
      color: Mixable.maybeValue(color),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      backgroundColor: Mixable.maybeValue(backgroundColor),
      decorationColor: Mixable.maybeValue(decorationColor),
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
    Mixable<Color>? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    Mixable<Color>? backgroundColor,
    Mixable<Color>? decorationColor,
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
      fontSize: Mixable.maybeValue(fontSize),
      fontWeight: Mixable.maybeValue(fontWeight),
      fontStyle: Mixable.maybeValue(fontStyle),
      letterSpacing: Mixable.maybeValue(letterSpacing),
      debugLabel: Mixable.maybeValue(debugLabel),
      wordSpacing: Mixable.maybeValue(wordSpacing),
      textBaseline: Mixable.maybeValue(textBaseline),
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: Mixable.maybeValue(decoration),
      decorationColor: decorationColor,
      decorationStyle: Mixable.maybeValue(decorationStyle),
      fontVariations: fontVariations,
      height: Mixable.maybeValue(height),
      foreground: foreground,
      background: background,
      decorationThickness: Mixable.maybeValue(decorationThickness),
      fontFamily: Mixable.maybeValue(fontFamily),
      fontFamilyFallback: fontFamilyFallback,
    );

    return builder(textStyle);
  }
}

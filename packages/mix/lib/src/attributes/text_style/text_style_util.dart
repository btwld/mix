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

  late final fontWeight = FontWeightUtility((v) => only(fontWeight: Mixable.value(v)));

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: Mixable.value(v)));

  late final decoration = TextDecorationUtility((v) => only(decoration: Mixable.value(v)));

  late final fontSize = FontSizeUtility((v) => only(fontSize: Mixable.value(v)));

  late final backgroundColor = ColorUtility((v) => only(backgroundColor: v));

  late final decorationColor = ColorUtility((v) => only(decorationColor: v));

  late final shadow = ShadowUtility((v) => only(shadows: [v]));

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: Mixable.value(v)),
  );

  late final textBaseline = TextBaselineUtility((v) => only(textBaseline: Mixable.value(v)));

  late final fontFamily = FontFamilyUtility((v) => call(fontFamily: v));

  TextStyleUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  T token(MixableToken<TextStyle> token) => builder(TextStyleDto.token(token));

  T height(double v) => only(height: Mixable.value(v));

  T wordSpacing(double v) => only(wordSpacing: Mixable.value(v));

  T letterSpacing(double v) => only(letterSpacing: Mixable.value(v));

  T fontVariations(List<FontVariation> v) => only(fontVariations: v.map(Mixable.value).toList());

  T fontVariation(FontVariation v) => only(fontVariations: [Mixable.value(v)]);

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
      fontWeight: Mixable.maybeValue(fontWeight),
      fontStyle: Mixable.maybeValue(fontStyle),
      decoration: Mixable.maybeValue(decoration),
      fontSize: Mixable.maybeValue(fontSize),
      letterSpacing: Mixable.maybeValue(letterSpacing),
      wordSpacing: Mixable.maybeValue(wordSpacing),
      backgroundColor: Mixable.maybeValue(backgroundColor),
      decorationColor: Mixable.maybeValue(decorationColor),
      decorationStyle: Mixable.maybeValue(decorationStyle),
      textBaseline: Mixable.maybeValue(textBaseline),
      fontVariations: fontVariations?.map(Mixable.value).toList(),
      shadows: shadows?.map((e) => e.toDto()).toList(),
      fontFeatures: fontFeatures?.map(Mixable.value).toList(),
      foreground: foreground,
      background: background,
      decorationThickness: Mixable.maybeValue(decorationThickness),
      fontFamilyFallback: fontFamilyFallback?.map(Mixable.value).toList(),
      debugLabel: Mixable.maybeValue(debugLabel),
      height: Mixable.maybeValue(height),
      fontFamily: Mixable.maybeValue(fontFamily),
    );
  }

  @override
  T only({
    Mixable<Color>? color,
    Mixable<FontWeight>? fontWeight,
    Mixable<FontStyle>? fontStyle,
    Mixable<TextDecoration>? decoration,
    Mixable<double>? fontSize,
    Mixable<double>? letterSpacing,
    Mixable<double>? wordSpacing,
    Mixable<Color>? backgroundColor,
    Mixable<Color>? decorationColor,
    Mixable<TextDecorationStyle>? decorationStyle,
    Mixable<TextBaseline>? textBaseline,
    List<Mixable<FontVariation>>? fontVariations,
    List<ShadowDto>? shadows,
    List<Mixable<FontFeature>>? fontFeatures,
    Paint? foreground,
    Paint? background,
    Mixable<double>? decorationThickness,
    List<Mixable<String>>? fontFamilyFallback,
    Mixable<String>? debugLabel,
    Mixable<double>? height,
    Mixable<String>? fontFamily,
  }) {
    final textStyle = ValueTextStyleDto(
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
    );

    return builder(textStyle);
  }
}

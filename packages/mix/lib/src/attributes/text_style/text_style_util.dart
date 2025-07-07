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

  late final fontWeight = FontWeightUtility(
    (v) => only(fontWeight: Mixable.value(v)),
  );

  late final fontStyle = FontStyleUtility(
    (v) => only(fontStyle: Mixable.value(v)),
  );

  late final decoration = TextDecorationUtility(
    (v) => only(decoration: Mixable.value(v)),
  );

  late final fontSize = FontSizeUtility(
    (v) => only(fontSize: Mixable.value(v)),
  );

  late final backgroundColor = ColorUtility((v) => only(backgroundColor: v));

  late final decorationColor = ColorUtility((v) => only(decorationColor: v));

  // Shadow utility needs special handling since it returns ShadowDto not Shadow
  late final shadow = ShadowUtility((v) => throw UnimplementedError('Shadow utility needs to be redesigned'));

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: Mixable.value(v)),
  );

  late final textBaseline = TextBaselineUtility(
    (v) => only(textBaseline: Mixable.value(v)),
  );

  late final fontFamily = FontFamilyUtility((v) => call(fontFamily: v));

  TextStyleUtility(super.builder) : super(valueToDto: (v) => v.toDto());



  T token(MixableToken<TextStyle> token) =>
      throw UnimplementedError('Token support needs implementation for whole TextStyle');

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
      TextStyleDto.values(
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        debugLabel: debugLabel,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        shadows: shadows?.toList(),
        fontFeatures: fontFeatures?.toList(),
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontVariations: fontVariations?.toList(),
        height: height,
        foreground: foreground,
        background: background,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback?.toList(),
      ),
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
    List<Mixable<Shadow>>? shadows,
    List<Mixable<FontFeature>>? fontFeatures,
    Mixable<Paint>? foreground,
    Mixable<Paint>? background,
    Mixable<double>? decorationThickness,
    List<Mixable<String>>? fontFamilyFallback,
    Mixable<String>? debugLabel,
    Mixable<double>? height,
    Mixable<String>? fontFamily,
  }) {
    return builder(
      TextStyleDto(
        color: .maybeValue(color?.value),
        backgroundColor: .maybeValue(backgroundColor?.value),
        fontSize: .maybeValue(fontSize?.value),
        fontWeight: .maybeValue(fontWeight?.value),
        fontStyle: .maybeValue(fontStyle?.value),
        letterSpacing: .maybeValue(letterSpacing?.value),
        debugLabel: .maybeValue(debugLabel?.value),
        wordSpacing: .maybeValue(wordSpacing?.value),
        textBaseline: .maybeValue(textBaseline?.value),
        shadows: .maybeValue(shadows?.map((e) => e.value).whereType<Shadow>().toList()),
        fontFeatures: .maybeValue(fontFeatures?.map((e) => e.value).whereType<FontFeature>().toList()),
        decoration: .maybeValue(decoration?.value),
        decorationColor: .maybeValue(decorationColor?.value),
        decorationThickness: .maybeValue(decorationThickness?.value),
        fontFamily: .maybeValue(fontFamily?.value),
        fontFamilyFallback: .maybeValue(fontFamilyFallback?.map((e) => e.value).whereType<String>().toList()),
        fontVariations: .maybeValue(fontVariations?.map((e) => e.value).whereType<FontVariation>().toList()),
        foreground: .maybeValue(foreground?.value),
        background: .maybeValue(background?.value),
        decorationStyle: .maybeValue(decorationStyle?.value),
        height: .maybeValue(height?.value),
      ),
    );
  }
}

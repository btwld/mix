import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../theme/tokens/mix_token.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'text_style_dto.dart';

final class TextStyleUtility<T extends StyleElement>
    extends DtoUtility<T, TextStyleDto, TextStyle> {
  late final color = ColorUtility((v) => only(color: v));

  late final fontWeight = FontWeightUtility(
    (v) => only(fontWeight: Mix.value(v)),
  );

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: Mix.value(v)));

  late final decoration = TextDecorationUtility(
    (v) => only(decoration: Mix.value(v)),
  );

  late final fontSize = FontSizeUtility((v) => only(fontSize: Mix.value(v)));

  late final backgroundColor = ColorUtility((v) => only(backgroundColor: v));

  late final decorationColor = ColorUtility((v) => only(decorationColor: v));

  // TODO: Shadow utility integration needs redesign for TextStyle compatibility
  // The ShadowUtility creates ShadowDto but TextStyle needs List<Shadow>
  // For now, use the shadows() method directly on the utility

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: Mix.value(v)),
  );

  late final textBaseline = TextBaselineUtility(
    (v) => only(textBaseline: Mix.value(v)),
  );

  late final fontFamily = FontFamilyUtility(
    (v) => only(fontFamily: Mix.value(v)),
  );

  TextStyleUtility(super.builder)
    : super(valueToDto: (v) => TextStyleDto.from(v));

  T token(MixableToken<TextStyle> token) => throw UnimplementedError(
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
    Mix<Color>? color,
    Mix<FontWeight>? fontWeight,
    Mix<FontStyle>? fontStyle,
    Mix<TextDecoration>? decoration,
    Mix<double>? fontSize,
    Mix<double>? letterSpacing,
    Mix<double>? wordSpacing,
    Mix<Color>? backgroundColor,
    Mix<Color>? decorationColor,
    Mix<TextDecorationStyle>? decorationStyle,
    Mix<TextBaseline>? textBaseline,
    List<Mix<FontVariation>>? fontVariations,
    List<Mix<Shadow>>? shadows,
    List<Mix<FontFeature>>? fontFeatures,
    Mix<Paint>? foreground,
    Mix<Paint>? background,
    Mix<double>? decorationThickness,
    List<Mix<String>>? fontFamilyFallback,
    Mix<String>? debugLabel,
    Mix<double>? height,
    Mix<String>? fontFamily,
  }) {
    return builder(
      TextStyleDto.raw(
        color: MixProperty(color),
        backgroundColor: MixProperty(backgroundColor),
        fontSize: MixProperty(fontSize),
        fontWeight: MixProperty(fontWeight),
        fontStyle: MixProperty(fontStyle),
        letterSpacing: MixProperty(letterSpacing),
        debugLabel: MixProperty(debugLabel),
        wordSpacing: MixProperty(wordSpacing),
        textBaseline: MixProperty(textBaseline),
        decoration: MixProperty(decoration),
        decorationColor: MixProperty(decorationColor),
        decorationStyle: MixProperty(decorationStyle),
        height: MixProperty(height),
        decorationThickness: MixProperty(decorationThickness),
        fontFamily: MixProperty(fontFamily),
        fontFamilyFallback: MixProperty(
          fontFamilyFallback != null ? MixableList(fontFamilyFallback) : null,
        ),
        fontFeatures: MixProperty(
          fontFeatures != null ? MixableList(fontFeatures) : null,
        ),
        fontVariations: MixProperty(
          fontVariations != null ? MixableList(fontVariations) : null,
        ),
        foreground: MixProperty(foreground),
        background: MixProperty(background),
        shadows: MixProperty(shadows != null ? MixableList(shadows) : null),
      ),
    );
  }
}

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

  // TODO: Shadow utility integration needs redesign for TextStyle compatibility
  // The ShadowUtility creates ShadowDto but TextStyle needs List<Shadow>
  // For now, use the shadows() method directly on the utility

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: Mixable.value(v)),
  );

  late final textBaseline = TextBaselineUtility(
    (v) => only(textBaseline: Mixable.value(v)),
  );

  late final fontFamily = FontFamilyUtility((v) => only(fontFamily: Mixable.value(v)));

  TextStyleUtility(super.builder) : super(valueToDto: (v) => TextStyleDto.from(v));

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
      TextStyleDto.raw(
        color: MixableProperty(color),
        backgroundColor: MixableProperty(backgroundColor),
        fontSize: MixableProperty(fontSize),
        fontWeight: MixableProperty(fontWeight),
        fontStyle: MixableProperty(fontStyle),
        letterSpacing: MixableProperty(letterSpacing),
        debugLabel: MixableProperty(debugLabel),
        wordSpacing: MixableProperty(wordSpacing),
        textBaseline: MixableProperty(textBaseline),
        decoration: MixableProperty(decoration),
        decorationColor: MixableProperty(decorationColor),
        decorationStyle: MixableProperty(decorationStyle),
        height: MixableProperty(height),
        decorationThickness: MixableProperty(decorationThickness),
        fontFamily: MixableProperty(fontFamily),
        fontFamilyFallback: MixableProperty(
          fontFamilyFallback != null ? MixableList(fontFamilyFallback) : null,
        ),
        fontFeatures: MixableProperty(
          fontFeatures != null ? MixableList(fontFeatures) : null,
        ),
        fontVariations: MixableProperty(
          fontVariations != null ? MixableList(fontVariations) : null,
        ),
        foreground: MixableProperty(foreground),
        background: MixableProperty(background),
        shadows: MixableProperty(shadows != null ? MixableList(shadows) : null),
      ),
    );
  }
}

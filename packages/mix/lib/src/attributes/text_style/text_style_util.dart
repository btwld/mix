import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../core/mix_value.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'text_style_dto.dart';

final class TextStyleUtility<T extends StyleElement>
    extends DtoUtility<T, TextStyleDto, TextStyle> {
  late final color = ColorUtility((v) => only(color: v as ColorMix));

  late final fontWeight = FontWeightUtility(
    (v) => only(fontWeight: FontWeightMix(v)),
  );

  late final fontStyle = FontStyleUtility(
    (v) => only(fontStyle: FontStyleMix(v)),
  );

  late final decoration = TextDecorationUtility(
    (v) => only(decoration: TextDecorationMix(v)),
  );

  late final fontSize = FontSizeUtility((v) => only(fontSize: DoubleMix(v)));

  late final backgroundColor = ColorUtility(
    (v) => only(backgroundColor: v as ColorMix),
  );

  late final decorationColor = ColorUtility(
    (v) => only(decorationColor: v as ColorMix),
  );

  // TODO: Shadow utility integration needs redesign for TextStyle compatibility
  // The ShadowUtility creates ShadowDto but TextStyle needs List<Shadow>
  // For now, use the shadows() method directly on the utility

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: TextDecorationStyleMix(v)),
  );

  late final textBaseline = TextBaselineUtility(
    (v) => only(textBaseline: TextBaselineMix(v)),
  );

  late final fontFamily = FontFamilyUtility(
    (v) => only(fontFamily: StringMix(v)),
  );

  TextStyleUtility(super.builder)
    : super(
        valueToDto: (v) => TextStyleDto(
          color: v.color != null ? MixValue.mix(ColorMix(v.color!)) : null,
          backgroundColor: v.backgroundColor != null
              ? MixValue.mix(ColorMix(v.backgroundColor!))
              : null,
          fontSize: v.fontSize != null
              ? MixValue.mix(DoubleMix(v.fontSize!))
              : null,
          fontWeight: v.fontWeight != null
              ? MixValue.mix(FontWeightMix(v.fontWeight!))
              : null,
          fontStyle: v.fontStyle != null
              ? MixValue.mix(EnumMix(v.fontStyle!))
              : null,
          letterSpacing: v.letterSpacing != null
              ? MixValue.mix(DoubleMix(v.letterSpacing!))
              : null,
          debugLabel: v.debugLabel != null
              ? MixValue.mix(StringMix(v.debugLabel!))
              : null,
          wordSpacing: v.wordSpacing != null
              ? MixValue.mix(DoubleMix(v.wordSpacing!))
              : null,
          textBaseline: v.textBaseline != null
              ? MixValue.mix(EnumMix(v.textBaseline!))
              : null,
          shadows: v.shadows != null
              ? MixValue.mix(
                  ListMix(v.shadows!.map((s) => ShadowMix(s)).toList()),
                )
              : null,
          fontFeatures: v.fontFeatures != null
              ? MixValue.mix(
                  ListMix(
                    v.fontFeatures!.map((f) => FontFeatureMix(f)).toList(),
                  ),
                )
              : null,
          decoration: v.decoration != null
              ? MixValue.mix(TextDecorationMix(v.decoration!))
              : null,
          decorationColor: v.decorationColor != null
              ? MixValue.mix(ColorMix(v.decorationColor!))
              : null,
          decorationStyle: v.decorationStyle != null
              ? MixValue.mix(EnumMix(v.decorationStyle!))
              : null,
          fontVariations: v.fontVariations != null
              ? MixValue.mix(
                  ListMix(
                    v.fontVariations!.map((f) => FontVariationMix(f)).toList(),
                  ),
                )
              : null,
          height: v.height != null ? MixValue.mix(DoubleMix(v.height!)) : null,
          foreground: v.foreground != null
              ? MixValue.mix(PaintMix(v.foreground!))
              : null,
          background: v.background != null
              ? MixValue.mix(PaintMix(v.background!))
              : null,
          decorationThickness: v.decorationThickness != null
              ? MixValue.mix(DoubleMix(v.decorationThickness!))
              : null,
          fontFamily: v.fontFamily != null
              ? MixValue.mix(StringMix(v.fontFamily!))
              : null,
          fontFamilyFallback: v.fontFamilyFallback != null
              ? MixValue.mix(
                  ListMix(
                    v.fontFamilyFallback!.map((s) => StringMix(s)).toList(),
                  ),
                )
              : null,
        ),
      );

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
        color: color != null ? MixValue.mix(ColorMix(color)) : null,
        backgroundColor: backgroundColor != null
            ? MixValue.mix(ColorMix(backgroundColor))
            : null,
        fontSize: fontSize != null ? MixValue.mix(DoubleMix(fontSize)) : null,
        fontWeight: fontWeight != null
            ? MixValue.mix(FontWeightMix(fontWeight))
            : null,
        fontStyle: fontStyle != null ? MixValue.mix(EnumMix(fontStyle)) : null,
        letterSpacing: letterSpacing != null
            ? MixValue.mix(DoubleMix(letterSpacing))
            : null,
        debugLabel: debugLabel != null
            ? MixValue.mix(StringMix(debugLabel))
            : null,
        wordSpacing: wordSpacing != null
            ? MixValue.mix(DoubleMix(wordSpacing))
            : null,
        textBaseline: textBaseline != null
            ? MixValue.mix(EnumMix(textBaseline))
            : null,
        shadows: shadows != null
            ? MixValue.mix(ListMix(shadows.map((s) => ShadowMix(s)).toList()))
            : null,
        fontFeatures: fontFeatures != null
            ? MixValue.mix(
                ListMix(fontFeatures.map((f) => FontFeatureMix(f)).toList()),
              )
            : null,
        decoration: decoration != null
            ? MixValue.mix(TextDecorationMix(decoration))
            : null,
        decorationColor: decorationColor != null
            ? MixValue.mix(ColorMix(decorationColor))
            : null,
        decorationStyle: decorationStyle != null
            ? MixValue.mix(EnumMix(decorationStyle))
            : null,
        fontVariations: fontVariations != null
            ? MixValue.mix(
                ListMix(
                  fontVariations.map((f) => FontVariationMix(f)).toList(),
                ),
              )
            : null,
        height: height != null ? MixValue.mix(DoubleMix(height)) : null,
        foreground: foreground != null
            ? MixValue.mix(PaintMix(foreground))
            : null,
        background: background != null
            ? MixValue.mix(PaintMix(background))
            : null,
        decorationThickness: decorationThickness != null
            ? MixValue.mix(DoubleMix(decorationThickness))
            : null,
        fontFamily: fontFamily != null
            ? MixValue.mix(StringMix(fontFamily))
            : null,
        fontFamilyFallback: fontFamilyFallback != null
            ? MixValue.mix(
                ListMix(fontFamilyFallback.map((s) => StringMix(s)).toList()),
              )
            : null,
      ),
    );
  }

  @override
  T only({
    ColorMix? color,
    FontWeightMix? fontWeight,
    FontStyleMix? fontStyle,
    TextDecorationMix? decoration,
    DoubleMix? fontSize,
    DoubleMix? letterSpacing,
    DoubleMix? wordSpacing,
    ColorMix? backgroundColor,
    ColorMix? decorationColor,
    TextDecorationStyleMix? decorationStyle,
    TextBaselineMix? textBaseline,
    List<FontVariationMix>? fontVariations,
    List<ShadowMix>? shadows,
    List<FontFeatureMix>? fontFeatures,
    PaintMix? foreground,
    PaintMix? background,
    DoubleMix? decorationThickness,
    List<StringMix>? fontFamilyFallback,
    StringMix? debugLabel,
    DoubleMix? height,
    StringMix? fontFamily,
  }) {
    return builder(
      TextStyleDto(
        color: color != null ? MixValue.mix(color) : null,
        backgroundColor: backgroundColor != null
            ? MixValue.mix(backgroundColor)
            : null,
        fontSize: fontSize != null ? MixValue.mix(fontSize) : null,
        fontWeight: fontWeight != null ? MixValue.mix(fontWeight) : null,
        fontStyle: fontStyle != null ? MixValue.mix(fontStyle) : null,
        letterSpacing: letterSpacing != null
            ? MixValue.mix(letterSpacing)
            : null,
        debugLabel: debugLabel != null ? MixValue.mix(debugLabel) : null,
        wordSpacing: wordSpacing != null ? MixValue.mix(wordSpacing) : null,
        textBaseline: textBaseline != null ? MixValue.mix(textBaseline) : null,
        shadows: shadows != null ? MixValue.mix(ListMix(shadows)) : null,
        fontFeatures: fontFeatures != null
            ? MixValue.mix(ListMix(fontFeatures))
            : null,
        decoration: decoration != null ? MixValue.mix(decoration) : null,
        decorationColor: decorationColor != null
            ? MixValue.mix(decorationColor)
            : null,
        decorationStyle: decorationStyle != null
            ? MixValue.mix(decorationStyle)
            : null,
        fontVariations: fontVariations != null
            ? MixValue.mix(ListMix(fontVariations))
            : null,
        height: height != null ? MixValue.mix(height) : null,
        foreground: foreground != null ? MixValue.mix(foreground) : null,
        background: background != null ? MixValue.mix(background) : null,
        decorationThickness: decorationThickness != null
            ? MixValue.mix(decorationThickness)
            : null,
        fontFamily: fontFamily != null ? MixValue.mix(fontFamily) : null,
        fontFamilyFallback: fontFamilyFallback != null
            ? MixValue.mix(ListMix(fontFamilyFallback))
            : null,
      ),
    );
  }
}

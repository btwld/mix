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
          color: v.color != null ? Mixable.mix(ColorMix(v.color!)) : null,
          backgroundColor: v.backgroundColor != null
              ? Mixable.mix(ColorMix(v.backgroundColor!))
              : null,
          fontSize: v.fontSize != null
              ? Mixable.mix(DoubleMix(v.fontSize!))
              : null,
          fontWeight: v.fontWeight != null
              ? Mixable.mix(FontWeightMix(v.fontWeight!))
              : null,
          fontStyle: v.fontStyle != null
              ? Mixable.mix(EnumMix(v.fontStyle!))
              : null,
          letterSpacing: v.letterSpacing != null
              ? Mixable.mix(DoubleMix(v.letterSpacing!))
              : null,
          debugLabel: v.debugLabel != null
              ? Mixable.mix(StringMix(v.debugLabel!))
              : null,
          wordSpacing: v.wordSpacing != null
              ? Mixable.mix(DoubleMix(v.wordSpacing!))
              : null,
          textBaseline: v.textBaseline != null
              ? Mixable.mix(EnumMix(v.textBaseline!))
              : null,
          shadows: v.shadows != null
              ? Mixable.mix(
                  ListMix(v.shadows!.map((s) => ShadowMix(s)).toList()),
                )
              : null,
          fontFeatures: v.fontFeatures != null
              ? Mixable.mix(
                  ListMix(
                    v.fontFeatures!.map((f) => FontFeatureMix(f)).toList(),
                  ),
                )
              : null,
          decoration: v.decoration != null
              ? Mixable.mix(TextDecorationMix(v.decoration!))
              : null,
          decorationColor: v.decorationColor != null
              ? Mixable.mix(ColorMix(v.decorationColor!))
              : null,
          decorationStyle: v.decorationStyle != null
              ? Mixable.mix(EnumMix(v.decorationStyle!))
              : null,
          fontVariations: v.fontVariations != null
              ? Mixable.mix(
                  ListMix(
                    v.fontVariations!.map((f) => FontVariationMix(f)).toList(),
                  ),
                )
              : null,
          height: v.height != null ? Mixable.mix(DoubleMix(v.height!)) : null,
          foreground: v.foreground != null
              ? Mixable.mix(PaintMix(v.foreground!))
              : null,
          background: v.background != null
              ? Mixable.mix(PaintMix(v.background!))
              : null,
          decorationThickness: v.decorationThickness != null
              ? Mixable.mix(DoubleMix(v.decorationThickness!))
              : null,
          fontFamily: v.fontFamily != null
              ? Mixable.mix(StringMix(v.fontFamily!))
              : null,
          fontFamilyFallback: v.fontFamilyFallback != null
              ? Mixable.mix(
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
        color: color != null ? Mixable.mix(ColorMix(color)) : null,
        backgroundColor: backgroundColor != null
            ? Mixable.mix(ColorMix(backgroundColor))
            : null,
        fontSize: fontSize != null ? Mixable.mix(DoubleMix(fontSize)) : null,
        fontWeight: fontWeight != null
            ? Mixable.mix(FontWeightMix(fontWeight))
            : null,
        fontStyle: fontStyle != null ? Mixable.mix(EnumMix(fontStyle)) : null,
        letterSpacing: letterSpacing != null
            ? Mixable.mix(DoubleMix(letterSpacing))
            : null,
        debugLabel: debugLabel != null
            ? Mixable.mix(StringMix(debugLabel))
            : null,
        wordSpacing: wordSpacing != null
            ? Mixable.mix(DoubleMix(wordSpacing))
            : null,
        textBaseline: textBaseline != null
            ? Mixable.mix(EnumMix(textBaseline))
            : null,
        shadows: shadows != null
            ? Mixable.mix(ListMix(shadows.map((s) => ShadowMix(s)).toList()))
            : null,
        fontFeatures: fontFeatures != null
            ? Mixable.mix(
                ListMix(fontFeatures.map((f) => FontFeatureMix(f)).toList()),
              )
            : null,
        decoration: decoration != null
            ? Mixable.mix(TextDecorationMix(decoration))
            : null,
        decorationColor: decorationColor != null
            ? Mixable.mix(ColorMix(decorationColor))
            : null,
        decorationStyle: decorationStyle != null
            ? Mixable.mix(EnumMix(decorationStyle))
            : null,
        fontVariations: fontVariations != null
            ? Mixable.mix(
                ListMix(
                  fontVariations.map((f) => FontVariationMix(f)).toList(),
                ),
              )
            : null,
        height: height != null ? Mixable.mix(DoubleMix(height)) : null,
        foreground: foreground != null
            ? Mixable.mix(PaintMix(foreground))
            : null,
        background: background != null
            ? Mixable.mix(PaintMix(background))
            : null,
        decorationThickness: decorationThickness != null
            ? Mixable.mix(DoubleMix(decorationThickness))
            : null,
        fontFamily: fontFamily != null
            ? Mixable.mix(StringMix(fontFamily))
            : null,
        fontFamilyFallback: fontFamilyFallback != null
            ? Mixable.mix(
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
        color: color != null ? Mixable.mix(color) : null,
        backgroundColor: backgroundColor != null
            ? Mixable.mix(backgroundColor)
            : null,
        fontSize: fontSize != null ? Mixable.mix(fontSize) : null,
        fontWeight: fontWeight != null ? Mixable.mix(fontWeight) : null,
        fontStyle: fontStyle != null ? Mixable.mix(fontStyle) : null,
        letterSpacing: letterSpacing != null
            ? Mixable.mix(letterSpacing)
            : null,
        debugLabel: debugLabel != null ? Mixable.mix(debugLabel) : null,
        wordSpacing: wordSpacing != null ? Mixable.mix(wordSpacing) : null,
        textBaseline: textBaseline != null ? Mixable.mix(textBaseline) : null,
        shadows: shadows != null ? Mixable.mix(ListMix(shadows)) : null,
        fontFeatures: fontFeatures != null
            ? Mixable.mix(ListMix(fontFeatures))
            : null,
        decoration: decoration != null ? Mixable.mix(decoration) : null,
        decorationColor: decorationColor != null
            ? Mixable.mix(decorationColor)
            : null,
        decorationStyle: decorationStyle != null
            ? Mixable.mix(decorationStyle)
            : null,
        fontVariations: fontVariations != null
            ? Mixable.mix(ListMix(fontVariations))
            : null,
        height: height != null ? Mixable.mix(height) : null,
        foreground: foreground != null ? Mixable.mix(foreground) : null,
        background: background != null ? Mixable.mix(background) : null,
        decorationThickness: decorationThickness != null
            ? Mixable.mix(decorationThickness)
            : null,
        fontFamily: fontFamily != null ? Mixable.mix(fontFamily) : null,
        fontFamilyFallback: fontFamilyFallback != null
            ? Mixable.mix(ListMix(fontFamilyFallback))
            : null,
      ),
    );
  }
}

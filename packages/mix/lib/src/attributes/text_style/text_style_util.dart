import 'package:flutter/widgets.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../color/color_util.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'text_style_dto.dart';

final class TextStyleUtility<T extends StyleElement>
    extends DtoUtility<T, TextStyleDto, TextStyle> {
  late final color = ColorUtility((v) => only(color: v));

  late final fontWeight = FontWeightUtility(
    (v) => only(fontWeight: FontWeightMix(v)),
  );

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: EnumMix(v)));

  late final decoration = TextDecorationUtility(
    (v) => only(decoration: TextDecorationMix(v)),
  );

  late final fontSize = FontSizeUtility((v) => only(fontSize: DoubleMix(v)));

  late final backgroundColor = ColorUtility((v) => only(backgroundColor: v));

  late final decorationColor = ColorUtility((v) => only(decorationColor: v));

  // TODO: Shadow utility integration needs redesign for TextStyle compatibility
  // The ShadowUtility creates ShadowDto but TextStyle needs List<Shadow>
  // For now, use the shadows() method directly on the utility

  late final decorationStyle = TextDecorationStyleUtility(
    (v) => only(decorationStyle: EnumMix(v)),
  );

  late final textBaseline = TextBaselineUtility(
    (v) => only(textBaseline: EnumMix(v)),
  );

  late final fontFamily = FontFamilyUtility(
    (v) => only(fontFamily: StringMix(v)),
  );

  TextStyleUtility(super.builder)
    : super(valueToDto: (v) => TextStyleDto(
          color: v.color != null ? ColorMix(v.color!) : null,
          backgroundColor: v.backgroundColor != null ? ColorMix(v.backgroundColor!) : null,
          fontSize: v.fontSize != null ? DoubleMix(v.fontSize!) : null,
          fontWeight: v.fontWeight != null ? FontWeightMix(v.fontWeight!) : null,
          fontStyle: v.fontStyle != null ? EnumMix(v.fontStyle!) : null,
          letterSpacing: v.letterSpacing != null ? DoubleMix(v.letterSpacing!) : null,
          debugLabel: v.debugLabel != null ? StringMix(v.debugLabel!) : null,
          wordSpacing: v.wordSpacing != null ? DoubleMix(v.wordSpacing!) : null,
          textBaseline: v.textBaseline != null ? EnumMix(v.textBaseline!) : null,
          decoration: v.decoration != null ? TextDecorationMix(v.decoration!) : null,
          decorationColor: v.decorationColor != null ? ColorMix(v.decorationColor!) : null,
          decorationStyle: v.decorationStyle != null ? EnumMix(v.decorationStyle!) : null,
          height: v.height != null ? DoubleMix(v.height!) : null,
          decorationThickness: v.decorationThickness != null ? DoubleMix(v.decorationThickness!) : null,
          fontFamily: v.fontFamily != null ? StringMix(v.fontFamily!) : null,
          fontFamilyFallback: v.fontFamilyFallback != null ? _ListMix(v.fontFamilyFallback!) : null,
          fontFeatures: v.fontFeatures != null ? _ListMix(v.fontFeatures!) : null,
          fontVariations: v.fontVariations != null ? _ListMix(v.fontVariations!) : null,
          foreground: v.foreground != null ? PaintMix(v.foreground!) : null,
          background: v.background != null ? PaintMix(v.background!) : null,
          shadows: v.shadows != null ? _ListMix(v.shadows!) : null,
        ));

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
        color: color != null ? ColorMix(color) : null,
        backgroundColor: backgroundColor != null ? ColorMix(backgroundColor) : null,
        fontSize: fontSize != null ? DoubleMix(fontSize) : null,
        fontWeight: fontWeight != null ? FontWeightMix(fontWeight) : null,
        fontStyle: fontStyle != null ? EnumMix(fontStyle) : null,
        letterSpacing: letterSpacing != null ? DoubleMix(letterSpacing) : null,
        debugLabel: debugLabel != null ? StringMix(debugLabel) : null,
        wordSpacing: wordSpacing != null ? DoubleMix(wordSpacing) : null,
        textBaseline: textBaseline != null ? EnumMix(textBaseline) : null,
        shadows: shadows != null ? _ListMix(shadows.toList()) : null,
        fontFeatures: fontFeatures != null ? _ListMix(fontFeatures.toList()) : null,
        decoration: decoration != null ? TextDecorationMix(decoration) : null,
        decorationColor: decorationColor != null ? ColorMix(decorationColor) : null,
        decorationStyle: decorationStyle != null ? EnumMix(decorationStyle) : null,
        fontVariations: fontVariations != null ? _ListMix(fontVariations.toList()) : null,
        height: height != null ? DoubleMix(height) : null,
        foreground: foreground != null ? PaintMix(foreground) : null,
        background: background != null ? PaintMix(background) : null,
        decorationThickness: decorationThickness != null ? DoubleMix(decorationThickness) : null,
        fontFamily: fontFamily != null ? StringMix(fontFamily) : null,
        fontFamilyFallback: fontFamilyFallback != null ? _ListMix(fontFamilyFallback.toList()) : null,
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
    Mix<List<FontVariation>>? fontVariations,
    Mix<List<Shadow>>? shadows,
    Mix<List<FontFeature>>? fontFeatures,
    Mix<Paint>? foreground,
    Mix<Paint>? background,
    Mix<double>? decorationThickness,
    Mix<List<String>>? fontFamilyFallback,
    Mix<String>? debugLabel,
    Mix<double>? height,
    Mix<String>? fontFamily,
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
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        height: height,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontFeatures: fontFeatures,
        fontVariations: fontVariations,
        foreground: foreground,
        background: background,
        shadows: shadows,
      ),
    );
  }
}

// Generic helper class for lists
class _ListMix<T> extends Mix<List<T>> {
  final List<T> _values;
  const _ListMix(this._values);

  @override
  List<T> resolve(MixContext mix) {
    return _values;
  }

  @override
  Mix<List<T>> merge(Mix<List<T>>? other) {
    return other ?? this;
  }

  @override
  get props => [_values];
}


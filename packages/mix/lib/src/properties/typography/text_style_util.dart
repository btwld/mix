import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import '../layout/enum_util.dart';
import '../layout/scalar_util.dart';
import '../painting/color_util.dart';
import '../painting/shadow_mix.dart';
import 'text_style_mix.dart';

final class TextStyleUtility<T extends Style<Object?>>
    extends MixPropUtility<T, TextStyleMix, TextStyle> {
  late final color = ColorUtility<T>((prop) => only(color: prop));

  late final fontWeight = PropUtility<T, FontWeight>(
    (prop) => only(fontWeight: prop),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => only(fontStyle: prop),
  );

  late final decoration = PropUtility<T, TextDecoration>(
    (prop) => only(decoration: prop),
  );

  late final fontSize = PropUtility<T, double>((prop) => only(fontSize: prop));

  late final backgroundColor = ColorUtility<T>(
    (prop) => only(backgroundColor: prop),
  );

  late final decorationColor = ColorUtility<T>(
    (prop) => only(decorationColor: prop),
  );

  late final decorationStyle = PropUtility<T, TextDecorationStyle>(
    (prop) => only(decorationStyle: prop),
  );

  late final textBaseline = PropUtility<T, TextBaseline>(
    (prop) => only(textBaseline: prop),
  );

  late final fontFamily = PropUtility<T, String>((v) => only(fontFamily: v));

  TextStyleUtility(super.builder) : super(convertToMix: TextStyleMix.value);

  T only({
    Color? color,
    Color? backgroundColor,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Paint? foreground,
    Paint? background,
    List<ShadowMix>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    List<FontVariation>? fontVariations,
  }) {
    return builder(
      TextStyleMix(
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
    Color? color,
    Color? backgroundColor,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    List<FontVariation>? fontVariations,
  }) {
    return only(
      color: color,
      backgroundColor: backgroundColor,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      foreground: foreground,
      background: background,
      shadows: shadows?.map(ShadowMix.value).toList(),
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontVariations: fontVariations,
    );
  }
}

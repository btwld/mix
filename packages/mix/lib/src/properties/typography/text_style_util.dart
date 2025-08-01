import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../layout/enum_util.dart';
import '../layout/scalar_util.dart';
import '../painting/color_util.dart';
import '../painting/shadow_mix.dart';
import 'text_style_mix.dart';

final class TextStyleUtility<T extends Style<Object?>>
    extends MixUtility<T, MixProp<TextStyle>> {
  @Deprecated('Use call(color: value) instead')
  late final color = ColorUtility<T>(
    (prop) => buildProp(TextStyleMix.raw(color: prop)),
  );

  @Deprecated('Use call(fontWeight: value) instead')
  late final fontWeight = MixUtility<T, FontWeight>(
    (prop) => only(fontWeight: prop),
  );

  @Deprecated('Use call(fontStyle: value) instead')
  late final fontStyle = MixUtility<T, FontStyle>(
    (prop) => only(fontStyle: prop),
  );

  @Deprecated('Use call(decoration: value) instead')
  late final decoration = MixUtility<T, TextDecoration>(
    (prop) => only(decoration: prop),
  );

  @Deprecated('Use call(backgroundColor: value) instead')
  late final backgroundColor = ColorUtility<T>(
    (prop) => buildProp(TextStyleMix.raw(backgroundColor: prop)),
  );

  @Deprecated('Use call(decorationColor: value) instead')
  late final decorationColor = ColorUtility<T>(
    (prop) => buildProp(TextStyleMix.raw(decorationColor: prop)),
  );

  @Deprecated('Use call(decorationStyle: value) instead')
  late final decorationStyle = MixUtility<T, TextDecorationStyle>(
    (prop) => only(decorationStyle: prop),
  );

  @Deprecated('Use call(textBaseline: value) instead')
  late final textBaseline = MixUtility<T, TextBaseline>(
    (prop) => only(textBaseline: prop),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;

  TextStyleUtility(super.builder);

  @Deprecated('Use call(fontSize: value) instead')
  T fontSize(double value) => only(fontSize: value);

  @Deprecated('Use call(fontFamily: value) instead')
  T fontFamily(String value) => only(fontFamily: value);
  @protected
  T buildProp(TextStyleMix value) => builder(MixProp(value));

  @Deprecated('Use call(height: value) instead')
  T height(double v) => call(height: v);

  @Deprecated('Use call(wordSpacing: value) instead')
  T wordSpacing(double v) => call(wordSpacing: v);

  @Deprecated('Use call(letterSpacing: value) instead')
  T letterSpacing(double v) => call(letterSpacing: v);

  @Deprecated('Use call(fontVariations: value) instead')
  T fontVariations(List<FontVariation> v) => call(fontVariations: v);

  @Deprecated('Use call(fontVariations: value) instead')
  T fontVariation(FontVariation v) => call(fontVariations: [v]);

  @Deprecated('Use call(shadows: value) instead')
  T shadows(List<Shadow> v) => call(shadows: v.map(ShadowMix.value).toList());

  @Deprecated('Use call(fontStyle: FontStyle.italic) instead')
  T italic() => fontStyle.italic();

  @Deprecated('Use call(fontWeight: FontWeight.bold) instead')
  T bold() => fontWeight.bold();

  @Deprecated('Use call(foreground: value) instead')
  T foreground(Paint v) => call(foreground: v);

  @Deprecated('Use call(background: value) instead')
  T background(Paint v) => call(background: v);

  @Deprecated('Use call(fontFeatures: value) instead')
  T fontFeatures(List<FontFeature> v) => call(fontFeatures: v);

  @Deprecated('Use call(debugLabel: value) instead')
  T debugLabel(String v) => call(debugLabel: v);

  @Deprecated('Use call(decorationThickness: value) instead')
  T decorationThickness(double v) => call(decorationThickness: v);

  @Deprecated('Use call(fontFamilyFallback: value) instead')
  T fontFamilyFallback(List<String> v) => call(fontFamilyFallback: v);

  T call({
    TextStyle? as,
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
    var textStyle = TextStyleMix();
    if (as != null) {
      textStyle = textStyle.merge(TextStyleMix.value(as));
    }

    textStyle = textStyle.merge(
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

    return builder(MixProp(textStyle));
  }

  @Deprecated('Use call(as: value) instead')
  T as(TextStyle value) => buildProp(TextStyleMix.value(value));
}

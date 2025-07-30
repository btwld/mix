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
    extends MixPropUtility<T, TextStyle> {
  late final color = ColorUtility<T>(
    (prop) => onlyProps(color: prop),
  );

  late final fontWeight = PropUtility<T, FontWeight>(
    (prop) => onlyProps(fontWeight: prop),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => onlyProps(fontStyle: prop),
  );

  late final decoration = PropUtility<T, TextDecoration>(
    (prop) => onlyProps(decoration: prop),
  );

  late final fontSize = PropUtility<T, double>(
    (prop) => onlyProps(fontSize: prop),
  );

  late final backgroundColor = ColorUtility<T>(
    (prop) => onlyProps(backgroundColor: prop),
  );

  late final decorationColor = ColorUtility<T>(
    (prop) => onlyProps(decorationColor: prop),
  );

  late final decorationStyle = PropUtility<T, TextDecorationStyle>(
    (prop) => onlyProps(decorationStyle: prop),
  );

  late final textBaseline = PropUtility<T, TextBaseline>(
    (prop) => onlyProps(textBaseline: prop),
  );

  late final fontFamily = PropUtility<T, String>(
    (v) => onlyProps(fontFamily: v),
  );

  TextStyleUtility(super.builder) : super(convertToMix: TextStyleMix.value);

  @protected
  T onlyProps({
    Prop<Color>? color,
    Prop<Color>? backgroundColor,
    Prop<String>? fontFamily,
    List<Prop<String>>? fontFamilyFallback,
    Prop<double>? fontSize,
    Prop<FontWeight>? fontWeight,
    Prop<FontStyle>? fontStyle,
    Prop<double>? letterSpacing,
    Prop<double>? wordSpacing,
    Prop<TextBaseline>? textBaseline,
    Prop<double>? height,
    Prop<Paint>? foreground,
    Prop<Paint>? background,
    List<MixProp<Shadow>>? shadows,
    List<Prop<FontFeature>>? fontFeatures,
    Prop<TextDecoration>? decoration,
    Prop<Color>? decorationColor,
    Prop<TextDecorationStyle>? decorationStyle,
    Prop<double>? decorationThickness,
    Prop<String>? debugLabel,
    List<Prop<FontVariation>>? fontVariations,
  }) {
    return builder(
      MixProp(
        TextStyleMix.raw(
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
          shadows: shadows,
          fontFeatures: fontFeatures,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          debugLabel: debugLabel,
          fontVariations: fontVariations,
        ),
      ),
    );
  }

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
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    List<FontVariation>? fontVariations,
  }) {
    return onlyProps(
      color: Prop.maybe(color),
      backgroundColor: Prop.maybe(backgroundColor),
      fontFamily: Prop.maybe(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Prop.new).toList(),
      fontSize: Prop.maybe(fontSize),
      fontWeight: Prop.maybe(fontWeight),
      fontStyle: Prop.maybe(fontStyle),
      letterSpacing: Prop.maybe(letterSpacing),
      wordSpacing: Prop.maybe(wordSpacing),
      textBaseline: Prop.maybe(textBaseline),
      height: Prop.maybe(height),
      foreground: Prop.maybe(foreground),
      background: Prop.maybe(background),
      shadows: shadows?.map((s) => MixProp(ShadowMix.value(s))).toList(),
      fontFeatures: fontFeatures?.map(Prop.new).toList(),
      decoration: Prop.maybe(decoration),
      decorationColor: Prop.maybe(decorationColor),
      decorationStyle: Prop.maybe(decorationStyle),
      decorationThickness: Prop.maybe(decorationThickness),
      debugLabel: Prop.maybe(debugLabel),
      fontVariations: fontVariations?.map(Prop.new).toList(),
    );
  }

  T height(double v) => only(height: v);

  T wordSpacing(double v) => only(wordSpacing: v);

  T letterSpacing(double v) => only(letterSpacing: v);

  T fontVariations(List<FontVariation> v) => only(fontVariations: v);

  T fontVariation(FontVariation v) => only(fontVariations: [v]);

  T shadows(List<Shadow> v) => only(shadows: v);

  T italic() => fontStyle.italic();

  T bold() => fontWeight.bold();

  T foreground(Paint v) => only(foreground: v);

  T background(Paint v) => only(background: v);

  T fontFeatures(List<FontFeature> v) => only(fontFeatures: v);

  T debugLabel(String v) => only(debugLabel: v);

  T decorationThickness(double v) => only(decorationThickness: v);

  T fontFamilyFallback(List<String> v) => only(fontFamilyFallback: v);

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
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontVariations: fontVariations,
    );
  }

  T mix(TextStyleMix value) => builder(MixProp(value));
}

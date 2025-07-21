import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'color/color_util.dart';
import 'scalar_util.dart';
import 'shadow_mix.dart';
import 'text_style_mix.dart';

final class TextStyleUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, TextStyle> {
  late final color = ColorUtility<T>((prop) => call(TextStyleMix(color: prop)));

  late final fontWeight = FontWeightUtility<T>(
    (prop) => call(TextStyleMix(fontWeight: prop)),
  );

  late final fontStyle = FontStyleUtility<T>(
    (v) => call(TextStyleMix(fontStyle: v)),
  );

  late final decoration = TextDecorationUtility<T>(
    (prop) => call(TextStyleMix(decoration: prop)),
  );

  late final fontSize = FontSizeUtility<T>(
    (prop) => call(TextStyleMix(fontSize: prop)),
  );

  late final backgroundColor = ColorUtility<T>(
    (prop) => call(TextStyleMix(backgroundColor: prop)),
  );

  late final decorationColor = ColorUtility<T>(
    (prop) => call(TextStyleMix(decorationColor: prop)),
  );

  late final decorationStyle = TextDecorationStyleUtility<T>(
    (v) => call(TextStyleMix(decorationStyle: v)),
  );

  late final textBaseline = TextBaselineUtility<T>(
    (v) => call(TextStyleMix(textBaseline: v)),
  );

  late final fontFamily = FontFamilyUtility<T>(
    (v) => call(TextStyleMix(fontFamily: v)),
  );

  TextStyleUtility(super.builder) : super(convertToMix: TextStyleMix.value);

  T height(double v) => call(TextStyleMix.only(height: v));

  T wordSpacing(double v) => call(TextStyleMix.only(wordSpacing: v));

  T letterSpacing(double v) => call(TextStyleMix.only(letterSpacing: v));

  T fontVariations(List<FontVariation> v) =>
      call(TextStyleMix.only(fontVariations: v));

  T fontVariation(FontVariation v) =>
      call(TextStyleMix.only(fontVariations: [v]));

  T shadows(List<Shadow> v) =>
      call(TextStyleMix.only(shadows: v.map(ShadowMix.value).toList()));

  T italic() => fontStyle.italic();

  T bold() => fontWeight.bold();

  T foreground(Paint v) => call(TextStyleMix.only(foreground: v));

  T background(Paint v) => call(TextStyleMix.only(background: v));

  T fontFeatures(List<FontFeature> v) =>
      call(TextStyleMix.only(fontFeatures: v));

  T debugLabel(String v) => call(TextStyleMix.only(debugLabel: v));

  T decorationThickness(double v) =>
      call(TextStyleMix.only(decorationThickness: v));

  T fontFamilyFallback(List<String> v) =>
      call(TextStyleMix.only(fontFamilyFallback: v));

  @override
  T call(TextStyleMix value) => builder(MixProp(value));
}

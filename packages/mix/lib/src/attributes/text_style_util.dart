import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import '../utilities/color_util.dart';
import 'scalar_util.dart';
import 'shadow_mix.dart';
import 'text_style_mix.dart';

final class TextStyleUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, TextStyle> {
  late final color = ColorUtility<T>((prop) => call(TextStyleMix(color: prop)));

  late final fontWeight = FontWeightUtility<T>(
    (prop) => call(TextStyleMix(fontWeight: prop)),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => call(TextStyleMix(fontStyle: prop),)
  );

  late final decoration = TextDecorationUtility<T>(
    (prop) => call(TextStyleMix(decoration: prop)),
  );

  late final fontSize = PropUtility<T, double>(
    (prop) => call(TextStyleMix(fontSize: prop),)
  );

  late final backgroundColor = ColorUtility<T>(
    (prop) => call(TextStyleMix(backgroundColor: prop)),
  );

  late final decorationColor = ColorUtility<T>(
    (prop) => call(TextStyleMix(decorationColor: prop)),
  );

  late final decorationStyle = PropUtility<T, TextDecorationStyle>(
    (prop) => call(TextStyleMix(decorationStyle: prop),)
  );

  late final textBaseline = PropUtility<T, TextBaseline>(
    (prop) => call(TextStyleMix(textBaseline: prop),)
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

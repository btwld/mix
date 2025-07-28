import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../layout/enum_util.dart';
import '../layout/scalar_util.dart';
import '../painting/color_util.dart';
import '../painting/shadow_mix.dart';
import 'text_style_mix.dart';

final class TextStyleUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, TextStyle> {
  late final color = ColorUtility<T>(
    (prop) => call(TextStyleMix.raw(color: prop)),
  );

  late final fontWeight = PropUtility<T, FontWeight>(
    (prop) => call(TextStyleMix.raw(fontWeight: prop)),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => call(TextStyleMix.raw(fontStyle: prop)),
  );

  late final decoration = PropUtility<T, TextDecoration>(
    (prop) => call(TextStyleMix.raw(decoration: prop)),
  );

  late final fontSize = PropUtility<T, double>(
    (prop) => call(TextStyleMix.raw(fontSize: prop)),
  );

  late final backgroundColor = ColorUtility<T>(
    (prop) => call(TextStyleMix.raw(backgroundColor: prop)),
  );

  late final decorationColor = ColorUtility<T>(
    (prop) => call(TextStyleMix.raw(decorationColor: prop)),
  );

  late final decorationStyle = PropUtility<T, TextDecorationStyle>(
    (prop) => call(TextStyleMix.raw(decorationStyle: prop)),
  );

  late final textBaseline = PropUtility<T, TextBaseline>(
    (prop) => call(TextStyleMix.raw(textBaseline: prop)),
  );

  late final fontFamily = PropUtility<T, String>(
    (v) => call(TextStyleMix.raw(fontFamily: v)),
  );

  TextStyleUtility(super.builder) : super(convertToMix: TextStyleMix.value);

  T height(double v) => call(TextStyleMix(height: v));

  T wordSpacing(double v) => call(TextStyleMix(wordSpacing: v));

  T letterSpacing(double v) => call(TextStyleMix(letterSpacing: v));

  T fontVariations(List<FontVariation> v) =>
      call(TextStyleMix(fontVariations: v));

  T fontVariation(FontVariation v) => call(TextStyleMix(fontVariations: [v]));

  T shadows(List<Shadow> v) =>
      call(TextStyleMix(shadows: v.map(ShadowMix.value).toList()));

  T italic() => fontStyle.italic();

  T bold() => fontWeight.bold();

  T foreground(Paint v) => call(TextStyleMix(foreground: v));

  T background(Paint v) => call(TextStyleMix(background: v));

  T fontFeatures(List<FontFeature> v) => call(TextStyleMix(fontFeatures: v));

  T debugLabel(String v) => call(TextStyleMix(debugLabel: v));

  T decorationThickness(double v) => call(TextStyleMix(decorationThickness: v));

  T fontFamilyFallback(List<String> v) =>
      call(TextStyleMix(fontFamilyFallback: v));

  @override
  T call(TextStyleMix value) => builder(MixProp(value));
}

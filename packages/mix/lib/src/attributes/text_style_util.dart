import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'color/color_util.dart';
import 'scalar_util.dart';
import 'shadow_dto.dart';
import 'text_style_dto.dart';

final class TextStyleUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, TextStyle> {
  late final color = ColorUtility<T>((prop) => call(TextStyleDto(color: prop)));

  late final fontWeight = FontWeightUtility<T>(
    (prop) => call(TextStyleDto(fontWeight: prop)),
  );

  late final fontStyle = FontStyleUtility<T>(
    (v) => call(TextStyleDto(fontStyle: v)),
  );

  late final decoration = TextDecorationUtility<T>(
    (prop) => call(TextStyleDto(decoration: prop)),
  );

  late final fontSize = FontSizeUtility<T>(
    (prop) => call(TextStyleDto(fontSize: prop)),
  );

  late final backgroundColor = ColorUtility<T>(
    (prop) => call(TextStyleDto(backgroundColor: prop)),
  );

  late final decorationColor = ColorUtility<T>(
    (prop) => call(TextStyleDto(decorationColor: prop)),
  );

  late final decorationStyle = TextDecorationStyleUtility<T>(
    (v) => call(TextStyleDto(decorationStyle: v)),
  );

  late final textBaseline = TextBaselineUtility<T>(
    (v) => call(TextStyleDto(textBaseline: v)),
  );

  late final fontFamily = FontFamilyUtility<T>(
    (v) => call(TextStyleDto(fontFamily: v)),
  );

  TextStyleUtility(super.builder) : super(valueToMix: TextStyleDto.value);

  T height(double v) => call(TextStyleDto.only(height: v));

  T wordSpacing(double v) => call(TextStyleDto.only(wordSpacing: v));

  T letterSpacing(double v) => call(TextStyleDto.only(letterSpacing: v));

  T fontVariations(List<FontVariation> v) =>
      call(TextStyleDto.only(fontVariations: v));

  T fontVariation(FontVariation v) =>
      call(TextStyleDto.only(fontVariations: [v]));

  T shadows(List<Shadow> v) =>
      call(TextStyleDto.only(shadows: v.map(ShadowDto.value).toList()));

  T italic() => fontStyle.italic();

  T bold() => fontWeight.bold();

  T foreground(Paint v) => call(TextStyleDto.only(foreground: v));

  T background(Paint v) => call(TextStyleDto.only(background: v));

  T fontFeatures(List<FontFeature> v) =>
      call(TextStyleDto.only(fontFeatures: v));

  T debugLabel(String v) => call(TextStyleDto.only(debugLabel: v));

  T decorationThickness(double v) =>
      call(TextStyleDto.only(decorationThickness: v));

  T fontFamilyFallback(List<String> v) =>
      call(TextStyleDto.only(fontFamilyFallback: v));

  @override
  T call(TextStyleDto value) => builder(MixProp(value));
}

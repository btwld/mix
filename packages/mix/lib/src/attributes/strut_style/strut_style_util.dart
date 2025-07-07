import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../theme/tokens/mix_token.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'strut_style_dto.dart';

final class StrutStyleUtility<T extends StyleElement>
    extends DtoUtility<T, StrutStyleDto, StrutStyle> {
  late final fontWeight = FontWeightUtility((v) => only(fontWeight: Mixable.value(v)));

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: Mixable.value(v)));

  late final fontSize = FontSizeUtility((v) => only(fontSize: Mixable.value(v)));

  late final fontFamily = FontFamilyUtility((v) => call(fontFamily: v));

  StrutStyleUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  T token(MixableToken<StrutStyle> token) => builder(StrutStyleDto.token(token));

  T height(double v) => only(height: Mixable.value(v));

  T leading(double v) => only(leading: Mixable.value(v));

  T forceStrutHeight(bool v) => only(forceStrutHeight: Mixable.value(v));

  T fontFamilyFallback(List<String> v) => call(fontFamilyFallback: v);

  T call({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return only(
      fontFamily: Mixable.maybeValue(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Mixable.value).toList(),
      fontSize: Mixable.maybeValue(fontSize),
      fontWeight: Mixable.maybeValue(fontWeight),
      fontStyle: Mixable.maybeValue(fontStyle),
      height: Mixable.maybeValue(height),
      leading: Mixable.maybeValue(leading),
      forceStrutHeight: Mixable.maybeValue(forceStrutHeight),
    );
  }

  @override
  T only({
    Mixable<String>? fontFamily,
    List<Mixable<String>>? fontFamilyFallback,
    Mixable<double>? fontSize,
    Mixable<FontWeight>? fontWeight,
    Mixable<FontStyle>? fontStyle,
    Mixable<double>? height,
    Mixable<double>? leading,
    Mixable<bool>? forceStrutHeight,
  }) {
    final strutStyle = ValueStrutStyleDto(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    );

    return builder(strutStyle);
  }
}
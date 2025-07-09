import 'package:flutter/widgets.dart';

import '../../core/element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'strut_style_dto.dart';

final class StrutStyleUtility<T extends StyleElement>
    extends DtoUtility<T, StrutStyleDto, StrutStyle> {
  late final fontWeight = FontWeightUtility(
    (v) => only(fontWeight: Mix.value(v)),
  );

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: Mix.value(v)));

  late final fontSize = FontSizeUtility((v) => only(fontSize: Mix.value(v)));

  late final fontFamily = FontFamilyUtility(
    (v) => only(fontFamily: Mix.value(v)),
  );

  StrutStyleUtility(super.builder)
    : super(valueToDto: (v) => StrutStyleDto.from(v));

  T token(MixableToken<StrutStyle> token) => throw UnimplementedError(
    'Token support for StrutStyle needs to be redesigned for the simplified DTO pattern',
  );

  T height(double v) => only(height: Mix.value(v));

  T leading(double v) => only(leading: Mix.value(v));

  T forceStrutHeight(bool v) => only(forceStrutHeight: Mix.value(v));

  T fontFamilyFallback(List<String> v) =>
      only(fontFamilyFallback: v.map(Mix.value).toList());

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
      fontFamily: Mix.maybeValue(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Mix.value).toList(),
      fontSize: Mix.maybeValue(fontSize),
      fontWeight: Mix.maybeValue(fontWeight),
      fontStyle: Mix.maybeValue(fontStyle),
      height: Mix.maybeValue(height),
      leading: Mix.maybeValue(leading),
      forceStrutHeight: Mix.maybeValue(forceStrutHeight),
    );
  }

  @override
  T only({
    Mix<String>? fontFamily,
    List<Mix<String>>? fontFamilyFallback,
    Mix<double>? fontSize,
    Mix<FontWeight>? fontWeight,
    Mix<FontStyle>? fontStyle,
    Mix<double>? height,
    Mix<double>? leading,
    Mix<bool>? forceStrutHeight,
  }) {
    return builder(
      StrutStyleDto.raw(
        fontFamily: MixProperty(fontFamily),
        fontFamilyFallback: MixProperty(
          fontFamilyFallback != null ? MixableList(fontFamilyFallback) : null,
        ),
        fontSize: MixProperty(fontSize),
        fontWeight: MixProperty(fontWeight),
        fontStyle: MixProperty(fontStyle),
        height: MixProperty(height),
        leading: MixProperty(leading),
        forceStrutHeight: MixProperty(forceStrutHeight),
      ),
    );
  }
}

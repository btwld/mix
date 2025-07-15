import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../../theme/tokens/mix_token.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'strut_style_dto.dart';

final class StrutStyleUtility<T extends StyleElement>
    extends DtoUtility<T, StrutStyleDto, StrutStyle> {
  late final fontWeight = FontWeightUtility((v) => only(fontWeight: v));

  late final fontStyle = FontStyleUtility((v) => only(fontStyle: v));

  late final fontSize = FontSizeUtility((v) => only(fontSize: v));

  late final fontFamily = FontFamilyUtility((v) => only(fontFamily: v));

  StrutStyleUtility(super.builder)
    : super(
        valueToDto: (v) => StrutStyleDto(
          fontFamily: v.fontFamily,
          fontFamilyFallback: v.fontFamilyFallback,
          fontSize: v.fontSize,
          fontWeight: v.fontWeight,
          fontStyle: v.fontStyle,
          height: v.height,
          leading: v.leading,
          forceStrutHeight: v.forceStrutHeight,
        ),
      );

  T token(MixableToken<StrutStyle> token) => throw UnimplementedError(
    'Token support for StrutStyle needs to be redesigned for the simplified DTO pattern',
  );

  T height(double v) => only(height: v);

  T leading(double v) => only(leading: v);

  T forceStrutHeight(bool v) => only(forceStrutHeight: v);

  T fontFamilyFallback(List<String> v) => only(fontFamilyFallback: v);

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
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      leading: leading,
      forceStrutHeight: forceStrutHeight,
    );
  }

  @override
  T only({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    return builder(
      StrutStyleDto(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
        leading: leading,
        forceStrutHeight: forceStrutHeight,
      ),
    );
  }
}

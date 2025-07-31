import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StrutStyleMix, StrutStyle> {
  late final fontWeight = MixUtility<T, FontWeight>(
    (prop) => only(fontWeight: prop),
  );

  late final fontStyle = MixUtility<T, FontStyle>(
    (prop) => only(fontStyle: prop),
  );

  late final fontSize = MixUtility<T, double>((prop) => only(fontSize: prop));

  late final fontFamily = MixUtility<T, String>((v) => only(fontFamily: v));

  StrutStyleUtility(super.builder);

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
      StrutStyleMix(
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
  T as(StrutStyle value) {
    return builder(StrutStyleMix.value(value));
  }
}

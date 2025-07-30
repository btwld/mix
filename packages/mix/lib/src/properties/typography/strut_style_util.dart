import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StrutStyleMix, StrutStyle> {
  late final fontWeight = PropUtility<T, FontWeight>(
    (prop) => only(fontWeight: prop),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => only(fontStyle: prop),
  );

  late final fontSize = PropUtility<T, double>((prop) => only(fontSize: prop));

  late final fontFamily = PropUtility<T, String>((v) => only(fontFamily: v));

  StrutStyleUtility(super.builder) : super(convertToMix: StrutStyleMix.value);

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
}

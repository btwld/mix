import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends Style<Object?>>
    extends MixUtility<T, StrutStyleMix> {
  late final fontWeight = MixUtility<T, FontWeight>(
    (prop) => call(fontWeight: prop),
  );

  late final fontStyle = MixUtility<T, FontStyle>(
    (prop) => call(fontStyle: prop),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;

  StrutStyleUtility(super.builder);

  T fontSize(double value) => call(fontSize: value);

  T fontFamily(String value) => call(fontFamily: value);

  T height(double value) => call(height: value);

  T leading(double value) => call(leading: value);

  T forceStrutHeight(bool value) => call(forceStrutHeight: value);

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

  T as(StrutStyle value) {
    return builder(StrutStyleMix.value(value));
  }
}

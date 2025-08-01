import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StrutStyleMix, StrutStyle> {
  @Deprecated('Use call(fontFamily: value) instead')
  late final fontWeight = MixUtility<T, FontWeight>(
    (prop) => call(fontWeight: prop),
  );

  @Deprecated('Use call(fontStyle: value) instead')
  late final fontStyle = MixUtility<T, FontStyle>(
    (prop) => call(fontStyle: prop),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;

  StrutStyleUtility(super.builder);

  @Deprecated('Use call(fontSize: value) instead')
  T fontSize(double value) => call(fontSize: value);

  @Deprecated('Use call(fontFamily: value) instead')
  T fontFamily(String value) => call(fontFamily: value);

  @Deprecated('Use call(height: value) instead')
  T height(double value) => call(height: value);

  @Deprecated('Use call(leading: value) instead')
  T leading(double value) => call(leading: value);

  @Deprecated('Use call(forceStrutHeight: value) instead')
  T forceStrutHeight(bool value) => call(forceStrutHeight: value);

  T call({
    StrutStyle? as,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    double? leading,
    bool? forceStrutHeight,
  }) {
    if (as != null) {
      return builder(StrutStyleMix.value(as));
    }

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

  @override
  @Deprecated('Use call(as: value) instead')
  T as(StrutStyle value) {
    return builder(StrutStyleMix.value(value));
  }
}

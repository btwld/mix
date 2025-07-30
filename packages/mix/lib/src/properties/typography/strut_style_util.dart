import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'strut_style_mix.dart';

final class StrutStyleUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StrutStyle> {
  late final fontWeight = PropUtility<T, FontWeight>(
    (prop) => onlyProps(fontWeight: prop),
  );

  late final fontStyle = PropUtility<T, FontStyle>(
    (prop) => onlyProps(fontStyle: prop),
  );

  late final fontSize = PropUtility<T, double>(
    (prop) => onlyProps(fontSize: prop),
  );

  late final fontFamily = PropUtility<T, String>(
    (v) => onlyProps(fontFamily: v),
  );

  StrutStyleUtility(super.builder) : super(convertToMix: StrutStyleMix.value);

  @protected
  T onlyProps({
    Prop<String>? fontFamily,
    List<Prop<String>>? fontFamilyFallback,
    Prop<double>? fontSize,
    Prop<FontWeight>? fontWeight,
    Prop<FontStyle>? fontStyle,
    Prop<double>? height,
    Prop<double>? leading,
    Prop<bool>? forceStrutHeight,
  }) {
    return builder(
      MixProp(
        StrutStyleMix.raw(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          height: height,
          leading: leading,
          forceStrutHeight: forceStrutHeight,
        ),
      ),
    );
  }

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
    return onlyProps(
      fontFamily: Prop.maybe(fontFamily),
      fontFamilyFallback: fontFamilyFallback?.map(Prop.new).toList(),
      fontSize: Prop.maybe(fontSize),
      fontWeight: Prop.maybe(fontWeight),
      fontStyle: Prop.maybe(fontStyle),
      height: Prop.maybe(height),
      leading: Prop.maybe(leading),
      forceStrutHeight: Prop.maybe(forceStrutHeight),
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

  T mix(StrutStyleMix value) => builder(MixProp(value));
}

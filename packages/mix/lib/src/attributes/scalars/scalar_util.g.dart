// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scalar_util.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// {@template alignment_utility}
/// A utility class for creating [StyleElement] instances from [AlignmentGeometry] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [AlignmentGeometry] values.
/// {@endtemplate}
mixin _$AlignmentUtility<T extends StyleElement>
    on MixUtility<T, AlignmentGeometry> {
  /// Creates a [StyleElement] instance with [Alignment.topLeft] value.
  T topLeft() => builder(Alignment.topLeft);

  /// Creates a [StyleElement] instance with [Alignment.topCenter] value.
  T topCenter() => builder(Alignment.topCenter);

  /// Creates a [StyleElement] instance with [Alignment.topRight] value.
  T topRight() => builder(Alignment.topRight);

  /// Creates a [StyleElement] instance with [Alignment.centerLeft] value.
  T centerLeft() => builder(Alignment.centerLeft);

  /// Creates a [StyleElement] instance with [Alignment.center] value.
  T center() => builder(Alignment.center);

  /// Creates a [StyleElement] instance with [Alignment.centerRight] value.
  T centerRight() => builder(Alignment.centerRight);

  /// Creates a [StyleElement] instance with [Alignment.bottomLeft] value.
  T bottomLeft() => builder(Alignment.bottomLeft);

  /// Creates a [StyleElement] instance with [Alignment.bottomCenter] value.
  T bottomCenter() => builder(Alignment.bottomCenter);

  /// Creates a [StyleElement] instance with [Alignment.bottomRight] value.
  T bottomRight() => builder(Alignment.bottomRight);

  /// Creates a [StyleElement] instance with the specified AlignmentGeometry value.
  T call(AlignmentGeometry value) => builder(value);
}

/// {@template alignment_directional_utility}
/// A utility class for creating [StyleElement] instances from [AlignmentDirectional] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [AlignmentDirectional] values.
/// {@endtemplate}
mixin _$AlignmentDirectionalUtility<T extends StyleElement>
    on MixUtility<T, AlignmentDirectional> {
  /// Creates a [StyleElement] instance with [AlignmentDirectional.topStart] value.
  T topStart() => builder(AlignmentDirectional.topStart);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.topCenter] value.
  T topCenter() => builder(AlignmentDirectional.topCenter);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.topEnd] value.
  T topEnd() => builder(AlignmentDirectional.topEnd);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.centerStart] value.
  T centerStart() => builder(AlignmentDirectional.centerStart);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.center] value.
  T center() => builder(AlignmentDirectional.center);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.centerEnd] value.
  T centerEnd() => builder(AlignmentDirectional.centerEnd);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.bottomStart] value.
  T bottomStart() => builder(AlignmentDirectional.bottomStart);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.bottomCenter] value.
  T bottomCenter() => builder(AlignmentDirectional.bottomCenter);

  /// Creates a [StyleElement] instance with [AlignmentDirectional.bottomEnd] value.
  T bottomEnd() => builder(AlignmentDirectional.bottomEnd);

  /// Creates a [StyleElement] instance with the specified AlignmentDirectional value.
  T call(AlignmentDirectional value) => builder(value);
}

/// {@template font_feature_utility}
/// A utility class for creating [StyleElement] instances from [FontFeature] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FontFeature] values.
/// {@endtemplate}
mixin _$FontFeatureUtility<T extends StyleElement>
    on MixUtility<T, FontFeature> {
  /// Creates a [StyleElement] instance using the [FontFeature.enable] constructor.
  T enable(String feature) => builder(FontFeature.enable(feature));

  /// Creates a [StyleElement] instance using the [FontFeature.disable] constructor.
  T disable(String feature) => builder(FontFeature.disable(feature));

  /// Creates a [StyleElement] instance using the [FontFeature.alternative] constructor.
  T alternative(int value) => builder(FontFeature.alternative(value));

  /// Creates a [StyleElement] instance using the [FontFeature.alternativeFractions] constructor.
  T alternativeFractions() => builder(const FontFeature.alternativeFractions());

  /// Creates a [StyleElement] instance using the [FontFeature.contextualAlternates] constructor.
  T contextualAlternates() => builder(const FontFeature.contextualAlternates());

  /// Creates a [StyleElement] instance using the [FontFeature.caseSensitiveForms] constructor.
  T caseSensitiveForms() => builder(const FontFeature.caseSensitiveForms());

  /// Creates a [StyleElement] instance using the [FontFeature.characterVariant] constructor.
  T characterVariant(int value) => builder(FontFeature.characterVariant(value));

  /// Creates a [StyleElement] instance using the [FontFeature.denominator] constructor.
  T denominator() => builder(const FontFeature.denominator());

  /// Creates a [StyleElement] instance using the [FontFeature.fractions] constructor.
  T fractions() => builder(const FontFeature.fractions());

  /// Creates a [StyleElement] instance using the [FontFeature.historicalForms] constructor.
  T historicalForms() => builder(const FontFeature.historicalForms());

  /// Creates a [StyleElement] instance using the [FontFeature.historicalLigatures] constructor.
  T historicalLigatures() => builder(const FontFeature.historicalLigatures());

  /// Creates a [StyleElement] instance using the [FontFeature.liningFigures] constructor.
  T liningFigures() => builder(const FontFeature.liningFigures());

  /// Creates a [StyleElement] instance using the [FontFeature.localeAware] constructor.
  T localeAware({bool enable = true}) {
    return builder(FontFeature.localeAware(enable: enable));
  }

  /// Creates a [StyleElement] instance using the [FontFeature.notationalForms] constructor.
  T notationalForms([int value = 1]) =>
      builder(FontFeature.notationalForms(value));

  /// Creates a [StyleElement] instance using the [FontFeature.numerators] constructor.
  T numerators() => builder(const FontFeature.numerators());

  /// Creates a [StyleElement] instance using the [FontFeature.oldstyleFigures] constructor.
  T oldstyleFigures() => builder(const FontFeature.oldstyleFigures());

  /// Creates a [StyleElement] instance using the [FontFeature.ordinalForms] constructor.
  T ordinalForms() => builder(const FontFeature.ordinalForms());

  /// Creates a [StyleElement] instance using the [FontFeature.proportionalFigures] constructor.
  T proportionalFigures() => builder(const FontFeature.proportionalFigures());

  /// Creates a [StyleElement] instance using the [FontFeature.randomize] constructor.
  T randomize() => builder(const FontFeature.randomize());

  /// Creates a [StyleElement] instance using the [FontFeature.stylisticAlternates] constructor.
  T stylisticAlternates() => builder(const FontFeature.stylisticAlternates());

  /// Creates a [StyleElement] instance using the [FontFeature.scientificInferiors] constructor.
  T scientificInferiors() => builder(const FontFeature.scientificInferiors());

  /// Creates a [StyleElement] instance using the [FontFeature.stylisticSet] constructor.
  T stylisticSet(int value) => builder(FontFeature.stylisticSet(value));

  /// Creates a [StyleElement] instance using the [FontFeature.subscripts] constructor.
  T subscripts() => builder(const FontFeature.subscripts());

  /// Creates a [StyleElement] instance using the [FontFeature.superscripts] constructor.
  T superscripts() => builder(const FontFeature.superscripts());

  /// Creates a [StyleElement] instance using the [FontFeature.swash] constructor.
  T swash([int value = 1]) => builder(FontFeature.swash(value));

  /// Creates a [StyleElement] instance using the [FontFeature.tabularFigures] constructor.
  T tabularFigures() => builder(const FontFeature.tabularFigures());

  /// Creates a [StyleElement] instance using the [FontFeature.slashedZero] constructor.
  T slashedZero() => builder(const FontFeature.slashedZero());

  /// Creates a [StyleElement] instance with the specified FontFeature value.
  T call(FontFeature value) => builder(value);
}

/// {@template duration_utility}
/// A utility class for creating [StyleElement] instances from [Duration] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Duration] values.
/// {@endtemplate}
mixin _$DurationUtility<T extends StyleElement> on MixUtility<T, Duration> {
  /// Creates a [StyleElement] instance with [Duration.zero] value.
  T zero() => builder(Duration.zero);

  /// Creates a [StyleElement] instance with the specified Duration value.
  T call(Duration value) => builder(value);
}

/// {@template font_weight_utility}
/// A utility class for creating [StyleElement] instances from [FontWeight] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [FontWeight] values.
/// {@endtemplate}
mixin _$FontWeightUtility<T extends StyleElement> on MixUtility<T, FontWeight> {
  /// Creates a [StyleElement] instance with [FontWeight.w100] value.
  T w100() => builder(FontWeight.w100);

  /// Creates a [StyleElement] instance with [FontWeight.w200] value.
  T w200() => builder(FontWeight.w200);

  /// Creates a [StyleElement] instance with [FontWeight.w300] value.
  T w300() => builder(FontWeight.w300);

  /// Creates a [StyleElement] instance with [FontWeight.w400] value.
  T w400() => builder(FontWeight.w400);

  /// Creates a [StyleElement] instance with [FontWeight.w500] value.
  T w500() => builder(FontWeight.w500);

  /// Creates a [StyleElement] instance with [FontWeight.w600] value.
  T w600() => builder(FontWeight.w600);

  /// Creates a [StyleElement] instance with [FontWeight.w700] value.
  T w700() => builder(FontWeight.w700);

  /// Creates a [StyleElement] instance with [FontWeight.w800] value.
  T w800() => builder(FontWeight.w800);

  /// Creates a [StyleElement] instance with [FontWeight.w900] value.
  T w900() => builder(FontWeight.w900);

  /// Creates a [StyleElement] instance with [FontWeight.normal] value.
  T normal() => builder(FontWeight.normal);

  /// Creates a [StyleElement] instance with [FontWeight.bold] value.
  T bold() => builder(FontWeight.bold);

  /// Creates a [StyleElement] instance with the specified FontWeight value.
  T call(FontWeight value) => builder(value);
}

/// {@template text_decoration_utility}
/// A utility class for creating [StyleElement] instances from [TextDecoration] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextDecoration] values.
/// {@endtemplate}
mixin _$TextDecorationUtility<T extends StyleElement>
    on MixUtility<T, TextDecoration> {
  /// Creates a [StyleElement] instance with [TextDecoration.none] value.
  T none() => builder(TextDecoration.none);

  /// Creates a [StyleElement] instance with [TextDecoration.underline] value.
  T underline() => builder(TextDecoration.underline);

  /// Creates a [StyleElement] instance with [TextDecoration.overline] value.
  T overline() => builder(TextDecoration.overline);

  /// Creates a [StyleElement] instance with [TextDecoration.lineThrough] value.
  T lineThrough() => builder(TextDecoration.lineThrough);

  /// Creates a [StyleElement] instance using the [TextDecoration.combine] constructor.
  T combine(List<TextDecoration> decorations) {
    return builder(TextDecoration.combine(decorations));
  }

  /// Creates a [StyleElement] instance with the specified TextDecoration value.
  T call(TextDecoration value) => builder(value);
}

/// {@template curve_utility}
/// A utility class for creating [StyleElement] instances from [Curve] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Curve] values.
/// {@endtemplate}
mixin _$CurveUtility<T extends StyleElement> on MixUtility<T, Curve> {
  /// Creates a [StyleElement] instance with [Curves.linear] value.
  T linear() => builder(Curves.linear);

  /// Creates a [StyleElement] instance with [Curves.decelerate] value.
  T decelerate() => builder(Curves.decelerate);

  /// Creates a [StyleElement] instance with [Curves.fastLinearToSlowEaseIn] value.
  T fastLinearToSlowEaseIn() => builder(Curves.fastLinearToSlowEaseIn);

  /// Creates a [StyleElement] instance with [Curves.fastEaseInToSlowEaseOut] value.
  T fastEaseInToSlowEaseOut() => builder(Curves.fastEaseInToSlowEaseOut);

  /// Creates a [StyleElement] instance with [Curves.ease] value.
  T ease() => builder(Curves.ease);

  /// Creates a [StyleElement] instance with [Curves.easeIn] value.
  T easeIn() => builder(Curves.easeIn);

  /// Creates a [StyleElement] instance with [Curves.easeInToLinear] value.
  T easeInToLinear() => builder(Curves.easeInToLinear);

  /// Creates a [StyleElement] instance with [Curves.easeInSine] value.
  T easeInSine() => builder(Curves.easeInSine);

  /// Creates a [StyleElement] instance with [Curves.easeInQuad] value.
  T easeInQuad() => builder(Curves.easeInQuad);

  /// Creates a [StyleElement] instance with [Curves.easeInCubic] value.
  T easeInCubic() => builder(Curves.easeInCubic);

  /// Creates a [StyleElement] instance with [Curves.easeInQuart] value.
  T easeInQuart() => builder(Curves.easeInQuart);

  /// Creates a [StyleElement] instance with [Curves.easeInQuint] value.
  T easeInQuint() => builder(Curves.easeInQuint);

  /// Creates a [StyleElement] instance with [Curves.easeInExpo] value.
  T easeInExpo() => builder(Curves.easeInExpo);

  /// Creates a [StyleElement] instance with [Curves.easeInCirc] value.
  T easeInCirc() => builder(Curves.easeInCirc);

  /// Creates a [StyleElement] instance with [Curves.easeInBack] value.
  T easeInBack() => builder(Curves.easeInBack);

  /// Creates a [StyleElement] instance with [Curves.easeOut] value.
  T easeOut() => builder(Curves.easeOut);

  /// Creates a [StyleElement] instance with [Curves.linearToEaseOut] value.
  T linearToEaseOut() => builder(Curves.linearToEaseOut);

  /// Creates a [StyleElement] instance with [Curves.easeOutSine] value.
  T easeOutSine() => builder(Curves.easeOutSine);

  /// Creates a [StyleElement] instance with [Curves.easeOutQuad] value.
  T easeOutQuad() => builder(Curves.easeOutQuad);

  /// Creates a [StyleElement] instance with [Curves.easeOutCubic] value.
  T easeOutCubic() => builder(Curves.easeOutCubic);

  /// Creates a [StyleElement] instance with [Curves.easeOutQuart] value.
  T easeOutQuart() => builder(Curves.easeOutQuart);

  /// Creates a [StyleElement] instance with [Curves.easeOutQuint] value.
  T easeOutQuint() => builder(Curves.easeOutQuint);

  /// Creates a [StyleElement] instance with [Curves.easeOutExpo] value.
  T easeOutExpo() => builder(Curves.easeOutExpo);

  /// Creates a [StyleElement] instance with [Curves.easeOutCirc] value.
  T easeOutCirc() => builder(Curves.easeOutCirc);

  /// Creates a [StyleElement] instance with [Curves.easeOutBack] value.
  T easeOutBack() => builder(Curves.easeOutBack);

  /// Creates a [StyleElement] instance with [Curves.easeInOut] value.
  T easeInOut() => builder(Curves.easeInOut);

  /// Creates a [StyleElement] instance with [Curves.easeInOutSine] value.
  T easeInOutSine() => builder(Curves.easeInOutSine);

  /// Creates a [StyleElement] instance with [Curves.easeInOutQuad] value.
  T easeInOutQuad() => builder(Curves.easeInOutQuad);

  /// Creates a [StyleElement] instance with [Curves.easeInOutCubic] value.
  T easeInOutCubic() => builder(Curves.easeInOutCubic);

  /// Creates a [StyleElement] instance with [Curves.easeInOutCubicEmphasized] value.
  T easeInOutCubicEmphasized() => builder(Curves.easeInOutCubicEmphasized);

  /// Creates a [StyleElement] instance with [Curves.easeInOutQuart] value.
  T easeInOutQuart() => builder(Curves.easeInOutQuart);

  /// Creates a [StyleElement] instance with [Curves.easeInOutQuint] value.
  T easeInOutQuint() => builder(Curves.easeInOutQuint);

  /// Creates a [StyleElement] instance with [Curves.easeInOutExpo] value.
  T easeInOutExpo() => builder(Curves.easeInOutExpo);

  /// Creates a [StyleElement] instance with [Curves.easeInOutCirc] value.
  T easeInOutCirc() => builder(Curves.easeInOutCirc);

  /// Creates a [StyleElement] instance with [Curves.easeInOutBack] value.
  T easeInOutBack() => builder(Curves.easeInOutBack);

  /// Creates a [StyleElement] instance with [Curves.fastOutSlowIn] value.
  T fastOutSlowIn() => builder(Curves.fastOutSlowIn);

  /// Creates a [StyleElement] instance with [Curves.slowMiddle] value.
  T slowMiddle() => builder(Curves.slowMiddle);

  /// Creates a [StyleElement] instance with [Curves.bounceIn] value.
  T bounceIn() => builder(Curves.bounceIn);

  /// Creates a [StyleElement] instance with [Curves.bounceOut] value.
  T bounceOut() => builder(Curves.bounceOut);

  /// Creates a [StyleElement] instance with [Curves.bounceInOut] value.
  T bounceInOut() => builder(Curves.bounceInOut);

  /// Creates a [StyleElement] instance with [Curves.elasticIn] value.
  T elasticIn() => builder(Curves.elasticIn);

  /// Creates a [StyleElement] instance with [Curves.elasticOut] value.
  T elasticOut() => builder(Curves.elasticOut);

  /// Creates a [StyleElement] instance with [Curves.elasticInOut] value.
  T elasticInOut() => builder(Curves.elasticInOut);

  /// Creates a [StyleElement] instance with the specified Curve value.
  T call(Curve value) => builder(value);
}

/// {@template offset_utility}
/// A utility class for creating [StyleElement] instances from [Offset] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Offset] values.
/// {@endtemplate}
mixin _$OffsetUtility<T extends StyleElement> on MixUtility<T, Offset> {
  /// Creates a [StyleElement] instance with [Offset.zero] value.
  T zero() => builder(Offset.zero);

  /// Creates a [StyleElement] instance with [Offset.infinite] value.
  T infinite() => builder(Offset.infinite);

  /// Creates a [StyleElement] instance using the [Offset] constructor.
  T call(double dx, double dy) => builder(Offset(dx, dy));

  /// Creates a [StyleElement] instance using the [Offset.fromDirection] constructor.
  T fromDirection(double direction, [double distance = 1.0]) {
    return builder(Offset.fromDirection(direction, distance));
  }
}

/// {@template radius_utility}
/// A utility class for creating [StyleElement] instances from [Radius] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Radius] values.
/// {@endtemplate}
mixin _$RadiusUtility<T extends StyleElement> on MixUtility<T, Radius> {
  /// Creates a [StyleElement] instance with [Radius.zero] value.
  T zero() => builder(Radius.zero);

  /// Creates a [StyleElement] instance using the [Radius.circular] constructor.
  T circular(double radius) => builder(Radius.circular(radius));

  /// Creates a [StyleElement] instance using the [Radius.elliptical] constructor.
  T elliptical(double x, double y) => builder(Radius.elliptical(x, y));
}

/// {@template rect_utility}
/// A utility class for creating [StyleElement] instances from [Rect] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Rect] values.
/// {@endtemplate}
mixin _$RectUtility<T extends StyleElement> on MixUtility<T, Rect> {
  /// Creates a [StyleElement] instance with [Rect.zero] value.
  T zero() => builder(Rect.zero);

  /// Creates a [StyleElement] instance with [Rect.largest] value.
  T largest() => builder(Rect.largest);

  /// Creates a [StyleElement] instance using the [Rect.fromLTRB] constructor.
  T fromLTRB(double left, double top, double right, double bottom) {
    return builder(Rect.fromLTRB(left, top, right, bottom));
  }

  /// Creates a [StyleElement] instance using the [Rect.fromLTWH] constructor.
  T fromLTWH(double left, double top, double width, double height) {
    return builder(Rect.fromLTWH(left, top, width, height));
  }

  /// Creates a [StyleElement] instance using the [Rect.fromCircle] constructor.
  T fromCircle({required Offset center, required double radius}) {
    return builder(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a [StyleElement] instance using the [Rect.fromCenter] constructor.
  T fromCenter(
      {required Offset center, required double width, required double height}) {
    return builder(
        Rect.fromCenter(center: center, width: width, height: height));
  }

  /// Creates a [StyleElement] instance using the [Rect.fromPoints] constructor.
  T fromPoints(Offset a, Offset b) => builder(Rect.fromPoints(a, b));

  /// Creates a [StyleElement] instance with the specified Rect value.
  T call(Rect value) => builder(value);
}

/// {@template image_provider_utility}
/// A utility class for creating [StyleElement] instances from [ImageProvider] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [ImageProvider] values.
/// {@endtemplate}
mixin _$ImageProviderUtility<T extends StyleElement>
    on MixUtility<T, ImageProvider> {
  /// Creates a [StyleElement] instance with the specified ImageProvider value.
  T call(ImageProvider value) => builder(value);
}

/// {@template gradient_transform_utility}
/// A utility class for creating [StyleElement] instances from [GradientTransform] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [GradientTransform] values.
/// {@endtemplate}
mixin _$GradientTransformUtility<T extends StyleElement>
    on MixUtility<T, GradientTransform> {
  /// Creates a [StyleElement] instance with the specified GradientTransform value.
  T call(GradientTransform value) => builder(value);
}

/// {@template matrix4_utility}
/// A utility class for creating [StyleElement] instances from [Matrix4] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [Matrix4] values.
/// {@endtemplate}
mixin _$Matrix4Utility<T extends StyleElement> on MixUtility<T, Matrix4> {
  /// Creates a [StyleElement] instance using the [Matrix4.fromList] constructor.
  T fromList(List<double> values) => builder(Matrix4.fromList(values));

  /// Creates a [StyleElement] instance using the [Matrix4.zero] constructor.
  T zero() => builder(Matrix4.zero());

  /// Creates a [StyleElement] instance using the [Matrix4.identity] constructor.
  T identity() => builder(Matrix4.identity());

  /// Creates a [StyleElement] instance using the [Matrix4.rotationX] constructor.
  T rotationX(double radians) => builder(Matrix4.rotationX(radians));

  /// Creates a [StyleElement] instance using the [Matrix4.rotationY] constructor.
  T rotationY(double radians) => builder(Matrix4.rotationY(radians));

  /// Creates a [StyleElement] instance using the [Matrix4.rotationZ] constructor.
  T rotationZ(double radians) => builder(Matrix4.rotationZ(radians));

  /// Creates a [StyleElement] instance using the [Matrix4.translationValues] constructor.
  T translationValues(double x, double y, double z) {
    return builder(Matrix4.translationValues(x, y, z));
  }

  /// Creates a [StyleElement] instance using the [Matrix4.diagonal3Values] constructor.
  T diagonal3Values(double x, double y, double z) {
    return builder(Matrix4.diagonal3Values(x, y, z));
  }

  /// Creates a [StyleElement] instance using the [Matrix4.skewX] constructor.
  T skewX(double alpha) => builder(Matrix4.skewX(alpha));

  /// Creates a [StyleElement] instance using the [Matrix4.skewY] constructor.
  T skewY(double beta) => builder(Matrix4.skewY(beta));

  /// Creates a [StyleElement] instance using the [Matrix4.skew] constructor.
  T skew(double alpha, double beta) => builder(Matrix4.skew(alpha, beta));

  /// Creates a [StyleElement] instance using the [Matrix4.fromBuffer] constructor.
  T fromBuffer(ByteBuffer buffer, int offset) {
    return builder(Matrix4.fromBuffer(buffer, offset));
  }

  /// Creates a [StyleElement] instance with the specified Matrix4 value.
  T call(Matrix4 value) => builder(value);
}

/// {@template font_family_utility}
/// A utility class for creating [StyleElement] instances from [String] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [String] values.
/// {@endtemplate}
mixin _$FontFamilyUtility<T extends StyleElement> on MixUtility<T, String> {
  /// Creates a [StyleElement] instance using the [String.fromCharCodes] constructor.
  T fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]) {
    return builder(String.fromCharCodes(charCodes, start, end));
  }

  /// Creates a [StyleElement] instance using the [String.fromCharCode] constructor.
  T fromCharCode(int charCode) => builder(String.fromCharCode(charCode));

  /// Creates a [StyleElement] instance using the [String.fromEnvironment] constructor.
  T fromEnvironment(String name, {String defaultValue = ""}) {
    return builder(String.fromEnvironment(name, defaultValue: defaultValue));
  }

  /// Creates a [StyleElement] instance with the specified String value.
  T call(String value) => builder(value);
}

/// {@template text_scaler_utility}
/// A utility class for creating [StyleElement] instances from [TextScaler] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TextScaler] values.
/// {@endtemplate}
mixin _$TextScalerUtility<T extends StyleElement> on MixUtility<T, TextScaler> {
  /// Creates a [StyleElement] instance with [TextScaler.noScaling] value.
  T noScaling() => builder(TextScaler.noScaling);

  /// Creates a [StyleElement] instance using the [TextScaler.linear] constructor.
  T linear(double textScaleFactor) =>
      builder(TextScaler.linear(textScaleFactor));

  /// Creates a [StyleElement] instance with the specified TextScaler value.
  T call(TextScaler value) => builder(value);
}

/// {@template table_column_width_utility}
/// A utility class for creating [StyleElement] instances from [TableColumnWidth] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TableColumnWidth] values.
/// {@endtemplate}
mixin _$TableColumnWidthUtility<T extends StyleElement>
    on MixUtility<T, TableColumnWidth> {
  /// Creates a [StyleElement] instance with the specified TableColumnWidth value.
  T call(TableColumnWidth value) => builder(value);
}

/// {@template table_border_utility}
/// A utility class for creating [StyleElement] instances from [TableBorder] values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// from predefined [TableBorder] values.
/// {@endtemplate}
mixin _$TableBorderUtility<T extends StyleElement>
    on MixUtility<T, TableBorder> {
  /// Creates a [StyleElement] instance using the [TableBorder.all] constructor.
  T all(
      {Color color = const Color(0xFF000000),
      double width = 1.0,
      BorderStyle style = BorderStyle.solid,
      BorderRadius borderRadius = BorderRadius.zero}) {
    return builder(TableBorder.all(
        color: color, width: width, style: style, borderRadius: borderRadius));
  }

  /// Creates a [StyleElement] instance using the [TableBorder.symmetric] constructor.
  T symmetric(
      {BorderSide inside = BorderSide.none,
      BorderSide outside = BorderSide.none,
      BorderRadius borderRadius = BorderRadius.zero}) {
    return builder(TableBorder.symmetric(
        inside: inside, outside: outside, borderRadius: borderRadius));
  }

  /// Creates a [StyleElement] instance with the specified TableBorder value.
  T call(TableBorder value) => builder(value);
}

// ignore_for_file: unused_element

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../../animation/spring_curves.dart';
import '../../core/directive.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../painting/shadow_mix.dart';

@immutable
class SpacingSideUtility<T extends Style<Object?>>
    extends MixUtility<T, double> {
  const SpacingSideUtility(super.utilityBuilder);

  T call(double value) => utilityBuilder(value);
}

/// Extension for creating [AlignmentGeometry] values with both absolute and directional alignments.
extension AlignmentPropUtilityExt<S extends Style<Object?>>
    on MixUtility<S, AlignmentGeometry> {
  S call(AlignmentGeometry value) => utilityBuilder(value);

  /// Creates a [StyleBase] instance with a custom [Alignment] or [AlignmentDirectional] value.
  ///
  /// If [start] is provided, an [AlignmentDirectional] is created. Otherwise, an [Alignment] is created.
  /// Throws an [AssertionError] if both [x] and [start] are provided.
  S only({double? x, double? y, double? start}) {
    assert(
      x == null || start == null,
      'Cannot provide both an x and a start parameter.',
    );

    return start == null
        ? call(Alignment(x ?? 0, y ?? 0))
        : call(AlignmentDirectional(start, y ?? 0));
  }

  /// Creates a [StyleBase] instance with [Alignment.topLeft] value.

  S topLeft() => call(Alignment.topLeft);

  /// Creates a [StyleBase] instance with [Alignment.topCenter] value.
  S topCenter() => call(Alignment.topCenter);

  /// Creates a [StyleBase] instance with [Alignment.topRight] value.
  S topRight() => call(Alignment.topRight);

  /// Creates a [StyleBase] instance with [Alignment.centerLeft] value.
  S centerLeft() => call(Alignment.centerLeft);

  /// Creates a [StyleBase] instance with [Alignment.center] value.
  S center() => call(Alignment.center);

  /// Creates a [StyleBase] instance with [Alignment.centerRight] value.
  S centerRight() => call(Alignment.centerRight);

  /// Creates a [StyleBase] instance with [Alignment.bottomLeft] value.
  S bottomLeft() => call(Alignment.bottomLeft);

  /// Creates a [StyleBase] instance with [Alignment.bottomCenter] value.
  S bottomCenter() => call(Alignment.bottomCenter);

  /// Creates a [StyleBase] instance with [Alignment.bottomRight] value.
  S bottomRight() => call(Alignment.bottomRight);
}

/// Extension for creating [AlignmentDirectional] values that respect text direction.
extension AlignmentDirectionalPropUtilityExt<S extends Style<Object?>>
    on MixUtility<S, AlignmentDirectional> {
  S call(AlignmentDirectional value) => utilityBuilder(value);

  S only({double? y, double? start}) {
    return call(AlignmentDirectional(start ?? 0, y ?? 0));
  }

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topStart] value.
  S topStart() => call(AlignmentDirectional.topStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topCenter] value.
  S topCenter() => call(AlignmentDirectional.topCenter);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topEnd] value.
  S topEnd() => call(AlignmentDirectional.topEnd);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.centerStart] value.
  S centerStart() => call(AlignmentDirectional.centerStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.center] value.
  S center() => call(AlignmentDirectional.center);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.centerEnd] value.
  S centerEnd() => call(AlignmentDirectional.centerEnd);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomStart] value.
  S bottomStart() => call(AlignmentDirectional.bottomStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomCenter] value.
  S bottomCenter() => call(AlignmentDirectional.bottomCenter);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomEnd] value.
  S bottomEnd() => call(AlignmentDirectional.bottomEnd);
}

/// Extension for creating [FontFeature] values with predefined OpenType features.
extension FontFeaturePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FontFeature> {
  T call(FontFeature value) => utilityBuilder(value);

  /// Creates a [Style] instance using the [FontFeature.enable] constructor.
  T enable(String feature) => call(FontFeature.enable(feature));

  /// Creates a [Style] instance using the [FontFeature.disable] constructor.
  T disable(String feature) => call(FontFeature.disable(feature));

  /// Creates a [Style] instance using the [FontFeature.alternative] constructor.
  T alternative(int value) => call(FontFeature.alternative(value));

  /// Creates a [Style] instance using the [FontFeature.alternativeFractions] constructor.
  T alternativeFractions() => call(const FontFeature.alternativeFractions());

  /// Creates a [Style] instance using the [FontFeature.contextualAlternates] constructor.
  T contextualAlternates() => call(const FontFeature.contextualAlternates());

  /// Creates a [Style] instance using the [FontFeature.caseSensitiveForms] constructor.
  T caseSensitiveForms() => call(const FontFeature.caseSensitiveForms());

  /// Creates a [Style] instance using the [FontFeature.characterVariant] constructor.
  T characterVariant(int value) => call(FontFeature.characterVariant(value));

  /// Creates a [Style] instance using the [FontFeature.denominator] constructor.
  T denominator() => call(const FontFeature.denominator());

  /// Creates a [Style] instance using the [FontFeature.fractions] constructor.
  T fractions() => call(const FontFeature.fractions());

  /// Creates a [Style] instance using the [FontFeature.historicalForms] constructor.
  T historicalForms() => call(const FontFeature.historicalForms());

  /// Creates a [Style] instance using the [FontFeature.historicalLigatures] constructor.
  T historicalLigatures() => call(const FontFeature.historicalLigatures());

  /// Creates a [Style] instance using the [FontFeature.liningFigures] constructor.
  T liningFigures() => call(const FontFeature.liningFigures());

  /// Creates a [Style] instance using the [FontFeature.localeAware] constructor.
  T localeAware({bool enable = true}) {
    return call(FontFeature.localeAware(enable: enable));
  }

  /// Creates a [Style] instance using the [FontFeature.notationalForms] constructor.
  T notationalForms([int value = 1]) =>
      call(FontFeature.notationalForms(value));

  /// Creates a [Style] instance using the [FontFeature.numerators] constructor.
  T numerators() => call(const FontFeature.numerators());

  /// Creates a [Style] instance using the [FontFeature.oldstyleFigures] constructor.
  T oldstyleFigures() => call(const FontFeature.oldstyleFigures());

  /// Creates a [Style] instance using the [FontFeature.ordinalForms] constructor.
  T ordinalForms() => call(const FontFeature.ordinalForms());

  /// Creates a [Style] instance using the [FontFeature.proportionalFigures] constructor.
  T proportionalFigures() => call(const FontFeature.proportionalFigures());

  /// Creates a [Style] instance using the [FontFeature.randomize] constructor.
  T randomize() => call(const FontFeature.randomize());

  /// Creates a [Style] instance using the [FontFeature.stylisticAlternates] constructor.
  T stylisticAlternates() => call(const FontFeature.stylisticAlternates());

  /// Creates a [Style] instance using the [FontFeature.scientificInferiors] constructor.
  T scientificInferiors() => call(const FontFeature.scientificInferiors());

  /// Creates a [Style] instance using the [FontFeature.stylisticSet] constructor.
  T stylisticSet(int value) => call(FontFeature.stylisticSet(value));

  /// Creates a [Style] instance using the [FontFeature.subscripts] constructor.
  T subscripts() => call(const FontFeature.subscripts());

  /// Creates a [Style] instance using the [FontFeature.superscripts] constructor.
  T superscripts() => call(const FontFeature.superscripts());

  /// Creates a [Style] instance using the [FontFeature.swash] constructor.
  T swash([int value = 1]) => call(FontFeature.swash(value));

  /// Creates a [Style] instance using the [FontFeature.tabularFigures] constructor.
  T tabularFigures() => call(const FontFeature.tabularFigures());

  /// Creates a [Style] instance using the [FontFeature.slashedZero] constructor.
  T slashedZero() => call(const FontFeature.slashedZero());
}

/// Extension for creating [Duration] values with time unit methods.
extension DurationPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Duration> {
  T call(Duration value) => utilityBuilder(value);

  T microseconds(int microseconds) =>
      call(Duration(microseconds: microseconds));

  T milliseconds(int milliseconds) =>
      call(Duration(milliseconds: milliseconds));

  T seconds(int seconds) => call(Duration(seconds: seconds));

  T minutes(int minutes) => call(Duration(minutes: minutes));

  /// Creates a [Style] instance with [Duration.zero] value.
  T zero() => call(Duration.zero);
}

/// Extension for creating double values with predefined options.
extension DoublePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, double> {
  T call(double value) => utilityBuilder(value);
}

/// Extension for creating [FontWeight] values with predefined weights.
extension FontWeightPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, FontWeight> {
  T call(FontWeight value) => utilityBuilder(value);

  /// Creates a [Style] instance with [FontWeight.w100] value.
  T w100() => call(FontWeight.w100);

  /// Creates a [Style] instance with [FontWeight.w200] value.
  T w200() => call(FontWeight.w200);

  /// Creates a [Style] instance with [FontWeight.w300] value.
  T w300() => call(FontWeight.w300);

  /// Creates a [Style] instance with [FontWeight.w400] value.
  T w400() => call(FontWeight.w400);

  /// Creates a [Style] instance with [FontWeight.w500] value.
  T w500() => call(FontWeight.w500);

  /// Creates a [Style] instance with [FontWeight.w600] value.
  T w600() => call(FontWeight.w600);

  /// Creates a [Style] instance with [FontWeight.w700] value.
  T w700() => call(FontWeight.w700);

  /// Creates a [Style] instance with [FontWeight.w800] value.
  T w800() => call(FontWeight.w800);

  /// Creates a [Style] instance with [FontWeight.w900] value.
  T w900() => call(FontWeight.w900);

  /// Creates a [Style] instance with [FontWeight.normal] value.
  T normal() => call(FontWeight.normal);

  /// Creates a [Style] instance with [FontWeight.bold] value.
  T bold() => call(FontWeight.bold);
}

/// Extension for creating [TextDecoration] values with predefined decorations.
extension TextDecorationPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextDecoration> {
  T call(TextDecoration value) => utilityBuilder(value);

  /// Creates a [Style] instance with [TextDecoration.none] value.
  T none() => call(TextDecoration.none);

  /// Creates a [Style] instance with [TextDecoration.underline] value.
  T underline() => call(TextDecoration.underline);

  /// Creates a [Style] instance with [TextDecoration.overline] value.
  T overline() => call(TextDecoration.overline);

  /// Creates a [Style] instance with [TextDecoration.lineThrough] value.
  T lineThrough() => call(TextDecoration.lineThrough);

  /// Creates a [Style] instance using the [TextDecoration.combine] constructor.
  T combine(List<TextDecoration> decorations) {
    return call(TextDecoration.combine(decorations));
  }
}

/// Extension for creating [Curve] values with predefined animation curves.
extension CurvePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Curve> {
  T call(Curve value) => utilityBuilder(value);

  T spring({double stiffness = 3.5, double ratio = 1.0, double mass = 1.0}) =>
      call(
        SpringCurve.withDampingRatio(
          mass: mass,
          stiffness: stiffness,
          ratio: ratio,
        ),
      );

  /// Creates a [Style] instance with [Curves.linear] value.
  T linear() => call(Curves.linear);

  /// Creates a [Style] instance with [Curves.decelerate] value.
  T decelerate() => call(Curves.decelerate);

  /// Creates a [Style] instance with [Curves.fastLinearToSlowEaseIn] value.
  T fastLinearToSlowEaseIn() => call(Curves.fastLinearToSlowEaseIn);

  /// Creates a [Style] instance with [Curves.fastEaseInToSlowEaseOut] value.
  T fastEaseInToSlowEaseOut() => call(Curves.fastEaseInToSlowEaseOut);

  /// Creates a [Style] instance with [Curves.ease] value.
  T ease() => call(Curves.ease);

  /// Creates a [Style] instance with [Curves.easeIn] value.
  T easeIn() => call(Curves.easeIn);

  /// Creates a [Style] instance with [Curves.easeInToLinear] value.
  T easeInToLinear() => call(Curves.easeInToLinear);

  /// Creates a [Style] instance with [Curves.easeInSine] value.
  T easeInSine() => call(Curves.easeInSine);

  /// Creates a [Style] instance with [Curves.easeInQuad] value.
  T easeInQuad() => call(Curves.easeInQuad);

  /// Creates a [Style] instance with [Curves.easeInCubic] value.
  T easeInCubic() => call(Curves.easeInCubic);

  /// Creates a [Style] instance with [Curves.easeInQuart] value.
  T easeInQuart() => call(Curves.easeInQuart);

  /// Creates a [Style] instance with [Curves.easeInQuint] value.
  T easeInQuint() => call(Curves.easeInQuint);

  /// Creates a [Style] instance with [Curves.easeInExpo] value.
  T easeInExpo() => call(Curves.easeInExpo);

  /// Creates a [Style] instance with [Curves.easeInCirc] value.
  T easeInCirc() => call(Curves.easeInCirc);

  /// Creates a [Style] instance with [Curves.easeInBack] value.
  T easeInBack() => call(Curves.easeInBack);

  /// Creates a [Style] instance with [Curves.easeOut] value.
  T easeOut() => call(Curves.easeOut);

  /// Creates a [Style] instance with [Curves.linearToEaseOut] value.
  T linearToEaseOut() => call(Curves.linearToEaseOut);

  /// Creates a [Style] instance with [Curves.easeOutSine] value.
  T easeOutSine() => call(Curves.easeOutSine);

  /// Creates a [Style] instance with [Curves.easeOutQuad] value.
  T easeOutQuad() => call(Curves.easeOutQuad);

  /// Creates a [Style] instance with [Curves.easeOutCubic] value.
  T easeOutCubic() => call(Curves.easeOutCubic);

  /// Creates a [Style] instance with [Curves.easeOutQuart] value.
  T easeOutQuart() => call(Curves.easeOutQuart);

  /// Creates a [Style] instance with [Curves.easeOutQuint] value.
  T easeOutQuint() => call(Curves.easeOutQuint);

  /// Creates a [Style] instance with [Curves.easeOutExpo] value.
  T easeOutExpo() => call(Curves.easeOutExpo);

  /// Creates a [Style] instance with [Curves.easeOutCirc] value.
  T easeOutCirc() => call(Curves.easeOutCirc);

  /// Creates a [Style] instance with [Curves.easeOutBack] value.
  T easeOutBack() => call(Curves.easeOutBack);

  /// Creates a [Style] instance with [Curves.easeInOut] value.
  T easeInOut() => call(Curves.easeInOut);

  /// Creates a [Style] instance with [Curves.easeInOutSine] value.
  T easeInOutSine() => call(Curves.easeInOutSine);

  /// Creates a [Style] instance with [Curves.easeInOutQuad] value.
  T easeInOutQuad() => call(Curves.easeInOutQuad);

  /// Creates a [Style] instance with [Curves.easeInOutCubic] value.
  T easeInOutCubic() => call(Curves.easeInOutCubic);

  /// Creates a [Style] instance with [Curves.easeInOutCubicEmphasized] value.
  T easeInOutCubicEmphasized() => call(Curves.easeInOutCubicEmphasized);

  /// Creates a [Style] instance with [Curves.easeInOutQuart] value.
  T easeInOutQuart() => call(Curves.easeInOutQuart);

  /// Creates a [Style] instance with [Curves.easeInOutQuint] value.
  T easeInOutQuint() => call(Curves.easeInOutQuint);

  /// Creates a [Style] instance with [Curves.easeInOutExpo] value.
  T easeInOutExpo() => call(Curves.easeInOutExpo);

  /// Creates a [Style] instance with [Curves.easeInOutCirc] value.
  T easeInOutCirc() => call(Curves.easeInOutCirc);

  /// Creates a [Style] instance with [Curves.easeInOutBack] value.
  T easeInOutBack() => call(Curves.easeInOutBack);

  /// Creates a [Style] instance with [Curves.fastOutSlowIn] value.
  T fastOutSlowIn() => call(Curves.fastOutSlowIn);

  /// Creates a [Style] instance with [Curves.slowMiddle] value.
  T slowMiddle() => call(Curves.slowMiddle);

  /// Creates a [Style] instance with [Curves.bounceIn] value.
  T bounceIn() => call(Curves.bounceIn);

  /// Creates a [Style] instance with [Curves.bounceOut] value.
  T bounceOut() => call(Curves.bounceOut);

  /// Creates a [Style] instance with [Curves.bounceInOut] value.
  T bounceInOut() => call(Curves.bounceInOut);

  /// Creates a [Style] instance with [Curves.elasticIn] value.
  T elasticIn() => call(Curves.elasticIn);

  /// Creates a [Style] instance with [Curves.elasticOut] value.
  T elasticOut() => call(Curves.elasticOut);

  /// Creates a [Style] instance with [Curves.elasticInOut] value.
  T elasticInOut() => call(Curves.elasticInOut);
}

/// Extension for creating [Offset] values with predefined positions.
extension OffsetPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Offset> {
  T call(Offset value) => utilityBuilder(value);

  /// Creates a [Style] instance with [Offset.zero] value.
  T zero() => call(Offset.zero);

  /// Creates a [Style] instance with [Offset.infinite] value.
  T infinite() => call(Offset.infinite);

  /// Creates a [Style] instance using the [Offset.fromDirection] constructor.
  T fromDirection(double direction, [double distance = 1.0]) {
    return call(Offset.fromDirection(direction, distance));
  }
}

/// Extension for creating [Radius] values with predefined radius shapes.
extension RadiusPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Radius> {
  T call(Radius value) => utilityBuilder(value);

  /// Creates a [Style] instance with [Radius.zero] value.
  T zero() => call(Radius.zero);

  /// Creates a [Style] instance using the [Radius.circular] constructor.
  T circular(double radius) => call(Radius.circular(radius));

  /// Creates a [Style] instance using the [Radius.elliptical] constructor.
  T elliptical(double x, double y) => call(Radius.elliptical(x, y));
}

/// Extension for creating [Rect] values with predefined rectangles and constructors.
extension RectPropUtilityExt<T extends Style<Object?>> on MixUtility<T, Rect> {
  T call(Rect value) => utilityBuilder(value);

  /// Creates a [Style] instance with [Rect.zero] value.
  T zero() => call(Rect.zero);

  /// Creates a [Style] instance with [Rect.largest] value.
  T largest() => call(Rect.largest);

  /// Creates a [Style] instance using the [Rect.fromLTRB] constructor.
  T fromLTRB(double left, double top, double right, double bottom) {
    return call(Rect.fromLTRB(left, top, right, bottom));
  }

  /// Creates a [Style] instance using the [Rect.fromLTWH] constructor.
  T fromLTWH(double left, double top, double width, double height) {
    return call(Rect.fromLTWH(left, top, width, height));
  }

  /// Creates a [Style] instance using the [Rect.fromCircle] constructor.
  T fromCircle({required Offset center, required double radius}) {
    return call(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a [Style] instance using the [Rect.fromCenter] constructor.
  T fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) {
    return call(Rect.fromCenter(center: center, width: width, height: height));
  }

  /// Creates a [Style] instance using the [Rect.fromPoints] constructor.
  T fromPoints(Offset a, Offset b) => call(Rect.fromPoints(a, b));
}

/// Extension for creating [Paint] values for custom drawing operations.
extension PaintPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Paint> {
  T call(Paint value) => utilityBuilder(value);

  // No predefined paint values - this extension provides type consistency
}

/// Extension for creating [Locale] values for internationalization.
extension LocalePropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Locale> {
  T call(Locale value) => utilityBuilder(value);

  // No predefined locale values - this extension provides type consistency
}

/// Extension for creating [ImageProvider] values with different image sources.
extension ImageProviderPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, ImageProvider> {
  T call(ImageProvider value) => utilityBuilder(value);

  /// Creates an [Style] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  T network(String url) => call(NetworkImage(url));
  T file(File file) => call(FileImage(file));
  T asset(String asset) => call(AssetImage(asset));
  T memory(Uint8List bytes) => call(MemoryImage(bytes));
}

/// Extension for creating [GradientTransform] values for gradient transformations.
extension GradientTransformPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, GradientTransform> {
  T call(GradientTransform value) => utilityBuilder(value);

  /// Creates an [Style] instance with a [GradientRotation] value.
  T rotate(double radians) => call(GradientRotation(radians));
}

/// Extension for creating [Matrix4] values for 3D transformations.
extension Matrix4PropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Matrix4> {
  T call(Matrix4 value) => utilityBuilder(value);

  /// Creates a [Style] instance using the [Matrix4.fromList] constructor.
  T fromList(List<double> values) => call(Matrix4.fromList(values));

  /// Creates a [Style] instance using the [Matrix4.zero] constructor.
  T zero() => call(Matrix4.zero());

  /// Creates a [Style] instance using the [Matrix4.identity] constructor.
  T identity() => call(Matrix4.identity());

  /// Creates a [Style] instance using the [Matrix4.rotationX] constructor.
  T rotationX(double radians) => call(Matrix4.rotationX(radians));

  /// Creates a [Style] instance using the [Matrix4.rotationY] constructor.
  T rotationY(double radians) => call(Matrix4.rotationY(radians));

  /// Creates a [Style] instance using the [Matrix4.rotationZ] constructor.
  T rotationZ(double radians) => call(Matrix4.rotationZ(radians));

  /// Creates a [Style] instance using the [Matrix4.translationValues] constructor.
  T translationValues(double x, double y, double z) {
    return call(Matrix4.translationValues(x, y, z));
  }

  /// Creates a [Style] instance using the [Matrix4.diagonal3Values] constructor.
  T diagonal3Values(double x, double y, double z) {
    return call(Matrix4.diagonal3Values(x, y, z));
  }

  /// Creates a [Style] instance using the [Matrix4.skewX] constructor.
  T skewX(double alpha) => call(Matrix4.skewX(alpha));

  /// Creates a [Style] instance using the [Matrix4.skewY] constructor.
  T skewY(double beta) => call(Matrix4.skewY(beta));

  /// Creates a [Style] instance using the [Matrix4.skew] constructor.
  T skew(double alpha, double beta) => call(Matrix4.skew(alpha, beta));

  /// Creates a [Style] instance using the [Matrix4.fromBuffer] constructor.
  T fromBuffer(ByteBuffer buffer, int offset) {
    return call(Matrix4.fromBuffer(buffer, offset));
  }
}

/// Extension for creating [TextScaler] values for text scaling.
extension TextScalerPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TextScaler> {
  T call(TextScaler value) => utilityBuilder(value);

  /// Creates a [Style] instance with [TextScaler.noScaling] value.
  T noScaling() => call(TextScaler.noScaling);

  /// Creates a [Style] instance using the [TextScaler.linear] constructor.
  T linear(double textScaleFactor) => call(TextScaler.linear(textScaleFactor));
}

/// Extension for creating [TableColumnWidth] values for table column sizing.
extension TableColumnWidthPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, TableColumnWidth> {
  T call(TableColumnWidth value) => utilityBuilder(value);

  // No predefined table column width values - this extension provides type consistency
}

/// Utility for creating [TableBorder] values with predefined border styles.
extension TableBorderUtility<T extends Style<Object?>>
    on MixUtility<T, TableBorder> {
  T call(TableBorder value) => utilityBuilder(value);

  /// Creates a [Style] instance using the [TableBorder.all] constructor.
  T all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return call(
      TableBorder.all(
        color: color,
        width: width,
        style: style,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Creates a [Style] instance using the [TableBorder.symmetric] constructor.
  T symmetric({
    BorderSide inside = BorderSide.none,
    BorderSide outside = BorderSide.none,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return call(
      TableBorder.symmetric(
        inside: inside,
        outside: outside,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Extension for creating list values with MixUtility
extension ListMixUtilityExt<T extends Style<Object?>, V>
    on MixUtility<T, List<V>> {
  T call(List<V> value) => utilityBuilder(value);
}

/// Extension for creating [ElevationShadow] values with predefined elevation levels.
extension ElevationShadowPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, ElevationShadow> {
  T call(ElevationShadow value) => utilityBuilder(value);

  /// Creates a [Style] instance with [ElevationShadow.one] value.
  T one() => call(ElevationShadow.one);

  /// Creates a [Style] instance with [ElevationShadow.two] value.
  T two() => call(ElevationShadow.two);

  /// Creates a [Style] instance with [ElevationShadow.three] value.
  T three() => call(ElevationShadow.three);

  /// Creates a [Style] instance with [ElevationShadow.four] value.
  T four() => call(ElevationShadow.four);

  /// Creates a [Style] instance with [ElevationShadow.six] value.
  T six() => call(ElevationShadow.six);

  /// Creates a [Style] instance with [ElevationShadow.eight] value.
  T eight() => call(ElevationShadow.eight);

  /// Creates a [Style] instance with [ElevationShadow.nine] value.
  T nine() => call(ElevationShadow.nine);

  /// Creates a [Style] instance with [ElevationShadow.twelve] value.
  T twelve() => call(ElevationShadow.twelve);

  /// Creates a [Style] instance with [ElevationShadow.sixteen] value.
  T sixteen() => call(ElevationShadow.sixteen);

  /// Creates a [Style] instance with [ElevationShadow.twentyFour] value.
  T twentyFour() => call(ElevationShadow.twentyFour);
}

/// Extension for creating [Directive<String>] values with text transformations.
extension DirectiveStringPropUtilityExt<T extends Style<Object?>>
    on MixUtility<T, Directive<String>> {
  T call(Directive<String> value) => utilityBuilder(value);

  T capitalize() => call(CapitalizeStringDirective());
  T uppercase() => call(UppercaseStringDirective());
  T lowercase() => call(LowercaseStringDirective());
  T titleCase() => call(TitleCaseStringDirective());
  T sentenceCase() => call(SentenceCaseStringDirective());
}

// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

// =============================================================================
// SCALAR UTILITIES
// =============================================================================

final class AlignmentUtility<S extends SpecUtility<Object?>>
    extends PropUtility<S, AlignmentGeometry> {
  const AlignmentUtility(super.builder);

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

final class AlignmentGeometryUtility<S extends SpecUtility<Object?>>
    extends AlignmentUtility<S> {
  late final directional = AlignmentDirectionalUtility<S>(builder);
  AlignmentGeometryUtility(super.builder);
}

final class AlignmentDirectionalUtility<S extends SpecUtility<Object?>>
    extends PropUtility<S, AlignmentDirectional> {
  const AlignmentDirectionalUtility(super.builder);

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

final class FontFeatureUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, FontFeature> {
  const FontFeatureUtility(super.builder);

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

  /// Creates a [Style] instance with the specified FontFeature value.
  @override
  T call(FontFeature value) => call(value);
}

final class DurationUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Duration> {
  const DurationUtility(super.builder);

  T microseconds(int microseconds) =>
      call(Duration(microseconds: microseconds));

  T milliseconds(int milliseconds) =>
      call(Duration(milliseconds: milliseconds));

  T seconds(int seconds) => call(Duration(seconds: seconds));

  T minutes(int minutes) => call(Duration(minutes: minutes));

  /// Creates a [Style] instance with [Duration.zero] value.
  T zero() => call(Duration.zero);
}

final class FontSizeUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, double> {
  const FontSizeUtility(super.builder);
}

final class FontWeightUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, FontWeight> {
  const FontWeightUtility(super.builder);

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

final class TextDecorationUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, TextDecoration> {
  const TextDecorationUtility(super.builder);

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

final class CurveUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Curve> {
  const CurveUtility(super.builder);

  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) => call(
    SpringCurve(stiffness: stiffness, dampingRatio: dampingRatio, mass: mass),
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

final class OffsetUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Offset> {
  const OffsetUtility(super.builder);

  /// Creates a [Style] instance with [Offset.zero] value.
  T zero() => call(Offset.zero);

  /// Creates a [Style] instance with [Offset.infinite] value.
  T infinite() => call(Offset.infinite);

  /// Creates a [Style] instance using the [Offset.fromDirection] constructor.
  T fromDirection(double direction, [double distance = 1.0]) {
    return call(Offset.fromDirection(direction, distance));
  }
}

final class RadiusUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Radius> {
  const RadiusUtility(super.builder);

  // TODO: Update to use MixableToken<Radius> when RadiusDto integration is complete

  /// Creates a [Style] instance with [Radius.zero] value.
  T zero() => call(Radius.zero);

  /// Creates a [Style] instance using the [Radius.circular] constructor.
  T circular(double radius) => call(Radius.circular(radius));

  /// Creates a [Style] instance using the [Radius.elliptical] constructor.
  T elliptical(double x, double y) => call(Radius.elliptical(x, y));
}

final class RectUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Rect> {
  const RectUtility(super.builder);

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

final class PaintUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Paint> {
  const PaintUtility(super.builder);
}

final class LocaleUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Locale> {
  const LocaleUtility(super.builder);
}

final class ImageProviderUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, ImageProvider> {
  const ImageProviderUtility(super.builder);

  /// Creates an [Style] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  T network(String url) => call(NetworkImage(url));
  T file(File file) => call(FileImage(file));
  T asset(String asset) => call(AssetImage(asset));
  T memory(Uint8List bytes) => call(MemoryImage(bytes));
}

final class GradientTransformUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, GradientTransform> {
  const GradientTransformUtility(super.builder);

  /// Creates an [Style] instance with a [GradientRotation] value.
  T rotate(double radians) => call(GradientRotation(radians));
}

final class Matrix4Utility<T extends SpecUtility<Object?>>
    extends PropUtility<T, Matrix4> {
  const Matrix4Utility(super.builder);

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

final class FontFamilyUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, String> {
  const FontFamilyUtility(super.builder);

  /// Creates a [Style] instance using the [String.fromCharCodes] constructor.
  T fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]) {
    return call(String.fromCharCodes(charCodes, start, end));
  }

  /// Creates a [Style] instance using the [String.fromCharCode] constructor.
  T fromCharCode(int charCode) => call(String.fromCharCode(charCode));

  /// Creates a [Style] instance using the [String.fromEnvironment] constructor.
  T fromEnvironment(String name, {String defaultValue = ""}) {
    return call(String.fromEnvironment(name, defaultValue: defaultValue));
  }
}

final class TextScalerUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, TextScaler> {
  const TextScalerUtility(super.builder);

  /// Creates a [Style] instance with [TextScaler.noScaling] value.
  T noScaling() => call(TextScaler.noScaling);

  /// Creates a [Style] instance using the [TextScaler.linear] constructor.
  T linear(double textScaleFactor) => call(TextScaler.linear(textScaleFactor));
}

final class TableColumnWidthUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, TableColumnWidth> {
  const TableColumnWidthUtility(super.builder);
}

class TableBorderUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, TableBorder> {
  const TableBorderUtility(super.builder);

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

final class StrokeAlignUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, double> {
  const StrokeAlignUtility(super.builder);

  T center() => call(0);
  T inside() => call(-1);
  T outside() => call(1);
}

class ListUtility<T extends SpecUtility<Object?>, V>
    extends MixUtility<T, List<V>> {
  const ListUtility(super.builder);

  T call(List<V> values) => builder(values);
}

final class StringUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, String> {
  const StringUtility(super.builder);
}

/// A utility class for creating [Attribute] instances from [double] values.
///
/// This class extends [PropUtility] and provides methods to create [Attribute] instances
/// from predefined [double] values or custom [double] values.
final class DoubleUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, double> {
  const DoubleUtility(super.builder);

  /// Creates an [Attribute] instance with a value of 0.
  T zero() => call(0);

  /// Creates an [Attribute] instance with a value of [double.infinity].
  T infinity() => call(double.infinity);
}

/// A utility class for creating [Attribute] instances from [int] values.
///
/// This class extends [PropUtility] and provides methods to create [Attribute] instances
/// from predefined [int] values or custom [int] values.
final class IntUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, int> {
  const IntUtility(super.builder);

  /// Creates an [Attribute] instance with a value of 0.
  T zero() => call(0);
}

/// A utility class for creating [Attribute] instances from [bool] values.
///
/// This class extends [PropUtility] and provides methods to create [Attribute] instances
/// from predefined [bool] values or custom [bool] values.
final class BoolUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, bool> {
  const BoolUtility(super.builder);

  /// Creates an [Attribute] instance with a value of `true`.
  T on() => call(true);

  /// Creates an [Attribute] instance with a value of `false`.
  T off() => call(false);
}

/// An abstract utility class for creating [Attribute] instances from [double] values representing sizes.
///
/// This class extends [PropUtility] and serves as a base for more specific sizing utilities.
abstract base class SizingUtility<T extends SpecUtility<Object?>>
    extends PropUtility<T, double> {
  const SizingUtility(super.builder);
}

// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/prop_utility.dart';

// Note: MixableDirective and private implementations are now in core/element.dart

// =============================================================================
// SCALAR UTILITIES
// =============================================================================

final class AlignmentUtility<T extends Attribute>
    extends MixUtility<T, AlignmentGeometry> {
  const AlignmentUtility(super.builder);

  /// Creates an [Style] instance with a custom [Alignment] or [AlignmentDirectional] value.
  ///
  /// If [start] is provided, an [AlignmentDirectional] is created. Otherwise, an [Alignment] is created.
  /// Throws an [AssertionError] if both [x] and [start] are provided.
  T only({double? x, double? y, double? start}) {
    assert(
      x == null || start == null,
      'Cannot provide both an x and a start parameter.',
    );

    return start == null
        ? builder(Alignment(x ?? 0, y ?? 0))
        : builder(AlignmentDirectional(start, y ?? 0));
  }

  /// Creates a [Style] instance with [Alignment.topLeft] value.
  T topLeft() => builder(Alignment.topLeft);

  /// Creates a [Style] instance with [Alignment.topCenter] value.
  T topCenter() => builder(Alignment.topCenter);

  /// Creates a [Style] instance with [Alignment.topRight] value.
  T topRight() => builder(Alignment.topRight);

  /// Creates a [Style] instance with [Alignment.centerLeft] value.
  T centerLeft() => builder(Alignment.centerLeft);

  /// Creates a [Style] instance with [Alignment.center] value.
  T center() => builder(Alignment.center);

  /// Creates a [Style] instance with [Alignment.centerRight] value.
  T centerRight() => builder(Alignment.centerRight);

  /// Creates a [Style] instance with [Alignment.bottomLeft] value.
  T bottomLeft() => builder(Alignment.bottomLeft);

  /// Creates a [Style] instance with [Alignment.bottomCenter] value.
  T bottomCenter() => builder(Alignment.bottomCenter);

  /// Creates a [Style] instance with [Alignment.bottomRight] value.
  T bottomRight() => builder(Alignment.bottomRight);

  /// Creates a [Style] instance with the specified AlignmentGeometry value.
  T call(AlignmentGeometry value) => builder(value);
}

final class AlignmentGeometryUtility<T extends Attribute>
    extends AlignmentUtility<T> {
  late final directional = AlignmentDirectionalUtility(builder);
  AlignmentGeometryUtility(super.builder);
}

final class AlignmentDirectionalUtility<T extends Attribute>
    extends MixUtility<T, AlignmentDirectional> {
  const AlignmentDirectionalUtility(super.builder);

  T only({double? y, double? start}) {
    return builder(AlignmentDirectional(start ?? 0, y ?? 0));
  }

  /// Creates a [Style] instance with [AlignmentDirectional.topStart] value.
  T topStart() => builder(AlignmentDirectional.topStart);

  /// Creates a [Style] instance with [AlignmentDirectional.topCenter] value.
  T topCenter() => builder(AlignmentDirectional.topCenter);

  /// Creates a [Style] instance with [AlignmentDirectional.topEnd] value.
  T topEnd() => builder(AlignmentDirectional.topEnd);

  /// Creates a [Style] instance with [AlignmentDirectional.centerStart] value.
  T centerStart() => builder(AlignmentDirectional.centerStart);

  /// Creates a [Style] instance with [AlignmentDirectional.center] value.
  T center() => builder(AlignmentDirectional.center);

  /// Creates a [Style] instance with [AlignmentDirectional.centerEnd] value.
  T centerEnd() => builder(AlignmentDirectional.centerEnd);

  /// Creates a [Style] instance with [AlignmentDirectional.bottomStart] value.
  T bottomStart() => builder(AlignmentDirectional.bottomStart);

  /// Creates a [Style] instance with [AlignmentDirectional.bottomCenter] value.
  T bottomCenter() => builder(AlignmentDirectional.bottomCenter);

  /// Creates a [Style] instance with [AlignmentDirectional.bottomEnd] value.
  T bottomEnd() => builder(AlignmentDirectional.bottomEnd);

  /// Creates a [Style] instance with the specified AlignmentDirectional value.
  T call(AlignmentDirectional value) => builder(value);
}

final class FontFeatureUtility<T extends Attribute>
    extends MixUtility<T, FontFeature> {
  const FontFeatureUtility(super.builder);

  /// Creates a [Style] instance using the [FontFeature.enable] constructor.
  T enable(String feature) => builder(FontFeature.enable(feature));

  /// Creates a [Style] instance using the [FontFeature.disable] constructor.
  T disable(String feature) => builder(FontFeature.disable(feature));

  /// Creates a [Style] instance using the [FontFeature.alternative] constructor.
  T alternative(int value) => builder(FontFeature.alternative(value));

  /// Creates a [Style] instance using the [FontFeature.alternativeFractions] constructor.
  T alternativeFractions() => builder(const FontFeature.alternativeFractions());

  /// Creates a [Style] instance using the [FontFeature.contextualAlternates] constructor.
  T contextualAlternates() => builder(const FontFeature.contextualAlternates());

  /// Creates a [Style] instance using the [FontFeature.caseSensitiveForms] constructor.
  T caseSensitiveForms() => builder(const FontFeature.caseSensitiveForms());

  /// Creates a [Style] instance using the [FontFeature.characterVariant] constructor.
  T characterVariant(int value) => builder(FontFeature.characterVariant(value));

  /// Creates a [Style] instance using the [FontFeature.denominator] constructor.
  T denominator() => builder(const FontFeature.denominator());

  /// Creates a [Style] instance using the [FontFeature.fractions] constructor.
  T fractions() => builder(const FontFeature.fractions());

  /// Creates a [Style] instance using the [FontFeature.historicalForms] constructor.
  T historicalForms() => builder(const FontFeature.historicalForms());

  /// Creates a [Style] instance using the [FontFeature.historicalLigatures] constructor.
  T historicalLigatures() => builder(const FontFeature.historicalLigatures());

  /// Creates a [Style] instance using the [FontFeature.liningFigures] constructor.
  T liningFigures() => builder(const FontFeature.liningFigures());

  /// Creates a [Style] instance using the [FontFeature.localeAware] constructor.
  T localeAware({bool enable = true}) {
    return builder(FontFeature.localeAware(enable: enable));
  }

  /// Creates a [Style] instance using the [FontFeature.notationalForms] constructor.
  T notationalForms([int value = 1]) =>
      builder(FontFeature.notationalForms(value));

  /// Creates a [Style] instance using the [FontFeature.numerators] constructor.
  T numerators() => builder(const FontFeature.numerators());

  /// Creates a [Style] instance using the [FontFeature.oldstyleFigures] constructor.
  T oldstyleFigures() => builder(const FontFeature.oldstyleFigures());

  /// Creates a [Style] instance using the [FontFeature.ordinalForms] constructor.
  T ordinalForms() => builder(const FontFeature.ordinalForms());

  /// Creates a [Style] instance using the [FontFeature.proportionalFigures] constructor.
  T proportionalFigures() => builder(const FontFeature.proportionalFigures());

  /// Creates a [Style] instance using the [FontFeature.randomize] constructor.
  T randomize() => builder(const FontFeature.randomize());

  /// Creates a [Style] instance using the [FontFeature.stylisticAlternates] constructor.
  T stylisticAlternates() => builder(const FontFeature.stylisticAlternates());

  /// Creates a [Style] instance using the [FontFeature.scientificInferiors] constructor.
  T scientificInferiors() => builder(const FontFeature.scientificInferiors());

  /// Creates a [Style] instance using the [FontFeature.stylisticSet] constructor.
  T stylisticSet(int value) => builder(FontFeature.stylisticSet(value));

  /// Creates a [Style] instance using the [FontFeature.subscripts] constructor.
  T subscripts() => builder(const FontFeature.subscripts());

  /// Creates a [Style] instance using the [FontFeature.superscripts] constructor.
  T superscripts() => builder(const FontFeature.superscripts());

  /// Creates a [Style] instance using the [FontFeature.swash] constructor.
  T swash([int value = 1]) => builder(FontFeature.swash(value));

  /// Creates a [Style] instance using the [FontFeature.tabularFigures] constructor.
  T tabularFigures() => builder(const FontFeature.tabularFigures());

  /// Creates a [Style] instance using the [FontFeature.slashedZero] constructor.
  T slashedZero() => builder(const FontFeature.slashedZero());

  /// Creates a [Style] instance with the specified FontFeature value.
  T call(FontFeature value) => builder(value);
}

final class DurationUtility<T extends Attribute>
    extends MixUtility<T, Duration> {
  const DurationUtility(super.builder);

  T microseconds(int microseconds) =>
      builder(Duration(microseconds: microseconds));

  T milliseconds(int milliseconds) =>
      builder(Duration(milliseconds: milliseconds));

  T seconds(int seconds) => builder(Duration(seconds: seconds));

  T minutes(int minutes) => builder(Duration(minutes: minutes));

  /// Creates a [Style] instance with [Duration.zero] value.
  T zero() => builder(Duration.zero);

  /// Creates a [Style] instance with the specified Duration value.
  T call(Duration value) => builder(value);
}

final class FontSizeUtility<T extends Attribute>
    extends PropUtility<T, double> {
  const FontSizeUtility(super.builder);
}

final class FontWeightUtility<T extends Attribute>
    extends PropUtility<T, FontWeight> {
  const FontWeightUtility(super.builder);

  /// Creates a [Style] instance with [FontWeight.w100] value.
  T w100() => builder(Prop.fromValue(FontWeight.w100));

  /// Creates a [Style] instance with [FontWeight.w200] value.
  T w200() => builder(Prop.fromValue(FontWeight.w200));

  /// Creates a [Style] instance with [FontWeight.w300] value.
  T w300() => builder(Prop.fromValue(FontWeight.w300));

  /// Creates a [Style] instance with [FontWeight.w400] value.
  T w400() => builder(Prop.fromValue(FontWeight.w400));

  /// Creates a [Style] instance with [FontWeight.w500] value.
  T w500() => builder(Prop.fromValue(FontWeight.w500));

  /// Creates a [Style] instance with [FontWeight.w600] value.
  T w600() => builder(Prop.fromValue(FontWeight.w600));

  /// Creates a [Style] instance with [FontWeight.w700] value.
  T w700() => builder(Prop.fromValue(FontWeight.w700));

  /// Creates a [Style] instance with [FontWeight.w800] value.
  T w800() => builder(Prop.fromValue(FontWeight.w800));

  /// Creates a [Style] instance with [FontWeight.w900] value.
  T w900() => builder(Prop.fromValue(FontWeight.w900));

  /// Creates a [Style] instance with [FontWeight.normal] value.
  T normal() => builder(Prop.fromValue(FontWeight.normal));

  /// Creates a [Style] instance with [FontWeight.bold] value.
  T bold() => builder(Prop.fromValue(FontWeight.bold));
}

final class TextDecorationUtility<T extends Attribute>
    extends PropUtility<T, TextDecoration> {
  const TextDecorationUtility(super.builder);

  /// Creates a [Style] instance with [TextDecoration.none] value.
  T none() => builder(Prop.fromValue(TextDecoration.none));

  /// Creates a [Style] instance with [TextDecoration.underline] value.
  T underline() => builder(Prop.fromValue(TextDecoration.underline));

  /// Creates a [Style] instance with [TextDecoration.overline] value.
  T overline() => builder(Prop.fromValue(TextDecoration.overline));

  /// Creates a [Style] instance with [TextDecoration.lineThrough] value.
  T lineThrough() => builder(Prop.fromValue(TextDecoration.lineThrough));

  /// Creates a [Style] instance using the [TextDecoration.combine] constructor.
  T combine(List<TextDecoration> decorations) {
    return builder(Prop.fromValue(TextDecoration.combine(decorations)));
  }
}

final class CurveUtility<T extends Attribute> extends MixUtility<T, Curve> {
  const CurveUtility(super.builder);

  T as(Curve curve) => builder(curve);

  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) => builder(
    SpringCurve(stiffness: stiffness, dampingRatio: dampingRatio, mass: mass),
  );

  /// Creates a [Style] instance with [Curves.linear] value.
  T linear() => builder(Curves.linear);

  /// Creates a [Style] instance with [Curves.decelerate] value.
  T decelerate() => builder(Curves.decelerate);

  /// Creates a [Style] instance with [Curves.fastLinearToSlowEaseIn] value.
  T fastLinearToSlowEaseIn() => builder(Curves.fastLinearToSlowEaseIn);

  /// Creates a [Style] instance with [Curves.fastEaseInToSlowEaseOut] value.
  T fastEaseInToSlowEaseOut() => builder(Curves.fastEaseInToSlowEaseOut);

  /// Creates a [Style] instance with [Curves.ease] value.
  T ease() => builder(Curves.ease);

  /// Creates a [Style] instance with [Curves.easeIn] value.
  T easeIn() => builder(Curves.easeIn);

  /// Creates a [Style] instance with [Curves.easeInToLinear] value.
  T easeInToLinear() => builder(Curves.easeInToLinear);

  /// Creates a [Style] instance with [Curves.easeInSine] value.
  T easeInSine() => builder(Curves.easeInSine);

  /// Creates a [Style] instance with [Curves.easeInQuad] value.
  T easeInQuad() => builder(Curves.easeInQuad);

  /// Creates a [Style] instance with [Curves.easeInCubic] value.
  T easeInCubic() => builder(Curves.easeInCubic);

  /// Creates a [Style] instance with [Curves.easeInQuart] value.
  T easeInQuart() => builder(Curves.easeInQuart);

  /// Creates a [Style] instance with [Curves.easeInQuint] value.
  T easeInQuint() => builder(Curves.easeInQuint);

  /// Creates a [Style] instance with [Curves.easeInExpo] value.
  T easeInExpo() => builder(Curves.easeInExpo);

  /// Creates a [Style] instance with [Curves.easeInCirc] value.
  T easeInCirc() => builder(Curves.easeInCirc);

  /// Creates a [Style] instance with [Curves.easeInBack] value.
  T easeInBack() => builder(Curves.easeInBack);

  /// Creates a [Style] instance with [Curves.easeOut] value.
  T easeOut() => builder(Curves.easeOut);

  /// Creates a [Style] instance with [Curves.linearToEaseOut] value.
  T linearToEaseOut() => builder(Curves.linearToEaseOut);

  /// Creates a [Style] instance with [Curves.easeOutSine] value.
  T easeOutSine() => builder(Curves.easeOutSine);

  /// Creates a [Style] instance with [Curves.easeOutQuad] value.
  T easeOutQuad() => builder(Curves.easeOutQuad);

  /// Creates a [Style] instance with [Curves.easeOutCubic] value.
  T easeOutCubic() => builder(Curves.easeOutCubic);

  /// Creates a [Style] instance with [Curves.easeOutQuart] value.
  T easeOutQuart() => builder(Curves.easeOutQuart);

  /// Creates a [Style] instance with [Curves.easeOutQuint] value.
  T easeOutQuint() => builder(Curves.easeOutQuint);

  /// Creates a [Style] instance with [Curves.easeOutExpo] value.
  T easeOutExpo() => builder(Curves.easeOutExpo);

  /// Creates a [Style] instance with [Curves.easeOutCirc] value.
  T easeOutCirc() => builder(Curves.easeOutCirc);

  /// Creates a [Style] instance with [Curves.easeOutBack] value.
  T easeOutBack() => builder(Curves.easeOutBack);

  /// Creates a [Style] instance with [Curves.easeInOut] value.
  T easeInOut() => builder(Curves.easeInOut);

  /// Creates a [Style] instance with [Curves.easeInOutSine] value.
  T easeInOutSine() => builder(Curves.easeInOutSine);

  /// Creates a [Style] instance with [Curves.easeInOutQuad] value.
  T easeInOutQuad() => builder(Curves.easeInOutQuad);

  /// Creates a [Style] instance with [Curves.easeInOutCubic] value.
  T easeInOutCubic() => builder(Curves.easeInOutCubic);

  /// Creates a [Style] instance with [Curves.easeInOutCubicEmphasized] value.
  T easeInOutCubicEmphasized() => builder(Curves.easeInOutCubicEmphasized);

  /// Creates a [Style] instance with [Curves.easeInOutQuart] value.
  T easeInOutQuart() => builder(Curves.easeInOutQuart);

  /// Creates a [Style] instance with [Curves.easeInOutQuint] value.
  T easeInOutQuint() => builder(Curves.easeInOutQuint);

  /// Creates a [Style] instance with [Curves.easeInOutExpo] value.
  T easeInOutExpo() => builder(Curves.easeInOutExpo);

  /// Creates a [Style] instance with [Curves.easeInOutCirc] value.
  T easeInOutCirc() => builder(Curves.easeInOutCirc);

  /// Creates a [Style] instance with [Curves.easeInOutBack] value.
  T easeInOutBack() => builder(Curves.easeInOutBack);

  /// Creates a [Style] instance with [Curves.fastOutSlowIn] value.
  T fastOutSlowIn() => builder(Curves.fastOutSlowIn);

  /// Creates a [Style] instance with [Curves.slowMiddle] value.
  T slowMiddle() => builder(Curves.slowMiddle);

  /// Creates a [Style] instance with [Curves.bounceIn] value.
  T bounceIn() => builder(Curves.bounceIn);

  /// Creates a [Style] instance with [Curves.bounceOut] value.
  T bounceOut() => builder(Curves.bounceOut);

  /// Creates a [Style] instance with [Curves.bounceInOut] value.
  T bounceInOut() => builder(Curves.bounceInOut);

  /// Creates a [Style] instance with [Curves.elasticIn] value.
  T elasticIn() => builder(Curves.elasticIn);

  /// Creates a [Style] instance with [Curves.elasticOut] value.
  T elasticOut() => builder(Curves.elasticOut);

  /// Creates a [Style] instance with [Curves.elasticInOut] value.
  T elasticInOut() => builder(Curves.elasticInOut);

  /// Creates a [Style] instance with the specified Curve value.
  T call(Curve value) => builder(value);
}

final class OffsetUtility<T extends Attribute> extends MixUtility<T, Offset> {
  const OffsetUtility(super.builder);

  T as(Offset offset) => builder(offset);

  /// Creates a [Style] instance with [Offset.zero] value.
  T zero() => builder(Offset.zero);

  /// Creates a [Style] instance with [Offset.infinite] value.
  T infinite() => builder(Offset.infinite);

  /// Creates a [Style] instance using the [Offset] constructor.
  T call(double dx, double dy) => builder(Offset(dx, dy));

  /// Creates a [Style] instance using the [Offset.fromDirection] constructor.
  T fromDirection(double direction, [double distance = 1.0]) {
    return builder(Offset.fromDirection(direction, distance));
  }
}

final class RadiusUtility<T extends Attribute> extends MixUtility<T, Radius> {
  const RadiusUtility(super.builder);

  T call(double radius) => builder(Radius.circular(radius));

  // TODO: Update to use MixableToken<Radius> when RadiusDto integration is complete
  T ref(Radius ref) => builder(ref);

  /// Creates a [Style] instance with [Radius.zero] value.
  T zero() => builder(Radius.zero);

  /// Creates a [Style] instance using the [Radius.circular] constructor.
  T circular(double radius) => builder(Radius.circular(radius));

  /// Creates a [Style] instance using the [Radius.elliptical] constructor.
  T elliptical(double x, double y) => builder(Radius.elliptical(x, y));
}

final class RectUtility<T extends Attribute> extends MixUtility<T, Rect> {
  const RectUtility(super.builder);

  /// Creates a [Style] instance with [Rect.zero] value.
  T zero() => builder(Rect.zero);

  /// Creates a [Style] instance with [Rect.largest] value.
  T largest() => builder(Rect.largest);

  /// Creates a [Style] instance using the [Rect.fromLTRB] constructor.
  T fromLTRB(double left, double top, double right, double bottom) {
    return builder(Rect.fromLTRB(left, top, right, bottom));
  }

  /// Creates a [Style] instance using the [Rect.fromLTWH] constructor.
  T fromLTWH(double left, double top, double width, double height) {
    return builder(Rect.fromLTWH(left, top, width, height));
  }

  /// Creates a [Style] instance using the [Rect.fromCircle] constructor.
  T fromCircle({required Offset center, required double radius}) {
    return builder(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a [Style] instance using the [Rect.fromCenter] constructor.
  T fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) {
    return builder(
      Rect.fromCenter(center: center, width: width, height: height),
    );
  }

  /// Creates a [Style] instance using the [Rect.fromPoints] constructor.
  T fromPoints(Offset a, Offset b) => builder(Rect.fromPoints(a, b));

  /// Creates a [Style] instance with the specified Rect value.
  T call(Rect value) => builder(value);
}

final class PaintUtility<T extends Attribute> extends PropUtility<T, Paint> {
  const PaintUtility(super.builder);
}

final class LocaleUtility<T extends Attribute> extends PropUtility<T, Locale> {
  const LocaleUtility(super.builder);
}

final class ImageProviderUtility<T extends Attribute>
    extends MixUtility<T, ImageProvider> {
  const ImageProviderUtility(super.builder);

  /// Creates an [Style] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  T network(String url) => builder(NetworkImage(url));
  T file(File file) => builder(FileImage(file));
  T asset(String asset) => builder(AssetImage(asset));
  T memory(Uint8List bytes) => builder(MemoryImage(bytes));

  /// Creates a [Style] instance with the specified ImageProvider value.
  T call(ImageProvider value) => builder(value);
}

final class GradientTransformUtility<T extends Attribute>
    extends MixUtility<T, GradientTransform> {
  const GradientTransformUtility(super.builder);

  /// Creates an [Style] instance with a [GradientRotation] value.
  T rotate(double radians) => builder(GradientRotation(radians));

  /// Creates a [Style] instance with the specified GradientTransform value.
  T call(GradientTransform value) => builder(value);
}

final class Matrix4Utility<T extends Attribute> extends MixUtility<T, Matrix4> {
  const Matrix4Utility(super.builder);

  /// Creates a [Style] instance using the [Matrix4.fromList] constructor.
  T fromList(List<double> values) => builder(Matrix4.fromList(values));

  /// Creates a [Style] instance using the [Matrix4.zero] constructor.
  T zero() => builder(Matrix4.zero());

  /// Creates a [Style] instance using the [Matrix4.identity] constructor.
  T identity() => builder(Matrix4.identity());

  /// Creates a [Style] instance using the [Matrix4.rotationX] constructor.
  T rotationX(double radians) => builder(Matrix4.rotationX(radians));

  /// Creates a [Style] instance using the [Matrix4.rotationY] constructor.
  T rotationY(double radians) => builder(Matrix4.rotationY(radians));

  /// Creates a [Style] instance using the [Matrix4.rotationZ] constructor.
  T rotationZ(double radians) => builder(Matrix4.rotationZ(radians));

  /// Creates a [Style] instance using the [Matrix4.translationValues] constructor.
  T translationValues(double x, double y, double z) {
    return builder(Matrix4.translationValues(x, y, z));
  }

  /// Creates a [Style] instance using the [Matrix4.diagonal3Values] constructor.
  T diagonal3Values(double x, double y, double z) {
    return builder(Matrix4.diagonal3Values(x, y, z));
  }

  /// Creates a [Style] instance using the [Matrix4.skewX] constructor.
  T skewX(double alpha) => builder(Matrix4.skewX(alpha));

  /// Creates a [Style] instance using the [Matrix4.skewY] constructor.
  T skewY(double beta) => builder(Matrix4.skewY(beta));

  /// Creates a [Style] instance using the [Matrix4.skew] constructor.
  T skew(double alpha, double beta) => builder(Matrix4.skew(alpha, beta));

  /// Creates a [Style] instance using the [Matrix4.fromBuffer] constructor.
  T fromBuffer(ByteBuffer buffer, int offset) {
    return builder(Matrix4.fromBuffer(buffer, offset));
  }

  /// Creates a [Style] instance with the specified Matrix4 value.
  T call(Matrix4 value) => builder(value);
}

final class FontFamilyUtility<T extends Attribute>
    extends MixUtility<T, String> {
  const FontFamilyUtility(super.builder);

  /// Creates a [Style] instance using the [String.fromCharCodes] constructor.
  T fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]) {
    return builder(String.fromCharCodes(charCodes, start, end));
  }

  /// Creates a [Style] instance using the [String.fromCharCode] constructor.
  T fromCharCode(int charCode) => builder(String.fromCharCode(charCode));

  /// Creates a [Style] instance using the [String.fromEnvironment] constructor.
  T fromEnvironment(String name, {String defaultValue = ""}) {
    return builder(String.fromEnvironment(name, defaultValue: defaultValue));
  }

  /// Creates a [Style] instance with the specified String value.
  T call(String value) => builder(value);
}

final class TextScalerUtility<T extends Attribute>
    extends MixUtility<T, TextScaler> {
  const TextScalerUtility(super.builder);

  /// Creates a [Style] instance with [TextScaler.noScaling] value.
  T noScaling() => builder(TextScaler.noScaling);

  /// Creates a [Style] instance using the [TextScaler.linear] constructor.
  T linear(double textScaleFactor) =>
      builder(TextScaler.linear(textScaleFactor));

  /// Creates a [Style] instance with the specified TextScaler value.
  T call(TextScaler value) => builder(value);
}

final class TableColumnWidthUtility<T extends Attribute>
    extends PropUtility<T, TableColumnWidth> {
  const TableColumnWidthUtility(super.builder);
}

class TableBorderUtility<T extends Attribute>
    extends MixUtility<T, TableBorder> {
  const TableBorderUtility(super.builder);

  /// Creates a [Style] instance using the [TableBorder.all] constructor.
  T all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return builder(
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
    return builder(
      TableBorder.symmetric(
        inside: inside,
        outside: outside,
        borderRadius: borderRadius,
      ),
    );
  }

  /// Creates a [Style] instance with the specified TableBorder value.
  T call(TableBorder value) => builder(value);
}

final class StrokeAlignUtility<T extends Attribute>
    extends PropUtility<T, double> {
  const StrokeAlignUtility(super.builder);

  T center() => builder(Prop.fromValue(0));
  T inside() => builder(Prop.fromValue(-1));
  T outside() => builder(Prop.fromValue(1));
}

// Extension removed - token() method is now built into RadiusUtility

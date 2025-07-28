// ignore_for_file: unused_element, prefer_relative_imports, avoid-importing-entrypoint-exports

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Extension for creating [AlignmentGeometry] values with both absolute and directional alignments.
extension AlignmentPropUtilityExt<S extends StyleAttribute<Object?>>
    on PropUtility<S, AlignmentGeometry> {
  /// Creates a [StyleBase] instance with a custom [Alignment] or [AlignmentDirectional] value.
  ///
  /// If [start] is provided, an [AlignmentDirectional] is created. Otherwise, an [Alignment] is created.
  /// Throws an [AssertionError] if both [x] and [start] are provided.
  @Deprecated('Use call(Alignment(x, y)) or call(AlignmentDirectional(start, y)) instead')
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
  @Deprecated('Use call(Alignment.topLeft) instead')
  S topLeft() => call(Alignment.topLeft);

  /// Creates a [StyleBase] instance with [Alignment.topCenter] value.
  @Deprecated('Use call(Alignment.topCenter) instead')
  S topCenter() => call(Alignment.topCenter);

  /// Creates a [StyleBase] instance with [Alignment.topRight] value.
  @Deprecated('Use call(Alignment.topRight) instead')
  S topRight() => call(Alignment.topRight);

  /// Creates a [StyleBase] instance with [Alignment.centerLeft] value.
  @Deprecated('Use call(Alignment.centerLeft) instead')
  S centerLeft() => call(Alignment.centerLeft);

  /// Creates a [StyleBase] instance with [Alignment.center] value.
  @Deprecated('Use call(Alignment.center) instead')
  S center() => call(Alignment.center);

  /// Creates a [StyleBase] instance with [Alignment.centerRight] value.
  @Deprecated('Use call(Alignment.centerRight) instead')
  S centerRight() => call(Alignment.centerRight);

  /// Creates a [StyleBase] instance with [Alignment.bottomLeft] value.
  @Deprecated('Use call(Alignment.bottomLeft) instead')
  S bottomLeft() => call(Alignment.bottomLeft);

  /// Creates a [StyleBase] instance with [Alignment.bottomCenter] value.
  @Deprecated('Use call(Alignment.bottomCenter) instead')
  S bottomCenter() => call(Alignment.bottomCenter);

  /// Creates a [StyleBase] instance with [Alignment.bottomRight] value.
  @Deprecated('Use call(Alignment.bottomRight) instead')
  S bottomRight() => call(Alignment.bottomRight);
}


/// Extension for creating [AlignmentDirectional] values that respect text direction.
extension AlignmentDirectionalPropUtilityExt<S extends StyleAttribute<Object?>>
    on PropUtility<S, AlignmentDirectional> {
  @Deprecated('Use call(AlignmentDirectional(start, y)) instead')
  S only({double? y, double? start}) {
    return call(AlignmentDirectional(start ?? 0, y ?? 0));
  }

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topStart] value.
  @Deprecated('Use call(AlignmentDirectional.topStart) instead')
  S topStart() => call(AlignmentDirectional.topStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topCenter] value.
  @Deprecated('Use call(AlignmentDirectional.topCenter) instead')
  S topCenter() => call(AlignmentDirectional.topCenter);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.topEnd] value.
  @Deprecated('Use call(AlignmentDirectional.topEnd) instead')
  S topEnd() => call(AlignmentDirectional.topEnd);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.centerStart] value.
  @Deprecated('Use call(AlignmentDirectional.centerStart) instead')
  S centerStart() => call(AlignmentDirectional.centerStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.center] value.
  @Deprecated('Use call(AlignmentDirectional.center) instead')
  S center() => call(AlignmentDirectional.center);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.centerEnd] value.
  @Deprecated('Use call(AlignmentDirectional.centerEnd) instead')
  S centerEnd() => call(AlignmentDirectional.centerEnd);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomStart] value.
  @Deprecated('Use call(AlignmentDirectional.bottomStart) instead')
  S bottomStart() => call(AlignmentDirectional.bottomStart);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomCenter] value.
  @Deprecated('Use call(AlignmentDirectional.bottomCenter) instead')
  S bottomCenter() => call(AlignmentDirectional.bottomCenter);

  /// Creates a [StyleBase] instance with [AlignmentDirectional.bottomEnd] value.
  @Deprecated('Use call(AlignmentDirectional.bottomEnd) instead')
  S bottomEnd() => call(AlignmentDirectional.bottomEnd);
}

/// Extension for creating [FontFeature] values with predefined OpenType features.
extension FontFeaturePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FontFeature> {
  /// Creates a [StyleAttribute] instance using the [FontFeature.enable] constructor.
  @Deprecated('Use call(FontFeature.enable(feature)) instead')
  T enable(String feature) => call(FontFeature.enable(feature));

  /// Creates a [StyleAttribute] instance using the [FontFeature.disable] constructor.
  @Deprecated('Use call(FontFeature.disable(feature)) instead')
  T disable(String feature) => call(FontFeature.disable(feature));

  /// Creates a [StyleAttribute] instance using the [FontFeature.alternative] constructor.
  @Deprecated('Use call(FontFeature.alternative(value)) instead')
  T alternative(int value) => call(FontFeature.alternative(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.alternativeFractions] constructor.
  @Deprecated('Use call(FontFeature.alternativeFractions()) instead')
  T alternativeFractions() => call(const FontFeature.alternativeFractions());

  /// Creates a [StyleAttribute] instance using the [FontFeature.contextualAlternates] constructor.
  @Deprecated('Use call(FontFeature.contextualAlternates()) instead')
  T contextualAlternates() => call(const FontFeature.contextualAlternates());

  /// Creates a [StyleAttribute] instance using the [FontFeature.caseSensitiveForms] constructor.
  @Deprecated('Use call(FontFeature.caseSensitiveForms()) instead')
  T caseSensitiveForms() => call(const FontFeature.caseSensitiveForms());

  /// Creates a [StyleAttribute] instance using the [FontFeature.characterVariant] constructor.
  @Deprecated('Use call(FontFeature.characterVariant(value)) instead')
  T characterVariant(int value) => call(FontFeature.characterVariant(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.denominator] constructor.
  @Deprecated('Use call(FontFeature.denominator()) instead')
  T denominator() => call(const FontFeature.denominator());

  /// Creates a [StyleAttribute] instance using the [FontFeature.fractions] constructor.
  @Deprecated('Use call(FontFeature.fractions()) instead')
  T fractions() => call(const FontFeature.fractions());

  /// Creates a [StyleAttribute] instance using the [FontFeature.historicalForms] constructor.
  @Deprecated('Use call(FontFeature.historicalForms()) instead')
  T historicalForms() => call(const FontFeature.historicalForms());

  /// Creates a [StyleAttribute] instance using the [FontFeature.historicalLigatures] constructor.
  @Deprecated('Use call(FontFeature.historicalLigatures()) instead')
  T historicalLigatures() => call(const FontFeature.historicalLigatures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.liningFigures] constructor.
  @Deprecated('Use call(FontFeature.liningFigures()) instead')
  T liningFigures() => call(const FontFeature.liningFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.localeAware] constructor.
  @Deprecated('Use call(FontFeature.localeAware(enable: enable)) instead')
  T localeAware({bool enable = true}) {
    return call(FontFeature.localeAware(enable: enable));
  }

  /// Creates a [StyleAttribute] instance using the [FontFeature.notationalForms] constructor.
  @Deprecated('Use call(FontFeature.notationalForms(value)) instead')
  T notationalForms([int value = 1]) =>
      call(FontFeature.notationalForms(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.numerators] constructor.
  @Deprecated('Use call(FontFeature.numerators()) instead')
  T numerators() => call(const FontFeature.numerators());

  /// Creates a [StyleAttribute] instance using the [FontFeature.oldstyleFigures] constructor.
  @Deprecated('Use call(FontFeature.oldstyleFigures()) instead')
  T oldstyleFigures() => call(const FontFeature.oldstyleFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.ordinalForms] constructor.
  @Deprecated('Use call(FontFeature.ordinalForms()) instead')
  T ordinalForms() => call(const FontFeature.ordinalForms());

  /// Creates a [StyleAttribute] instance using the [FontFeature.proportionalFigures] constructor.
  @Deprecated('Use call(FontFeature.proportionalFigures()) instead')
  T proportionalFigures() => call(const FontFeature.proportionalFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.randomize] constructor.
  @Deprecated('Use call(FontFeature.randomize()) instead')
  T randomize() => call(const FontFeature.randomize());

  /// Creates a [StyleAttribute] instance using the [FontFeature.stylisticAlternates] constructor.
  @Deprecated('Use call(FontFeature.stylisticAlternates()) instead')
  T stylisticAlternates() => call(const FontFeature.stylisticAlternates());

  /// Creates a [StyleAttribute] instance using the [FontFeature.scientificInferiors] constructor.
  @Deprecated('Use call(FontFeature.scientificInferiors()) instead')
  T scientificInferiors() => call(const FontFeature.scientificInferiors());

  /// Creates a [StyleAttribute] instance using the [FontFeature.stylisticSet] constructor.
  @Deprecated('Use call(FontFeature.stylisticSet(value)) instead')
  T stylisticSet(int value) => call(FontFeature.stylisticSet(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.subscripts] constructor.
  @Deprecated('Use call(FontFeature.subscripts()) instead')
  T subscripts() => call(const FontFeature.subscripts());

  /// Creates a [StyleAttribute] instance using the [FontFeature.superscripts] constructor.
  @Deprecated('Use call(FontFeature.superscripts()) instead')
  T superscripts() => call(const FontFeature.superscripts());

  /// Creates a [StyleAttribute] instance using the [FontFeature.swash] constructor.
  @Deprecated('Use call(FontFeature.swash(value)) instead')
  T swash([int value = 1]) => call(FontFeature.swash(value));

  /// Creates a [StyleAttribute] instance using the [FontFeature.tabularFigures] constructor.
  @Deprecated('Use call(FontFeature.tabularFigures()) instead')
  T tabularFigures() => call(const FontFeature.tabularFigures());

  /// Creates a [StyleAttribute] instance using the [FontFeature.slashedZero] constructor.
  @Deprecated('Use call(FontFeature.slashedZero()) instead')
  T slashedZero() => call(const FontFeature.slashedZero());
}

/// Extension for creating [Duration] values with time unit methods.
extension DurationPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Duration> {
  @Deprecated('Use call(Duration(microseconds: microseconds)) instead')
  T microseconds(int microseconds) =>
      call(Duration(microseconds: microseconds));

  @Deprecated('Use call(Duration(milliseconds: milliseconds)) instead')
  T milliseconds(int milliseconds) =>
      call(Duration(milliseconds: milliseconds));

  @Deprecated('Use call(Duration(seconds: seconds)) instead')
  T seconds(int seconds) => call(Duration(seconds: seconds));

  @Deprecated('Use call(Duration(minutes: minutes)) instead')
  T minutes(int minutes) => call(Duration(minutes: minutes));

  /// Creates a [StyleAttribute] instance with [Duration.zero] value.
  @Deprecated('Use call(Duration.zero) instead')
  T zero() => call(Duration.zero);
}

/// Extension for creating font size values as doubles.
extension FontSizePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, double> {
  // No predefined font size values - this extension provides type consistency for font sizes
}

/// Extension for creating [FontWeight] values with predefined weights.
extension FontWeightPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, FontWeight> {
  /// Creates a [StyleAttribute] instance with [FontWeight.w100] value.
  @Deprecated('Use call(FontWeight.w100) instead')
  T w100() => call(FontWeight.w100);

  /// Creates a [StyleAttribute] instance with [FontWeight.w200] value.
  @Deprecated('Use call(FontWeight.w200) instead')
  T w200() => call(FontWeight.w200);

  /// Creates a [StyleAttribute] instance with [FontWeight.w300] value.
  @Deprecated('Use call(FontWeight.w300) instead')
  T w300() => call(FontWeight.w300);

  /// Creates a [StyleAttribute] instance with [FontWeight.w400] value.
  @Deprecated('Use call(FontWeight.w400) instead')
  T w400() => call(FontWeight.w400);

  /// Creates a [StyleAttribute] instance with [FontWeight.w500] value.
  @Deprecated('Use call(FontWeight.w500) instead')
  T w500() => call(FontWeight.w500);

  /// Creates a [StyleAttribute] instance with [FontWeight.w600] value.
  @Deprecated('Use call(FontWeight.w600) instead')
  T w600() => call(FontWeight.w600);

  /// Creates a [StyleAttribute] instance with [FontWeight.w700] value.
  @Deprecated('Use call(FontWeight.w700) instead')
  T w700() => call(FontWeight.w700);

  /// Creates a [StyleAttribute] instance with [FontWeight.w800] value.
  @Deprecated('Use call(FontWeight.w800) instead')
  T w800() => call(FontWeight.w800);

  /// Creates a [StyleAttribute] instance with [FontWeight.w900] value.
  @Deprecated('Use call(FontWeight.w900) instead')
  T w900() => call(FontWeight.w900);

  /// Creates a [StyleAttribute] instance with [FontWeight.normal] value.
  @Deprecated('Use call(FontWeight.normal) instead')
  T normal() => call(FontWeight.normal);

  /// Creates a [StyleAttribute] instance with [FontWeight.bold] value.
  @Deprecated('Use call(FontWeight.bold) instead')
  T bold() => call(FontWeight.bold);
}

/// Extension for creating [TextDecoration] values with predefined decorations.
extension TextDecorationPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextDecoration> {
  /// Creates a [StyleAttribute] instance with [TextDecoration.none] value.
  @Deprecated('Use call(TextDecoration.none) instead')
  T none() => call(TextDecoration.none);

  /// Creates a [StyleAttribute] instance with [TextDecoration.underline] value.
  @Deprecated('Use call(TextDecoration.underline) instead')
  T underline() => call(TextDecoration.underline);

  /// Creates a [StyleAttribute] instance with [TextDecoration.overline] value.
  @Deprecated('Use call(TextDecoration.overline) instead')
  T overline() => call(TextDecoration.overline);

  /// Creates a [StyleAttribute] instance with [TextDecoration.lineThrough] value.
  @Deprecated('Use call(TextDecoration.lineThrough) instead')
  T lineThrough() => call(TextDecoration.lineThrough);

  /// Creates a [StyleAttribute] instance using the [TextDecoration.combine] constructor.
  @Deprecated('Use call(TextDecoration.combine(decorations)) instead')
  T combine(List<TextDecoration> decorations) {
    return call(TextDecoration.combine(decorations));
  }
}

/// Extension for creating [Curve] values with predefined animation curves.
extension CurvePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Curve> {

  @Deprecated('Use call(SpringCurve(stiffness: stiffness, dampingRatio: dampingRatio, mass: mass)) instead')
  T spring({
    double stiffness = 3.5,
    double dampingRatio = 1.0,
    double mass = 1.0,
  }) => call(
    SpringCurve(stiffness: stiffness, dampingRatio: dampingRatio, mass: mass),
  );

  /// Creates a [StyleAttribute] instance with [Curves.linear] value.
  @Deprecated('Use call(Curves.linear) instead')
  T linear() => call(Curves.linear);

  /// Creates a [StyleAttribute] instance with [Curves.decelerate] value.
  @Deprecated('Use call(Curves.decelerate) instead')
  T decelerate() => call(Curves.decelerate);

  /// Creates a [StyleAttribute] instance with [Curves.fastLinearToSlowEaseIn] value.
  @Deprecated('Use call(Curves.fastLinearToSlowEaseIn) instead')
  T fastLinearToSlowEaseIn() => call(Curves.fastLinearToSlowEaseIn);

  /// Creates a [StyleAttribute] instance with [Curves.fastEaseInToSlowEaseOut] value.
  @Deprecated('Use call(Curves.fastEaseInToSlowEaseOut) instead')
  T fastEaseInToSlowEaseOut() => call(Curves.fastEaseInToSlowEaseOut);

  /// Creates a [StyleAttribute] instance with [Curves.ease] value.
  @Deprecated('Use call(Curves.ease) instead')
  T ease() => call(Curves.ease);

  /// Creates a [StyleAttribute] instance with [Curves.easeIn] value.
  @Deprecated('Use call(Curves.easeIn) instead')
  T easeIn() => call(Curves.easeIn);

  /// Creates a [StyleAttribute] instance with [Curves.easeInToLinear] value.
  @Deprecated('Use call(Curves.easeInToLinear) instead')
  T easeInToLinear() => call(Curves.easeInToLinear);

  /// Creates a [StyleAttribute] instance with [Curves.easeInSine] value.
  @Deprecated('Use call(Curves.easeInSine) instead')
  T easeInSine() => call(Curves.easeInSine);

  /// Creates a [StyleAttribute] instance with [Curves.easeInQuad] value.
  @Deprecated('Use call(Curves.easeInQuad) instead')
  T easeInQuad() => call(Curves.easeInQuad);

  /// Creates a [StyleAttribute] instance with [Curves.easeInCubic] value.
  @Deprecated('Use call(Curves.easeInCubic) instead')
  T easeInCubic() => call(Curves.easeInCubic);

  /// Creates a [StyleAttribute] instance with [Curves.easeInQuart] value.
  @Deprecated('Use call(Curves.easeInQuart) instead')
  T easeInQuart() => call(Curves.easeInQuart);

  /// Creates a [StyleAttribute] instance with [Curves.easeInQuint] value.
  @Deprecated('Use call(Curves.easeInQuint) instead')
  T easeInQuint() => call(Curves.easeInQuint);

  /// Creates a [StyleAttribute] instance with [Curves.easeInExpo] value.
  @Deprecated('Use call(Curves.easeInExpo) instead')
  T easeInExpo() => call(Curves.easeInExpo);

  /// Creates a [StyleAttribute] instance with [Curves.easeInCirc] value.
  @Deprecated('Use call(Curves.easeInCirc) instead')
  T easeInCirc() => call(Curves.easeInCirc);

  /// Creates a [StyleAttribute] instance with [Curves.easeInBack] value.
  @Deprecated('Use call(Curves.easeInBack) instead')
  T easeInBack() => call(Curves.easeInBack);

  /// Creates a [StyleAttribute] instance with [Curves.easeOut] value.
  @Deprecated('Use call(Curves.easeOut) instead')
  T easeOut() => call(Curves.easeOut);

  /// Creates a [StyleAttribute] instance with [Curves.linearToEaseOut] value.
  @Deprecated('Use call(Curves.linearToEaseOut) instead')
  T linearToEaseOut() => call(Curves.linearToEaseOut);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutSine] value.
  @Deprecated('Use call(Curves.easeOutSine) instead')
  T easeOutSine() => call(Curves.easeOutSine);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutQuad] value.
  @Deprecated('Use call(Curves.easeOutQuad) instead')
  T easeOutQuad() => call(Curves.easeOutQuad);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutCubic] value.
  @Deprecated('Use call(Curves.easeOutCubic) instead')
  T easeOutCubic() => call(Curves.easeOutCubic);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutQuart] value.
  @Deprecated('Use call(Curves.easeOutQuart) instead')
  T easeOutQuart() => call(Curves.easeOutQuart);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutQuint] value.
  @Deprecated('Use call(Curves.easeOutQuint) instead')
  T easeOutQuint() => call(Curves.easeOutQuint);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutExpo] value.
  @Deprecated('Use call(Curves.easeOutExpo) instead')
  T easeOutExpo() => call(Curves.easeOutExpo);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutCirc] value.
  @Deprecated('Use call(Curves.easeOutCirc) instead')
  T easeOutCirc() => call(Curves.easeOutCirc);

  /// Creates a [StyleAttribute] instance with [Curves.easeOutBack] value.
  @Deprecated('Use call(Curves.easeOutBack) instead')
  T easeOutBack() => call(Curves.easeOutBack);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOut] value.
  @Deprecated('Use call(Curves.easeInOut) instead')
  T easeInOut() => call(Curves.easeInOut);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutSine] value.
  @Deprecated('Use call(Curves.easeInOutSine) instead')
  T easeInOutSine() => call(Curves.easeInOutSine);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutQuad] value.
  @Deprecated('Use call(Curves.easeInOutQuad) instead')
  T easeInOutQuad() => call(Curves.easeInOutQuad);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutCubic] value.
  @Deprecated('Use call(Curves.easeInOutCubic) instead')
  T easeInOutCubic() => call(Curves.easeInOutCubic);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutCubicEmphasized] value.
  @Deprecated('Use call(Curves.easeInOutCubicEmphasized) instead')
  T easeInOutCubicEmphasized() => call(Curves.easeInOutCubicEmphasized);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutQuart] value.
  @Deprecated('Use call(Curves.easeInOutQuart) instead')
  T easeInOutQuart() => call(Curves.easeInOutQuart);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutQuint] value.
  @Deprecated('Use call(Curves.easeInOutQuint) instead')
  T easeInOutQuint() => call(Curves.easeInOutQuint);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutExpo] value.
  @Deprecated('Use call(Curves.easeInOutExpo) instead')
  T easeInOutExpo() => call(Curves.easeInOutExpo);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutCirc] value.
  @Deprecated('Use call(Curves.easeInOutCirc) instead')
  T easeInOutCirc() => call(Curves.easeInOutCirc);

  /// Creates a [StyleAttribute] instance with [Curves.easeInOutBack] value.
  @Deprecated('Use call(Curves.easeInOutBack) instead')
  T easeInOutBack() => call(Curves.easeInOutBack);

  /// Creates a [StyleAttribute] instance with [Curves.fastOutSlowIn] value.
  @Deprecated('Use call(Curves.fastOutSlowIn) instead')
  T fastOutSlowIn() => call(Curves.fastOutSlowIn);

  /// Creates a [StyleAttribute] instance with [Curves.slowMiddle] value.
  @Deprecated('Use call(Curves.slowMiddle) instead')
  T slowMiddle() => call(Curves.slowMiddle);

  /// Creates a [StyleAttribute] instance with [Curves.bounceIn] value.
  @Deprecated('Use call(Curves.bounceIn) instead')
  T bounceIn() => call(Curves.bounceIn);

  /// Creates a [StyleAttribute] instance with [Curves.bounceOut] value.
  @Deprecated('Use call(Curves.bounceOut) instead')
  T bounceOut() => call(Curves.bounceOut);

  /// Creates a [StyleAttribute] instance with [Curves.bounceInOut] value.
  @Deprecated('Use call(Curves.bounceInOut) instead')
  T bounceInOut() => call(Curves.bounceInOut);

  /// Creates a [StyleAttribute] instance with [Curves.elasticIn] value.
  @Deprecated('Use call(Curves.elasticIn) instead')
  T elasticIn() => call(Curves.elasticIn);

  /// Creates a [StyleAttribute] instance with [Curves.elasticOut] value.
  @Deprecated('Use call(Curves.elasticOut) instead')
  T elasticOut() => call(Curves.elasticOut);

  /// Creates a [StyleAttribute] instance with [Curves.elasticInOut] value.
  @Deprecated('Use call(Curves.elasticInOut) instead')
  T elasticInOut() => call(Curves.elasticInOut);
}

/// Extension for creating [Offset] values with predefined positions.
extension OffsetPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Offset> {
  /// Creates a [StyleAttribute] instance with [Offset.zero] value.
  @Deprecated('Use call(Offset.zero) instead')
  T zero() => call(Offset.zero);

  /// Creates a [StyleAttribute] instance with [Offset.infinite] value.
  @Deprecated('Use call(Offset.infinite) instead')
  T infinite() => call(Offset.infinite);

  /// Creates a [StyleAttribute] instance using the [Offset.fromDirection] constructor.
  @Deprecated('Use call(Offset.fromDirection(direction, distance)) instead')
  T fromDirection(double direction, [double distance = 1.0]) {
    return call(Offset.fromDirection(direction, distance));
  }
}

/// Extension for creating [Radius] values with predefined radius shapes.
extension RadiusPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Radius> {
  /// Creates a [StyleAttribute] instance with [Radius.zero] value.
  @Deprecated('Use call(Radius.zero) instead')
  T zero() => call(Radius.zero);

  /// Creates a [StyleAttribute] instance using the [Radius.circular] constructor.
  @Deprecated('Use call(Radius.circular(radius)) instead')
  T circular(double radius) => call(Radius.circular(radius));

  /// Creates a [StyleAttribute] instance using the [Radius.elliptical] constructor.
  @Deprecated('Use call(Radius.elliptical(x, y)) instead')
  T elliptical(double x, double y) => call(Radius.elliptical(x, y));
}

/// Extension for creating [Rect] values with predefined rectangles and constructors.
extension RectPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Rect> {
  /// Creates a [StyleAttribute] instance with [Rect.zero] value.
  @Deprecated('Use call(Rect.zero) instead')
  T zero() => call(Rect.zero);

  /// Creates a [StyleAttribute] instance with [Rect.largest] value.
  @Deprecated('Use call(Rect.largest) instead')
  T largest() => call(Rect.largest);

  /// Creates a [StyleAttribute] instance using the [Rect.fromLTRB] constructor.
  @Deprecated('Use call(Rect.fromLTRB(left, top, right, bottom)) instead')
  T fromLTRB(double left, double top, double right, double bottom) {
    return call(Rect.fromLTRB(left, top, right, bottom));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromLTWH] constructor.
  @Deprecated('Use call(Rect.fromLTWH(left, top, width, height)) instead')
  T fromLTWH(double left, double top, double width, double height) {
    return call(Rect.fromLTWH(left, top, width, height));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromCircle] constructor.
  @Deprecated('Use call(Rect.fromCircle(center: center, radius: radius)) instead')
  T fromCircle({required Offset center, required double radius}) {
    return call(Rect.fromCircle(center: center, radius: radius));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromCenter] constructor.
  @Deprecated('Use call(Rect.fromCenter(center: center, width: width, height: height)) instead')
  T fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) {
    return call(Rect.fromCenter(center: center, width: width, height: height));
  }

  /// Creates a [StyleAttribute] instance using the [Rect.fromPoints] constructor.
  @Deprecated('Use call(Rect.fromPoints(a, b)) instead')
  T fromPoints(Offset a, Offset b) => call(Rect.fromPoints(a, b));
}

/// Extension for creating [Paint] values for custom drawing operations.
extension PaintPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Paint> {
  // No predefined paint values - this extension provides type consistency
}

/// Extension for creating [Locale] values for internationalization.
extension LocalePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Locale> {
  // No predefined locale values - this extension provides type consistency
}

/// Extension for creating [ImageProvider] values with different image sources.
extension ImageProviderPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, ImageProvider> {
  /// Creates an [StyleAttribute] instance with [ImageProvider.network].
  /// @param url The URL of the image.
  @Deprecated('Use call(NetworkImage(url)) instead')
  T network(String url) => call(NetworkImage(url));
  @Deprecated('Use call(FileImage(file)) instead')
  T file(File file) => call(FileImage(file));
  @Deprecated('Use call(AssetImage(asset)) instead')
  T asset(String asset) => call(AssetImage(asset));
  @Deprecated('Use call(MemoryImage(bytes)) instead')
  T memory(Uint8List bytes) => call(MemoryImage(bytes));
}

/// Extension for creating [GradientTransform] values for gradient transformations.
extension GradientTransformPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, GradientTransform> {
  /// Creates an [StyleAttribute] instance with a [GradientRotation] value.
  @Deprecated('Use call(GradientRotation(radians)) instead')
  T rotate(double radians) => call(GradientRotation(radians));
}

/// Extension for creating [Matrix4] values for 3D transformations.
extension Matrix4PropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, Matrix4> {
  /// Creates a [StyleAttribute] instance using the [Matrix4.fromList] constructor.
  @Deprecated('Use call(Matrix4.fromList(values)) instead')
  T fromList(List<double> values) => call(Matrix4.fromList(values));

  /// Creates a [StyleAttribute] instance using the [Matrix4.zero] constructor.
  @Deprecated('Use call(Matrix4.zero()) instead')
  T zero() => call(Matrix4.zero());

  /// Creates a [StyleAttribute] instance using the [Matrix4.identity] constructor.
  @Deprecated('Use call(Matrix4.identity()) instead')
  T identity() => call(Matrix4.identity());

  /// Creates a [StyleAttribute] instance using the [Matrix4.rotationX] constructor.
  @Deprecated('Use call(Matrix4.rotationX(radians)) instead')
  T rotationX(double radians) => call(Matrix4.rotationX(radians));

  /// Creates a [StyleAttribute] instance using the [Matrix4.rotationY] constructor.
  @Deprecated('Use call(Matrix4.rotationY(radians)) instead')
  T rotationY(double radians) => call(Matrix4.rotationY(radians));

  /// Creates a [StyleAttribute] instance using the [Matrix4.rotationZ] constructor.
  @Deprecated('Use call(Matrix4.rotationZ(radians)) instead')
  T rotationZ(double radians) => call(Matrix4.rotationZ(radians));

  /// Creates a [StyleAttribute] instance using the [Matrix4.translationValues] constructor.
  @Deprecated('Use call(Matrix4.translationValues(x, y, z)) instead')
  T translationValues(double x, double y, double z) {
    return call(Matrix4.translationValues(x, y, z));
  }

  /// Creates a [StyleAttribute] instance using the [Matrix4.diagonal3Values] constructor.
  @Deprecated('Use call(Matrix4.diagonal3Values(x, y, z)) instead')
  T diagonal3Values(double x, double y, double z) {
    return call(Matrix4.diagonal3Values(x, y, z));
  }

  /// Creates a [StyleAttribute] instance using the [Matrix4.skewX] constructor.
  @Deprecated('Use call(Matrix4.skewX(alpha)) instead')
  T skewX(double alpha) => call(Matrix4.skewX(alpha));

  /// Creates a [StyleAttribute] instance using the [Matrix4.skewY] constructor.
  @Deprecated('Use call(Matrix4.skewY(beta)) instead')
  T skewY(double beta) => call(Matrix4.skewY(beta));

  /// Creates a [StyleAttribute] instance using the [Matrix4.skew] constructor.
  @Deprecated('Use call(Matrix4.skew(alpha, beta)) instead')
  T skew(double alpha, double beta) => call(Matrix4.skew(alpha, beta));

  /// Creates a [StyleAttribute] instance using the [Matrix4.fromBuffer] constructor.
  @Deprecated('Use call(Matrix4.fromBuffer(buffer, offset)) instead')
  T fromBuffer(ByteBuffer buffer, int offset) {
    return call(Matrix4.fromBuffer(buffer, offset));
  }
}

/// Extension for creating font family strings with various constructors.
extension FontFamilyPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, String> {
  /// Creates a [StyleAttribute] instance using the [String.fromCharCodes] constructor.
  @Deprecated('Use call(String.fromCharCodes(charCodes, start, end)) instead')
  T fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]) {
    return call(String.fromCharCodes(charCodes, start, end));
  }

  /// Creates a [StyleAttribute] instance using the [String.fromCharCode] constructor.
  @Deprecated('Use call(String.fromCharCode(charCode)) instead')
  T fromCharCode(int charCode) => call(String.fromCharCode(charCode));

  /// Creates a [StyleAttribute] instance using the [String.fromEnvironment] constructor.
  @Deprecated('Use call(String.fromEnvironment(name, defaultValue: defaultValue)) instead')
  T fromEnvironment(String name, {String defaultValue = ""}) {
    return call(String.fromEnvironment(name, defaultValue: defaultValue));
  }
}

/// Extension for creating [TextScaler] values for text scaling.
extension TextScalerPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TextScaler> {
  /// Creates a [StyleAttribute] instance with [TextScaler.noScaling] value.
  @Deprecated('Use call(TextScaler.noScaling) instead')
  T noScaling() => call(TextScaler.noScaling);

  /// Creates a [StyleAttribute] instance using the [TextScaler.linear] constructor.
  @Deprecated('Use call(TextScaler.linear(textScaleFactor)) instead')
  T linear(double textScaleFactor) => call(TextScaler.linear(textScaleFactor));
}

/// Extension for creating [TableColumnWidth] values for table column sizing.
extension TableColumnWidthPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, TableColumnWidth> {
  // No predefined table column width values - this extension provides type consistency
}

/// Utility for creating [TableBorder] values with predefined border styles.
class TableBorderUtility<T extends StyleAttribute<Object?>>
    extends PropUtility<T, TableBorder> {
  const TableBorderUtility(super.builder);

  /// Creates a [StyleAttribute] instance using the [TableBorder.all] constructor.
  @Deprecated('Use call(TableBorder.all(color: color, width: width, style: style, borderRadius: borderRadius)) instead')
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

  /// Creates a [StyleAttribute] instance using the [TableBorder.symmetric] constructor.
  @Deprecated('Use call(TableBorder.symmetric(inside: inside, outside: outside, borderRadius: borderRadius)) instead')
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

/// Extension for creating stroke alignment values for border positioning.
extension StrokeAlignPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, double> {
  /// Creates a [StyleAttribute] instance with center stroke alignment (0).
  @Deprecated('Use call(0) instead')
  T center() => call(0);
  
  /// Creates a [StyleAttribute] instance with inside stroke alignment (-1).
  @Deprecated('Use call(-1) instead')
  T inside() => call(-1);
  
  /// Creates a [StyleAttribute] instance with outside stroke alignment (1).
  @Deprecated('Use call(1) instead')
  T outside() => call(1);
}

/// Extension for creating string values.
extension StringPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, String> {
  // No predefined string values - this extension provides type consistency
}

/// Extension for creating [double] values with predefined options.
extension DoublePropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, double> {
  /// Creates an [StyleAttribute] instance with a value of 0.
  @Deprecated('Use call(0) instead')
  T zero() => call(0);

  /// Creates an [StyleAttribute] instance with a value of [double.infinity].
  @Deprecated('Use call(double.infinity) instead')
  T infinity() => call(double.infinity);
}

/// Extension for creating [int] values with predefined options.
extension IntPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, int> {
  /// Creates an [StyleAttribute] instance with a value of 0.
  @Deprecated('Use call(0) instead')
  T zero() => call(0);
}

/// Extension for creating [bool] values with predefined options.
extension BoolPropUtilityExt<T extends StyleAttribute<Object?>>
    on PropUtility<T, bool> {
  /// Creates an [StyleAttribute] instance with a value of `true`.
  @Deprecated('Use call(true) instead')
  T on() => call(true);

  /// Creates an [StyleAttribute] instance with a value of `false`.
  @Deprecated('Use call(false) instead')
  T off() => call(false);
}

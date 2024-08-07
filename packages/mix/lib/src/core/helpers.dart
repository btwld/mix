import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as r;
import 'package:flutter/widgets.dart' as w;

import '../internal/deep_collection_equality.dart';
import 'dto.dart';

/// Class to provide some helpers without conflicting
/// name space with other libraries.
class MixHelpers {
  // This should only be used for testing
  @visibleForTesting
  static TargetPlatform? targetPlatformOverride;

  // This should only be used for testing
  @visibleForTesting
  static bool? isWebOverride;
  static const deepEquality = DeepCollectionEquality();

  static const lerpDouble = ui.lerpDouble;

  static const mergeList = _mergeDtoList;

  static const lerpStrutStyle = _lerpStrutStyle;

  static const lerpMatrix4 = _lerpMatrix4;

  static const lerpTextStyle = _lerpTextStyle;

  static const lerpInt = _lerpInt;

  static const lerpSnap = _lerpSnap;

  static bool get isWeb => isWebOverride ?? kIsWeb;
  static TargetPlatform get targetPlatform =>
      targetPlatformOverride ?? defaultTargetPlatform;

  const MixHelpers._();
}

P? _lerpSnap<P>(P? from, P? to, double t) {
  if (from == null) return to;
  if (to == null) return from;

  return t < 0.5 ? from : to;
}

w.TextStyle? _lerpTextStyle(w.TextStyle? a, w.TextStyle? b, double t) {
  return w.TextStyle.lerp(a, b, t)?.copyWith(
    shadows: w.Shadow.lerpList(a?.shadows, b?.shadows, t),
    fontVariations: lerpFontVariations(
      a?.fontVariations,
      b?.fontVariations,
      t,
    ),
  );
}

int _lerpInt(int? a, int? b, double t) {
  a ??= 0;
  b ??= 0;

  return (a + (b - a) * t).round();
}

List<T>? _mergeDtoList<T>(List<T>? a, List<T>? b) {
  if (b == null) return a;
  if (a == null) return b;

  if (a.isEmpty) return b;
  if (b.isEmpty) return a;

  final listLength = a.length;
  final otherLength = b.length;
  final maxLength = math.max(listLength, otherLength);

  return List.generate(maxLength, (int index) {
    if (index < listLength && index < otherLength) {
      final currentValue = a[index];
      final otherValue = b[index];

      if (currentValue is Dto && otherValue is Dto) {
        return currentValue.merge(otherValue) as T;
      }

      return otherValue ?? currentValue;
    } else if (index < listLength) {
      return a[index];
    }

    return b[index];
  });
}

w.Matrix4? _lerpMatrix4(w.Matrix4? a, w.Matrix4? b, double t) {
  if (a == null && b == null) return null;
  if (a == null) return b;
  if (b == null) return a;

  return w.Matrix4Tween(begin: a, end: b).lerp(t);
}

w.StrutStyle? _lerpStrutStyle(w.StrutStyle? a, w.StrutStyle? b, double t) {
  if (a == null && b == null) return null;
  if (a == null) return b;
  if (b == null) return a;

  return w.StrutStyle(
    fontFamily: t < 0.5 ? a.fontFamily : b.fontFamily,
    fontFamilyFallback: t < 0.5 ? a.fontFamilyFallback : b.fontFamilyFallback,
    fontSize: MixHelpers.lerpDouble(a.fontSize, b.fontSize, t),
    height: MixHelpers.lerpDouble(a.height, b.height, t),
    leadingDistribution:
        t < 0.5 ? a.leadingDistribution : b.leadingDistribution,
    leading: MixHelpers.lerpDouble(a.leading, b.leading, t),
    fontWeight: r.FontWeight.lerp(a.fontWeight, b.fontWeight, t),
    fontStyle: t < 0.5 ? a.fontStyle : b.fontStyle,
    forceStrutHeight: t < 0.5 ? a.forceStrutHeight : b.forceStrutHeight,
    debugLabel: a.debugLabel ?? b.debugLabel,
  );
}

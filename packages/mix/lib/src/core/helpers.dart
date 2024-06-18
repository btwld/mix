import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as r;
import 'package:flutter/widgets.dart' as w;

import '../internal/deep_collection_equality.dart';
import 'core.dart';

/// Class to provide some helpers without conflicting
/// name space with other libraries.
class MixHelpers {
  static const deepEquality = DeepCollectionEquality();

  static const lerpDouble = ui.lerpDouble;

  static const mergeList = _mergeDtoList;

  static const lerpStrutStyle = _lerpStrutStyle;

  static const lerpMatrix4 = _lerpMatrix4;

  static const lerpTextStyle = _lerpTextStyle;

  const MixHelpers._();
}

w.TextStyle? _lerpTextStyle(w.TextStyle? a, w.TextStyle? b, double t) {
  return w.TextStyle.lerp(a, b, t)
      ?.copyWith(shadows: w.Shadow.lerpList(a?.shadows, b?.shadows, t));
}

List<T>? _mergeList<T>(List<T>? a, List<T>? b) {
  if (b == null) return a;
  if (a == null) return b;

  final mergedList = [...a];
  for (int i = 0; i < b.length; i++) {
    if (i < mergedList.length) {
      final currentValue = mergedList[i];
      final newValue = b[i];

      if (currentValue is Dto && newValue is Dto) {
        mergedList[i] = currentValue.merge(newValue) as T;
      } else {
        mergedList[i] = newValue ?? currentValue;
      }
    } else {
      mergedList.add(b[i]);
    }
  }

  return mergedList;
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

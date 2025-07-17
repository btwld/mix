import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as r;
import 'package:flutter/widgets.dart' as w;

import '../internal/deep_collection_equality.dart';
import 'mix_element.dart';
import 'prop.dart';

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

  static const mergeList = _mergeList;

  static const resolveList = _resolveList;

  static const mergePropList = _mergePropList;

  static const resolvePropList = _resolvePropList;

  static const mergeMixPropList = _mergeMixPropList;

  static const resolveMixPropList = _resolveMixPropList;

  static const lerpStrutStyle = _lerpStrutStyle;

  static const lerpMatrix4 = _lerpMatrix4;

  static const lerpTextStyle = _lerpTextStyle;

  static const lerpInt = _lerpInt;

  static const lerpSnap = _lerpSnap;

  static const lerpShadowList = ui.Shadow.lerpList;

  const MixHelpers._();
  static bool get isWeb => isWebOverride ?? kIsWeb;
  static TargetPlatform get targetPlatform =>
      targetPlatformOverride ?? defaultTargetPlatform;
}

P? _lerpSnap<P>(P? from, P? to, double t) {
  if (from == null) return to;
  if (to == null) return from;

  return t < 0.5 ? from : to;
}

w.TextStyle? _lerpTextStyle(w.TextStyle? a, w.TextStyle? b, double t) {
  return w.TextStyle.lerp(a, b, t)?.copyWith(
    shadows: w.Shadow.lerpList(a?.shadows, b?.shadows, t),
    fontVariations: lerpFontVariations(a?.fontVariations, b?.fontVariations, t),
  );
}

int _lerpInt(int? a, int? b, double t) {
  a ??= 0;
  b ??= 0;

  return (a + (b - a) * t).round();
}

List<T>? _mergeList<T>(
  List<T>? a,
  List<T>? b, {
  ListMergeStrategy strategy = ListMergeStrategy.replace,
}) {
  if (b == null) return a;
  if (a == null) return b;

  if (a.isEmpty) return b;
  if (b.isEmpty) return a;

  switch (strategy) {
    case ListMergeStrategy.append:
      return [...a, ...b];
    case ListMergeStrategy.replace:
      final listLength = a.length;
      final otherLength = b.length;
      final maxLength = math.max(listLength, otherLength);

      return List.generate(maxLength, (int index) {
        if (index < listLength && index < otherLength) {
          final currentValue = a[index];
          final otherValue = b[index];

          if (currentValue is Mix && otherValue is Mix) {
            return currentValue.merge(otherValue) as T;
          }

          return otherValue ?? currentValue;
        } else if (index < listLength) {
          return a[index];
        }

        return b[index];
      });
    case ListMergeStrategy.override:
      return b;
  }
}

List<V> _resolveList<T extends Mix<V>, V>(List<T>? a, BuildContext mix) {
  if (a == null) return [];

  return a.map((e) => e.resolve(mix)).whereType<V>().toList();
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
    leadingDistribution: t < 0.5
        ? a.leadingDistribution
        : b.leadingDistribution,
    leading: MixHelpers.lerpDouble(a.leading, b.leading, t),
    fontWeight: r.FontWeight.lerp(a.fontWeight, b.fontWeight, t),
    fontStyle: t < 0.5 ? a.fontStyle : b.fontStyle,
    forceStrutHeight: t < 0.5 ? a.forceStrutHeight : b.forceStrutHeight,
    debugLabel: a.debugLabel ?? b.debugLabel,
  );
}

List<Prop<V>>? _mergePropList<V>(
  List<Prop<V>>? a,
  List<Prop<V>>? b, {
  ListMergeStrategy strategy = ListMergeStrategy.replace,
}) {
  if (a == null) return b;
  if (b == null) return a;

  switch (strategy) {
    case ListMergeStrategy.append:
      return [...a, ...b];
    case ListMergeStrategy.replace:
      final result = List<Prop<V>>.of(a);
      for (int i = 0; i < b.length; i++) {
        if (i < result.length) {
          result[i] = result[i].merge(b[i]);
        } else {
          result.add(b[i]);
        }
      }

      return result;
    case ListMergeStrategy.override:
      return b;
  }
}

List<V>? _resolvePropList<V>(BuildContext context, List<Prop<V>>? list) {
  if (list == null || list.isEmpty) return null;

  final resolved = <V>[];
  for (final item in list) {
    final value = item.resolve(context);
    if (value != null) resolved.add(value);
  }

  return resolved.isEmpty ? null : resolved;
}

List<MixProp<R, D>>? _mergeMixPropList<R, D extends Mix<R>>(
  List<MixProp<R, D>>? a,
  List<MixProp<R, D>>? b, {
  ListMergeStrategy strategy = ListMergeStrategy.replace,
}) {
  if (a == null) return b;
  if (b == null) return a;

  switch (strategy) {
    case ListMergeStrategy.append:
      return [...a, ...b];
    case ListMergeStrategy.replace:
      final result = List<MixProp<R, D>>.of(a);
      for (int i = 0; i < b.length; i++) {
        if (i < result.length) {
          result[i] = result[i].merge(b[i]);
        } else {
          result.add(b[i]);
        }
      }

      return result;
    case ListMergeStrategy.override:
      return b;
  }
}

List<R>? _resolveMixPropList<R, D extends Mix<R>>(
  BuildContext context,
  List<MixProp<R, D>>? list,
) {
  if (list == null || list.isEmpty) return null;

  final resolved = <R>[];
  for (final mixProp in list) {
    final value = mixProp.resolve(context);
    if (value != null) resolved.add(value);
  }

  return resolved.isEmpty ? null : resolved;
}

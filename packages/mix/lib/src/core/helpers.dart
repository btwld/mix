import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as r;
import 'package:flutter/widgets.dart' as w;

import '../modifiers/modifier_config.dart';
import '../properties/painting/decoration_mix.dart';
import '../properties/painting/shape_border_mix.dart';
import 'decoration_merge.dart';
import 'directive.dart';
import 'internal/deep_collection_equality.dart';
import 'mix_element.dart';
import 'modifier.dart';
import 'prop.dart';
import 'prop_source.dart';
import 'shape_border_merge.dart';
import 'spec.dart';

/// Core operations for Mix framework value transformations.
///
/// Provides value resolution, merging, and interpolation operations
/// used throughout the Mix styling system.
class MixOps {
  static const deepEquality = DeepCollectionEquality();

  static const lerp = _lerpValue;

  static const lerpSnap = _lerpSnap;

  static const mergeList = _mergeList;

  static const resolveList = _resolveList;

  const MixOps._();

  static V? resolve<V>(BuildContext context, Prop<V>? prop) {
    if (prop == null) return null;

    return prop.resolveProp(context);
  }

  static P? merge<P extends Prop<V>, V>(P? a, P? b) {
    if (a == null) return b;
    if (b == null) return a;

    return a.mergeProp(b) as P;
  }

  static List<T>? _mergeList<T>(
    List<T>? a,
    List<T>? b, {

    /// Defaults to `replace`
    ListMergeStrategy? strategy,
  }) {
    if (b == null) return a;
    if (a == null) return b;

    if (a.isEmpty) return b;
    if (b.isEmpty) return a;

    strategy ??= ListMergeStrategy.replace;

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

            if (currentValue is Mixable && otherValue is Mixable) {
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

  static List<V>? _resolveList<T extends Prop<V>, V>(
    BuildContext mix,
    List<T>? a,
  ) {
    if (a == null) return null;

    return a.map((e) => e.resolveProp(mix)).whereType<V>().toList();
  }

  static w.StrutStyle? _lerpStrutStyle(
    w.StrutStyle? a,
    w.StrutStyle? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    return w.StrutStyle(
      fontFamily: t < 0.5 ? a.fontFamily : b.fontFamily,
      fontFamilyFallback: t < 0.5 ? a.fontFamilyFallback : b.fontFamilyFallback,
      fontSize: ui.lerpDouble(a.fontSize, b.fontSize, t),
      height: ui.lerpDouble(a.height, b.height, t),
      leadingDistribution: t < 0.5
          ? a.leadingDistribution
          : b.leadingDistribution,
      leading: ui.lerpDouble(a.leading, b.leading, t),
      fontWeight: r.FontWeight.lerp(a.fontWeight, b.fontWeight, t),
      fontStyle: t < 0.5 ? a.fontStyle : b.fontStyle,
      forceStrutHeight: t < 0.5 ? a.forceStrutHeight : b.forceStrutHeight,
      debugLabel: a.debugLabel ?? b.debugLabel,
    );
  }
}

/// Snap interpolation for non-lerpable types.
/// Returns [a] when t < 0.5, otherwise returns [b].
T? _lerpSnap<T>(T? a, T? b, double t) {
  return t < 0.5 ? a : b;
}

/// Lerp modifier lists using ModifierListTween
List<Modifier>? _lerpModifierList(
  List<Modifier>? a,
  List<Modifier>? b,
  double t,
) {
  return ModifierListTween(begin: a, end: b).lerp(t);
}

T? _lerpValue<T>(T? a, T? b, double t) {
  return switch ((a, b)) {
    (Spec? a, Spec? b) => a?.lerp(b, t) as T?,

    // Numeric types
    (int? a, int? b) => ui.lerpDouble(a, b, t)?.round() as T?,
    (double? a, double? b) => ui.lerpDouble(a, b, t) as T?,

    // Core Flutter geometry (dart:ui)
    (Offset? a, Offset? b) => Offset.lerp(a, b, t) as T?,
    (Size? a, Size? b) => Size.lerp(a, b, t) as T?,
    (Rect? a, Rect? b) => Rect.lerp(a, b, t) as T?,
    (RRect? a, RRect? b) => RRect.lerp(a, b, t) as T?,

    // Core Flutter color (dart:ui)
    (Color? a, Color? b) => Color.lerp(a, b, t) as T?,
    (HSVColor? a, HSVColor? b) => HSVColor.lerp(a, b, t) as T?,
    (HSLColor? a, HSLColor? b) => HSLColor.lerp(a, b, t) as T?,

    // Alignment - handle specific types first
    (FractionalOffset? a, FractionalOffset? b) =>
      FractionalOffset.lerp(a, b, t) as T?,
    (Alignment? a, Alignment? b) => Alignment.lerp(a, b, t) as T?,
    (AlignmentGeometry? a, AlignmentGeometry? b) =>
      AlignmentGeometry.lerp(a, b, t) as T?,

    // EdgeInsets - handle specific types first
    (Decoration? a, Decoration? b) => Decoration.lerp(a, b, t) as T?,
    (EdgeInsets? a, EdgeInsets? b) => EdgeInsets.lerp(a, b, t) as T?,
    (EdgeInsetsGeometry? a, EdgeInsetsGeometry? b) =>
      EdgeInsetsGeometry.lerp(a, b, t) as T?,

    // BorderRadius - handle specific types first
    (BorderRadius? a, BorderRadius? b) => BorderRadius.lerp(a, b, t) as T?,
    (BorderRadiusGeometry? a, BorderRadiusGeometry? b) =>
      BorderRadiusGeometry.lerp(a, b, t) as T?,

    // Relative positioning
    (RelativeRect? a, RelativeRect? b) => RelativeRect.lerp(a, b, t) as T?,

    (List<BoxShadow>? a, List<BoxShadow>? b) =>
      BoxShadow.lerpList(a, b, t) as T?,
    (List<Shadow>? a, List<Shadow>? b) => Shadow.lerpList(a, b, t) as T?,

    // Text painting
    (TextStyle? a, TextStyle? b) => TextStyle.lerp(a, b, t) as T?,
    (StrutStyle? a, StrutStyle? b) => MixOps._lerpStrutStyle(a, b, t) as T?,

    // Shadows
    (BoxShadow? a, BoxShadow? b) => BoxShadow.lerp(a, b, t) as T?,
    (Shadow? a, Shadow? b) => Shadow.lerp(a, b, t) as T?,

    // Borders and shapes
    (Border? a, Border? b) => Border.lerp(a, b, t) as T?,
    (ShapeBorder? a, ShapeBorder? b) => ShapeBorder.lerp(a, b, t) as T?,

    // Gradients
    (LinearGradient? a, LinearGradient? b) =>
      LinearGradient.lerp(a, b, t) as T?,
    (RadialGradient? a, RadialGradient? b) =>
      RadialGradient.lerp(a, b, t) as T?,
    (SweepGradient? a, SweepGradient? b) => SweepGradient.lerp(a, b, t) as T?,

    // Constraints
    (BoxConstraints? a, BoxConstraints? b) =>
      BoxConstraints.lerp(a, b, t) as T?,

    // Theme data
    (IconThemeData? a, IconThemeData? b) => IconThemeData.lerp(a, b, t) as T?,

    // Matrix4 - use proper tween instead of snap
    (Matrix4? a, Matrix4? b) => Matrix4Tween(begin: a, end: b).lerp(t) as T?,

    // List of Modifiers - use ModifierListTween for proper lerping
    (List<Modifier>? a, List<Modifier>? b) => 
      _lerpModifierList(a, b, t) as T?,

    // Default snap behavior for non-lerpable types
    _ => t < 0.5 ? a : b,
  };
}

/// Operations for Prop merge and resolution logic.
///
/// Centralizes all prop-related operations to keep prop classes lean
/// and focused on data storage while providing sophisticated merge
/// and resolution capabilities.
class PropOps {
  const PropOps._();

  /// Applies directives to a resolved value
  static V applyDirectives<V>(V value, List<Directive<V>>? directives) {
    if (directives == null || directives.isEmpty) return value;

    var result = value;
    for (final directive in directives) {
      result = directive.apply(result);
    }

    return result;
  }

  /// Merges two directive lists
  static List<Directive<V>>? mergeDirectives<V>(
    List<Directive<V>>? current,
    List<Directive<V>>? other,
  ) {
    return switch ((current, other)) {
      (null, null) => null,
      (final a?, null) => a,
      (null, final b?) => b,
      (final a?, final b?) => [...a, ...b],
    };
  }

  /// Merges two Prop instances
  static Prop<V> merge<V>(Prop<V> current, Prop<V>? other) {
    // Delegate to Prop's own mergeProp method
    return current.mergeProp(other);
  }

  /// Resolves a Prop instance to its final value
  static V resolve<V>(Prop<V> prop, BuildContext context) {
    // Delegate to Prop's own resolveProp method
    return prop.resolveProp(context);
  }

  /// Merges two Prop instances containing Mix values
  static Prop<V> mergeMix<V>(Prop<V> current, Prop<V>? other) {
    // Delegate to Prop's own mergeProp method
    return current.mergeProp(other);
  }

  /// Resolves a Prop instance containing Mix values to its final value
  static V resolveMix<V>(Prop<V> prop, BuildContext context) {
    // Delegate to Prop's own resolveProp method
    return prop.resolveProp(context);
  }

  /// Merges two Mix instances using appropriate merger with BuildContext

  static Mix<V> mergeMixes<V>(BuildContext context, Mix<V> a, Mix<V> b) {
    // Handle special cases that need BuildContext-aware merging
    return switch ((a, b)) {
      (DecorationMix a, DecorationMix b) =>
        DecorationMerger().tryMerge(context, a, b)! as Mix<V>,
      (ShapeBorderMix a, ShapeBorderMix b) =>
        ShapeBorderMerger().tryMerge(context, a, b)! as Mix<V>,
      _ => a.merge(b),
    };
  }

  /// Consolidates consecutive MixSource instances
  static List<PropSource<V>> consolidateSources<V>(
    List<PropSource<V>> sources,
    BuildContext context,
  ) {
    if (sources.length <= 1) return sources;

    final consolidated = <PropSource<V>>[];
    MixSource<V>? pendingMixSource;

    for (final source in sources) {
      if (source is MixSource<V>) {
        if (pendingMixSource != null) {
          final mergedMix = mergeMixes(
            context,
            pendingMixSource.mix,
            source.mix,
          );
          pendingMixSource = MixSource(mergedMix);
        } else {
          pendingMixSource = source;
        }
      } else {
        if (pendingMixSource != null) {
          consolidated.add(pendingMixSource);
          pendingMixSource = null;
        }
        consolidated.add(source);
      }
    }

    if (pendingMixSource != null) {
      consolidated.add(pendingMixSource);
    }

    return consolidated;
  }
}

/// Merge strategy for lists
enum ListMergeStrategy {
  /// Append items from other list (default)
  append,

  /// Replace items at same index
  replace,

  /// Override entire list
  override,
}

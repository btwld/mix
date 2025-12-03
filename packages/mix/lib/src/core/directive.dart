import 'dart:math' as math;

import 'package:flutter/widgets.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PROP DIRECTIVES - For Prop resolution only
// ═══════════════════════════════════════════════════════════════════════════

/// Directive applied once during Prop resolution.
///
/// PropDirectives are used with Prop instances and applied immediately during
/// `Prop.resolveProp()`. They transform values once and are discarded before
/// the Spec is created.
///
/// ## Usage
///
/// ```dart
/// // In color transformations
/// Prop<Color>.value(Colors.red)
///   .directives([OpacityColorDirective(0.5)]);
/// ```
///
/// PropDirectives are stored in `Prop.$directives` and applied during resolution,
/// before animation occurs. For directives that need to animate, use [SpecDirective].
@immutable
abstract class PropDirective<T> {
  const PropDirective();

  /// The unique identifier for this directive type.
  String get key;

  /// Applies the transformation to the given value.
  T apply(T value);
}

// ═══════════════════════════════════════════════════════════════════════════
// SPEC DIRECTIVES - For Spec storage and rendering
// ═══════════════════════════════════════════════════════════════════════════

/// Base for directives stored in Specs.
///
/// SpecDirectives live inside [Spec] objects (e.g., [TextSpec]) and are
/// interpolated whenever the spec animates. There are two types:
///
/// - [StaticSpecDirective]: Instant transformations that snap during animation
///   (e.g., uppercase, titlecase)
/// - [AnimatedSpecDirective]: Animated transformations that lerp during animation
///   (e.g., typewriter effect)
///
/// This class is sealed - you must extend either [StaticSpecDirective] or
/// [AnimatedSpecDirective].
@immutable
sealed class SpecDirective<T> {
  const SpecDirective();

  /// The unique identifier for this directive type.
  String get key;
}

/// Instant transformation that snaps during animation.
///
/// Use this for transformations that should apply instantly without interpolation,
/// such as text case transformations (uppercase, lowercase, titlecase).
///
/// ## Example
///
/// ```dart
/// final class UppercaseDirective extends StaticSpecDirective<String> {
///   const UppercaseDirective();
///
///   @override
///   String get key => 'uppercase';
///
///   @override
///   String apply(String value) => value.toUpperCase();
/// }
/// ```
@immutable
abstract class StaticSpecDirective<T> extends SpecDirective<T> {
  const StaticSpecDirective();

  /// Applies the transformation to the given value.
  T apply(T value);
}

/// Animated transformation that lerps progress during animation.
///
/// Use this for transformations that should animate smoothly, such as
/// typewriter effects where text is revealed character by character.
///
/// Progress is provided externally during animation - directives are stateless.
///
/// ## Example
///
/// ```dart
/// final class TypewriterDirective extends AnimatedSpecDirective<String> {
///   final bool reverse;
///
///   const TypewriterDirective({this.reverse = false});
///
///   @override
///   String get key => 'typewriter';
///
///   @override
///   String apply(String value, double progress) {
///     if (value.isEmpty) return value;
///     final p = reverse ? (1.0 - progress) : progress;
///     final length = (value.length * p).round().clamp(0, value.length);
///     return value.substring(0, length);
///   }
/// }
/// ```
@immutable
abstract class AnimatedSpecDirective<T> extends SpecDirective<T> {
  const AnimatedSpecDirective();

  /// Applies the transformation with externally-provided progress (0.0 to 1.0).
  T apply(T value, double progress);

  /// Whether this directive can animate with [other].
  ///
  /// Subclasses can override to include additional state comparisons.
  @mustCallSuper
  bool isCompatibleWith(covariant AnimatedSpecDirective<T> other) =>
      runtimeType == other.runtimeType && key == other.key;
}

/// Internal wrapper to carry progress through spec lerping.
///
/// This is not part of the public API. It wraps an [AnimatedSpecDirective]
/// with a specific progress value so that [SpecDirectiveListExt.apply] can
/// apply the correct progress without external context.
final class _AnimatedWithProgress<T> extends AnimatedSpecDirective<T> {
  final AnimatedSpecDirective<T> _directive;
  final double _progress;

  const _AnimatedWithProgress(this._directive, this._progress);

  @override
  T apply(T value, double _) => _directive.apply(value, _progress);

  @override
  String get key => _directive.key;

  // Intentionally not calling super - we delegate to wrapped directive
  @override
  // ignore: must_call_super
  bool isCompatibleWith(covariant AnimatedSpecDirective<T> other) {
    final directive = other is _AnimatedWithProgress<T>
        ? other._directive
        : other;

    return _directive.isCompatibleWith(directive);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _AnimatedWithProgress<T> &&
          _directive == other._directive &&
          _progress == other._progress;

  @override
  int get hashCode => Object.hash(_directive, _progress);
}

// ═══════════════════════════════════════════════════════════════════════════
// EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════

/// Extension on [List<SpecDirective<T>>] to provide apply functionality.
extension SpecDirectiveListExt<T> on List<SpecDirective<T>> {
  /// Applies all directives in the list to the given value in sequence.
  T apply(T value) {
    var result = value;
    for (final directive in this) {
      result = switch (directive) {
        StaticSpecDirective<T>() => directive.apply(result),
        // For wrapped animated directives, progress is already captured
        _AnimatedWithProgress<T>() => directive.apply(result, 0),
        // For unwrapped animated directives, apply at full progress
        AnimatedSpecDirective<T>() => directive.apply(result, 1.0),
      };
    }

    return result;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TWEEN
// ═══════════════════════════════════════════════════════════════════════════

/// Tween for interpolating between [SpecDirective] lists.
///
/// This tween enables smooth animations of directive lists by:
/// - Interpolating progress for [AnimatedSpecDirective] instances
/// - Snapping instantly for [StaticSpecDirective] instances
///
/// Used internally by specs (e.g., [TextSpec]) to handle directive animation.
class SpecDirectiveListTween<T> extends Tween<List<SpecDirective<T>>?> {
  SpecDirectiveListTween({super.begin, super.end});

  @override
  List<SpecDirective<T>>? lerp(double t) {
    final a = begin;
    final b = end;

    if (a == null && b == null) return null;
    if (a == null) return _animateAppearing(b!, t);
    if (b == null) return _animateDisappearing(a, t);

    return _interpolateLists(a, b, t);
  }

  List<SpecDirective<T>> _animateAppearing(
    List<SpecDirective<T>> end,
    double t,
  ) {
    return end.map((d) => switch (d) {
      AnimatedSpecDirective<T>() => _AnimatedWithProgress(d, t),
      StaticSpecDirective<T>() => d,
    }).toList();
  }

  List<SpecDirective<T>> _animateDisappearing(
    List<SpecDirective<T>> begin,
    double t,
  ) {
    return begin.map((d) => switch (d) {
      AnimatedSpecDirective<T>() => _AnimatedWithProgress(d, 1.0 - t),
      StaticSpecDirective<T>() => d,
    }).toList();
  }

  List<SpecDirective<T>> _interpolateLists(
    List<SpecDirective<T>> a,
    List<SpecDirective<T>> b,
    double t,
  ) {
    final maxLength = math.max(a.length, b.length);
    final result = <SpecDirective<T>>[];

    for (var i = 0; i < maxLength; i++) {
      final da = i < a.length ? a[i] : null;
      final db = i < b.length ? b[i] : null;
      result.add(_lerpDirective(da, db, t));
    }

    return result;
  }

  SpecDirective<T> _lerpDirective(
    SpecDirective<T>? a,
    SpecDirective<T>? b,
    double t,
  ) {
    // At least one must be non-null (guaranteed by caller iterating over maxLength)
    assert(a != null || b != null, 'At least one directive must be non-null');

    return switch ((a, b)) {
      // Appearing
      (null, final AnimatedSpecDirective<T> b) => _AnimatedWithProgress(b, t),
      (null, final StaticSpecDirective<T> b) => b,

      // Disappearing
      (final AnimatedSpecDirective<T> a, null) =>
        _AnimatedWithProgress(a, 1.0 - t),
      (final StaticSpecDirective<T> a, null) => a,

      // Both animated & compatible: lerp progress
      (final AnimatedSpecDirective<T> a, final AnimatedSpecDirective<T> b)
          when a.isCompatibleWith(b) =>
        _AnimatedWithProgress(b, t),

      // Snap at 0.5 for incompatible or static (both non-null)
      (final a?, final b?) => t < 0.5 ? a : b,

      // Unreachable: (null, null) case - assertion above prevents this
      _ => throw StateError('Unreachable: both directives are null'),
    };
  }
}

import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'internal/internal_extensions.dart';

/// Base class for directives that apply transformations to values.
///
/// Directives provide a way to transform values like colors or strings in a consistent,
/// composable manner throughout the Mix framework.
@immutable
abstract class Directive<T> {
  const Directive();

  /// The unique identifier for this directive type.
  String get key;

  /// Applies the transformation to the given value.
  T apply(T value);
}

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
///
/// // In string transformations
/// Prop<String>.value("hello")
///   .directives([UppercaseStringDirective()]);
/// ```
///
/// PropDirectives are stored in `Prop.$directives` and applied during resolution,
/// before animation occurs. For directives that need to animate, use [SpecDirective].
@immutable
abstract class PropDirective<T> extends Directive<T> {
  const PropDirective();
}

/// Directive lerped during Spec animation.
///
/// SpecDirectives are used in Spec instances (like TextSpec) and participate in
/// animation by implementing [lerp] to interpolate between two directive states.
///
/// ## Basic Implementation
///
/// ```dart
/// class TypewriterDirective extends SpecDirective<String> {
///   final double progress;
///
///   const TypewriterDirective({this.progress = 0.0});
///
///   @override
///   String apply(String value) {
///     final length = (value.length * progress).round().clamp(0, value.length);
///     return value.substring(0, length);
///   }
///
///   @override
///   SpecDirective<String> lerp(SpecDirective<String>? other, double t) {
///     if (other is! TypewriterDirective) return this;
///     return TypewriterDirective(
///       progress: progress + (other.progress - progress) * t,
///     );
///   }
///
///   @override
///   String get key => 'typewriter';
/// }
/// ```
///
/// ## Animation Behavior
///
/// During `Spec.lerp()`, SpecDirective instances are matched by runtime type and [key].
/// When both specs contain matching SpecDirectives, [lerp] is called to interpolate
/// between them:
///
/// ```dart
/// final start = TextSpec(textDirectives: [TypewriterDirective(progress: 0.0)]);
/// final end = TextSpec(textDirectives: [TypewriterDirective(progress: 1.0)]);
///
/// // At t=0.5
/// final interpolated = start.lerp(end, 0.5);
/// // Result: TypewriterDirective(progress: 0.5)
/// ```
///
/// Non-matching directives snap to the nearest value (t < 0.5 uses first, otherwise second).
///
/// ## Implementation Requirements
///
/// Subclasses must:
/// - Override [key] to uniquely identify the directive type for lerp matching
/// - Override [apply] to transform values based on directive state
/// - Override [lerp] to interpolate with another directive of the same type
/// - Ensure [key] is consistent across instances for animation continuity
@immutable
abstract class SpecDirective<T> extends Directive<T> {
  const SpecDirective();

  /// Interpolates between this directive and [other] at time [t].
  ///
  /// This method mirrors the [Spec.lerp] pattern for consistency. When [other]
  /// is not the same type as this directive, implementations should snap to the
  /// nearest value (return this if t < 0.5, otherwise return other).
  ///
  /// The [t] parameter is typically in the range 0.0 to 1.0, where:
  /// - 0.0 returns this directive's state
  /// - 1.0 returns other's state
  /// - 0.5 returns halfway between
  ///
  /// Implementations should handle null [other] by returning this.
  SpecDirective<T> lerp(SpecDirective<T>? other, double t);
}

/// Extension on [List<Directive<T>>] to provide apply functionality
extension DirectiveListExt<T> on List<Directive<T>> {
  /// Applies all directives in the list to the given value in sequence
  T apply(T value) {
    var result = value;
    for (final directive in this) {
      result = directive.apply(result);
    }

    return result;
  }
}

/// Tween for interpolating between directive lists.
///
/// This tween enables smooth animations of directive lists by:
/// - Calling [SpecDirective.lerp] for matching SpecDirective pairs
/// - Snapping to nearest for PropDirectives or incompatible directives
///
/// Used internally by [MixOps.lerpDirectives] to handle [List<Directive<T>>] interpolation
/// while preserving generic type safety.
class DirectiveListTween<T> extends Tween<List<Directive<T>>?> {
  DirectiveListTween({super.begin, super.end});

  @override
  List<Directive<T>>? lerp(double t) {
    final a = begin;
    final b = end;

    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;

    final maxLength = a.length > b.length ? a.length : b.length;
    final result = <Directive<T>>[];

    for (var i = 0; i < maxLength; i++) {
      final directiveA = i < a.length ? a[i] : null;
      final directiveB = i < b.length ? b[i] : null;

      final directive = switch ((directiveA, directiveB)) {
        // One is null - use the non-null directive
        (null, final b?) => b,
        (final a?, null) => a,

        // Both are SpecDirectives with matching type and key - lerp them
        (final SpecDirective<T> a, final SpecDirective<T> b)
          when a.runtimeType == b.runtimeType && a.key == b.key => () {
            final lerped = a.lerp(b, t);

            // Fail-fast validation: verify return type consistency
            if (lerped.runtimeType != a.runtimeType) {
              throw FlutterError(
                'Mix: SpecDirective.lerp() type safety violation.\n'
                'Expected: ${a.runtimeType}\n'
                'Received: ${lerped.runtimeType}\n'
                'This is a bug in the ${a.runtimeType}.lerp() implementation.\n'
                'Directive key: ${a.key}\n'
                'The lerp() method must return an instance of the same type it was called on.',
              );
            }

            return lerped;
          }(),

        // Otherwise snap to nearest
        (final a?, final b?) => t < 0.5 ? a : b,

        // Both null - skip
        _ => null,
      };

      if (directive != null) result.add(directive);
    }

    return result;
  }
}



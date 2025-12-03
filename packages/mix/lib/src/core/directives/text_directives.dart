import 'package:flutter/widgets.dart';

import '../directive.dart';
import '../internal/internal_extensions.dart';

/// Base class for parameterless string transformation directives.
abstract class _StringTransformDirective extends PropDirective<String> {
  const _StringTransformDirective();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other.runtimeType == runtimeType;

  @override
  int get hashCode => key.hashCode;
}

/// Directive that capitalizes the first letter of a string.
final class CapitalizeStringDirective extends _StringTransformDirective {
  const CapitalizeStringDirective();

  @override
  String apply(String value) => value.capitalize;

  @override
  String get key => 'capitalize';
}

/// Directive that converts a string to uppercase.
final class UppercaseStringDirective extends _StringTransformDirective {
  const UppercaseStringDirective();

  @override
  String apply(String value) => value.toUpperCase();

  @override
  String get key => 'uppercase';
}

/// Directive that converts a string to lowercase.
final class LowercaseStringDirective extends _StringTransformDirective {
  const LowercaseStringDirective();

  @override
  String apply(String value) => value.toLowerCase();

  @override
  String get key => 'lowercase';
}

/// Directive that converts a string to title case.
final class TitleCaseStringDirective extends _StringTransformDirective {
  const TitleCaseStringDirective();

  @override
  String apply(String value) => value.titleCase;

  @override
  String get key => 'title_case';
}

/// Directive that converts a string to sentence case.
final class SentenceCaseStringDirective extends _StringTransformDirective {
  const SentenceCaseStringDirective();

  @override
  String apply(String value) => value.sentenceCase;

  @override
  String get key => 'sentence_case';
}

/// Directive that reveals text character by character as progress increases.
///
/// This SpecDirective creates a typewriter effect by progressively revealing
/// characters based on the progress value. During animations, the progress
/// is smoothly lerped between start and end values.
///
/// ## Example
///
/// ```dart
/// // Start hidden (progress: 0.0)
/// final hidden = TextSpec(
///   textDirectives: [TypewriterDirective(progress: 0.0)]
/// );
///
/// // End fully visible (progress: 1.0)
/// final visible = TextSpec(
///   textDirectives: [TypewriterDirective(progress: 1.0)]
/// );
///
/// // Animate between them
/// final style = TextStyler()
///   .textDirectives([TypewriterDirective(progress: 0.0)])
///   .animate(duration: Duration(seconds: 2));
///
/// // Switch to trigger animation
/// StyledText('Hello World', style: showText ? visible : hidden);
/// ```
///
/// Progress 0.0 shows no characters, progress 1.0 shows all characters.
final class TypewriterDirective extends SpecDirective<String> {
  final double progress;

  const TypewriterDirective({this.progress = 0.0});

  @override
  String apply(String value) {
    if (value.isEmpty) return value;

    // Always clamp progress to valid range for consistency
    final clampedProgress = progress.clamp(0.0, 1.0);

    // Debug-only warning for invalid input values
    assert(() {
      if (!progress.isFinite || progress < 0.0 || progress > 1.0) {
        debugPrint(
          'Mix: TypewriterDirective received invalid progress value: $progress. '
          'Progress must be between 0.0 and 1.0. Using clamped value: $clampedProgress.',
        );
      }
      return true;
    }());

    final length = (value.length * clampedProgress).round().clamp(0, value.length);
    return value.substring(0, length);
  }

  @override
  TypewriterDirective lerp(SpecDirective<String>? other, double t) {
    if (other is! TypewriterDirective) return this;
    return TypewriterDirective(
      progress: progress + (other.progress - progress) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypewriterDirective && progress == other.progress;

  @override
  int get hashCode => progress.hashCode;

  @override
  String get key => 'typewriter';
}

/// Directive that hides text character by character as progress increases.
///
/// This SpecDirective creates a reverse typewriter effect by progressively
/// hiding characters based on the progress value. During animations, the
/// progress is smoothly lerped between start and end values.
///
/// ## Example
///
/// ```dart
/// // Start fully visible (progress: 0.0)
/// final visible = TextSpec(
///   textDirectives: [ReverseTypewriterDirective(progress: 0.0)]
/// );
///
/// // End hidden (progress: 1.0)
/// final hidden = TextSpec(
///   textDirectives: [ReverseTypewriterDirective(progress: 1.0)]
/// );
///
/// // Animate between them
/// final style = TextStyler()
///   .textDirectives([ReverseTypewriterDirective(progress: 0.0)])
///   .animate(duration: Duration(seconds: 2));
///
/// // Switch to trigger animation
/// StyledText('Goodbye World', style: hideText ? hidden : visible);
/// ```
///
/// Progress 0.0 shows all characters, progress 1.0 shows no characters.
final class ReverseTypewriterDirective extends SpecDirective<String> {
  final double progress;

  const ReverseTypewriterDirective({this.progress = 0.0});

  @override
  String apply(String value) {
    if (value.isEmpty) return value;

    // Always clamp progress to valid range for consistency
    final clampedProgress = progress.clamp(0.0, 1.0);

    // Debug-only warning for invalid input values
    assert(() {
      if (!progress.isFinite || progress < 0.0 || progress > 1.0) {
        debugPrint(
          'Mix: ReverseTypewriterDirective received invalid progress value: $progress. '
          'Progress must be between 0.0 and 1.0. Using clamped value: $clampedProgress.',
        );
      }
      return true;
    }());

    final remainingLength =
        (value.length * (1.0 - clampedProgress)).round().clamp(0, value.length);
    return value.substring(0, remainingLength);
  }

  @override
  ReverseTypewriterDirective lerp(SpecDirective<String>? other, double t) {
    if (other is! ReverseTypewriterDirective) return this;
    return ReverseTypewriterDirective(
      progress: progress + (other.progress - progress) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReverseTypewriterDirective && progress == other.progress;

  @override
  int get hashCode => progress.hashCode;

  @override
  String get key => 'reverse_typewriter';
}

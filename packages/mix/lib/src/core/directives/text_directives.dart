import '../directive.dart';
import '../internal/internal_extensions.dart';

// ═══════════════════════════════════════════════════════════════════════════
// STATIC SPEC DIRECTIVES - Snap during animation
// ═══════════════════════════════════════════════════════════════════════════

/// Base class for parameterless string transformation directives.
abstract class _StringTransformDirective extends StaticSpecDirective<String> {
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

// ═══════════════════════════════════════════════════════════════════════════
// ANIMATED SPEC DIRECTIVES - Lerp during animation
// ═══════════════════════════════════════════════════════════════════════════

/// Directive that reveals or hides text character by character with animation.
///
/// The directive is stateless - progress is provided externally during animation.
/// When the directive appears, progress animates from 0.0 to 1.0.
/// When the directive disappears, progress animates from 1.0 to 0.0.
///
/// ## Example
///
/// ```dart
/// // In a TextSpec
/// TextSpec(
///   textDirectives: [TypewriterDirective()],
/// )
/// ```
final class TypewriterDirective extends AnimatedSpecDirective<String> {
  /// Whether to reverse the animation (hide instead of reveal).
  final bool reverse;

  const TypewriterDirective({this.reverse = false});

  @override
  String apply(String value, double progress) {
    if (value.isEmpty) return value;

    final clampedProgress = progress.clamp(0.0, 1.0);
    final effectiveProgress = reverse
        ? (1.0 - clampedProgress)
        : clampedProgress;

    final length = (value.length * effectiveProgress).round().clamp(
      0,
      value.length,
    );

    return value.substring(0, length);
  }

  @override
  bool isCompatibleWith(covariant TypewriterDirective other) {
    return super.isCompatibleWith(other) && reverse == other.reverse;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypewriterDirective && reverse == other.reverse;

  @override
  int get hashCode => reverse.hashCode;

  @override
  String get key => 'typewriter';
}

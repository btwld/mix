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

/// Directive that applies opacity to a color.
class OpacityColorDirective extends Directive<Color> {
  final double opacity;

  const OpacityColorDirective(this.opacity);

  @override
  Color apply(Color color) => color.withValues(alpha: opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpacityColorDirective && opacity == other.opacity;

  @override
  String get key => 'color_opacity';

  @override
  int get hashCode => opacity.hashCode;
}

/// Directive that applies withValues to a color.
class WithValuesColorDirective extends Directive<Color> {
  final double? alpha;
  final double? red;
  final double? green;
  final double? blue;
  final ColorSpace? colorSpace;

  const WithValuesColorDirective({
    this.alpha,
    this.red,
    this.green,
    this.blue,
    this.colorSpace,
  });

  @override
  Color apply(Color color) => color.withValues(
    alpha: alpha,
    red: red,
    green: green,
    blue: blue,
    colorSpace: colorSpace,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithValuesColorDirective &&
          alpha == other.alpha &&
          red == other.red &&
          green == other.green &&
          blue == other.blue &&
          colorSpace == other.colorSpace;

  @override
  String get key => 'color_with_values';

  @override
  int get hashCode =>
      alpha.hashCode ^
      red.hashCode ^
      green.hashCode ^
      blue.hashCode ^
      colorSpace.hashCode;
}

/// Directive that applies alpha to a color.
class AlphaColorDirective extends Directive<Color> {
  final int alpha;

  const AlphaColorDirective(this.alpha);

  @override
  Color apply(Color color) => color.withAlpha(alpha);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlphaColorDirective && alpha == other.alpha;

  @override
  String get key => 'color_alpha';

  @override
  int get hashCode => alpha.hashCode;
}

/// Directive that darkens a color.
class DarkenColorDirective extends Directive<Color> {
  final int amount;

  const DarkenColorDirective(this.amount);

  @override
  Color apply(Color color) => color.darken(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkenColorDirective && amount == other.amount;

  @override
  String get key => 'color_darken';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that lightens a color.
class LightenColorDirective extends Directive<Color> {
  final int amount;

  const LightenColorDirective(this.amount);

  @override
  Color apply(Color color) => color.lighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightenColorDirective && amount == other.amount;

  @override
  String get key => 'color_lighten';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that saturates a color.
class SaturateColorDirective extends Directive<Color> {
  final int amount;

  const SaturateColorDirective(this.amount);

  @override
  Color apply(Color color) => color.saturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaturateColorDirective && amount == other.amount;

  @override
  String get key => 'color_saturate';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that desaturates a color.
class DesaturateColorDirective extends Directive<Color> {
  final int amount;

  const DesaturateColorDirective(this.amount);

  @override
  Color apply(Color color) => color.desaturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesaturateColorDirective && amount == other.amount;

  @override
  String get key => 'color_desaturate';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that applies tint to a color.
class TintColorDirective extends Directive<Color> {
  final int amount;

  const TintColorDirective(this.amount);

  @override
  Color apply(Color color) => color.tint(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TintColorDirective && amount == other.amount;

  @override
  String get key => 'color_tint';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that applies shade to a color.
class ShadeColorDirective extends Directive<Color> {
  final int amount;

  const ShadeColorDirective(this.amount);

  @override
  Color apply(Color color) => color.shade(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadeColorDirective && amount == other.amount;

  @override
  String get key => 'color_shade';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that brightens a color.
class BrightenColorDirective extends Directive<Color> {
  final int amount;

  const BrightenColorDirective(this.amount);

  @override
  Color apply(Color color) => color.brighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrightenColorDirective && amount == other.amount;

  @override
  String get key => 'color_brighten';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that sets the red channel of a color.
class WithRedColorDirective extends Directive<Color> {
  final int red;

  const WithRedColorDirective(this.red);

  @override
  Color apply(Color color) => color.withRed(red);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithRedColorDirective && red == other.red;

  @override
  String get key => 'color_with_red';

  @override
  int get hashCode => red.hashCode;
}

/// Directive that sets the green channel of a color.
class WithGreenColorDirective extends Directive<Color> {
  final int green;

  const WithGreenColorDirective(this.green);

  @override
  Color apply(Color color) => color.withGreen(green);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithGreenColorDirective && green == other.green;

  @override
  String get key => 'color_with_green';

  @override
  int get hashCode => green.hashCode;
}

/// Directive that sets the blue channel of a color.
class WithBlueColorDirective extends Directive<Color> {
  final int blue;

  const WithBlueColorDirective(this.blue);

  @override
  Color apply(Color color) => color.withBlue(blue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithBlueColorDirective && blue == other.blue;

  @override
  String get key => 'color_with_blue';

  @override
  int get hashCode => blue.hashCode;
}

/// Directive that capitalizes the first letter of a string.
final class CapitalizeStringDirective extends Directive<String> {
  const CapitalizeStringDirective();
  @override
  String apply(String value) => value.capitalize;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CapitalizeStringDirective;
  @override
  String get key => 'capitalize';
  @override
  int get hashCode => key.hashCode;
}

/// Directive that converts a string to uppercase.
final class UppercaseStringDirective extends Directive<String> {
  const UppercaseStringDirective();
  @override
  String apply(String value) => value.toUpperCase();
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UppercaseStringDirective;
  @override
  String get key => 'uppercase';
  @override
  int get hashCode => key.hashCode;
}

/// Directive that converts a string to lowercase.
final class LowercaseStringDirective extends Directive<String> {
  const LowercaseStringDirective();
  @override
  String apply(String value) => value.toLowerCase();
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LowercaseStringDirective;
  @override
  String get key => 'lowercase';
  @override
  int get hashCode => key.hashCode;
}

/// Directive that converts a string to title case.
final class TitleCaseStringDirective extends Directive<String> {
  const TitleCaseStringDirective();
  @override
  String apply(String value) => value.titleCase;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TitleCaseStringDirective;
  @override
  String get key => 'title_case';
  @override
  int get hashCode => key.hashCode;
}

/// Directive that converts a string to sentence case.
final class SentenceCaseStringDirective extends Directive<String> {
  const SentenceCaseStringDirective();
  @override
  String apply(String value) => value.sentenceCase;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SentenceCaseStringDirective;
  @override
  String get key => 'sentence_case';
  @override
  int get hashCode => key.hashCode;
}

/// Base class for number directives that transform numeric values.
///
/// Number directives work with [num] type to support both [int] and [double]
/// values, allowing Dart's type system to handle coercion naturally.
abstract class NumberDirective extends Directive<num> {
  const NumberDirective();
}

/// Multiplies a numeric value by a factor.
///
/// Throws [ArgumentError] if [factor] is not finite.
///
/// Example:
/// ```dart
/// letterSpacing: Prop.value(0.0025).multiply(12.0) // = 0.03
/// ```
final class MultiplyNumberDirective extends NumberDirective {
  final num factor;

  MultiplyNumberDirective(this.factor) {
    if (!factor.isFinite) {
      throw ArgumentError.value(factor, 'factor', 'Must be finite');
    }
  }

  @override
  num apply(num value) => value * factor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiplyNumberDirective && factor == other.factor;

  @override
  String get key => 'number_multiply';

  @override
  int get hashCode => Object.hash(key, factor);
}

/// Adds a value to a numeric value.
///
/// Throws [ArgumentError] if [addend] is not finite.
final class AddNumberDirective extends NumberDirective {
  final num addend;

  AddNumberDirective(this.addend) {
    if (!addend.isFinite) {
      throw ArgumentError.value(addend, 'addend', 'Must be finite');
    }
  }

  @override
  num apply(num value) => value + addend;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddNumberDirective && addend == other.addend;

  @override
  String get key => 'number_add';

  @override
  int get hashCode => Object.hash(key, addend);
}

/// Subtracts a value from a numeric value.
///
/// Throws [ArgumentError] if [subtrahend] is not finite.
final class SubtractNumberDirective extends NumberDirective {
  final num subtrahend;

  SubtractNumberDirective(this.subtrahend) {
    if (!subtrahend.isFinite) {
      throw ArgumentError.value(subtrahend, 'subtrahend', 'Must be finite');
    }
  }

  @override
  num apply(num value) => value - subtrahend;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubtractNumberDirective && subtrahend == other.subtrahend;

  @override
  String get key => 'number_subtract';

  @override
  int get hashCode => Object.hash(key, subtrahend);
}

/// Divides a numeric value by a divisor.
///
/// Throws [ArgumentError] if [divisor] is zero or not finite.
///
/// Note: Division in Dart always returns a double, even for int/int division.
final class DivideNumberDirective extends NumberDirective {
  final num divisor;

  DivideNumberDirective(this.divisor) {
    if (divisor == 0) {
      throw ArgumentError.value(divisor, 'divisor', 'Cannot divide by zero');
    }
    if (!divisor.isFinite) {
      throw ArgumentError.value(divisor, 'divisor', 'Must be finite');
    }
  }

  @override
  num apply(num value) {
    return value / divisor;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DivideNumberDirective && divisor == other.divisor;

  @override
  String get key => 'number_divide';

  @override
  int get hashCode => Object.hash(key, divisor);
}

/// Clamps a numeric value between min and max bounds.
///
/// Throws [ArgumentError] if [min] or [max] is not finite,
/// or if [min] is greater than [max].
///
/// Inspired by CSS `clamp()` function.
final class ClampNumberDirective extends NumberDirective {
  final num min;
  final num max;

  ClampNumberDirective(this.min, this.max) {
    if (!min.isFinite) {
      throw ArgumentError.value(min, 'min', 'Must be finite');
    }
    if (!max.isFinite) {
      throw ArgumentError.value(max, 'max', 'Must be finite');
    }
    if (min > max) {
      throw ArgumentError(
        'min ($min) must be less than or equal to max ($max)',
      );
    }
  }

  @override
  num apply(num value) => value.clamp(min, max);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClampNumberDirective && min == other.min && max == other.max;

  @override
  String get key => 'number_clamp';

  @override
  int get hashCode => Object.hash(key, min, max);
}

/// Returns the absolute value of a numeric value.
///
/// Inspired by CSS `abs()` function.
final class AbsNumberDirective extends NumberDirective {
  const AbsNumberDirective();

  @override
  num apply(num value) => value.abs();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AbsNumberDirective;

  @override
  String get key => 'number_abs';

  @override
  int get hashCode => key.hashCode;
}

/// Rounds a numeric value to the nearest integer (as double).
///
/// Uses round-half-away-from-zero rounding (e.g., 2.5 → 3.0, -2.5 → -3.0).
///
/// Inspired by CSS `round()` function.
final class RoundNumberDirective extends NumberDirective {
  const RoundNumberDirective();

  @override
  num apply(num value) => value.roundToDouble();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RoundNumberDirective;

  @override
  String get key => 'number_round';

  @override
  int get hashCode => key.hashCode;
}

/// Floors a numeric value (rounds down).
final class FloorNumberDirective extends NumberDirective {
  const FloorNumberDirective();

  @override
  num apply(num value) => value.floorToDouble();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FloorNumberDirective;

  @override
  String get key => 'number_floor';

  @override
  int get hashCode => key.hashCode;
}

/// Ceils a numeric value (rounds up).
final class CeilNumberDirective extends NumberDirective {
  const CeilNumberDirective();

  @override
  num apply(num value) => value.ceilToDouble();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CeilNumberDirective;

  @override
  String get key => 'number_ceil';

  @override
  int get hashCode => key.hashCode;
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

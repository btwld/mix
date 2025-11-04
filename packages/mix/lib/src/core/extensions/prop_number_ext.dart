import '../../theme/tokens/mix_token.dart';
import '../directive.dart';
import '../prop.dart';
import '../prop_source.dart';

/// Extension on [Prop] for number transformations.
///
/// This extension works on [Prop<num>], [Prop<double>], and [Prop<int>]
/// since both double and int are subtypes of num.
///
/// Provides methods for applying numeric directives inspired by CSS math
/// functions like `calc()`, `clamp()`, etc.
///
/// Note: These methods return [Prop<num>] to handle Dart's type system
/// constraints, as numeric operations can change types (e.g., int * double = double).
///
/// Example:
/// ```dart
/// // Proportional typography scaling
/// letterSpacing: Prop.value(0.0025).multiply(12.0)
///
/// // With token reference
/// fontSize: Prop.token($baseFontSize).multiply(1.5).clamp(16, 32)
///
/// // Directive chaining
/// value: Prop.value(10.0).multiply(2).add(5).clamp(0, 20)
/// ```
extension NumberPropDirectiveExt<T extends num> on Prop<T> {
  /// Multiplies the resolved value by [factor].
  ///
  /// Example:
  /// ```dart
  /// letterSpacing: Prop.value(0.0025).multiply(12.0) // = 0.03
  /// ```
  Prop<num> multiply(num factor) {
    return _applyNumberDirective(MultiplyNumberDirective(factor));
  }

  /// Adds [addend] to the resolved value.
  ///
  /// Example:
  /// ```dart
  /// padding: Prop.token($baseSpacing).add(4.0)
  /// ```
  Prop<num> add(num addend) {
    return _applyNumberDirective(AddNumberDirective(addend));
  }

  /// Subtracts [subtrahend] from the resolved value.
  ///
  /// Example:
  /// ```dart
  /// margin: Prop.value(20.0).subtract(5.0) // = 15.0
  /// ```
  Prop<num> subtract(num subtrahend) {
    return _applyNumberDirective(SubtractNumberDirective(subtrahend));
  }

  /// Divides the resolved value by [divisor].
  ///
  /// Note: Division always returns a double in Dart.
  ///
  /// Example:
  /// ```dart
  /// halfSize: Prop.token($size).divide(2)
  /// ```
  Prop<num> divide(num divisor) {
    return _applyNumberDirective(DivideNumberDirective(divisor));
  }

  /// Clamps the resolved value between [min] and [max].
  ///
  /// Inspired by CSS `clamp()` function.
  ///
  /// Example:
  /// ```dart
  /// fontSize: Prop.token($dynamicSize).clamp(12, 24)
  /// ```
  Prop<num> clamp(num min, num max) {
    return _applyNumberDirective(ClampNumberDirective(min, max));
  }

  /// Returns the absolute value.
  ///
  /// Inspired by CSS `abs()` function.
  ///
  /// Example:
  /// ```dart
  /// offset: Prop.value(-10.0).abs() // = 10.0
  /// ```
  Prop<num> abs() {
    return _applyNumberDirective(const AbsNumberDirective());
  }

  /// Rounds to the nearest integer (returns double).
  ///
  /// Inspired by CSS `round()` function.
  ///
  /// Example:
  /// ```dart
  /// size: Prop.value(15.7).round() // = 16.0
  /// ```
  Prop<num> round() {
    return _applyNumberDirective(const RoundNumberDirective());
  }

  /// Floors the value (rounds down).
  ///
  /// Example:
  /// ```dart
  /// size: Prop.value(15.7).floor() // = 15.0
  /// ```
  Prop<num> floor() {
    return _applyNumberDirective(const FloorNumberDirective());
  }

  /// Ceils the value (rounds up).
  ///
  /// Example:
  /// ```dart
  /// size: Prop.value(15.3).ceil() // = 16.0
  /// ```
  Prop<num> ceil() {
    return _applyNumberDirective(const CeilNumberDirective());
  }

  /// Alias for [multiply] - scales the value by [ratio].
  ///
  /// Example:
  /// ```dart
  /// fontSize: Prop.token($base).scale(1.5)
  /// ```
  Prop<num> scale(num ratio) => multiply(ratio);

  /// Helper method to apply a number directive.
  ///
  /// Converts this Prop<T> to Prop<num> and applies the directive.
  Prop<num> _applyNumberDirective(Directive<num> directive) {
    return _asPropNum().directives([directive]);
  }

  /// Converts this Prop<T extends num> to Prop<num>.
  ///
  /// Required to work around Dart's type invariance - we can't directly apply
  /// Directive<num> to Prop<T> even though T extends num.
  Prop<num> _asPropNum() {
    // Edge case: prop with only directives (no sources)
    if (sources.isEmpty) {
      return Prop.directives([]);
    }

    // Fail fast on unsupported multiple sources
    if (sources.length > 1) {
      throw UnimplementedError(
        'Multiple sources not yet supported for number directives. '
        'This is a rare case - please report if you need this.',
      );
    }

    // Reconstruct single source as Prop<num>
    final source = sources.first;
    final Prop<num> base = source is ValueSource<T>
        ? Prop.value<num>((source).value)
        : source is TokenSource<T>
        ? Prop.token((source).token as MixToken<num>)
        : throw UnimplementedError(
            'Source type ${source.runtimeType} not supported',
          );

    // Preserve existing directives for chaining (e.g., multiply().add().round())
    return ($directives == null || $directives!.isEmpty)
        ? base
        : base.mergeProp(Prop.directives($directives!.cast()));
  }
}

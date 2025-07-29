import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/mix_theme.dart';

/// A collection of extension methods for the `String` class and `List<String>` class.
/// These methods provide various string manipulation functionalities such as converting
/// between different case styles (camel case, pascal case, snake case, etc.), capitalizing
/// words, and extracting words from a string.
///
/// The `StringExt` extension provides methods for manipulating individual strings,
/// while the `ListStringExt` extension provides methods for manipulating lists of strings.
///
/// Example usage:
/// ```dart
/// import 'package:mix/helpers/string_ext.dart';
///
/// void main() {
///   String myString = 'hello_world';
///   print(myString.camelCase); // Output: helloWorld
///
///   List<String> myStringList = ['hello', 'world'];
///   print(myStringList.uppercase); // Output: ['HELLO', 'WORLD']
/// }
/// ```
const _snakeCaseSeparator = '_';
const _paramCaseSeparator = '-';
const _spaceSeparator = ' ';

final _upperAlphaRegex = RegExp(r'[_-\sA-Z]');

final _symbolSet = {_snakeCaseSeparator, _paramCaseSeparator, _spaceSeparator};

/// Extension on [String] to provide various string manipulation operations.
extension StringExt on String {
  /// Splits the string into a list of words.
  List<String> get words {
    final sb = StringBuffer();
    final words = <String>[];
    final isAllCaps = toUpperCase() == this;

    for (int i = 0; i < length; i++) {
      final char = this[i];
      final nextChar = i + 1 == length ? null : this[i + 1];

      if (_symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      final isEndOfWord =
          nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          _symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  /// Checks if the string is in all uppercase.
  bool get isUpperCase => toUpperCase() == this;

  /// Checks if the string is in all lowercase.
  bool get isLowerCase => toLowerCase() == this;

  /// Converts the string to camel case.
  String get camelCase {
    final wordList = words.map((word) => word.capitalize).toList();
    if (wordList.isNotEmpty) {
      wordList[0] = wordList.first.toLowerCase();
    }

    return wordList.join();
  }

  /// Converts the string to pascal case.
  String get pascalCase => words.map((word) => word.capitalize).join();

  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (isEmpty) return this;
    final firstRune = runes.first;
    final restRunes = runes.skip(1);

    return String.fromCharCode(firstRune).toUpperCase() +
        restRunes.map((rune) => String.fromCharCode(rune).toLowerCase()).join();
  }

  /// Converts the string to constant case.
  String get constantCase => words.uppercase.join(_snakeCaseSeparator);

  /// Converts the string to snake case.
  String get snakeCase => words.lowercase.join(_snakeCaseSeparator);

  /// Converts the string to param case.
  String get paramCase => words.lowercase.join(_paramCaseSeparator);

  /// Converts the string to title case.
  String get titleCase =>
      words.map((word) => word.capitalize).join(_spaceSeparator);

  /// Converts the string to sentence case.
  String get sentenceCase {
    final wordList = [...words];
    if (wordList.isEmpty) return this;

    wordList[0] = wordList.first.capitalize;

    return wordList.join(_spaceSeparator);
  }
}

extension DoubleExt on double {
  Radius toRadius() => Radius.circular(this);
}

extension Matrix4Ext on Matrix4 {
  /// Merge [other] into this matrix.
  Matrix4 merge(Matrix4? other) {
    if (other == null || other == this) return this;

    return clone()..multiply(other);
  }
}

/// Extension on [List<String>] to provide additional string manipulation methods.
extension ListStringExt on List<String> {
  /// Converts all strings in the list to lowercase.
  List<String> get lowercase => map((e) => e.toLowerCase()).toList();

  /// Converts all strings in the list to uppercase.
  List<String> get uppercase => map((e) => e.toUpperCase()).toList();
}

// @nodoc
extension IterableExt<T> on Iterable<T> {
  T? get firstMaybeNull => isEmpty ? null : first;

  T? firstWhereOrNull(bool Function(T element) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }

    return null;
  }

  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;

    return elementAt(index);
  }

  Iterable<T> sorted([Comparator<T>? compare]) {
    List<T> newList = List.of(this);
    newList.sort(compare);

    return newList;
  }
}

extension ListExt<T> on List<T> {
  List<T> merge(List<T>? other) {
    if (other == null) return this;
    if (isEmpty) return other;

    return List.generate(math.max(length, other.length), (index) {
      if (index < length) {
        final currentValue = this[index];
        final otherValue = index < other.length ? other[index] : null;

        return otherValue ?? currentValue;
      }

      return other[index];
    });
  }
}

/// Extensions for color transformations in Flutter, using HSL for perceptual accuracy.
extension ColorExtensions on Color {
  /// Lightens the color by increasing lightness in HSL space by [amount] percent.
  Color lighten([int amount = 10]) {
    final p = _normalizeAmount(amount);
    final hsl = HSLColor.fromColor(this);

    return hsl.withLightness(_clamp(hsl.lightness + p)).toColor();
  }

  /// Brightens the color perceptually by increasing lightness and slightly boosting saturation in HSL space.
  /// This avoids the washing-out effect of pure RGB addition.
  Color brighten([int amount = 10]) {
    final p = _normalizeAmount(amount);
    final hsl = HSLColor.fromColor(this);
    final newLightness = _clamp(
      hsl.lightness + p * 0.8,
    ); // Softer increase to prevent clipping
    final newSaturation = _clamp(
      hsl.saturation + p * 0.2,
    ); // Boost saturation for vibrancy

    return hsl
        .withLightness(newLightness)
        .withSaturation(newSaturation)
        .toColor();
  }

  /// Darkens the color by decreasing lightness in HSL space by [amount] percent.
  Color darken([int amount = 10]) {
    final p = _normalizeAmount(amount);
    final hsl = HSLColor.fromColor(this);

    return hsl.withLightness(_clamp(hsl.lightness - p)).toColor();
  }

  /// Tints the color by mixing with white by [amount] percent.
  Color tint([int amount = 10]) {
    final p = _normalizeAmount(amount);
    return Color.lerp(this, Colors.white, p)!;
  }

  /// Shades the color by mixing with black by [amount] percent.
  Color shade([int amount = 10]) {
    final p = _normalizeAmount(amount);
    return Color.lerp(this, Colors.black, p)!;
  }

  /// Desaturates the color by decreasing saturation in HSL space by [amount] percent.
  Color desaturate([int amount = 10]) {
    final p = _normalizeAmount(amount);
    final hsl = HSLColor.fromColor(this);

    return hsl.withSaturation(_clamp(hsl.saturation - p)).toColor();
  }

  /// Saturates the color by increasing saturation in HSL space by [amount] percent.
  Color saturate([int amount = 10]) {
    final p = _normalizeAmount(amount);
    final hsl = HSLColor.fromColor(this);

    return hsl.withSaturation(_clamp(hsl.saturation + p)).toColor();
  }

  /// Converts the color to grayscale by fully desaturating it.
  Color grayscale() => desaturate(100);

  /// Returns the complementary color by rotating hue by 180 degrees in HSL space.
  Color complement() {
    final hsl = HSLColor.fromColor(this);
    final hue = (hsl.hue + 180) % 360;

    return hsl.withHue(hue).toColor();
  }

  double _normalizeAmount(int amount) {
    return RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100.0;
  }
}

/// Clamps a value between 0.0 and 1.0.
double _clamp(double val) => math.min(1.0, math.max(0.0, val));

extension BuildContextExt on BuildContext {
  /// MEDIA QUERY EXTENSION METHODS

  /// Directionality of context.
  TextDirection get directionality => Directionality.of(this);

  /// Orientation of the device.

  Orientation get orientation => MediaQuery.of(this).orientation;

  /// Screen size.

  Size get screenSize => MediaQuery.of(this).size;

  // Theme Context Extensions.
  Brightness get brightness => Theme.of(this).brightness;

  /// Theme context helpers.
  ThemeData get theme => Theme.of(this);

  /// Theme color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Theme text theme.
  TextTheme get textTheme => theme.textTheme;

  /// Mix Theme Data.
  MixScopeData get mixTheme => MixScope.of(this);

  /// Check if brightness is Brightness.dark.
  bool get isDarkMode => brightness == Brightness.dark;

  /// Is device in landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Is device in portrait mode.
  bool get isPortrait => orientation == Orientation.portrait;
}

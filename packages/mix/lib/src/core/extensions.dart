import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/mix/mix_theme.dart';

// Color Extensions
extension ColorExtensions on Color {
  /// Mixes this color with [toColor] by [amount] percent (0-100).
  Color mix(Color toColor, [int amount = 50]) {
    final p = _normalizeAmount(amount);
    
    return Color.lerp(this, toColor, p)!;
  }

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
  Color tint([int amount = 10]) => mix(Colors.white, amount);

  /// Shades the color by mixing with black by [amount] percent.
  Color shade([int amount = 10]) => mix(Colors.black, amount);

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
  
  Color inverseDarken([int amount = 10]) {
    return computeLuminance() > 0.5 ? darken(amount) : lighten(amount);
  }

  Color inverseLighten([int amount = 10]) {
    return computeLuminance() > 0.5 ? lighten(amount) : darken(amount);
  }

  double _normalizeAmount(int amount) {
    return RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100.0;
  }
}

// Widget State Extensions
extension MixWidgetStatesExt on WidgetStatesController {
  void updateAll(Set<WidgetState> states, bool isAdding) {
    for (final state in states) {
      update(state, isAdding);
    }
  }
}

// Duration Extensions
extension MixDurationInt on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get milliseconds => ms;
  Duration get s => Duration(seconds: this);
  Duration get seconds => s;
  Duration get m => Duration(minutes: this);
  Duration get minutes => m;
  Duration get h => Duration(hours: this);
  Duration get hours => h;
  Duration get d => Duration(days: this);
  Duration get days => d;
}

// BuildContext Extensions
extension BuildContextExt on BuildContext {
  // Navigation Extensions
  bool canPop() => Navigator.of(this).canPop();
  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();
  NavigatorState navigator() => Navigator.of(this);
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  
  Future<T?> push<T>(Route<T> route) {
    return Navigator.of(this).push(route);
  }
  
  Future<T?> pushNamed<T>(String name, {Object? arguments}) {
    return Navigator.of(this).pushNamed(name, arguments: arguments);
  }
  
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) {
    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
  
  // Media Query Extensions
  TextDirection get directionality => Directionality.of(this);
  Orientation get orientation => MediaQuery.of(this).orientation;
  Size get screenSize => MediaQuery.of(this).size;
  
  // Theme Extensions
  Brightness get brightness => Theme.of(this).brightness;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  // Mix Theme Extension
  MixScopeData get mixTheme => MixScope.of(this);
  
  // Convenience Properties
  bool get isDarkMode => brightness == Brightness.dark;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;
}

// Diagnostic Extensions
extension DiagnosticPropertiesBuilderExt on DiagnosticPropertiesBuilder {
  void addUnsupportedProperty({String name = '<unsupported>'}) {
    add(MessageProperty(name, '<unsupported>'));
  }
  
  void addUsingDefault<T>(String name, T value, {bool expandableValue = false}) {
    add(DiagnosticsProperty(
      name,
      value,
      defaultValue: null,
      expandableValue: expandableValue,
    ));
  }
}

// Iterable Extensions
extension IterableExt<T> on Iterable<T> {
  T? get firstMaybeNull => isEmpty ? null : first;
  
  Iterable<T> separated(T separator) sync* {
    final iter = iterator;
    if (!iter.moveNext()) return;
    yield iter.current;
    while (iter.moveNext()) {
      yield separator;
      yield iter.current;
    }
  }

  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keyExtractor) {
    final list = toList();
    list.sort((a, b) => keyExtractor(a).compareTo(keyExtractor(b)));
    
    return list;
  }
  
  Iterable<T> sorted([Comparator<T>? compare]) {
    List<T> newList = List.of(this);
    newList.sort(compare);
    
    return newList;
  }

  List<T> distinctBy<K>(K Function(T) keyExtractor) {
    final seen = <K>{};
    
    return where((item) => seen.add(keyExtractor(item))).toList();
  }

  Map<K, List<T>> groupBy<K>(K Function(T) keyExtractor) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keyExtractor(item);
      (map[key] ??= []).add(item);
    }
    
    return map;
  }

  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    
    return null;
  }

  T? lastWhereOrNull(bool Function(T) test) {
    T? result;
    for (final item in this) {
      if (test(item)) result = item;
    }
    
    return result;
  }

  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    
    return elementAt(index);
  }

  Iterable<T> takeUntil(bool Function(T) test) sync* {
    for (final item in this) {
      yield item;
      if (test(item)) break;
    }
  }

  Iterable<T> whereNotNull() {
    return where((item) => item != null);
  }
}

// List Extensions
extension ListExt<T> on List<T> {
  List<T> maybeSorted([int Function(T, T)? compare]) {
    if (compare == null) return this;
    
    return [...this]..sort(compare);
  }

  void replace(int start, int end, T replacement) {
    removeRange(start, end);
    insert(start, replacement);
  }
  
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

// String Extensions Constants
const _snakeCaseSeparator = '_';
const _paramCaseSeparator = '-';
const _spaceSeparator = ' ';

final _upperAlphaRegex = RegExp(r'[_-\sA-Z]');

final _symbolSet = {
  _snakeCaseSeparator,
  _paramCaseSeparator,
  _spaceSeparator,
};

// String Extensions
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

      final isEndOfWord = nextChar == null ||
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
  
  // Legacy methods for compatibility
  String toCamelCase() => camelCase;
  String toSnakeCase() => snakeCase;
  String toKebabCase() => paramCase;
  String toPascalCase() => pascalCase;
  bool isSnakeCase() => snakeCase == this;
  bool isCamelCase() => camelCase == this;
  bool isPascalCase() => pascalCase == this;
  bool isKebabCase() => paramCase == this;
}

// List<String> Extensions
extension ListStringExt on List<String> {
  /// Converts all strings in the list to lowercase.
  List<String> get lowercase => map((e) => e.toLowerCase()).toList();

  /// Converts all strings in the list to uppercase.
  List<String> get uppercase => map((e) => e.toUpperCase()).toList();
  
  // Legacy methods for compatibility
  List<String> toCamelCase() {
    return map((e) => e.toCamelCase()).toList();
  }
  
  List<String> toSnakeCase() {
    return map((e) => e.toSnakeCase()).toList();
  }
  
  List<String> toKebabCase() {
    return map((e) => e.toKebabCase()).toList();
  }
  
  List<String> toPascalCase() {
    return map((e) => e.toPascalCase()).toList();
  }
  
  List<String> capitalize() {
    return map((e) => e.capitalize).toList();
  }
}

// Numeric Extensions
extension DoubleExt on double {
  Radius get radius {
    return Radius.circular(this);
  }
}

// Matrix4 Extensions
extension Matrix4Ext on Matrix4 {
  Matrix4 merge(Matrix4? other) {
    if (other == null || other == Matrix4.identity()) return this;
    if (this == Matrix4.identity()) return other;
    
    return clone()..multiply(other);
  }
}


// Widget State Set Extension
extension WidgetStateSetExt on Set<WidgetState> {
  Map<WidgetState, bool> toMap() {
    return Map.fromEntries(
      WidgetState.values.map((state) => MapEntry(state, contains(state))),
    );
  }
  
  bool get hasDisabled => contains(WidgetState.disabled);
  bool get hasHovered => contains(WidgetState.hovered);
  bool get hasFocused => contains(WidgetState.focused);
  bool get hasPressed => contains(WidgetState.pressed);
  bool get hasDragged => contains(WidgetState.dragged);
  bool get hasSelected => contains(WidgetState.selected);
  bool get hasError => contains(WidgetState.error);
}

// Helper function for color operations
double _clamp(double val) => math.min(1.0, math.max(0.0, val));
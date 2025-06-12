// ignore_for_file: avoid-object-hashcode

import 'package:flutter/material.dart';

import '../mix/mix_theme.dart';
import 'color_token.dart';
import 'mix_token.dart';
import 'radius_token.dart';
import 'space_token.dart';
import 'text_style_token.dart';

/// A generic token that represents a value of type [T] in the Mix theme system.
///
/// This class serves as a unified token system, replacing the need for separate
/// token classes for each type (ColorToken, SpaceToken, etc).
///
/// Example:
/// ```dart
/// const primaryColor = Token<Color>('primary');
/// const largePadding = Token<double>('large-padding');
/// ```
@immutable
class Token<T> extends MixToken<T> with MixTokenCallable<T> {
  /// Creates a token with the given [name].
  const Token(super.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Token<T> && other.name == name);

  @override
  String toString() => 'Token<$T>($name)';

  /// Resolves the token value based on the current [BuildContext].
  ///
  /// This method provides backwards compatibility with the old token system.
  @override
  T resolve(BuildContext context) {
    // Type-specific resolution logic
    if (T == Color) {
      final colorToken = ColorToken(name);
      final themeValue = MixTheme.of(context).colors[colorToken];
      assert(
        themeValue != null,
        'Token<Color> $name is not defined in the theme',
      );

      final resolved = themeValue is ColorResolver
          ? themeValue.resolve(context)
          : (themeValue ?? Colors.transparent);

      return resolved as T;
    } else if (T == double) {
      // For SpaceToken compatibility
      final spaceToken = SpaceToken(name);
      final themeValue = MixTheme.of(context).spaces[spaceToken];
      assert(
        themeValue != null,
        'Token<double> $name is not defined in the theme',
      );

      return (themeValue ?? 0.0) as T;
    } else if (T == Radius) {
      final radiusToken = RadiusToken(name);
      final themeValue = MixTheme.of(context).radii[radiusToken];
      assert(
        themeValue != null,
        'Token<Radius> $name is not defined in the theme',
      );

      final resolved = themeValue is RadiusResolver
          ? themeValue.resolve(context)
          : (themeValue ?? const Radius.circular(0));

      return resolved as T;
    } else if (T == TextStyle) {
      final textStyleToken = TextStyleToken(name);
      final themeValue = MixTheme.of(context).textStyles[textStyleToken];
      assert(
        themeValue != null,
        'Token<TextStyle> $name is not defined in the theme',
      );

      final resolved = themeValue is TextStyleResolver
          ? themeValue.resolve(context)
          : (themeValue ?? const TextStyle());

      return resolved as T;
    }

    throw UnsupportedError('Token type $T is not supported');
  }

  /// Creates a reference value for this token.
  ///
  /// This method provides backwards compatibility with the old token system
  /// where tokens could be called to create references.
  @override
  T call() {
    if (T == Color) {
      return ColorRef(ColorToken(name)) as T;
    } else if (T == double) {
      // SpaceToken hack: returns negative hashcode
      return (hashCode * -1.0) as T;
    } else if (T == Radius) {
      return RadiusRef(RadiusToken(name)) as T;
    } else if (T == TextStyle) {
      return TextStyleRef(TextStyleToken(name)) as T;
    }

    throw UnsupportedError('Token type $T does not support call()');
  }

  @override
  int get hashCode => Object.hash(name, T);
}

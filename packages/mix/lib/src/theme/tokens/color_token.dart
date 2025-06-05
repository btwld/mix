import 'package:flutter/material.dart';

import '../mix/mix_theme.dart';
import 'mix_token.dart';

/// A token representing a color value in the Mix theme.
///
/// The color value can be resolved statically or dynamically.
///
/// To resolve the color value statically, pass a [Color] value to the constructor.
@immutable
class ColorToken extends MixToken<Color> with MixTokenCallable<Color> {
  const ColorToken(super.name);

  /// Calls the [ColorToken] to create a [ColorRef] instance.
  @override
  ColorRef call() => ColorRef(this);

  /// Resolves the color value based on the current [BuildContext].
  ///
  /// If the color value is not defined in the theme, an assertion error is thrown.
  /// If the color value is a [ColorResolver], it is resolved dynamically using the [BuildContext].
  /// If the color value is null, [Colors.transparent] is returned.
  @override
  Color resolve(BuildContext context) {
    final themeValue = MixTheme.of(context).colors[this];

    assert(
      themeValue != null,
      'ColorToken $name is not defined in the theme',
    );

    return themeValue is ColorResolver
        ? themeValue.resolve(context)
        : (themeValue ?? Colors.transparent);
  }
}

@immutable
class ColorTokenOfSwatch<T> extends ColorToken {
  final T index;

  @visibleForTesting
  final ColorSwatchToken<T> swatchToken;

  const ColorTokenOfSwatch(super.name, this.swatchToken, this.index);

  @override
  ColorRef call() => ColorRef(this);

  @override
  Color resolve(BuildContext context) {
    final colorSwatch = MixTheme.of(context).colors[swatchToken];
    assert(
      colorSwatch != null,
      'ColorSwatchToken $name is not defined in the theme',
    );

    assert(
      colorSwatch is ColorSwatch<T>,
      'ColorSwatchToken $name is not of type ColorSwatch<$T>',
    );

    return (colorSwatch as ColorSwatch<T>)[index]!;
  }
}

@immutable
class ColorSwatchToken<T> extends ColorToken {
  final Map<T, String> swatch;
  const ColorSwatchToken(super.name, this.swatch);

  static ColorSwatchToken<int> scale(
    String name,
    int steps, {
    String separator = '-',
  }) {
    return ColorSwatchToken(name, {
      for (var i = 1; i <= steps; i++) i: '$name$separator$i',
    });
  }

  operator [](T index) {
    final colorName = swatch[index];
    assert(
      colorName != null,
      'ColorSwatchToken $name does not have a value for index $index',
    );

    return ColorTokenOfSwatch(colorName!, this, index);
  }

  @override
  ColorSwatch<T> resolve(BuildContext context) {
    final themeValue = MixTheme.of(context).colors[this];
    assert(
      themeValue != null,
      'ColorSwatchToken $name is not defined in the theme',
    );

    return themeValue as ColorSwatch<T>;
  }
}

/// {@template mix.token.resolver}
/// A resolver that allows dynamic resolution of a token value.
///
/// This is useful when the token value is dependent on the current [BuildContext],
/// and cannot be resolved statically.
///
/// For more information, see [Dynamic Themes](https://www.fluttermix.com/docs/guides/design-token#dynamic-themes).
/// {@endtemplate}
class ColorResolver extends Color with WithTokenResolver<Color> {
  /// The function used to resolve the color value dynamically.
  @override
  final BuildContextResolver<Color> resolve;

  /// {@macro mix.token.resolver}
  const ColorResolver(this.resolve) : super(0);
}

/// A reference to a color token.
///
/// This is used to reference a color token in a theme, and is used to resolve the color value.
/// Allows pass a [ColorToken] as a [Color] value.
class ColorRef extends Color with TokenRef<ColorToken> {
  /// The token associated with the color reference.
  @override
  final ColorToken token;

  const ColorRef(this.token) : super(0);

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColorRef && other.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}

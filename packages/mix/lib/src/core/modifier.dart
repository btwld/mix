import 'package:flutter/widgets.dart';

import 'internal/internal_extensions.dart';

/// Base class for modifiers that apply transformations to values.
///
/// Modifiers provide a way to modify values like colors or strings in a consistent,
/// composable manner throughout the Mix framework.
@immutable
abstract class Modifier<T> {
  const Modifier();

  /// The unique identifier for this modifier type.
  String get key;

  /// Applies the transformation to the given value.
  T apply(T value);
}

/// Modifier that applies opacity to a color.
class OpacityColorModifier extends Modifier<Color> {
  final double opacity;

  const OpacityColorModifier(this.opacity);

  @override
  Color apply(Color color) => color.withValues(alpha: opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpacityColorModifier && opacity == other.opacity;

  @override
  String get key => 'color_opacity';

  @override
  int get hashCode => opacity.hashCode;
}

/// Modifier that applies alpha to a color.
class AlphaColorModifier extends Modifier<Color> {
  final int alpha;

  const AlphaColorModifier(this.alpha);

  @override
  Color apply(Color color) => color.withAlpha(alpha);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlphaColorModifier && alpha == other.alpha;

  @override
  String get key => 'color_alpha';

  @override
  int get hashCode => alpha.hashCode;
}

/// Modifier that darkens a color.
class DarkenColorModifier extends Modifier<Color> {
  final int amount;

  const DarkenColorModifier(this.amount);

  @override
  Color apply(Color color) => color.darken(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkenColorModifier && amount == other.amount;

  @override
  String get key => 'color_darken';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that lightens a color.
class LightenColorModifier extends Modifier<Color> {
  final int amount;

  const LightenColorModifier(this.amount);

  @override
  Color apply(Color color) => color.lighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightenColorModifier && amount == other.amount;

  @override
  String get key => 'color_lighten';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that saturates a color.
class SaturateColorModifier extends Modifier<Color> {
  final int amount;

  const SaturateColorModifier(this.amount);

  @override
  Color apply(Color color) => color.saturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaturateColorModifier && amount == other.amount;

  @override
  String get key => 'color_saturate';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that desaturates a color.
class DesaturateColorModifier extends Modifier<Color> {
  final int amount;

  const DesaturateColorModifier(this.amount);

  @override
  Color apply(Color color) => color.desaturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesaturateColorModifier && amount == other.amount;

  @override
  String get key => 'color_desaturate';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that applies tint to a color.
class TintColorModifier extends Modifier<Color> {
  final int amount;

  const TintColorModifier(this.amount);

  @override
  Color apply(Color color) => color.tint(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TintColorModifier && amount == other.amount;

  @override
  String get key => 'color_tint';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that applies shade to a color.
class ShadeColorModifier extends Modifier<Color> {
  final int amount;

  const ShadeColorModifier(this.amount);

  @override
  Color apply(Color color) => color.shade(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadeColorModifier && amount == other.amount;

  @override
  String get key => 'color_shade';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that brightens a color.
class BrightenColorModifier extends Modifier<Color> {
  final int amount;

  const BrightenColorModifier(this.amount);

  @override
  Color apply(Color color) => color.brighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrightenColorModifier && amount == other.amount;

  @override
  String get key => 'color_brighten';

  @override
  int get hashCode => amount.hashCode;
}

/// Modifier that sets the red channel of a color.
class WithRedColorModifier extends Modifier<Color> {
  final int red;

  const WithRedColorModifier(this.red);

  @override
  Color apply(Color color) => color.withRed(red);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithRedColorModifier && red == other.red;

  @override
  String get key => 'color_with_red';

  @override
  int get hashCode => red.hashCode;
}

/// Modifier that sets the green channel of a color.
class WithGreenColorModifier extends Modifier<Color> {
  final int green;

  const WithGreenColorModifier(this.green);

  @override
  Color apply(Color color) => color.withGreen(green);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithGreenColorModifier && green == other.green;

  @override
  String get key => 'color_with_green';

  @override
  int get hashCode => green.hashCode;
}

/// Modifier that sets the blue channel of a color.
class WithBlueColorModifier extends Modifier<Color> {
  final int blue;

  const WithBlueColorModifier(this.blue);

  @override
  Color apply(Color color) => color.withBlue(blue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithBlueColorModifier && blue == other.blue;

  @override
  String get key => 'color_with_blue';

  @override
  int get hashCode => blue.hashCode;
}

/// Modifier that capitalizes the first letter of a string.
final class CapitalizeStringModifier extends Modifier<String> {
  const CapitalizeStringModifier();
  @override
  String apply(String value) => value.capitalize;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CapitalizeStringModifier;
  @override
  String get key => 'capitalize';
  @override
  int get hashCode => key.hashCode;
}

/// Modifier that converts a string to uppercase.
final class UppercaseStringModifier extends Modifier<String> {
  const UppercaseStringModifier();
  @override
  String apply(String value) => value.toUpperCase();
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UppercaseStringModifier;
  @override
  String get key => 'uppercase';
  @override
  int get hashCode => key.hashCode;
}

/// Modifier that converts a string to lowercase.
final class LowercaseStringModifier extends Modifier<String> {
  const LowercaseStringModifier();
  @override
  String apply(String value) => value.toLowerCase();
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LowercaseStringModifier;
  @override
  String get key => 'lowercase';
  @override
  int get hashCode => key.hashCode;
}

/// Modifier that converts a string to title case.
final class TitleCaseStringModifier extends Modifier<String> {
  const TitleCaseStringModifier();
  @override
  String apply(String value) => value.titleCase;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TitleCaseStringModifier;
  @override
  String get key => 'title_case';
  @override
  int get hashCode => key.hashCode;
}

/// Modifier that converts a string to sentence case.
final class SentenceCaseStringModifier extends Modifier<String> {
  const SentenceCaseStringModifier();
  @override
  String apply(String value) => value.sentenceCase;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SentenceCaseStringModifier;
  @override
  String get key => 'sentence_case';
  @override
  int get hashCode => key.hashCode;
}

/// Extension on [List<Modifier<T>>] to provide apply functionality
extension ModifierListExt<T> on List<Modifier<T>> {
  /// Applies all modifiers in the list to the given value in sequence
  T apply(T value) {
    var result = value;
    for (final modifier in this) {
      result = modifier.apply(result);
    }

    return result;
  }
}

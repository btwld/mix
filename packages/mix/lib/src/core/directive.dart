import 'package:flutter/widgets.dart';

import '../internal/internal_extensions.dart';

@immutable
abstract class MixDirective<T> {
  const MixDirective();

  String get key;

  /// Applies the transformation to the given value
  T apply(T value);
}

/// Directive that applies opacity to a color
class OpacityDirective extends MixDirective<Color> {
  final double opacity;

  const OpacityDirective(this.opacity);

  @override
  Color apply(Color color) => color.withValues(alpha: opacity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpacityDirective && opacity == other.opacity;

  @override
  String get key => 'color_opacity';

  @override
  int get hashCode => opacity.hashCode;
}

/// Directive that applies alpha to a color
class AlphaDirective extends MixDirective<Color> {
  final int alpha;

  const AlphaDirective(this.alpha);

  @override
  Color apply(Color color) => color.withAlpha(alpha);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AlphaDirective && alpha == other.alpha;

  @override
  String get key => 'color_alpha';

  @override
  int get hashCode => alpha.hashCode;
}

/// Directive that darkens a color
class DarkenDirective extends MixDirective<Color> {
  final int amount;

  const DarkenDirective(this.amount);

  @override
  Color apply(Color color) => color.darken(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkenDirective && amount == other.amount;

  @override
  String get key => 'color_darken';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that lightens a color
class LightenDirective extends MixDirective<Color> {
  final int amount;

  const LightenDirective(this.amount);

  @override
  Color apply(Color color) => color.lighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LightenDirective && amount == other.amount;

  @override
  String get key => 'color_lighten';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that saturates a color
class SaturateDirective extends MixDirective<Color> {
  final int amount;

  const SaturateDirective(this.amount);

  @override
  Color apply(Color color) => color.saturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaturateDirective && amount == other.amount;

  @override
  String get key => 'color_saturate';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that desaturates a color
class DesaturateDirective extends MixDirective<Color> {
  final int amount;

  const DesaturateDirective(this.amount);

  @override
  Color apply(Color color) => color.desaturate(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesaturateDirective && amount == other.amount;

  @override
  String get key => 'color_desaturate';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that applies tint to a color
class TintDirective extends MixDirective<Color> {
  final int amount;

  const TintDirective(this.amount);

  @override
  Color apply(Color color) => color.tint(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TintDirective && amount == other.amount;

  @override
  String get key => 'color_tint';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that applies shade to a color
class ShadeDirective extends MixDirective<Color> {
  final int amount;

  const ShadeDirective(this.amount);

  @override
  Color apply(Color color) => color.shade(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadeDirective && amount == other.amount;

  @override
  String get key => 'color_shade';

  @override
  int get hashCode => amount.hashCode;
}

/// Directive that brightens a color
class BrightenDirective extends MixDirective<Color> {
  final int amount;

  const BrightenDirective(this.amount);

  @override
  Color apply(Color color) => color.brighten(amount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrightenDirective && amount == other.amount;

  @override
  String get key => 'color_brighten';

  @override
  int get hashCode => amount.hashCode;
}

final class CapitalizeStringDirective extends MixDirective<String> {
  const CapitalizeStringDirective();
  @override
  String apply(String value) => value.capitalize;
  @override
  String get key => 'capitalize';
}

final class UppercaseStringDirective extends MixDirective<String> {
  const UppercaseStringDirective();
  @override
  String apply(String value) => value.toUpperCase();
  @override
  String get key => 'uppercase';
}

final class LowercaseStringDirective extends MixDirective<String> {
  const LowercaseStringDirective();
  @override
  String apply(String value) => value.toLowerCase();
  @override
  String get key => 'lowercase';
}

final class TitleCaseStringDirective extends MixDirective<String> {
  const TitleCaseStringDirective();
  @override
  String apply(String value) => value.titleCase;
  @override
  String get key => 'title_case';
}

final class SentenceCaseStringDirective extends MixDirective<String> {
  const SentenceCaseStringDirective();
  @override
  String apply(String value) => value.sentenceCase;
  @override
  String get key => 'sentence_case';
}

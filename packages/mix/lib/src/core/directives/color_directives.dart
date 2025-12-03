import 'dart:ui';

import '../directive.dart';
import '../internal/internal_extensions.dart';

/// Base class for color directives with a single int parameter.
abstract class _IntValueColorDirective extends PropDirective<Color> {
  final int value;

  const _IntValueColorDirective(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
       other is _IntValueColorDirective &&
       value == other.value);

  @override
  int get hashCode => value.hashCode;
}

/// Base class for color directives with a single double parameter.
abstract class _DoubleValueColorDirective extends PropDirective<Color> {
  final double value;

  const _DoubleValueColorDirective(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
       other is _DoubleValueColorDirective &&
       value == other.value);

  @override
  int get hashCode => value.hashCode;
}

/// Directive that applies opacity to a color.
final class OpacityColorDirective extends _DoubleValueColorDirective {
  const OpacityColorDirective(super.opacity);

  @override
  Color apply(Color color) => color.withValues(alpha: value);

  @override
  String get key => 'color_opacity';
}

/// Directive that applies withValues to a color.
final class WithValuesColorDirective extends PropDirective<Color> {
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
final class AlphaColorDirective extends _IntValueColorDirective {
  const AlphaColorDirective(super.alpha);

  @override
  Color apply(Color color) => color.withAlpha(value);

  @override
  String get key => 'color_alpha';
}

/// Directive that darkens a color.
final class DarkenColorDirective extends _IntValueColorDirective {
  const DarkenColorDirective(super.amount);

  @override
  Color apply(Color color) => color.darken(value);

  @override
  String get key => 'color_darken';
}

/// Directive that lightens a color.
final class LightenColorDirective extends _IntValueColorDirective {
  const LightenColorDirective(super.amount);

  @override
  Color apply(Color color) => color.lighten(value);

  @override
  String get key => 'color_lighten';
}

/// Directive that saturates a color.
final class SaturateColorDirective extends _IntValueColorDirective {
  const SaturateColorDirective(super.amount);

  @override
  Color apply(Color color) => color.saturate(value);

  @override
  String get key => 'color_saturate';
}

/// Directive that desaturates a color.
final class DesaturateColorDirective extends _IntValueColorDirective {
  const DesaturateColorDirective(super.amount);

  @override
  Color apply(Color color) => color.desaturate(value);

  @override
  String get key => 'color_desaturate';
}

/// Directive that applies tint to a color.
final class TintColorDirective extends _IntValueColorDirective {
  const TintColorDirective(super.amount);

  @override
  Color apply(Color color) => color.tint(value);

  @override
  String get key => 'color_tint';
}

/// Directive that applies shade to a color.
final class ShadeColorDirective extends _IntValueColorDirective {
  const ShadeColorDirective(super.amount);

  @override
  Color apply(Color color) => color.shade(value);

  @override
  String get key => 'color_shade';
}

/// Directive that brightens a color.
final class BrightenColorDirective extends _IntValueColorDirective {
  const BrightenColorDirective(super.amount);

  @override
  Color apply(Color color) => color.brighten(value);

  @override
  String get key => 'color_brighten';
}

/// Directive that sets the red channel of a color.
final class WithRedColorDirective extends _IntValueColorDirective {
  const WithRedColorDirective(super.red);

  @override
  Color apply(Color color) => color.withRed(value);

  @override
  String get key => 'color_with_red';
}

/// Directive that sets the green channel of a color.
final class WithGreenColorDirective extends _IntValueColorDirective {
  const WithGreenColorDirective(super.green);

  @override
  Color apply(Color color) => color.withGreen(value);

  @override
  String get key => 'color_with_green';
}

/// Directive that sets the blue channel of a color.
final class WithBlueColorDirective extends _IntValueColorDirective {
  const WithBlueColorDirective(super.blue);

  @override
  Color apply(Color color) => color.withBlue(value);

  @override
  String get key => 'color_with_blue';
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'color_directives.dart';

class ResetColorDirective extends ColorDirective {
  const ResetColorDirective();

  @override
  Color modify(Color color) => color;

  @override
  List<Object?> get props => [];
}

@immutable
class OpacityColorDirective extends NumberBasedColorDirective<double> {
  const OpacityColorDirective(super.value);

  @override
  Color modify(Color color) => color.withValues(alpha: value);
}

@immutable
class ValueColorDirective extends NumberBasedColorDirective<double> {
  const ValueColorDirective(super.value);

  @override
  Color modify(Color color) =>
      HSVColor.fromColor(color).withValue(value).toColor();
}

@immutable
class SaturationColorDirective extends HSLColorDirective {
  const SaturationColorDirective(super.value);

  @override
  HSLColor transformer(HSLColor color, double value) {
    return color.withSaturation(value);
  }
}

@immutable
class HueColorDirective extends HSLColorDirective {
  const HueColorDirective(super.value);

  @override
  HSLColor transformer(HSLColor color, double value) {
    return color.withHue(value);
  }
}

@immutable
class LightnessColorDirective extends HSLColorDirective {
  const LightnessColorDirective(super.value);

  @override
  HSLColor transformer(HSLColor color, double value) {
    return color.withLightness(value);
  }
}

@immutable
class AlphaColorDirective extends NumberBasedColorDirective<int> {
  const AlphaColorDirective(super.value);

  @override
  Color modify(Color color) => color.withAlpha(value);
}

@immutable
class DarkenColorDirective extends NumberBasedColorDirective<int> {
  const DarkenColorDirective(super.value);

  @override
  Color modify(Color color) => color.darken(value);
}

@immutable
class LightenColorDirective extends NumberBasedColorDirective<int> {
  const LightenColorDirective(super.value);

  @override
  Color modify(Color color) => color.lighten(value);
}

@immutable
class SaturateColorDirective extends NumberBasedColorDirective<int> {
  const SaturateColorDirective(super.value);

  @override
  Color modify(Color color) => color.saturate(value);
}

@immutable
class DesaturateColorDirective extends NumberBasedColorDirective<int> {
  const DesaturateColorDirective(super.value);

  @override
  Color modify(Color color) => color.desaturate(value);
}

@immutable
class TintColorDirective extends NumberBasedColorDirective<int> {
  const TintColorDirective(super.value);

  @override
  Color modify(Color color) => color.tint(value);
}

@immutable
class ShadeColorDirective extends NumberBasedColorDirective<int> {
  const ShadeColorDirective(super.value);

  @override
  Color modify(Color color) => color.shade(value);
}

@immutable
class BrightenColorDirective extends NumberBasedColorDirective<int> {
  const BrightenColorDirective(super.value);

  @override
  Color modify(Color color) => color.brighten(value);
}

extension ColorExtUtilities on Color {
  Color mix(Color toColor, [int amount = 50]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;

    return Color.lerp(this, toColor, p)!;
  }

  Color lighten([int amount = 10]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;
    final hsl = HSLColor.fromColor(this);
    final lightness = _clamp(hsl.lightness + p);

    return hsl.withLightness(lightness).toColor();
  }

  Color brighten([int amount = 10]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;

    return Color.from(
      alpha: a,
      red: (r - (1 * -p)).clamp(0.0, 1.0),
      green: (g - (1 * -p)).clamp(0.0, 1.0),
      blue: (b - (1 * -p)).clamp(0.0, 1.0),
    );
  }

  Color contrast([int amount = 100]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;

    final luminance = computeLuminance();

    return luminance > 0.5 ? darken((p).round()) : brighten((p).round());
  }

  Color darken([int amount = 10]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;
    final hsl = HSLColor.fromColor(this);
    final lightness = _clamp(hsl.lightness - p);

    return hsl.withLightness(lightness).toColor();
  }

  Color tint([int amount = 10]) => mix(
        const Color.fromRGBO(255, 255, 255, 1.0),
        amount,
      );

  Color shade([int amount = 10]) => mix(
        const Color.fromRGBO(0, 0, 0, 1.0),
        amount,
      );

  Color desaturate([int amount = 10]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;
    final hsl = HSLColor.fromColor(this);
    final saturation = _clamp(hsl.saturation - p);

    return hsl.withSaturation(saturation).toColor();
  }

  Color saturate([int amount = 10]) {
    final p = RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100;
    final hsl = HSLColor.fromColor(this);
    final saturation = _clamp(hsl.saturation + p);

    return hsl.withSaturation(saturation).toColor();
  }

  Color greyscale() => desaturate(100);

  Color complement() {
    final hsl = HSLColor.fromColor(this);
    final hue = (hsl.hue + 180) % 360;

    return hsl.withHue(hue).toColor();
  }
}

double _clamp(double val) => math.min(1.0, math.max(0.0, val));

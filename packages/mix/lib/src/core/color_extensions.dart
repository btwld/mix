import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Extensions for color transformations in Flutter, using HSL for perceptual accuracy.
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

  double _normalizeAmount(int amount) {
    return RangeError.checkValueInInterval(amount, 0, 100, 'amount') / 100.0;
  }
}

/// Clamps a value between 0.0 and 1.0.
double _clamp(double val) => math.min(1.0, math.max(0.0, val));
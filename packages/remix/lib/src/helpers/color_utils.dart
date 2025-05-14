import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

extension ColorUtilityExt<T extends Attribute> on ColorUtility<T> {
  T alphaBlend(Color foreground, Color background) =>
      call(Color.alphaBlend(foreground, background));
}

double _calculateContrast(Color backgroundColor, Color textColor) {
  /// Calculates the contrast ratio between two colors.
  ///
  /// The contrast ratio is a measure of the perceived difference in brightness
  /// between the text color and the background color. A higher ratio indicates
  /// better readability.
  ///
  /// The calculation involves:
  /// 1. Computing the relative luminance of each color.
  /// 2. Finding the lighter (brightest) and darker (darkest) colors.
  /// 3. Applying the contrast ratio formula: (brightest + 0.05) / (darkest + 0.05)
  ///
  /// Note: Relative luminance calculation is computationally expensive.
  var lum1 = textColor.computeLuminance();
  var lum2 = backgroundColor.computeLuminance();

  var brightest = math.max(lum1, lum2);
  var darkest = math.min(lum1, lum2);

  return (brightest + 0.05) / (darkest + 0.05);
}

class RXColor {
  final Color color;
  final ColorSwatch<int> swatch;

  RXColor(this.color) : swatch = getColorSwatch(color);

  Color get shade50 => swatch[50]!;
  Color get shade100 => swatch[100]!;
  Color get shade200 => swatch[200]!;
  Color get shade300 => swatch[300]!;
  Color get shade400 => swatch[400]!;
  Color get shade500 => swatch[500]!;
  Color get shade600 => swatch[600]!;
  Color get shade700 => swatch[700]!;
  Color get shade800 => swatch[800]!;
  Color get shade900 => swatch[900]!;
}

ColorSwatch<int> getColorSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;

  /// if [500] is the default color, there are at LEAST five
  /// steps below [500]. (i.e. 400, 300, 200, 100, 50.) A
  /// divisor of 5 would mean [50] is a lightness of 1.0 or
  /// a color of #ffffff. A value of six would be near white
  /// but not quite.
  const lowDivisor = 6;

  /// if [500] is the default color, there are at LEAST four
  /// steps above [500]. A divisor of 4 would mean [900] is
  /// a lightness of 0.0 or color of #000000
  const highDivisor = 5;

  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;

  return ColorSwatch(color.toInt32, {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  });
}

Color getTextColor(Color background) {
  const white = Color(0xFFFFFFFF);

  final contrastRatio = _calculateContrast(white, background);

  if (contrastRatio <= 4.5) {
    final hslBackground = HSLColor.fromColor(background);
    final lightness = hslBackground.lightness;
    final saturation = hslBackground.saturation;
    final hue = hslBackground.hue;

    final adjustedLightness = lightness < 0.5 ? 0.95 : 0.05;

    return HSLColor.fromAHSL(1.0, hue, saturation * 0.08, adjustedLightness)
        .toColor();
  }

  return white;
}

extension on Color {
  static int floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  /// A 32 bit value representing this color.
  ///
  /// The bits are assigned as follows:
  ///
  /// * Bits 24-31 are the alpha value.
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  int get toInt32 {
    return floatToInt8(a) << 24 |
        floatToInt8(r) << 16 |
        floatToInt8(g) << 8 |
        floatToInt8(b) << 0;
  }
}

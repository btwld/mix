import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

void expectColor(Color color, Color expected) {
  expect(
    color.toHex().toRadixString(16),
    expected.toHex().toRadixString(16),
  );
}

extension on Color {
  /// Converts the [Color] to a hex integer.
  ///
  /// If [includeAlpha] is true, the format will be `0xAARRGGBB`,
  /// otherwise it will be `0xRRGGBB`.
  int toHex({bool includeAlpha = true}) {
    int scale(double value) => (value * 255).round().clamp(0, 255);

    final int alpha = scale(a);
    final int red = scale(r);
    final int green = scale(g);
    final int blue = scale(b);

    if (includeAlpha) {
      return (alpha << 24) | (red << 16) | (green << 8) | blue;
    } else {
      return (red << 16) | (green << 8) | blue;
    }
  }
}

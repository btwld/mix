import 'package:flutter/material.dart';

import '../attributes/scalar_attribute.dart';

GradientAttribute linearGradient({
  AlignmentGeometry? begin,
  AlignmentGeometry? end,
  required List<Color> colors,
  List<double>? stops,
  TileMode? tileMode,
  GradientTransform? transform,
}) {
  final defaultGradient = LinearGradient(colors: colors);

  return GradientAttribute(
    LinearGradient(
      begin: begin ?? defaultGradient.begin,
      end: end ?? defaultGradient.end,
      colors: colors,
      stops: stops,
      tileMode: tileMode ?? defaultGradient.tileMode,
      transform: transform,
    ),
  );
}

GradientAttribute radialGradient({
  AlignmentGeometry? center,
  double? radius,
  required List<Color> colors,
  List<double>? stops,
  TileMode tileMode = TileMode.clamp,
  AlignmentGeometry? focal,
  double? focalRadius,
  GradientTransform? transform,
}) {
  final defaultGradient = RadialGradient(colors: colors);

  return GradientAttribute(
    RadialGradient(
      center: center ?? defaultGradient.center,
      radius: radius ?? defaultGradient.radius,
      colors: colors,
      stops: stops,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius ?? defaultGradient.focalRadius,
      transform: transform,
    ),
  );
}

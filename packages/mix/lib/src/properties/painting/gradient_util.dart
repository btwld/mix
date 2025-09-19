import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'gradient_mix.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
final class LinearGradientUtility<T extends Style<Object?>>
    extends MixUtility<T, LinearGradientMix> {
  /// Utility for defining [LinearGradientMix.begin]
  late final begin = MixUtility<T, AlignmentGeometry>((v) => call(begin: v));

  /// Utility for defining [LinearGradientMix.end]
  late final end = MixUtility<T, AlignmentGeometry>((v) => call(end: v));

  /// Utility for defining [LinearGradientMix.tileMode]
  late final tileMode = MixUtility<T, TileMode>((prop) => call(tileMode: prop));

  /// Utility for defining [LinearGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => call(transform: v),
  );

  late final only = call;
  LinearGradientUtility(super.utilityBuilder);

  /// Utility for defining [LinearGradientMix.stops]
  T stops(List<double> stops) {
    return call(stops: stops);
  }

  T colors(List<Color> colors) {
    return call(colors: colors);
  }

  T call({
    LinearGradient? as,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    var gradient = LinearGradientMix();
    if (as != null) {
      gradient = gradient.merge(LinearGradientMix.value(as));
    }

    gradient = gradient.merge(
      LinearGradientMix(
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
        colors: colors,
        stops: stops,
      ),
    );

    return utilityBuilder(gradient);
  }

  T as(LinearGradient value) {
    return utilityBuilder(LinearGradientMix.value(value));
  }
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends Style<Object?>>
    extends MixUtility<T, RadialGradientMix> {
  /// Utility for defining [RadialGradientMix.center]
  late final center = MixUtility<T, AlignmentGeometry>((v) => call(center: v));

  /// Utility for defining [RadialGradientMix.tileMode]
  late final tileMode = MixUtility<T, TileMode>((prop) => call(tileMode: prop));

  /// Utility for defining [RadialGradientMix.focal]
  late final focal = MixUtility<T, AlignmentGeometry>((v) => call(focal: v));

  /// Utility for defining [RadialGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => call(transform: v),
  );

  late final only = call;

  /// Utility for defining [RadialGradientMix.radius]
  late final radius = MixUtility<T, double>((v) => call(radius: v));

  /// Utility for defining [RadialGradientMix.focalRadius]
  late final focalRadius = MixUtility<T, double>((v) => call(focalRadius: v));

  RadialGradientUtility(super.utilityBuilder);

  /// Utility for defining [RadialGradientMix.colors]
  T colors(List<Color> colors) {
    return call(colors: colors);
  }

  /// Utility for defining [RadialGradientMix.stops]
  T stops(List<double> stops) {
    return call(stops: stops);
  }

  T call({
    RadialGradient? as,
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    var gradient = RadialGradientMix();
    if (as != null) {
      gradient = gradient.merge(RadialGradientMix.value(as));
    }

    gradient = gradient.merge(
      RadialGradientMix(
        center: center,
        radius: radius,
        tileMode: tileMode,
        focal: focal,
        focalRadius: focalRadius,
        transform: transform,
        colors: colors,
        stops: stops,
      ),
    );

    return utilityBuilder(gradient);
  }

  T as(RadialGradient value) {
    return utilityBuilder(RadialGradientMix.value(value));
  }
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends Style<Object?>>
    extends MixUtility<T, SweepGradientMix> {
  /// Utility for defining [SweepGradientMix.center]
  late final center = MixUtility<T, AlignmentGeometry>((v) => call(center: v));

  /// Utility for defining [SweepGradientMix.tileMode]
  late final tileMode = MixUtility<T, TileMode>((prop) => call(tileMode: prop));

  /// Utility for defining [SweepGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => call(transform: v),
  );

  late final only = call;

  /// Utility for defining [SweepGradientMix.startAngle]
  late final startAngle = MixUtility<T, double>((v) => call(startAngle: v));

  /// Utility for defining [SweepGradientMix.endAngle]
  late final endAngle = MixUtility<T, double>((v) => call(endAngle: v));

  SweepGradientUtility(super.utilityBuilder);

  /// Utility for defining [SweepGradientMix.colors]
  T colors(List<Color> colors) {
    return call(colors: colors);
  }

  /// Utility for defining [SweepGradientMix.stops]
  T stops(List<double> stops) {
    return call(stops: stops);
  }

  T call({
    SweepGradient? as,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    var gradient = SweepGradientMix();
    if (as != null) {
      gradient = gradient.merge(SweepGradientMix.value(as));
    }

    gradient = gradient.merge(
      SweepGradientMix(
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
        colors: colors,
        stops: stops,
      ),
    );

    return utilityBuilder(gradient);
  }

  T as(SweepGradient value) {
    return utilityBuilder(SweepGradientMix.value(value));
  }
}

/// Utility class for working with gradients.
final class GradientUtility<T extends Style<Object?>>
    extends MixUtility<T, GradientMix> {
  /// Returns a [LinearGradientUtility] for creating linear gradients
  late final linear = LinearGradientUtility<T>(utilityBuilder);

  /// Returns a [RadialGradientUtility] for creating radial gradients
  late final radial = RadialGradientUtility<T>(utilityBuilder);

  /// Returns a [SweepGradientUtility] for creating sweep gradients
  late final sweep = SweepGradientUtility<T>(utilityBuilder);

  GradientUtility(super.utilityBuilder);

  T as(Gradient value) {
    return utilityBuilder(GradientMix.value(value));
  }
}

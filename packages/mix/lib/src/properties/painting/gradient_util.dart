import 'package:flutter/widgets.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'gradient_mix.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
final class LinearGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, LinearGradientMix, LinearGradient> {
  /// Utility for defining [LinearGradientMix.begin]
  late final begin = MixUtility<T, AlignmentGeometry>((v) => only(begin: v));

  /// Utility for defining [LinearGradientMix.end]
  late final end = MixUtility<T, AlignmentGeometry>((v) => only(end: v));

  /// Utility for defining [LinearGradientMix.tileMode]
  late final tileMode = MixUtility<T, TileMode>((prop) => only(tileMode: prop));

  /// Utility for defining [LinearGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => only(transform: v),
  );

  /// Utility for defining [LinearGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => builder(LinearGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [LinearGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => builder(LinearGradientMix.raw(stops: stops)),
  );

  LinearGradientUtility(super.builder);

  T only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return builder(
      LinearGradientMix(
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
        colors: colors,
        stops: stops,
      ),
    );
  }

  T call({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return only(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  @override
  T as(LinearGradient value) {
    return builder(LinearGradientMix.value(value));
  }
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, RadialGradientMix, RadialGradient> {
  /// Utility for defining [RadialGradientMix.center]
  late final center = MixUtility<T, AlignmentGeometry>((v) => only(center: v));

  /// Utility for defining [RadialGradientMix.radius]
  late final radius = MixUtility<T, double>((prop) => only(radius: prop));

  /// Utility for defining [RadialGradientMix.tileMode]
  late final tileMode = MixUtility<T, TileMode>((prop) => only(tileMode: prop));

  /// Utility for defining [RadialGradientMix.focal]
  late final focal = MixUtility<T, AlignmentGeometry>((v) => only(focal: v));

  /// Utility for defining [RadialGradientMix.focalRadius]
  late final focalRadius = MixUtility<T, double>(
    (prop) => only(focalRadius: prop),
  );

  /// Utility for defining [RadialGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => only(transform: v),
  );

  /// Utility for defining [RadialGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => builder(RadialGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [RadialGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => builder(RadialGradientMix.raw(stops: stops)),
  );

  RadialGradientUtility(super.builder);

  T only({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return builder(
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
  }

  T call({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return only(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  @override
  T as(RadialGradient value) {
    return builder(RadialGradientMix.value(value));
  }
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, SweepGradientMix, SweepGradient> {
  /// Utility for defining [SweepGradientMix.center]
  late final center = MixUtility<T, AlignmentGeometry>((v) => only(center: v));

  /// Utility for defining [SweepGradientMix.startAngle]
  late final startAngle = MixUtility<T, double>(
    (prop) => only(startAngle: prop),
  );

  /// Utility for defining [SweepGradientMix.endAngle]
  late final endAngle = MixUtility<T, double>((prop) => only(endAngle: prop));

  /// Utility for defining [SweepGradientMix.tileMode]
  late final tileMode = MixUtility<T, TileMode>((prop) => only(tileMode: prop));

  /// Utility for defining [SweepGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => only(transform: v),
  );

  /// Utility for defining [SweepGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => builder(SweepGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [SweepGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => builder(SweepGradientMix.raw(stops: stops)),
  );

  SweepGradientUtility(super.builder);

  T only({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return builder(
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
  }

  T call({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return only(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  @override
  T as(SweepGradient value) {
    return builder(SweepGradientMix.value(value));
  }
}

/// Utility class for working with gradients.
final class GradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, GradientMix, Gradient> {
  /// Returns a [LinearGradientUtility] for creating linear gradients
  late final linear = LinearGradientUtility<T>(builder);

  /// Returns a [RadialGradientUtility] for creating radial gradients
  late final radial = RadialGradientUtility<T>(builder);

  /// Returns a [SweepGradientUtility] for creating sweep gradients
  late final sweep = SweepGradientUtility<T>(builder);

  GradientUtility(super.builder);

  @override
  T as(Gradient value) {
    return builder(GradientMix.value(value));
  }
}

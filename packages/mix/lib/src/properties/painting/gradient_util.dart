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
  @Deprecated('Use call(begin: value) instead')
  late final begin = MixUtility<T, AlignmentGeometry>((v) => call(begin: v));

  /// Utility for defining [LinearGradientMix.end]
  @Deprecated('Use call(end: value) instead')
  late final end = MixUtility<T, AlignmentGeometry>((v) => call(end: v));

  /// Utility for defining [LinearGradientMix.tileMode]
  @Deprecated('Use call(tileMode: value) instead')
  late final tileMode = MixUtility<T, TileMode>((prop) => call(tileMode: prop));

  /// Utility for defining [LinearGradientMix.transform]
  @Deprecated('Use call(transform: value) instead')
  late final transform = MixUtility<T, GradientTransform>(
    (v) => call(transform: v),
  );

  /// Utility for defining [LinearGradientMix.stops]
  @Deprecated('Use call(stops: value) instead')
  late final stops = PropListUtility<T, double>(
    (stops) => builder(LinearGradientMix.raw(stops: stops)),
  );
  @Deprecated('Use call(...) instead')
  late final only = call;

  LinearGradientUtility(super.builder);

  @Deprecated('Use call(colors: value) instead')
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
    
    return builder(gradient);
  }

  @Deprecated('Use call(as: value) instead')
  T as(LinearGradient value) {
    return builder(LinearGradientMix.value(value));
  }
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends Style<Object?>>
    extends MixUtility<T, RadialGradientMix> {
  /// Utility for defining [RadialGradientMix.center]
  @Deprecated('Use call(center: value) instead')
  late final center = MixUtility<T, AlignmentGeometry>((v) => call(center: v));

  /// Utility for defining [RadialGradientMix.tileMode]
  @Deprecated('Use call(tileMode: value) instead')
  late final tileMode = MixUtility<T, TileMode>((prop) => call(tileMode: prop));

  /// Utility for defining [RadialGradientMix.focal]
  @Deprecated('Use call(focal: value) instead')
  late final focal = MixUtility<T, AlignmentGeometry>((v) => call(focal: v));

  /// Utility for defining [RadialGradientMix.transform]
  @Deprecated('Use call(transform: value) instead')
  late final transform = MixUtility<T, GradientTransform>(
    (v) => call(transform: v),
  );

  /// Utility for defining [RadialGradientMix.colors]
  @Deprecated('Use call(colors: value) instead')
  late final colors = PropListUtility<T, Color>(
    (colors) => builder(RadialGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [RadialGradientMix.stops]
  @Deprecated('Use call(stops: value) instead')
  late final stops = PropListUtility<T, double>(
    (stops) => builder(RadialGradientMix.raw(stops: stops)),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;
  
  RadialGradientUtility(super.builder);

  /// Utility for defining [RadialGradientMix.radius]
  @Deprecated('Use call(radius: value) instead')
  late final radius = MixUtility<T, double>((v) => call(radius: v));

  /// Utility for defining [RadialGradientMix.focalRadius]
  @Deprecated('Use call(focalRadius: value) instead')
  late final focalRadius = MixUtility<T, double>((v) => call(focalRadius: v));

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
    
    return builder(gradient);
  }

  @Deprecated('Use call(as: value) instead')
  T as(RadialGradient value) {
    return builder(RadialGradientMix.value(value));
  }
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends Style<Object?>>
    extends MixUtility<T, SweepGradientMix> {
  /// Utility for defining [SweepGradientMix.center]
  @Deprecated('Use call(center: value) instead')
  late final center = MixUtility<T, AlignmentGeometry>((v) => call(center: v));

  /// Utility for defining [SweepGradientMix.tileMode]
  @Deprecated('Use call(tileMode: value) instead')
  late final tileMode = MixUtility<T, TileMode>((prop) => call(tileMode: prop));

  @Deprecated('Use call(transform: value) instead')
  /// Utility for defining [SweepGradientMix.transform]
  late final transform = MixUtility<T, GradientTransform>(
    (v) => call(transform: v),
  );

  @Deprecated('Use call(colors: value) instead')
  /// Utility for defining [SweepGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => builder(SweepGradientMix.raw(colors: colors)),
  );

  @Deprecated('Use call(...) instead')
  late final only = call;
  SweepGradientUtility(super.builder);

  /// Utility for defining [SweepGradientMix.startAngle]
  @Deprecated('Use call(startAngle: value) instead')
  late final startAngle = MixUtility<T, double>((v) => call(startAngle: v));

  /// Utility for defining [SweepGradientMix.endAngle]
  @Deprecated('Use call(endAngle: value) instead')
  late final endAngle = MixUtility<T, double>((v) => call(endAngle: v));

  /// Utility for defining [SweepGradientMix.stops]
  @Deprecated('Use call(stops: value) instead')
  late final stops = PropListUtility<T, double>(
    (stops) => builder(SweepGradientMix.raw(stops: stops)),
  );

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
    
    return builder(gradient);
  }

  @Deprecated('Use call(as: value) instead')
  T as(SweepGradient value) {
    return builder(SweepGradientMix.value(value));
  }
}

/// Utility class for working with gradients.
final class GradientUtility<T extends Style<Object?>>
    extends MixUtility<T, GradientMix> {
  /// Returns a [LinearGradientUtility] for creating linear gradients
  late final linear = LinearGradientUtility<T>(builder);

  /// Returns a [RadialGradientUtility] for creating radial gradients
  late final radial = RadialGradientUtility<T>(builder);

  /// Returns a [SweepGradientUtility] for creating sweep gradients
  late final sweep = SweepGradientUtility<T>(builder);

  GradientUtility(super.builder);

  T as(Gradient value) {
    return builder(GradientMix.value(value));
  }
}

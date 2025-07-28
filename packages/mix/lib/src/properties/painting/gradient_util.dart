import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'gradient_mix.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
final class LinearGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, LinearGradient> {
  /// Utility for defining [LinearGradientMix.begin]
  late final begin = PropUtility<T, AlignmentGeometry>(
    (v) => call(LinearGradientMix.raw(begin: v)),
  );

  /// Utility for defining [LinearGradientMix.end]
  late final end = PropUtility<T, AlignmentGeometry>(
    (v) => call(LinearGradientMix.raw(end: v)),
  );

  /// Utility for defining [LinearGradientMix.tileMode]
  late final tileMode = PropUtility<T, TileMode>(
    (prop) => call(LinearGradientMix.raw(tileMode: prop)),
  );

  /// Utility for defining [LinearGradientMix.transform]
  late final transform = PropUtility<T, GradientTransform>(
    (v) => call(LinearGradientMix.raw(transform: v)),
  );

  /// Utility for defining [LinearGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => call(LinearGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [LinearGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => call(LinearGradientMix.raw(stops: stops)),
  );

  LinearGradientUtility(super.builder)
    : super(convertToMix: LinearGradientMix.value);

  @override
  T call(LinearGradientMix value) => builder(MixProp(value));
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, RadialGradient> {
  /// Utility for defining [RadialGradientMix.center]
  late final center = PropUtility<T, AlignmentGeometry>(
    (v) => call(RadialGradientMix.raw(center: v)),
  );

  /// Utility for defining [RadialGradientMix.radius]
  late final radius = PropUtility<T, double>(
    (prop) => call(RadialGradientMix.raw(radius: prop)),
  );

  /// Utility for defining [RadialGradientMix.tileMode]
  late final tileMode = PropUtility<T, TileMode>(
    (prop) => call(RadialGradientMix.raw(tileMode: prop)),
  );

  /// Utility for defining [RadialGradientMix.focal]
  late final focal = PropUtility<T, AlignmentGeometry>(
    (v) => call(RadialGradientMix.raw(focal: v)),
  );

  /// Utility for defining [RadialGradientMix.focalRadius]
  late final focalRadius = PropUtility<T, double>(
    (prop) => call(RadialGradientMix.raw(focalRadius: prop)),
  );

  /// Utility for defining [RadialGradientMix.transform]
  late final transform = PropUtility<T, GradientTransform>(
    (v) => call(RadialGradientMix.raw(transform: v)),
  );

  /// Utility for defining [RadialGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => call(RadialGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [RadialGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => call(RadialGradientMix.raw(stops: stops)),
  );

  RadialGradientUtility(super.builder)
    : super(convertToMix: RadialGradientMix.value);

  @override
  T call(RadialGradientMix value) => builder(MixProp(value));
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, SweepGradient> {
  /// Utility for defining [SweepGradientMix.center]
  late final center = PropUtility<T, AlignmentGeometry>(
    (v) => call(SweepGradientMix.raw(center: v)),
  );

  /// Utility for defining [SweepGradientMix.startAngle]
  late final startAngle = PropUtility<T, double>(
    (prop) => call(SweepGradientMix.raw(startAngle: prop)),
  );

  /// Utility for defining [SweepGradientMix.endAngle]
  late final endAngle = PropUtility<T, double>(
    (prop) => call(SweepGradientMix.raw(endAngle: prop)),
  );

  /// Utility for defining [SweepGradientMix.tileMode]
  late final tileMode = PropUtility<T, TileMode>(
    (prop) => call(SweepGradientMix.raw(tileMode: prop)),
  );

  /// Utility for defining [SweepGradientMix.transform]
  late final transform = PropUtility<T, GradientTransform>(
    (v) => call(SweepGradientMix.raw(transform: v)),
  );

  /// Utility for defining [SweepGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => call(SweepGradientMix.raw(colors: colors)),
  );

  /// Utility for defining [SweepGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => call(SweepGradientMix.raw(stops: stops)),
  );

  SweepGradientUtility(super.builder)
    : super(convertToMix: SweepGradientMix.value);

  @override
  T call(SweepGradientMix value) => builder(MixProp(value));
}

/// Utility class for working with gradients.
final class GradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, Gradient> {
  /// Returns a [LinearGradientUtility] for creating linear gradients
  late final linear = LinearGradientUtility<T>(builder);

  /// Returns a [RadialGradientUtility] for creating radial gradients
  late final radial = RadialGradientUtility<T>(builder);

  /// Returns a [SweepGradientUtility] for creating sweep gradients
  late final sweep = SweepGradientUtility<T>(builder);

  GradientUtility(super.builder) : super(convertToMix: GradientMix.value);

  @override
  T call(GradientMix value) => builder(MixProp(value));
}

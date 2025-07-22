import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'gradient_mix.dart';
import 'scalar_util.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
final class LinearGradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, LinearGradient> {
  /// Utility for defining [LinearGradientMix.begin]
  late final begin = AlignmentGeometryUtility<T>(
    (v) => call(LinearGradientMix(begin: v)),
  );

  /// Utility for defining [LinearGradientMix.end]
  late final end = AlignmentGeometryUtility<T>(
    (v) => call(LinearGradientMix(end: v)),
  );

  /// Utility for defining [LinearGradientMix.tileMode]
  late final tileMode = TileModeUtility<T>(
    (v) => call(LinearGradientMix(tileMode: v)),
  );

  /// Utility for defining [LinearGradientMix.transform]
  late final transform = GradientTransformUtility<T>(
    (v) => call(LinearGradientMix(transform: v)),
  );

  /// Utility for defining [LinearGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => call(LinearGradientMix(colors: colors)),
  );

  /// Utility for defining [LinearGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => call(LinearGradientMix(stops: stops)),
  );

  LinearGradientUtility(super.builder)
    : super(convertToMix: LinearGradientMix.value);

  @override
  T call(LinearGradientMix value) => builder(Prop(value));
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, RadialGradient> {
  /// Utility for defining [RadialGradientMix.center]
  late final center = AlignmentGeometryUtility<T>(
    (v) => call(RadialGradientMix(center: v)),
  );

  /// Utility for defining [RadialGradientMix.radius]
  late final radius = DoubleUtility<T>(
    (prop) => call(RadialGradientMix(radius: prop)),
  );

  /// Utility for defining [RadialGradientMix.tileMode]
  late final tileMode = TileModeUtility<T>(
    (v) => call(RadialGradientMix(tileMode: v)),
  );

  /// Utility for defining [RadialGradientMix.focal]
  late final focal = AlignmentGeometryUtility<T>(
    (v) => call(RadialGradientMix(focal: v)),
  );

  /// Utility for defining [RadialGradientMix.focalRadius]
  late final focalRadius = DoubleUtility<T>(
    (prop) => call(RadialGradientMix(focalRadius: prop)),
  );

  /// Utility for defining [RadialGradientMix.transform]
  late final transform = GradientTransformUtility<T>(
    (v) => call(RadialGradientMix(transform: v)),
  );

  /// Utility for defining [RadialGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => call(RadialGradientMix(colors: colors)),
  );

  /// Utility for defining [RadialGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => call(RadialGradientMix(stops: stops)),
  );

  RadialGradientUtility(super.builder)
    : super(convertToMix: RadialGradientMix.value);

  @override
  T call(RadialGradientMix value) => builder(Prop(value));
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, SweepGradient> {
  /// Utility for defining [SweepGradientMix.center]
  late final center = AlignmentGeometryUtility<T>(
    (v) => call(SweepGradientMix(center: v)),
  );

  /// Utility for defining [SweepGradientMix.startAngle]
  late final startAngle = DoubleUtility<T>(
    (prop) => call(SweepGradientMix(startAngle: prop)),
  );

  /// Utility for defining [SweepGradientMix.endAngle]
  late final endAngle = DoubleUtility<T>(
    (prop) => call(SweepGradientMix(endAngle: prop)),
  );

  /// Utility for defining [SweepGradientMix.tileMode]
  late final tileMode = TileModeUtility<T>(
    (v) => call(SweepGradientMix(tileMode: v)),
  );

  /// Utility for defining [SweepGradientMix.transform]
  late final transform = GradientTransformUtility<T>(
    (v) => call(SweepGradientMix(transform: v)),
  );

  /// Utility for defining [SweepGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => call(SweepGradientMix(colors: colors)),
  );

  /// Utility for defining [SweepGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => call(SweepGradientMix(stops: stops)),
  );

  SweepGradientUtility(super.builder)
    : super(convertToMix: SweepGradientMix.value);

  @override
  T call(SweepGradientMix value) => builder(Prop(value));
}

/// Utility class for working with gradients.
final class GradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, Gradient> {
  /// Returns a [LinearGradientUtility] for creating linear gradients
  late final linear = LinearGradientUtility<T>(builder);

  /// Returns a [RadialGradientUtility] for creating radial gradients
  late final radial = RadialGradientUtility<T>(builder);

  /// Returns a [SweepGradientUtility] for creating sweep gradients
  late final sweep = SweepGradientUtility<T>(builder);

  GradientUtility(super.builder) : super(convertToMix: GradientMix.value);

  @override
  T call(GradientMix value) => builder(Prop(value));
}

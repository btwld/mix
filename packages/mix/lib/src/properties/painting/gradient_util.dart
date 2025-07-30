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
    (v) => onlyProps(begin: v),
  );

  /// Utility for defining [LinearGradientMix.end]
  late final end = PropUtility<T, AlignmentGeometry>((v) => onlyProps(end: v));

  /// Utility for defining [LinearGradientMix.tileMode]
  late final tileMode = PropUtility<T, TileMode>(
    (prop) => onlyProps(tileMode: prop),
  );

  /// Utility for defining [LinearGradientMix.transform]
  late final transform = PropUtility<T, GradientTransform>(
    (v) => onlyProps(transform: v),
  );

  /// Utility for defining [LinearGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => onlyProps(colors: colors),
  );

  /// Utility for defining [LinearGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => onlyProps(stops: stops),
  );

  LinearGradientUtility(super.builder)
    : super(convertToMix: LinearGradientMix.value);

  @protected
  T onlyProps({
    Prop<AlignmentGeometry>? begin,
    Prop<AlignmentGeometry>? end,
    Prop<TileMode>? tileMode,
    Prop<GradientTransform>? transform,
    List<Prop<Color>>? colors,
    List<Prop<double>>? stops,
  }) {
    return builder(
      MixProp(
        LinearGradientMix.raw(
          begin: begin,
          end: end,
          tileMode: tileMode,
          transform: transform,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  T only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return onlyProps(
      begin: Prop.maybe(begin),
      end: Prop.maybe(end),
      tileMode: Prop.maybe(tileMode),
      transform: Prop.maybe(transform),
      colors: colors?.map(Prop.new).toList(),
      stops: stops?.map(Prop.new).toList(),
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
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, RadialGradient> {
  /// Utility for defining [RadialGradientMix.center]
  late final center = PropUtility<T, AlignmentGeometry>(
    (v) => onlyProps(center: v),
  );

  /// Utility for defining [RadialGradientMix.radius]
  late final radius = PropUtility<T, double>((prop) => onlyProps(radius: prop));

  /// Utility for defining [RadialGradientMix.tileMode]
  late final tileMode = PropUtility<T, TileMode>(
    (prop) => onlyProps(tileMode: prop),
  );

  /// Utility for defining [RadialGradientMix.focal]
  late final focal = PropUtility<T, AlignmentGeometry>(
    (v) => onlyProps(focal: v),
  );

  /// Utility for defining [RadialGradientMix.focalRadius]
  late final focalRadius = PropUtility<T, double>(
    (prop) => onlyProps(focalRadius: prop),
  );

  /// Utility for defining [RadialGradientMix.transform]
  late final transform = PropUtility<T, GradientTransform>(
    (v) => onlyProps(transform: v),
  );

  /// Utility for defining [RadialGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => onlyProps(colors: colors),
  );

  /// Utility for defining [RadialGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => onlyProps(stops: stops),
  );

  RadialGradientUtility(super.builder)
    : super(convertToMix: RadialGradientMix.value);

  @protected
  T onlyProps({
    Prop<AlignmentGeometry>? center,
    Prop<double>? radius,
    Prop<TileMode>? tileMode,
    Prop<AlignmentGeometry>? focal,
    Prop<double>? focalRadius,
    Prop<GradientTransform>? transform,
    List<Prop<Color>>? colors,
    List<Prop<double>>? stops,
  }) {
    return builder(
      MixProp(
        RadialGradientMix.raw(
          center: center,
          radius: radius,
          tileMode: tileMode,
          focal: focal,
          focalRadius: focalRadius,
          transform: transform,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

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
    return onlyProps(
      center: Prop.maybe(center),
      radius: Prop.maybe(radius),
      tileMode: Prop.maybe(tileMode),
      focal: Prop.maybe(focal),
      focalRadius: Prop.maybe(focalRadius),
      transform: Prop.maybe(transform),
      colors: colors?.map(Prop.new).toList(),
      stops: stops?.map(Prop.new).toList(),
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
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends Style<Object?>>
    extends MixPropUtility<T, SweepGradient> {
  /// Utility for defining [SweepGradientMix.center]
  late final center = PropUtility<T, AlignmentGeometry>(
    (v) => onlyProps(center: v),
  );

  /// Utility for defining [SweepGradientMix.startAngle]
  late final startAngle = PropUtility<T, double>(
    (prop) => onlyProps(startAngle: prop),
  );

  /// Utility for defining [SweepGradientMix.endAngle]
  late final endAngle = PropUtility<T, double>(
    (prop) => onlyProps(endAngle: prop),
  );

  /// Utility for defining [SweepGradientMix.tileMode]
  late final tileMode = PropUtility<T, TileMode>(
    (prop) => onlyProps(tileMode: prop),
  );

  /// Utility for defining [SweepGradientMix.transform]
  late final transform = PropUtility<T, GradientTransform>(
    (v) => onlyProps(transform: v),
  );

  /// Utility for defining [SweepGradientMix.colors]
  late final colors = PropListUtility<T, Color>(
    (colors) => onlyProps(colors: colors),
  );

  /// Utility for defining [SweepGradientMix.stops]
  late final stops = PropListUtility<T, double>(
    (stops) => onlyProps(stops: stops),
  );

  SweepGradientUtility(super.builder)
    : super(convertToMix: SweepGradientMix.value);

  @protected
  T onlyProps({
    Prop<AlignmentGeometry>? center,
    Prop<double>? startAngle,
    Prop<double>? endAngle,
    Prop<TileMode>? tileMode,
    Prop<GradientTransform>? transform,
    List<Prop<Color>>? colors,
    List<Prop<double>>? stops,
  }) {
    return builder(
      MixProp(
        SweepGradientMix.raw(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          tileMode: tileMode,
          transform: transform,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }

  T only({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return onlyProps(
      center: Prop.maybe(center),
      startAngle: Prop.maybe(startAngle),
      endAngle: Prop.maybe(endAngle),
      tileMode: Prop.maybe(tileMode),
      transform: Prop.maybe(transform),
      colors: colors?.map(Prop.new).toList(),
      stops: stops?.map(Prop.new).toList(),
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

  T call(GradientMix value) => builder(MixProp(value));
}

import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'gradient_dto.dart';
import 'scalar_util.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
final class LinearGradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, LinearGradient> {
  /// Utility for defining [LinearGradientDto.begin]
  late final begin = AlignmentGeometryUtility<T>(
    (v) => call(LinearGradientDto(begin: v)),
  );

  /// Utility for defining [LinearGradientDto.end]
  late final end = AlignmentGeometryUtility<T>(
    (v) => call(LinearGradientDto(end: v)),
  );

  /// Utility for defining [LinearGradientDto.tileMode]
  late final tileMode = TileModeUtility<T>(
    (v) => call(LinearGradientDto(tileMode: v)),
  );

  /// Utility for defining [LinearGradientDto.transform]
  late final transform = GradientTransformUtility<T>(
    (v) => call(LinearGradientDto(transform: v)),
  );

  /// Utility for defining [LinearGradientDto.colors]
  late final colors = ColorListUtility<T>(
    (v) => call(LinearGradientDto(colors: v)),
  );

  /// Utility for defining [LinearGradientDto.stops]
  late final stops = DoubleListUtility<T>(
    (v) => call(LinearGradientDto(stops: v)),
  );

  LinearGradientUtility(super.builder)
    : super(valueToMix: LinearGradientDto.value);

  @override
  T call(LinearGradientDto value) => builder(MixProp(value));
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
final class RadialGradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, RadialGradient> {
  /// Utility for defining [RadialGradientDto.center]
  late final center = AlignmentGeometryUtility<T>(
    (v) => call(RadialGradientDto(center: v)),
  );

  /// Utility for defining [RadialGradientDto.radius]
  late final radius = DoubleUtility<T>(
    (prop) => call(RadialGradientDto(radius: prop)),
  );

  /// Utility for defining [RadialGradientDto.tileMode]
  late final tileMode = TileModeUtility<T>(
    (v) => call(RadialGradientDto(tileMode: v)),
  );

  /// Utility for defining [RadialGradientDto.focal]
  late final focal = AlignmentGeometryUtility<T>(
    (v) => call(RadialGradientDto(focal: v)),
  );

  /// Utility for defining [RadialGradientDto.focalRadius]
  late final focalRadius = DoubleUtility<T>(
    (prop) => call(RadialGradientDto(focalRadius: prop)),
  );

  /// Utility for defining [RadialGradientDto.transform]
  late final transform = GradientTransformUtility<T>(
    (v) => call(RadialGradientDto(transform: v)),
  );

  /// Utility for defining [RadialGradientDto.colors]
  late final colors = ColorListUtility<T>(
    (v) => call(RadialGradientDto(colors: v)),
  );

  /// Utility for defining [RadialGradientDto.stops]
  late final stops = DoubleListUtility<T>(
    (v) => call(RadialGradientDto(stops: v)),
  );

  RadialGradientUtility(super.builder)
    : super(valueToMix: RadialGradientDto.value);

  @override
  T call(RadialGradientDto value) => builder(MixProp(value));
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
final class SweepGradientUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, SweepGradient> {
  /// Utility for defining [SweepGradientDto.center]
  late final center = AlignmentGeometryUtility<T>(
    (v) => call(SweepGradientDto(center: v)),
  );

  /// Utility for defining [SweepGradientDto.startAngle]
  late final startAngle = DoubleUtility<T>(
    (prop) => call(SweepGradientDto(startAngle: prop)),
  );

  /// Utility for defining [SweepGradientDto.endAngle]
  late final endAngle = DoubleUtility<T>(
    (prop) => call(SweepGradientDto(endAngle: prop)),
  );

  /// Utility for defining [SweepGradientDto.tileMode]
  late final tileMode = TileModeUtility<T>(
    (v) => call(SweepGradientDto(tileMode: v)),
  );

  /// Utility for defining [SweepGradientDto.transform]
  late final transform = GradientTransformUtility<T>(
    (v) => call(SweepGradientDto(transform: v)),
  );

  /// Utility for defining [SweepGradientDto.colors]
  late final colors = ColorListUtility<T>(
    (v) => call(SweepGradientDto(colors: v)),
  );

  /// Utility for defining [SweepGradientDto.stops]
  late final stops = DoubleListUtility<T>(
    (v) => call(SweepGradientDto(stops: v)),
  );

  SweepGradientUtility(super.builder)
    : super(valueToMix: SweepGradientDto.value);

  @override
  T call(SweepGradientDto value) => builder(MixProp(value));
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

  GradientUtility(super.builder) : super(valueToMix: GradientDto.value);

  @override
  T call(GradientDto value) => builder(MixProp(value));
}

/// Utility class for creating List<Prop<Color>> from List<Color>
final class ColorListUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, List<Prop<Color>>> {
  const ColorListUtility(super.builder);

  T call(List<Color> colors) {
    return builder(colors.map(Prop.new).toList());
  }
}

/// Utility class for creating List<Prop<double>> from List<double>
final class DoubleListUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, List<Prop<double>>> {
  const DoubleListUtility(super.builder);

  T call(List<double> stops) {
    return builder(stops.map(Prop.new).toList());
  }
}

import 'package:flutter/widgets.dart';

import '../../core/spec.dart';
import '../../core/utility.dart';
import '../../internal/constants.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'gradient_dto.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
class LinearGradientUtility<T extends SpecAttribute>
    extends DtoUtility<T, LinearGradientDto, LinearGradient> {
  /// Utility for defining [LinearGradientDto.begin]
  late final begin = AlignmentGeometryUtility((v) => only(begin: v));

  /// Utility for defining [LinearGradientDto.end]
  late final end = AlignmentGeometryUtility((v) => only(end: v));

  /// Utility for defining [LinearGradientDto.tileMode]
  late final tileMode = TileModeUtility((v) => only(tileMode: v));

  /// Utility for defining [LinearGradientDto.transform]
  late final transform = GradientTransformUtility((v) => call(transform: v));

  /// Utility for defining [LinearGradientDto.colors]
  late final colors = ListUtility<T, Color>((v) => only(colors: v));

  /// Utility for defining [LinearGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  LinearGradientUtility(super.builder)
    : super(valueToDto: LinearGradientDto.value);

  T call({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return builder(
      LinearGradientDto(
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
        colors: colors,
        stops: stops,
      ),
    );
  }

  /// Returns a new [LinearGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return builder(
      LinearGradientDto(
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
        colors: colors,
        stops: stops,
      ),
    );
  }
}

/// Utility class for configuring [RadialGradient] properties.
///
/// This class provides methods to set individual properties of a [RadialGradient].
/// Use the methods of this class to configure specific properties of a [RadialGradient].
class RadialGradientUtility<T extends SpecAttribute>
    extends DtoUtility<T, RadialGradientDto, RadialGradient> {
  /// Utility for defining [RadialGradientDto.center]
  late final center = AlignmentGeometryUtility((v) => only(center: v));

  /// Utility for defining [RadialGradientDto.radius]
  late final radius = DoubleUtility((prop) => only(radius: prop.value));

  /// Utility for defining [RadialGradientDto.tileMode]
  late final tileMode = TileModeUtility((v) => only(tileMode: v));

  /// Utility for defining [RadialGradientDto.focal]
  late final focal = AlignmentGeometryUtility((v) => only(focal: v));

  /// Utility for defining [RadialGradientDto.focalRadius]
  late final focalRadius = DoubleUtility(
    (prop) => only(focalRadius: prop.value),
  );

  /// Utility for defining [RadialGradientDto.transform]
  late final transform = GradientTransformUtility((v) => call(transform: v));

  /// Utility for defining [RadialGradientDto.colors]
  late final colors = ListUtility<T, Color>((v) => only(colors: v));

  /// Utility for defining [RadialGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  RadialGradientUtility(super.builder)
    : super(valueToDto: RadialGradientDto.value);

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
    return builder(
      RadialGradientDto(
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

  /// Returns a new [RadialGradientDto] with the specified properties.
  @override
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
      RadialGradientDto(
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
}

/// Utility class for configuring [SweepGradient] properties.
///
/// This class provides methods to set individual properties of a [SweepGradient].
/// Use the methods of this class to configure specific properties of a [SweepGradient].
class SweepGradientUtility<T extends SpecAttribute>
    extends DtoUtility<T, SweepGradientDto, SweepGradient> {
  /// Utility for defining [SweepGradientDto.center]
  late final center = AlignmentGeometryUtility((v) => only(center: v));

  /// Utility for defining [SweepGradientDto.startAngle]
  late final startAngle = DoubleUtility((prop) => only(startAngle: prop.value));

  /// Utility for defining [SweepGradientDto.endAngle]
  late final endAngle = DoubleUtility((prop) => only(endAngle: prop.value));

  /// Utility for defining [SweepGradientDto.tileMode]
  late final tileMode = TileModeUtility((v) => only(tileMode: v));

  /// Utility for defining [SweepGradientDto.transform]
  late final transform = GradientTransformUtility((v) => call(transform: v));

  /// Utility for defining [SweepGradientDto.colors]
  late final colors = ListUtility<T, Color>((v) => only(colors: v));

  /// Utility for defining [SweepGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  SweepGradientUtility(super.builder)
    : super(valueToDto: SweepGradientDto.value);

  T call({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return builder(
      SweepGradientDto(
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

  /// Returns a new [SweepGradientDto] with the specified properties.
  @override
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
      SweepGradientDto(
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
}

/// A utility class for working with gradients.
///
/// This class provides convenient methods for creating different types of gradients,
/// such as radial gradients, linear gradients, and sweep gradients.
/// It also provides a method for converting a generic [Gradient] object to a specific type [T].
///
/// Accepts a [builder] function that takes a [GradientDto] and returns an object of type [T].
final class GradientUtility<T extends SpecAttribute>
    extends MixUtility<T, GradientDto> {
  late final radial = RadialGradientUtility(builder);
  late final linear = LinearGradientUtility(builder);
  late final sweep = SweepGradientUtility(builder);

  GradientUtility(super.builder);

  /// Converts a [Gradient] object to the specific type [T].
  ///
  /// Throws an [UnimplementedError] if the given gradient type is not supported.
  T as(Gradient gradient) {
    switch (gradient) {
      case RadialGradient():
        return radial.as(gradient);
      case LinearGradient():
        return linear.as(gradient);
      case SweepGradient():
        return sweep.as(gradient);
    }

    throw FlutterError.fromParts([
      ErrorSummary('Mix does not support custom gradient implementations.'),
      ErrorDescription(
        'The provided gradient of type ${gradient.runtimeType} is not supported.',
      ),
      ErrorHint(
        'If you believe this gradient type should be supported, please open an issue at '
        '$mixIssuesUrl with details about your implementation '
        'and its use case.',
      ),
    ]);
  }
}

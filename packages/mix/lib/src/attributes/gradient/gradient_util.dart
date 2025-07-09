import 'package:flutter/widgets.dart';

import '../../core/factory/mix_context.dart';
import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../../internal/constants.dart';
import '../enum/enum_util.dart';
import '../scalars/scalar_util.dart';
import 'gradient_dto.dart';

/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
class LinearGradientUtility<T extends StyleElement>
    extends DtoUtility<T, LinearGradientDto, LinearGradient> {
  /// Utility for defining [LinearGradientDto.begin]
  late final begin = AlignmentGeometryUtility(
    (v) => only(begin: AligmentGeometryMix(v)),
  );

  /// Utility for defining [LinearGradientDto.end]
  late final end = AlignmentGeometryUtility(
    (v) => only(end: AligmentGeometryMix(v)),
  );

  /// Utility for defining [LinearGradientDto.tileMode]
  late final tileMode = TileModeUtility(
    (v) => only(tileMode: EnumMix(v)),
  );

  /// Utility for defining [LinearGradientDto.transform]
  late final transform = GradientTransformUtility(
    (v) => call(transform: v),
  );

  /// Utility for defining [LinearGradientDto.colors]
  late final colors = ListUtility<T, Mix<Color>>(
    (v) => only(colors: _ListColorMix(v)),
  );

  /// Utility for defining [LinearGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: _ListDoubleMix(v)));

  LinearGradientUtility(super.builder)
    : super(
        valueToDto: (v) => LinearGradientDto(
          begin: v.begin != null ? AligmentGeometryMix(v.begin!) : null,
          end: v.end != null ? AligmentGeometryMix(v.end!) : null,
          tileMode: v.tileMode != null ? EnumMix(v.tileMode!) : null,
          transform: v.transform != null ? GradientTransformMix(v.transform!) : null,
          colors: v.colors.isNotEmpty ? 
            _ListColorMix(v.colors.map((c) => ColorMix(c)).toList()) : null,
          stops: v.stops != null ? _ListDoubleMix(v.stops!) : null,
        ),
      );

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
        begin: begin != null ? AligmentGeometryMix(begin) : null,
        end: end != null ? AligmentGeometryMix(end) : null,
        tileMode: tileMode != null ? EnumMix(tileMode) : null,
        transform: transform != null ? GradientTransformMix(transform) : null,
        colors: colors != null ? 
          _ListColorMix(colors.map((c) => ColorMix(c)).toList()) : null,
        stops: stops != null ? _ListDoubleMix(stops) : null,
      ),
    );
  }

  /// Returns a new [LinearGradientDto] with the specified properties.
  @override
  T only({
    Mix<AlignmentGeometry>? begin,
    Mix<AlignmentGeometry>? end,
    Mix<TileMode>? tileMode,
    Mix<GradientTransform>? transform,
    Mix<List<Color>>? colors,
    Mix<List<double>>? stops,
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
class RadialGradientUtility<T extends StyleElement>
    extends DtoUtility<T, RadialGradientDto, RadialGradient> {
  /// Utility for defining [RadialGradientDto.center]
  late final center = AlignmentGeometryUtility(
    (v) => only(center: AligmentGeometryMix(v)),
  );

  /// Utility for defining [RadialGradientDto.radius]
  late final radius = DoubleUtility(
    (v) => only(radius: DoubleMix(v)),
  );

  /// Utility for defining [RadialGradientDto.tileMode]
  late final tileMode = TileModeUtility(
    (v) => only(tileMode: EnumMix(v)),
  );

  /// Utility for defining [RadialGradientDto.focal]
  late final focal = AlignmentGeometryUtility(
    (v) => only(focal: AligmentGeometryMix(v)),
  );

  /// Utility for defining [RadialGradientDto.focalRadius]
  late final focalRadius = DoubleUtility(
    (v) => only(focalRadius: DoubleMix(v)),
  );

  /// Utility for defining [RadialGradientDto.transform]
  late final transform = GradientTransformUtility(
    (v) => call(transform: v),
  );

  /// Utility for defining [RadialGradientDto.colors]
  late final colors = ListUtility<T, Mix<Color>>(
    (v) => only(colors: _ListColorMix(v)),
  );

  /// Utility for defining [RadialGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: _ListDoubleMix(v)));

  RadialGradientUtility(super.builder)
    : super(
        valueToDto: (v) => RadialGradientDto(
          center: v.center != null ? AligmentGeometryMix(v.center!) : null,
          radius: v.radius != null ? DoubleMix(v.radius!) : null,
          tileMode: v.tileMode != null ? EnumMix(v.tileMode!) : null,
          focal: v.focal != null ? AligmentGeometryMix(v.focal!) : null,
          focalRadius: v.focalRadius != null ? DoubleMix(v.focalRadius!) : null,
          transform: v.transform != null ? GradientTransformMix(v.transform!) : null,
          colors: v.colors.isNotEmpty ? 
            _ListColorMix(v.colors.map((c) => ColorMix(c)).toList()) : null,
          stops: v.stops != null ? _ListDoubleMix(v.stops!) : null,
        ),
      );

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
        center: center != null ? AligmentGeometryMix(center) : null,
        radius: radius != null ? DoubleMix(radius) : null,
        tileMode: tileMode != null ? EnumMix(tileMode) : null,
        focal: focal != null ? AligmentGeometryMix(focal) : null,
        focalRadius: focalRadius != null ? DoubleMix(focalRadius) : null,
        transform: transform != null ? GradientTransformMix(transform) : null,
        colors: colors != null ? 
          _ListColorMix(colors.map((c) => ColorMix(c)).toList()) : null,
        stops: stops != null ? _ListDoubleMix(stops) : null,
      ),
    );
  }

  /// Returns a new [RadialGradientDto] with the specified properties.
  @override
  T only({
    Mix<AlignmentGeometry>? center,
    Mix<double>? radius,
    Mix<TileMode>? tileMode,
    Mix<AlignmentGeometry>? focal,
    Mix<double>? focalRadius,
    Mix<GradientTransform>? transform,
    Mix<List<Color>>? colors,
    Mix<List<double>>? stops,
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
class SweepGradientUtility<T extends StyleElement>
    extends DtoUtility<T, SweepGradientDto, SweepGradient> {
  /// Utility for defining [SweepGradientDto.center]
  late final center = AlignmentGeometryUtility(
    (v) => only(center: AligmentGeometryMix(v)),
  );

  /// Utility for defining [SweepGradientDto.startAngle]
  late final startAngle = DoubleUtility(
    (v) => only(startAngle: DoubleMix(v)),
  );

  /// Utility for defining [SweepGradientDto.endAngle]
  late final endAngle = DoubleUtility(
    (v) => only(endAngle: DoubleMix(v)),
  );

  /// Utility for defining [SweepGradientDto.tileMode]
  late final tileMode = TileModeUtility(
    (v) => only(tileMode: EnumMix(v)),
  );

  /// Utility for defining [SweepGradientDto.transform]
  late final transform = GradientTransformUtility(
    (v) => call(transform: v),
  );

  /// Utility for defining [SweepGradientDto.colors]
  late final colors = ListUtility<T, Mix<Color>>(
    (v) => only(colors: _ListColorMix(v)),
  );

  /// Utility for defining [SweepGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: _ListDoubleMix(v)));

  SweepGradientUtility(super.builder)
    : super(
        valueToDto: (v) => SweepGradientDto(
          center: v.center != null ? AligmentGeometryMix(v.center!) : null,
          startAngle: v.startAngle != null ? DoubleMix(v.startAngle!) : null,
          endAngle: v.endAngle != null ? DoubleMix(v.endAngle!) : null,
          tileMode: v.tileMode != null ? EnumMix(v.tileMode!) : null,
          transform: v.transform != null ? GradientTransformMix(v.transform!) : null,
          colors: v.colors.isNotEmpty ? 
            _ListColorMix(v.colors.map((c) => ColorMix(c)).toList()) : null,
          stops: v.stops != null ? _ListDoubleMix(v.stops!) : null,
        ),
      );

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
        center: center != null ? AligmentGeometryMix(center) : null,
        startAngle: startAngle != null ? DoubleMix(startAngle) : null,
        endAngle: endAngle != null ? DoubleMix(endAngle) : null,
        tileMode: tileMode != null ? EnumMix(tileMode) : null,
        transform: transform != null ? GradientTransformMix(transform) : null,
        colors: colors != null ? 
          _ListColorMix(colors.map((c) => ColorMix(c)).toList()) : null,
        stops: stops != null ? _ListDoubleMix(stops) : null,
      ),
    );
  }

  /// Returns a new [SweepGradientDto] with the specified properties.
  @override
  T only({
    Mix<AlignmentGeometry>? center,
    Mix<double>? startAngle,
    Mix<double>? endAngle,
    Mix<TileMode>? tileMode,
    Mix<GradientTransform>? transform,
    Mix<List<Color>>? colors,
    Mix<List<double>>? stops,
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
final class GradientUtility<T extends StyleElement>
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

// Helper class to create Mix<List<Color>> from List<Mix<Color>>
class _ListColorMix extends Mix<List<Color>> {
  final List<Mix<Color>> _colors;
  const _ListColorMix(this._colors);

  @override
  List<Color> resolve(MixContext mix) {
    return _colors.map((c) => c.resolve(mix)).toList();
  }

  @override
  Mix<List<Color>> merge(Mix<List<Color>>? other) {
    return other ?? this;
  }

  @override
  get props => [_colors];
}

// Helper class to create Mix<List<double>> from List<double>
class _ListDoubleMix extends Mix<List<double>> {
  final List<double> _values;
  const _ListDoubleMix(this._values);

  @override
  List<double> resolve(MixContext mix) {
    return _values;
  }

  @override
  Mix<List<double>> merge(Mix<List<double>>? other) {
    return other ?? this;
  }

  @override
  get props => [_values];
}
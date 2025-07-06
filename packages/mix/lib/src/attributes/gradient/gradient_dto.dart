// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../internal/constants.dart';
import '../../internal/mix_error.dart';

/// Represents a base Data transfer object of [Gradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[Gradient]
@immutable
sealed class GradientDto<T extends Gradient> extends Mixable<T>
    with HasDefaultValue<T> {
  final List<double>? stops;
  final List<ColorDto>? colors;
  final GradientTransform? transform;
  const GradientDto({this.stops, this.colors, this.transform});

  static B _exhaustiveMerge<A extends GradientDto, B extends GradientDto>(
    A a,
    B b,
  ) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (LinearGradientDto g) => a.asLinearGradient().merge(g) as B,
      (RadialGradientDto g) => a.asRadialGradient().merge(g) as B,
      (SweepGradientDto g) => a.asSweepGradient().merge(g) as B,
    };
  }

  static GradientDto? tryToMerge(GradientDto? a, GradientDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  LinearGradientDto asLinearGradient() {
    return LinearGradientDto(
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  RadialGradientDto asRadialGradient() {
    return RadialGradientDto(
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  SweepGradientDto asSweepGradient() {
    return SweepGradientDto(
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  @override
  GradientDto<T> merge(covariant GradientDto<T>? other);
}

/// Represents a Data transfer object of [LinearGradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[LinearGradient]

final class LinearGradientDto extends GradientDto<LinearGradient> {
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final TileMode? tileMode;

  const LinearGradientDto({
    this.begin,
    this.end,
    this.tileMode,
    super.transform,
    super.colors,
    super.stops,
  });
  
  @override
  LinearGradient get defaultValue => const LinearGradient(colors: []);

  @override
  LinearGradient resolve(MixContext mix) {
    return LinearGradient(
      begin: begin ?? defaultValue.begin,
      end: end ?? defaultValue.end,
      tileMode: tileMode ?? defaultValue.tileMode,
      transform: transform ?? defaultValue.transform,
      colors: colors?.map((e) => e.resolve(mix)).toList() ?? defaultValue.colors,
      stops: stops ?? defaultValue.stops,
    );
  }

  @override
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return this;

    return LinearGradientDto(
      begin: other.begin ?? begin,
      end: other.end ?? end,
      tileMode: other.tileMode ?? tileMode,
      transform: other.transform ?? transform,
      colors: MixHelpers.mergeList(colors, other.colors),
      stops: MixHelpers.mergeList(stops, other.stops),
    );
  }

  @override
  List<Object?> get props => [
        begin,
        end,
        tileMode,
        transform,
        colors,
        stops,
      ];
}

/// Represents a Data transfer object of [RadialGradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[RadialGradient]
final class RadialGradientDto extends GradientDto<RadialGradient> {
  final AlignmentGeometry? center;
  final double? radius;

  // focalRadius
  final TileMode? tileMode;
  final AlignmentGeometry? focal;

  final double? focalRadius;

  const RadialGradientDto({
    this.center,
    this.radius,
    this.tileMode,
    this.focal,
    this.focalRadius,
    super.transform,
    super.colors,
    super.stops,
  });
  
  @override
  RadialGradient get defaultValue => const RadialGradient(colors: []);

  @override
  RadialGradient resolve(MixContext mix) {
    return RadialGradient(
      center: center ?? defaultValue.center,
      radius: radius ?? defaultValue.radius,
      tileMode: tileMode ?? defaultValue.tileMode,
      focal: focal ?? defaultValue.focal,
      focalRadius: focalRadius ?? defaultValue.focalRadius,
      transform: transform ?? defaultValue.transform,
      colors: colors?.map((e) => e.resolve(mix)).toList() ?? defaultValue.colors,
      stops: stops ?? defaultValue.stops,
    );
  }

  @override
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return this;

    return RadialGradientDto(
      center: other.center ?? center,
      radius: other.radius ?? radius,
      tileMode: other.tileMode ?? tileMode,
      focal: other.focal ?? focal,
      focalRadius: other.focalRadius ?? focalRadius,
      transform: other.transform ?? transform,
      colors: MixHelpers.mergeList(colors, other.colors),
      stops: MixHelpers.mergeList(stops, other.stops),
    );
  }

  @override
  List<Object?> get props => [
        center,
        radius,
        tileMode,
        focal,
        focalRadius,
        transform,
        colors,
        stops,
      ];
}

/// Represents a Data transfer object of [SweepGradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[SweepGradient]

final class SweepGradientDto extends GradientDto<SweepGradient> {
  final AlignmentGeometry? center;
  final double? startAngle;
  final double? endAngle;

  final TileMode? tileMode;

  const SweepGradientDto({
    this.center,
    this.startAngle,
    this.endAngle,
    this.tileMode,
    super.transform,
    super.colors,
    super.stops,
  });
  
  @override
  SweepGradient get defaultValue => const SweepGradient(colors: []);

  @override
  SweepGradient resolve(MixContext mix) {
    return SweepGradient(
      center: center ?? defaultValue.center,
      startAngle: startAngle ?? defaultValue.startAngle,
      endAngle: endAngle ?? defaultValue.endAngle,
      tileMode: tileMode ?? defaultValue.tileMode,
      transform: transform ?? defaultValue.transform,
      colors: colors?.map((e) => e.resolve(mix)).toList() ?? defaultValue.colors,
      stops: stops ?? defaultValue.stops,
    );
  }

  @override
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return this;

    return SweepGradientDto(
      center: other.center ?? center,
      startAngle: other.startAngle ?? startAngle,
      endAngle: other.endAngle ?? endAngle,
      tileMode: other.tileMode ?? tileMode,
      transform: other.transform ?? transform,
      colors: MixHelpers.mergeList(colors, other.colors),
      stops: MixHelpers.mergeList(stops, other.stops),
    );
  }

  @override
  List<Object?> get props => [
        center,
        startAngle,
        endAngle,
        tileMode,
        transform,
        colors,
        stops,
      ];
}

extension GradientExt on Gradient {
  // toDto
  GradientDto toDto() {
    final self = this;
    if (self is LinearGradient) return (self).toDto();
    if (self is RadialGradient) return (self).toDto();
    if (self is SweepGradient) return (self).toDto();

    throw MixError.unsupportedTypeInDto(
      Gradient,
      ['LinearGradient', 'RadialGradient', 'SweepGradient'],
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
/// Utility class for configuring [LinearGradient] properties.
///
/// This class provides methods to set individual properties of a [LinearGradient].
/// Use the methods of this class to configure specific properties of a [LinearGradient].
class LinearGradientUtility<T extends StyleElement>
    extends DtoUtility<T, LinearGradientDto, LinearGradient> {
  /// Utility for defining [LinearGradientDto.begin]
  late final begin = AlignmentGeometryUtility((v) => only(begin: v));

  /// Utility for defining [LinearGradientDto.end]
  late final end = AlignmentGeometryUtility((v) => only(end: v));

  /// Utility for defining [LinearGradientDto.tileMode]
  late final tileMode = TileModeUtility((v) => only(tileMode: v));

  /// Utility for defining [LinearGradientDto.transform]
  late final transform = GradientTransformUtility((v) => only(transform: v));

  /// Utility for defining [LinearGradientDto.colors]
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));

  /// Utility for defining [LinearGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  LinearGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [LinearGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<double>? stops,
  }) {
    return builder(LinearGradientDto(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    ));
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
      colors: colors?.map((e) => Mixable.value(e)).toList(),
      stops: stops,
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
  late final center = AlignmentGeometryUtility((v) => only(center: v));

  /// Utility for defining [RadialGradientDto.radius]
  late final radius = DoubleUtility((v) => only(radius: v));

  /// Utility for defining [RadialGradientDto.tileMode]
  late final tileMode = TileModeUtility((v) => only(tileMode: v));

  /// Utility for defining [RadialGradientDto.focal]
  late final focal = AlignmentGeometryUtility((v) => only(focal: v));

  /// Utility for defining [RadialGradientDto.focalRadius]
  late final focalRadius = DoubleUtility((v) => only(focalRadius: v));

  /// Utility for defining [RadialGradientDto.transform]
  late final transform = GradientTransformUtility((v) => only(transform: v));

  /// Utility for defining [RadialGradientDto.colors]
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));

  /// Utility for defining [RadialGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  RadialGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [RadialGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<double>? stops,
  }) {
    return builder(RadialGradientDto(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: colors,
      stops: stops,
    ));
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
      colors: colors?.map((e) => Mixable.value(e)).toList(),
      stops: stops,
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
  late final center = AlignmentGeometryUtility((v) => only(center: v));

  /// Utility for defining [SweepGradientDto.startAngle]
  late final startAngle = DoubleUtility((v) => only(startAngle: v));

  /// Utility for defining [SweepGradientDto.endAngle]
  late final endAngle = DoubleUtility((v) => only(endAngle: v));

  /// Utility for defining [SweepGradientDto.tileMode]
  late final tileMode = TileModeUtility((v) => only(tileMode: v));

  /// Utility for defining [SweepGradientDto.transform]
  late final transform = GradientTransformUtility((v) => only(transform: v));

  /// Utility for defining [SweepGradientDto.colors]
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));

  /// Utility for defining [SweepGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  SweepGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [SweepGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<double>? stops,
  }) {
    return builder(SweepGradientDto(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    ));
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
      colors: colors?.map((e) => Mixable.value(e)).toList(),
      stops: stops,
    );
  }
}

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

/// Extension methods to convert [LinearGradient] to [LinearGradientDto].
extension LinearGradientMixExt on LinearGradient {
  /// Converts this [LinearGradient] to a [LinearGradientDto].
  LinearGradientDto toDto() {
    return LinearGradientDto(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors.map((e) => Mixable.value(e)).toList(),
      stops: stops,
    );
  }
}

/// Extension methods to convert [RadialGradient] to [RadialGradientDto].
extension RadialGradientMixExt on RadialGradient {
  /// Converts this [RadialGradient] to a [RadialGradientDto].
  RadialGradientDto toDto() {
    return RadialGradientDto(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: colors.map((e) => Mixable.value(e)).toList(),
      stops: stops,
    );
  }
}

/// Extension methods to convert [SweepGradient] to [SweepGradientDto].
extension SweepGradientMixExt on SweepGradient {
  /// Converts this [SweepGradient] to a [SweepGradientDto].
  SweepGradientDto toDto() {
    return SweepGradientDto(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: colors.map((e) => Mixable.value(e)).toList(),
      stops: stops,
    );
  }
}

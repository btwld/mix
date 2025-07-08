// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../internal/constants.dart';

/// Represents a base Data transfer object of [Gradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[Gradient]
@immutable
sealed class GradientDto<T extends Gradient> extends Mix<T>
    with HasDefaultValue<T> {
  final List<double>? stops;
  final MixProperty<List<Color>> colors;
  final GradientTransform? transform;
  const GradientDto({this.stops, required this.colors, this.transform});

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
    return LinearGradientDto.raw(
      begin: null,
      end: null,
      tileMode: null,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  RadialGradientDto asRadialGradient() {
    return RadialGradientDto.raw(
      center: null,
      radius: null,
      tileMode: null,
      focal: null,
      focalRadius: null,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  SweepGradientDto asSweepGradient() {
    return SweepGradientDto.raw(
      center: null,
      startAngle: null,
      endAngle: null,
      tileMode: null,
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

  factory LinearGradientDto({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return LinearGradientDto.raw(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: MixProperty.prop(colors),
      stops: stops,
    );
  }

  const LinearGradientDto.raw({
    this.begin,
    this.end,
    this.tileMode,
    super.transform,
    required super.colors,
    super.stops,
  });

  // Factory from LinearGradient
  factory LinearGradientDto.from(LinearGradient gradient) {
    return LinearGradientDto(
      begin: gradient.begin,
      end: gradient.end,
      tileMode: gradient.tileMode,
      transform: gradient.transform,
      colors: gradient.colors,
      stops: gradient.stops,
    );
  }

  /// Creates a LinearGradientDto from a nullable LinearGradient value
  /// Returns null if the value is null, otherwise uses LinearGradientDto.from
  static LinearGradientDto? maybeFrom(LinearGradient? value) {
    return value != null ? LinearGradientDto.from(value) : null;
  }

  @override
  LinearGradient resolve(MixContext mix) {
    return LinearGradient(
      begin: begin ?? defaultValue.begin,
      end: end ?? defaultValue.end,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops ?? defaultValue.stops,
      tileMode: tileMode ?? defaultValue.tileMode,
      transform: transform ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return this;

    return LinearGradientDto.raw(
      begin: other.begin ?? begin,
      end: other.end ?? end,
      tileMode: other.tileMode ?? tileMode,
      transform: other.transform ?? transform,
      colors: colors.merge(other.colors),
      stops: MixHelpers.mergeList(stops, other.stops),
    );
  }

  @override
  LinearGradient get defaultValue => const LinearGradient(colors: []);

  @override
  List<Object?> get props => [begin, end, tileMode, transform, colors, stops];
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

  factory RadialGradientDto({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return RadialGradientDto.raw(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: MixProperty.prop(colors),
      stops: stops,
    );
  }

  const RadialGradientDto.raw({
    this.center,
    this.radius,
    this.tileMode,
    this.focal,
    this.focalRadius,
    super.transform,
    required super.colors,
    super.stops,
  });

  // Factory from RadialGradient
  factory RadialGradientDto.from(RadialGradient gradient) {
    return RadialGradientDto(
      center: gradient.center,
      radius: gradient.radius,
      tileMode: gradient.tileMode,
      focal: gradient.focal,
      focalRadius: gradient.focalRadius,
      transform: gradient.transform,
      colors: gradient.colors,
      stops: gradient.stops,
    );
  }

  /// Creates a RadialGradientDto from a nullable RadialGradient value
  /// Returns null if the value is null, otherwise uses RadialGradientDto.from
  static RadialGradientDto? maybeFrom(RadialGradient? value) {
    return value != null ? RadialGradientDto.from(value) : null;
  }

  @override
  RadialGradient resolve(MixContext mix) {
    return RadialGradient(
      center: center ?? defaultValue.center,
      radius: radius ?? defaultValue.radius,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops ?? defaultValue.stops,
      tileMode: tileMode ?? defaultValue.tileMode,
      focal: focal ?? defaultValue.focal,
      focalRadius: focalRadius ?? defaultValue.focalRadius,
      transform: transform ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return this;

    return RadialGradientDto.raw(
      center: other.center ?? center,
      radius: other.radius ?? radius,
      tileMode: other.tileMode ?? tileMode,
      focal: other.focal ?? focal,
      focalRadius: other.focalRadius ?? focalRadius,
      transform: other.transform ?? transform,
      colors: colors.merge(other.colors),
      stops: MixHelpers.mergeList(stops, other.stops),
    );
  }

  @override
  RadialGradient get defaultValue => const RadialGradient(colors: []);

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

  factory SweepGradientDto({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return SweepGradientDto.raw(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: MixProperty.prop(colors),
      stops: stops,
    );
  }

  const SweepGradientDto.raw({
    this.center,
    this.startAngle,
    this.endAngle,
    this.tileMode,
    super.transform,
    required super.colors,
    super.stops,
  });

  // Factory from SweepGradient
  factory SweepGradientDto.from(SweepGradient gradient) {
    return SweepGradientDto(
      center: gradient.center,
      startAngle: gradient.startAngle,
      endAngle: gradient.endAngle,
      tileMode: gradient.tileMode,
      transform: gradient.transform,
      colors: gradient.colors,
      stops: gradient.stops,
    );
  }

  /// Creates a SweepGradientDto from a nullable SweepGradient value
  /// Returns null if the value is null, otherwise uses SweepGradientDto.from
  static SweepGradientDto? maybeFrom(SweepGradient? value) {
    return value != null ? SweepGradientDto.from(value) : null;
  }

  @override
  SweepGradient resolve(MixContext mix) {
    return SweepGradient(
      center: center ?? defaultValue.center,
      startAngle: startAngle ?? defaultValue.startAngle,
      endAngle: endAngle ?? defaultValue.endAngle,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops ?? defaultValue.stops,
      tileMode: tileMode ?? defaultValue.tileMode,
      transform: transform ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return this;

    return SweepGradientDto.raw(
      center: other.center ?? center,
      startAngle: other.startAngle ?? startAngle,
      endAngle: other.endAngle ?? endAngle,
      tileMode: other.tileMode ?? tileMode,
      transform: other.transform ?? transform,
      colors: colors.merge(other.colors),
      stops: MixHelpers.mergeList(stops, other.stops),
    );
  }

  @override
  SweepGradient get defaultValue => const SweepGradient(colors: []);

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
  late final colors = ListUtility<T, Mix<Color>>((v) => only(colors: v));

  /// Utility for defining [LinearGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  LinearGradientUtility(super.builder)
    : super(
        valueToDto: (v) => LinearGradientDto(
          begin: v.begin,
          end: v.end,
          tileMode: v.tileMode,
          transform: v.transform,
          colors: v.colors,
          stops: v.stops,
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
    return only(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors?.map((e) => Mix.value(e)).toList(),
      stops: stops,
    );
  }

  /// Returns a new [LinearGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mix<Color>>? colors,
    List<double>? stops,
  }) {
    return builder(
      LinearGradientDto.raw(
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
        colors: MixProperty(colors != null ? MixableList(colors) : null),
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
  late final colors = ListUtility<T, Mix<Color>>((v) => only(colors: v));

  /// Utility for defining [RadialGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  RadialGradientUtility(super.builder)
    : super(
        valueToDto: (v) => RadialGradientDto(
          center: v.center,
          radius: v.radius,
          tileMode: v.tileMode,
          focal: v.focal,
          focalRadius: v.focalRadius,
          transform: v.transform,
          colors: v.colors,
          stops: v.stops,
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
    return only(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: colors?.map((e) => Mix.value(e)).toList(),
      stops: stops,
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
    List<Mix<Color>>? colors,
    List<double>? stops,
  }) {
    return builder(
      RadialGradientDto.raw(
        center: center,
        radius: radius,
        tileMode: tileMode,
        focal: focal,
        focalRadius: focalRadius,
        transform: transform,
        colors: MixProperty(colors != null ? MixableList(colors) : null),
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
  late final colors = ListUtility<T, Mix<Color>>((v) => only(colors: v));

  /// Utility for defining [SweepGradientDto.stops]
  late final stops = ListUtility<T, double>((v) => only(stops: v));

  SweepGradientUtility(super.builder)
    : super(
        valueToDto: (v) => SweepGradientDto(
          center: v.center,
          startAngle: v.startAngle,
          endAngle: v.endAngle,
          tileMode: v.tileMode,
          transform: v.transform,
          colors: v.colors,
          stops: v.stops,
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
    return only(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: colors?.map((e) => Mix.value(e)).toList(),
      stops: stops,
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
    List<Mix<Color>>? colors,
    List<double>? stops,
  }) {
    return builder(
      SweepGradientDto.raw(
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
        colors: MixProperty(colors != null ? MixableList(colors) : null),
        stops: stops,
      ),
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

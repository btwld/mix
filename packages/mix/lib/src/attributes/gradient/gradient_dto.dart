// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Represents a base Data transfer object of [Gradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[Gradient]
@immutable
sealed class GradientDto<T extends Gradient> extends Mix<T>
    with HasDefaultValue<T> {
  final Prop<List<double>>? stops;
  final Prop<List<Color>>? colors;
  final Prop<GradientTransform>? transform;
  const GradientDto({
    required this.stops,
    required this.colors,
    required this.transform,
  });

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

  static GradientDto<T> value<T extends Gradient>(T value) {
    return switch (value) {
      (LinearGradient v) => LinearGradientDto.value(v) as GradientDto<T>,
      (RadialGradient v) => RadialGradientDto.value(v) as GradientDto<T>,
      (SweepGradient v) => SweepGradientDto.value(v) as GradientDto<T>,
      _ => throw ArgumentError(
        'Unsupported Gradient type: ${value.runtimeType}',
      ),
    };
  }

  static GradientDto<T>? maybeValue<T extends Gradient>(T? value) {
    return value != null ? GradientDto.value(value) : null;
  }

  static GradientDto? tryToMerge(GradientDto? a, GradientDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  @protected
  LinearGradientDto asLinearGradient() {
    return LinearGradientDto.props(
      begin: null,
      end: null,
      tileMode: null,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  @protected
  RadialGradientDto asRadialGradient() {
    return RadialGradientDto.props(
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

  @protected
  SweepGradientDto asSweepGradient() {
    return SweepGradientDto.props(
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
  final Prop<AlignmentGeometry>? begin;
  final Prop<AlignmentGeometry>? end;
  final Prop<TileMode>? tileMode;

  factory LinearGradientDto({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return LinearGradientDto.props(
      begin: Prop.maybeValue(begin),
      end: Prop.maybeValue(end),
      tileMode: Prop.maybeValue(tileMode),
      transform: Prop.maybeValue(transform),
      colors: Prop.maybeValue(colors),
      stops: Prop.maybeValue(stops),
    );
  }

  /// Constructor that accepts a [LinearGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [LinearGradient] instances to [LinearGradientDto].
  ///
  /// ```dart
  /// const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = LinearGradientDto.value(gradient);
  /// ```
  factory LinearGradientDto.value(LinearGradient gradient) {
    return LinearGradientDto(
      begin: gradient.begin,
      end: gradient.end,
      tileMode: gradient.tileMode,
      transform: gradient.transform,
      colors: gradient.colors,
      stops: gradient.stops,
    );
  }

  const LinearGradientDto.props({
    required this.begin,
    required this.end,
    required this.tileMode,
    required super.transform,
    required super.colors,
    required super.stops,
  });

  /// Constructor that accepts a nullable [LinearGradient] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [LinearGradientDto.value].
  ///
  /// ```dart
  /// const LinearGradient? gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = LinearGradientDto.maybeValue(gradient); // Returns LinearGradientDto or null
  /// ```
  static LinearGradientDto? maybeValue(LinearGradient? gradient) {
    return gradient != null ? LinearGradientDto.value(gradient) : null;
  }

  @override
  LinearGradient resolve(MixContext context) {
    return LinearGradient(
      begin: resolveProp(context, begin) ?? defaultValue.begin,
      end: resolveProp(context, end) ?? defaultValue.end,
      colors: resolveProp(context, colors) ?? defaultValue.colors,
      stops: resolveProp(context, stops) ?? defaultValue.stops,
      tileMode: resolveProp(context, tileMode) ?? defaultValue.tileMode,
      transform: resolveProp(context, transform) ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return this;

    return LinearGradientDto.props(
      begin: mergeProp(begin, other.begin),
      end: mergeProp(end, other.end),
      tileMode: mergeProp(tileMode, other.tileMode),
      transform: mergeProp(transform, other.transform),
      colors: mergeProp(colors, other.colors),
      stops: mergeProp(stops, other.stops),
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
  final Prop<AlignmentGeometry>? center;
  final Prop<double>? radius;
  final Prop<TileMode>? tileMode;
  final Prop<AlignmentGeometry>? focal;
  final Prop<double>? focalRadius;

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
    return RadialGradientDto.props(
      center: Prop.maybeValue(center),
      radius: Prop.maybeValue(radius),
      tileMode: Prop.maybeValue(tileMode),
      focal: Prop.maybeValue(focal),
      focalRadius: Prop.maybeValue(focalRadius),
      transform: Prop.maybeValue(transform),
      colors: Prop.maybeValue(colors),
      stops: Prop.maybeValue(stops),
    );
  }

  /// Constructor that accepts a [RadialGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [RadialGradient] instances to [RadialGradientDto].
  ///
  /// ```dart
  /// const gradient = RadialGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = RadialGradientDto.value(gradient);
  /// ```
  factory RadialGradientDto.value(RadialGradient gradient) {
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

  const RadialGradientDto.props({
    required this.center,
    required this.radius,
    required this.tileMode,
    required this.focal,
    required this.focalRadius,
    required super.transform,
    required super.colors,
    required super.stops,
  });

  /// Constructor that accepts a nullable [RadialGradient] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [RadialGradientDto.value].
  ///
  /// ```dart
  /// const RadialGradient? gradient = RadialGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = RadialGradientDto.maybeValue(gradient); // Returns RadialGradientDto or null
  /// ```
  static RadialGradientDto? maybeValue(RadialGradient? gradient) {
    return gradient != null ? RadialGradientDto.value(gradient) : null;
  }

  @override
  RadialGradient resolve(MixContext context) {
    return RadialGradient(
      center: resolveProp(context, center) ?? defaultValue.center,
      radius: resolveProp(context, radius) ?? defaultValue.radius,
      colors: resolveProp(context, colors) ?? defaultValue.colors,
      stops: resolveProp(context, stops) ?? defaultValue.stops,
      tileMode: resolveProp(context, tileMode) ?? defaultValue.tileMode,
      focal: resolveProp(context, focal) ?? defaultValue.focal,
      focalRadius:
          resolveProp(context, focalRadius) ?? defaultValue.focalRadius,
      transform: resolveProp(context, transform) ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return this;

    return RadialGradientDto.props(
      center: mergeProp(center, other.center),
      radius: mergeProp(radius, other.radius),
      tileMode: mergeProp(tileMode, other.tileMode),
      focal: mergeProp(focal, other.focal),
      focalRadius: mergeProp(focalRadius, other.focalRadius),
      transform: mergeProp(transform, other.transform),
      colors: mergeProp(colors, other.colors),
      stops: mergeProp(stops, other.stops),
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
  final Prop<AlignmentGeometry>? center;
  final Prop<double>? startAngle;
  final Prop<double>? endAngle;
  final Prop<TileMode>? tileMode;

  factory SweepGradientDto({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return SweepGradientDto.props(
      center: Prop.maybeValue(center),
      startAngle: Prop.maybeValue(startAngle),
      endAngle: Prop.maybeValue(endAngle),
      tileMode: Prop.maybeValue(tileMode),
      transform: Prop.maybeValue(transform),
      colors: Prop.maybeValue(colors),
      stops: Prop.maybeValue(stops),
    );
  }

  /// Constructor that accepts a [SweepGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [SweepGradient] instances to [SweepGradientDto].
  ///
  /// ```dart
  /// const gradient = SweepGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = SweepGradientDto.value(gradient);
  /// ```
  factory SweepGradientDto.value(SweepGradient gradient) {
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

  const SweepGradientDto.props({
    required this.center,
    required this.startAngle,
    required this.endAngle,
    required this.tileMode,
    required super.transform,
    required super.colors,
    required super.stops,
  });

  /// Constructor that accepts a nullable [SweepGradient] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [SweepGradientDto.value].
  ///
  /// ```dart
  /// const SweepGradient? gradient = SweepGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = SweepGradientDto.maybeValue(gradient); // Returns SweepGradientDto or null
  /// ```
  static SweepGradientDto? maybeValue(SweepGradient? gradient) {
    return gradient != null ? SweepGradientDto.value(gradient) : null;
  }

  @override
  SweepGradient resolve(MixContext context) {
    return SweepGradient(
      center: resolveProp(context, center) ?? defaultValue.center,
      startAngle: resolveProp(context, startAngle) ?? defaultValue.startAngle,
      endAngle: resolveProp(context, endAngle) ?? defaultValue.endAngle,
      colors: resolveProp(context, colors) ?? defaultValue.colors,
      stops: resolveProp(context, stops) ?? defaultValue.stops,
      tileMode: resolveProp(context, tileMode) ?? defaultValue.tileMode,
      transform: resolveProp(context, transform) ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return this;

    return SweepGradientDto.props(
      center: mergeProp(center, other.center),
      startAngle: mergeProp(startAngle, other.startAngle),
      endAngle: mergeProp(endAngle, other.endAngle),
      tileMode: mergeProp(tileMode, other.tileMode),
      transform: mergeProp(transform, other.transform),
      colors: mergeProp(colors, other.colors),
      stops: mergeProp(stops, other.stops),
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

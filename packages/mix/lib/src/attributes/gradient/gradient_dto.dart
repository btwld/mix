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

  static GradientDto? tryToMerge(GradientDto? a, GradientDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  LinearGradientDto asLinearGradient() {
    return LinearGradientDto._(
      begin: null,
      end: null,
      tileMode: null,
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  RadialGradientDto asRadialGradient() {
    return RadialGradientDto._(
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
    return SweepGradientDto._(
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
    return LinearGradientDto._(
      begin: Prop.maybeValue(begin),
      end: Prop.maybeValue(end),
      tileMode: Prop.maybeValue(tileMode),
      transform: Prop.maybeValue(transform),
      colors: Prop.maybeValue(colors),
      stops: Prop.maybeValue(stops),
    );
  }

  const LinearGradientDto._({
    required this.begin,
    required this.end,
    required this.tileMode,
    required super.transform,
    required super.colors,
    required super.stops,
  });

  @override
  LinearGradient resolve(MixContext mix) {
    return LinearGradient(
      begin: resolveProp(mix, begin) ?? defaultValue.begin,
      end: resolveProp(mix, end) ?? defaultValue.end,
      colors: resolveProp(mix, colors) ?? defaultValue.colors,
      stops: resolveProp(mix, stops) ?? defaultValue.stops,
      tileMode: resolveProp(mix, tileMode) ?? defaultValue.tileMode,
      transform: resolveProp(mix, transform) ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return this;

    return LinearGradientDto._(
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
    return RadialGradientDto._(
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

  const RadialGradientDto._({
    required this.center,
    required this.radius,
    required this.tileMode,
    required this.focal,
    required this.focalRadius,
    required super.transform,
    required super.colors,
    required super.stops,
  });

  @override
  RadialGradient resolve(MixContext mix) {
    return RadialGradient(
      center: resolveProp(mix, center) ?? defaultValue.center,
      radius: resolveProp(mix, radius) ?? defaultValue.radius,
      colors: resolveProp(mix, colors) ?? defaultValue.colors,
      stops: resolveProp(mix, stops) ?? defaultValue.stops,
      tileMode: resolveProp(mix, tileMode) ?? defaultValue.tileMode,
      focal: resolveProp(mix, focal) ?? defaultValue.focal,
      focalRadius: resolveProp(mix, focalRadius) ?? defaultValue.focalRadius,
      transform: resolveProp(mix, transform) ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return this;

    return RadialGradientDto._(
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
    return SweepGradientDto._(
      center: Prop.maybeValue(center),
      startAngle: Prop.maybeValue(startAngle),
      endAngle: Prop.maybeValue(endAngle),
      tileMode: Prop.maybeValue(tileMode),
      transform: Prop.maybeValue(transform),
      colors: Prop.maybeValue(colors),
      stops: Prop.maybeValue(stops),
    );
  }

  const SweepGradientDto._({
    required this.center,
    required this.startAngle,
    required this.endAngle,
    required this.tileMode,
    required super.transform,
    required super.colors,
    required super.stops,
  });

  @override
  SweepGradient resolve(MixContext mix) {
    return SweepGradient(
      center: resolveProp(mix, center) ?? defaultValue.center,
      startAngle: resolveProp(mix, startAngle) ?? defaultValue.startAngle,
      endAngle: resolveProp(mix, endAngle) ?? defaultValue.endAngle,
      colors: resolveProp(mix, colors) ?? defaultValue.colors,
      stops: resolveProp(mix, stops) ?? defaultValue.stops,
      tileMode: resolveProp(mix, tileMode) ?? defaultValue.tileMode,
      transform: resolveProp(mix, transform) ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return this;

    return SweepGradientDto._(
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

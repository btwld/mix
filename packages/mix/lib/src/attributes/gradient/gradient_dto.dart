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
  final MixValue<List<double>> stops;
  final MixValue<List<Color>> colors;
  final MixValue<GradientTransform> transform;
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
      begin: const MixValue.empty(),
      end: const MixValue.empty(),
      tileMode: const MixValue.empty(),
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  RadialGradientDto asRadialGradient() {
    return RadialGradientDto._(
      center: const MixValue.empty(),
      radius: const MixValue.empty(),
      tileMode: const MixValue.empty(),
      focal: const MixValue.empty(),
      focalRadius: const MixValue.empty(),
      transform: transform,
      colors: colors,
      stops: stops,
    );
  }

  SweepGradientDto asSweepGradient() {
    return SweepGradientDto._(
      center: const MixValue.empty(),
      startAngle: const MixValue.empty(),
      endAngle: const MixValue.empty(),
      tileMode: const MixValue.empty(),
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
  final MixValue<AlignmentGeometry> begin;
  final MixValue<AlignmentGeometry> end;
  final MixValue<TileMode> tileMode;

  factory LinearGradientDto({
    Mix<AlignmentGeometry>? begin,
    Mix<AlignmentGeometry>? end,
    Mix<TileMode>? tileMode,
    Mix<GradientTransform>? transform,
    Mix<List<Color>>? colors,
    Mix<List<double>>? stops,
  }) {
    return LinearGradientDto._(
      begin: MixValue(begin),
      end: MixValue(end),
      tileMode: MixValue(tileMode),
      transform: MixValue(transform),
      colors: MixValue(colors),
      stops: MixValue(stops),
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
      begin: begin.resolve(mix) ?? defaultValue.begin,
      end: end.resolve(mix) ?? defaultValue.end,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops.resolve(mix) ?? defaultValue.stops,
      tileMode: tileMode.resolve(mix) ?? defaultValue.tileMode,
      transform: transform.resolve(mix) ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return this;

    return LinearGradientDto._(
      begin: begin.merge(other.begin),
      end: end.merge(other.end),
      tileMode: tileMode.merge(other.tileMode),
      transform: transform.merge(other.transform),
      colors: colors.merge(other.colors),
      stops: stops.merge(other.stops),
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
  final MixValue<AlignmentGeometry> center;
  final MixValue<double> radius;
  final MixValue<TileMode> tileMode;
  final MixValue<AlignmentGeometry> focal;
  final MixValue<double> focalRadius;

  factory RadialGradientDto({
    Mix<AlignmentGeometry>? center,
    Mix<double>? radius,
    Mix<TileMode>? tileMode,
    Mix<AlignmentGeometry>? focal,
    Mix<double>? focalRadius,
    Mix<GradientTransform>? transform,
    Mix<List<Color>>? colors,
    Mix<List<double>>? stops,
  }) {
    return RadialGradientDto._(
      center: MixValue(center),
      radius: MixValue(radius),
      tileMode: MixValue(tileMode),
      focal: MixValue(focal),
      focalRadius: MixValue(focalRadius),
      transform: MixValue(transform),
      colors: MixValue(colors),
      stops: MixValue(stops),
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
      center: center.resolve(mix) ?? defaultValue.center,
      radius: radius.resolve(mix) ?? defaultValue.radius,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops.resolve(mix) ?? defaultValue.stops,
      tileMode: tileMode.resolve(mix) ?? defaultValue.tileMode,
      focal: focal.resolve(mix) ?? defaultValue.focal,
      focalRadius: focalRadius.resolve(mix) ?? defaultValue.focalRadius,
      transform: transform.resolve(mix) ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return this;

    return RadialGradientDto._(
      center: center.merge(other.center),
      radius: radius.merge(other.radius),
      tileMode: tileMode.merge(other.tileMode),
      focal: focal.merge(other.focal),
      focalRadius: focalRadius.merge(other.focalRadius),
      transform: transform.merge(other.transform),
      colors: colors.merge(other.colors),
      stops: stops.merge(other.stops),
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
  final MixValue<AlignmentGeometry> center;
  final MixValue<double> startAngle;
  final MixValue<double> endAngle;
  final MixValue<TileMode> tileMode;

  factory SweepGradientDto({
    Mix<AlignmentGeometry>? center,
    Mix<double>? startAngle,
    Mix<double>? endAngle,
    Mix<TileMode>? tileMode,
    Mix<GradientTransform>? transform,
    Mix<List<Color>>? colors,
    Mix<List<double>>? stops,
  }) {
    return SweepGradientDto._(
      center: MixValue(center),
      startAngle: MixValue(startAngle),
      endAngle: MixValue(endAngle),
      tileMode: MixValue(tileMode),
      transform: MixValue(transform),
      colors: MixValue(colors),
      stops: MixValue(stops),
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
      center: center.resolve(mix) ?? defaultValue.center,
      startAngle: startAngle.resolve(mix) ?? defaultValue.startAngle,
      endAngle: endAngle.resolve(mix) ?? defaultValue.endAngle,
      colors: colors.resolve(mix) ?? defaultValue.colors,
      stops: stops.resolve(mix) ?? defaultValue.stops,
      tileMode: tileMode.resolve(mix) ?? defaultValue.tileMode,
      transform: transform.resolve(mix) ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return this;

    return SweepGradientDto._(
      center: center.merge(other.center),
      startAngle: startAngle.merge(other.startAngle),
      endAngle: endAngle.merge(other.endAngle),
      tileMode: tileMode.merge(other.tileMode),
      transform: transform.merge(other.transform),
      colors: colors.merge(other.colors),
      stops: stops.merge(other.stops),
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

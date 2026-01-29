import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

part 'gradient_mix.g.dart';

/// Base class for gradient styling.
///
/// Supports tokens and type-aware merging.
@immutable
sealed class GradientMix<T extends Gradient> extends Mix<T> {
  final Prop<List<double>>? $stops;
  final Prop<List<Color>>? $colors;
  final Prop<GradientTransform>? $transform;
  const GradientMix({
    Prop<List<double>>? stops,
    Prop<List<Color>>? colors,
    Prop<GradientTransform>? transform,
  }) : $stops = stops,
       $colors = colors,
       $transform = transform;

  factory GradientMix.value(T value) {
    return switch (value) {
      (LinearGradient v) => LinearGradientMix.value(v) as GradientMix<T>,
      (RadialGradient v) => RadialGradientMix.value(v) as GradientMix<T>,
      (SweepGradient v) => SweepGradientMix.value(v) as GradientMix<T>,
      _ => throw ArgumentError(
        'Unsupported Gradient type: ${value.runtimeType}',
      ),
    };
  }

  /// Identity function for radial gradient.
  static RadialGradientMix radial(RadialGradientMix value) {
    return value;
  }

  /// Identity function for linear gradient.
  static LinearGradientMix linear(LinearGradientMix value) {
    return value;
  }

  /// Identity function for sweep gradient.
  static SweepGradientMix sweep(SweepGradientMix value) {
    return value;
  }

  /// Creates from nullable [Gradient].
  static GradientMix<T>? maybeValue<T extends Gradient>(T? value) {
    return value != null ? GradientMix.value(value) : null;
  }

  static GradientMix? tryToMerge(GradientMix? a, GradientMix? b) {
    if (b == null) return a;
    if (a == null) return b;

    // Simple override behavior for different types (follows KISS principle)
    return a.runtimeType == b.runtimeType ? a.merge(b) : b;
  }

  /// Merges common gradient properties.
  @protected
  Map<String, dynamic> mergeCommonProperties(GradientMix? other) {
    return {
      'transform': MixOps.merge($transform, other?.$transform),
      'colors': MixOps.merge($colors, other?.$colors),
      'stops': MixOps.merge($stops, other?.$stops),
    };
  }

  @override
  GradientMix<T> merge(covariant GradientMix<T>? other);
}

/// Mix representation of [LinearGradient].
@mixable
final class LinearGradientMix extends GradientMix<LinearGradient>
    with
        DefaultValue<LinearGradient>,
        Diagnosticable,
        _$LinearGradientMixMixin {
  @override
  final Prop<AlignmentGeometry>? $begin;
  @override
  final Prop<AlignmentGeometry>? $end;
  @override
  final Prop<TileMode>? $tileMode;

  LinearGradientMix({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this.create(
         begin: Prop.maybe(begin),
         end: Prop.maybe(end),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: Prop.maybe(colors),
         stops: Prop.maybe(stops),
       );

  const LinearGradientMix.create({
    Prop<AlignmentGeometry>? begin,
    Prop<AlignmentGeometry>? end,
    Prop<TileMode>? tileMode,
    super.transform,
    super.colors,
    super.stops,
  }) : $begin = begin,
       $end = end,
       $tileMode = tileMode;

  /// Creates from [LinearGradient].
  LinearGradientMix.value(LinearGradient gradient)
    : this(
        begin: gradient.begin,
        end: gradient.end,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Creates with start alignment.
  factory LinearGradientMix.begin(AlignmentGeometry value) {
    return LinearGradientMix(begin: value);
  }

  /// Creates with end alignment.
  factory LinearGradientMix.end(AlignmentGeometry value) {
    return LinearGradientMix(end: value);
  }

  /// Creates with tile mode.
  factory LinearGradientMix.tileMode(TileMode value) {
    return LinearGradientMix(tileMode: value);
  }

  /// Creates with transform.
  factory LinearGradientMix.transform(GradientTransform value) {
    return LinearGradientMix(transform: value);
  }

  /// Creates with colors.
  factory LinearGradientMix.colors(List<Color> value) {
    return LinearGradientMix(colors: value);
  }

  /// Creates with color stops.
  factory LinearGradientMix.stops(List<double> value) {
    return LinearGradientMix(stops: value);
  }

  /// Creates from nullable [LinearGradient].
  static LinearGradientMix? maybeValue(LinearGradient? gradient) {
    return gradient != null ? LinearGradientMix.value(gradient) : null;
  }

  /// Copy with start alignment.
  LinearGradientMix begin(AlignmentGeometry value) {
    return merge(LinearGradientMix.begin(value));
  }

  /// Copy with end alignment.
  LinearGradientMix end(AlignmentGeometry value) {
    return merge(LinearGradientMix.end(value));
  }

  /// Copy with tile mode.
  LinearGradientMix tileMode(TileMode value) {
    return merge(LinearGradientMix.tileMode(value));
  }

  /// Copy with transform.
  LinearGradientMix transform(GradientTransform value) {
    return merge(LinearGradientMix.transform(value));
  }

  /// Copy with colors.
  LinearGradientMix colors(List<Color> value) {
    return merge(LinearGradientMix.colors(value));
  }

  /// Copy with color stops.
  LinearGradientMix stops(List<double> value) {
    return merge(LinearGradientMix.stops(value));
  }

  @override
  LinearGradient get defaultValue => const LinearGradient(colors: []);
}

/// Mix representation of [RadialGradient].
@mixable
final class RadialGradientMix extends GradientMix<RadialGradient>
    with
        DefaultValue<RadialGradient>,
        Diagnosticable,
        _$RadialGradientMixMixin {
  @override
  final Prop<AlignmentGeometry>? $center;
  @override
  final Prop<double>? $radius;
  @override
  final Prop<TileMode>? $tileMode;
  @override
  final Prop<AlignmentGeometry>? $focal;
  @override
  final Prop<double>? $focalRadius;

  RadialGradientMix({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this.create(
         center: Prop.maybe(center),
         radius: Prop.maybe(radius),
         tileMode: Prop.maybe(tileMode),
         focal: Prop.maybe(focal),
         focalRadius: Prop.maybe(focalRadius),
         transform: Prop.maybe(transform),
         colors: Prop.maybe(colors),
         stops: Prop.maybe(stops),
       );

  const RadialGradientMix.create({
    Prop<AlignmentGeometry>? center,
    Prop<double>? radius,
    Prop<TileMode>? tileMode,
    Prop<AlignmentGeometry>? focal,
    Prop<double>? focalRadius,
    super.transform,
    super.colors,
    super.stops,
  }) : $center = center,
       $radius = radius,
       $tileMode = tileMode,
       $focal = focal,
       $focalRadius = focalRadius;

  /// Creates from [RadialGradient].
  RadialGradientMix.value(RadialGradient gradient)
    : this(
        center: gradient.center,
        radius: gradient.radius,
        tileMode: gradient.tileMode,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Creates with center alignment.
  factory RadialGradientMix.center(AlignmentGeometry value) {
    return RadialGradientMix(center: value);
  }

  /// Creates with radius.
  factory RadialGradientMix.radius(double value) {
    return RadialGradientMix(radius: value);
  }

  /// Creates with tile mode.
  factory RadialGradientMix.tileMode(TileMode value) {
    return RadialGradientMix(tileMode: value);
  }

  /// Creates with focal point.
  factory RadialGradientMix.focal(AlignmentGeometry value) {
    return RadialGradientMix(focal: value);
  }

  /// Creates with focal radius.
  factory RadialGradientMix.focalRadius(double value) {
    return RadialGradientMix(focalRadius: value);
  }

  /// Creates with transform.
  factory RadialGradientMix.transform(GradientTransform value) {
    return RadialGradientMix(transform: value);
  }

  /// Creates with colors.
  factory RadialGradientMix.colors(List<Color> value) {
    return RadialGradientMix(colors: value);
  }

  /// Creates a radial gradient with the specified color stops.
  factory RadialGradientMix.stops(List<double> value) {
    return RadialGradientMix(stops: value);
  }

  /// Creates a [RadialGradientMix] from a nullable [RadialGradient].
  ///
  /// Returns null if the input is null.
  static RadialGradientMix? maybeValue(RadialGradient? gradient) {
    return gradient != null ? RadialGradientMix.value(gradient) : null;
  }

  /// Returns a copy with the specified center alignment.
  RadialGradientMix center(AlignmentGeometry value) {
    return merge(RadialGradientMix.center(value));
  }

  /// Returns a copy with the specified radius.
  RadialGradientMix radius(double value) {
    return merge(RadialGradientMix.radius(value));
  }

  /// Copy with tile mode.
  RadialGradientMix tileMode(TileMode value) {
    return merge(RadialGradientMix.tileMode(value));
  }

  /// Returns a copy with the specified focal point.
  RadialGradientMix focal(AlignmentGeometry value) {
    return merge(RadialGradientMix.focal(value));
  }

  /// Returns a copy with the specified focal radius.
  RadialGradientMix focalRadius(double value) {
    return merge(RadialGradientMix.focalRadius(value));
  }

  /// Copy with transform.
  RadialGradientMix transform(GradientTransform value) {
    return merge(RadialGradientMix.transform(value));
  }

  /// Copy with colors.
  RadialGradientMix colors(List<Color> value) {
    return merge(RadialGradientMix.colors(value));
  }

  /// Copy with color stops.
  RadialGradientMix stops(List<double> value) {
    return merge(RadialGradientMix.stops(value));
  }

  @override
  RadialGradient get defaultValue => const RadialGradient(colors: []);
}

/// Mix representation of [SweepGradient].
@mixable
final class SweepGradientMix extends GradientMix<SweepGradient>
    with DefaultValue<SweepGradient>, Diagnosticable, _$SweepGradientMixMixin {
  @override
  final Prop<AlignmentGeometry>? $center;
  @override
  final Prop<double>? $startAngle;
  @override
  final Prop<double>? $endAngle;
  @override
  final Prop<TileMode>? $tileMode;

  SweepGradientMix({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this.create(
         center: Prop.maybe(center),
         startAngle: Prop.maybe(startAngle),
         endAngle: Prop.maybe(endAngle),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: Prop.maybe(colors),
         stops: Prop.maybe(stops),
       );

  const SweepGradientMix.create({
    Prop<AlignmentGeometry>? center,
    Prop<double>? startAngle,
    Prop<double>? endAngle,
    Prop<TileMode>? tileMode,
    super.transform,
    super.colors,
    super.stops,
  }) : $center = center,
       $startAngle = startAngle,
       $endAngle = endAngle,
       $tileMode = tileMode;

  /// Creates from [SweepGradient].
  SweepGradientMix.value(SweepGradient gradient)
    : this(
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Creates with center alignment.
  factory SweepGradientMix.center(AlignmentGeometry value) {
    return SweepGradientMix(center: value);
  }

  /// Creates with start angle.
  factory SweepGradientMix.startAngle(double value) {
    return SweepGradientMix(startAngle: value);
  }

  /// Creates with end angle.
  factory SweepGradientMix.endAngle(double value) {
    return SweepGradientMix(endAngle: value);
  }

  /// Creates with tile mode.
  factory SweepGradientMix.tileMode(TileMode value) {
    return SweepGradientMix(tileMode: value);
  }

  /// Creates with transform.
  factory SweepGradientMix.transform(GradientTransform value) {
    return SweepGradientMix(transform: value);
  }

  /// Creates with colors.
  factory SweepGradientMix.colors(List<Color> value) {
    return SweepGradientMix(colors: value);
  }

  /// Creates with color stops.
  factory SweepGradientMix.stops(List<double> value) {
    return SweepGradientMix(stops: value);
  }

  /// Creates from nullable [SweepGradient].
  static SweepGradientMix? maybeValue(SweepGradient? gradient) {
    return gradient != null ? SweepGradientMix.value(gradient) : null;
  }

  /// Returns a copy with the specified center alignment.
  SweepGradientMix center(AlignmentGeometry value) {
    return merge(SweepGradientMix.center(value));
  }

  /// Returns a copy with the specified start angle.
  SweepGradientMix startAngle(double value) {
    return merge(SweepGradientMix.startAngle(value));
  }

  /// Returns a copy with the specified end angle.
  SweepGradientMix endAngle(double value) {
    return merge(SweepGradientMix.endAngle(value));
  }

  /// Copy with tile mode.
  SweepGradientMix tileMode(TileMode value) {
    return merge(SweepGradientMix.tileMode(value));
  }

  /// Copy with transform.
  SweepGradientMix transform(GradientTransform value) {
    return merge(SweepGradientMix.transform(value));
  }

  /// Copy with colors.
  SweepGradientMix colors(List<Color> value) {
    return merge(SweepGradientMix.colors(value));
  }

  /// Copy with color stops.
  SweepGradientMix stops(List<double> value) {
    return merge(SweepGradientMix.stops(value));
  }

  @override
  SweepGradient get defaultValue => const SweepGradient(colors: []);
}

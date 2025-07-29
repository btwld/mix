import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for gradient styling with resolvable tokens and merging support.
///
/// Supports same-type merging and override behavior for different gradient types.
@immutable
sealed class GradientMix<T extends Gradient> extends Mix<T>
    with DefaultValue<T> {
  final List<Prop<double>>? $stops;
  final List<Prop<Color>>? $colors;
  final Prop<GradientTransform>? $transform;
  const GradientMix({
    List<Prop<double>>? stops,
    List<Prop<Color>>? colors,
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

  /// Returns the provided radial gradient (identity function for consistency).
  static RadialGradientMix radial(RadialGradientMix value) {
    return value;
  }

  /// Returns the provided linear gradient (identity function for consistency).
  static LinearGradientMix linear(LinearGradientMix value) {
    return value;
  }

  /// Returns the provided sweep gradient (identity function for consistency).
  static SweepGradientMix sweep(SweepGradientMix value) {
    return value;
  }

  /// Creates the appropriate gradient mix type from a nullable Flutter [Gradient].
  ///
  /// Returns null if the input is null.
  static GradientMix<T>? maybeValue<T extends Gradient>(T? value) {
    return value != null ? GradientMix.value(value) : null;
  }

  static GradientMix? tryToMerge(GradientMix? a, GradientMix? b) {
    if (b == null) return a;
    if (a == null) return b;

    // Simple override behavior for different types (follows KISS principle)
    return a.runtimeType == b.runtimeType ? a.merge(b) : b;
  }

  /// Helper method to merge common gradient properties (transform, colors, stops)
  /// This follows DRY principle by consolidating shared merge logic
  @protected
  Map<String, dynamic> mergeCommonProperties(GradientMix other) {
    return {
      'transform': MixHelpers.merge($transform, other.$transform),
      'colors': MixHelpers.mergeList($colors, other.$colors),
      'stops': MixHelpers.mergeList($stops, other.$stops),
    };
  }

  @override
  GradientMix<T> merge(covariant GradientMix<T>? other);
}

/// Mix-compatible representation of [LinearGradient] with token support and merging behavior.

final class LinearGradientMix extends GradientMix<LinearGradient> {
  final Prop<AlignmentGeometry>? $begin;
  final Prop<AlignmentGeometry>? $end;
  final Prop<TileMode>? $tileMode;

  LinearGradientMix({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this.raw(
         begin: Prop.maybe(begin),
         end: Prop.maybe(end),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: colors?.map((c) => Prop(c)).toList(),
         stops: stops?.map(Prop.new).toList(),
       );

  const LinearGradientMix.raw({
    Prop<AlignmentGeometry>? begin,
    Prop<AlignmentGeometry>? end,
    Prop<TileMode>? tileMode,
    super.transform,
    super.colors,
    super.stops,
  }) : $begin = begin,
       $end = end,
       $tileMode = tileMode;

  /// Creates a [LinearGradientMix] from an existing [LinearGradient].
  LinearGradientMix.value(LinearGradient gradient)
    : this(
        begin: gradient.begin,
        end: gradient.end,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Creates a linear gradient with the specified start alignment.
  factory LinearGradientMix.begin(AlignmentGeometry value) {
    return LinearGradientMix(begin: value);
  }

  /// Creates a linear gradient with the specified end alignment.
  factory LinearGradientMix.end(AlignmentGeometry value) {
    return LinearGradientMix(end: value);
  }

  /// Creates a linear gradient with the specified tile mode.
  factory LinearGradientMix.tileMode(TileMode value) {
    return LinearGradientMix(tileMode: value);
  }

  /// Creates a linear gradient with the specified transform.
  factory LinearGradientMix.transform(GradientTransform value) {
    return LinearGradientMix(transform: value);
  }

  /// Creates a linear gradient with the specified colors.
  factory LinearGradientMix.colors(List<Color> value) {
    return LinearGradientMix(colors: value);
  }

  /// Creates a linear gradient with the specified color stops.
  factory LinearGradientMix.stops(List<double> value) {
    return LinearGradientMix(stops: value);
  }

  /// Creates a [LinearGradientMix] from a nullable [LinearGradient].
  ///
  /// Returns null if the input is null.
  static LinearGradientMix? maybeValue(LinearGradient? gradient) {
    return gradient != null ? LinearGradientMix.value(gradient) : null;
  }

  /// Returns a copy with the specified start alignment.
  LinearGradientMix begin(AlignmentGeometry value) {
    return merge(LinearGradientMix.begin(value));
  }

  /// Returns a copy with the specified end alignment.
  LinearGradientMix end(AlignmentGeometry value) {
    return merge(LinearGradientMix.end(value));
  }

  /// Returns a copy with the specified tile mode.
  LinearGradientMix tileMode(TileMode value) {
    return merge(LinearGradientMix.tileMode(value));
  }

  /// Returns a copy with the specified transform.
  LinearGradientMix transform(GradientTransform value) {
    return merge(LinearGradientMix.transform(value));
  }

  /// Returns a copy with the specified colors.
  LinearGradientMix colors(List<Color> value) {
    return merge(LinearGradientMix.colors(value));
  }

  /// Returns a copy with the specified color stops.
  LinearGradientMix stops(List<double> value) {
    return merge(LinearGradientMix.stops(value));
  }

  @override
  LinearGradient resolve(BuildContext context) {
    return LinearGradient(
      begin: MixHelpers.resolve(context, $begin) ?? defaultValue.begin,
      end: MixHelpers.resolve(context, $end) ?? defaultValue.end,
      colors:
          $colors?.map((c) => c.resolve(context)).toList() ??
          defaultValue.colors,
      stops: MixHelpers.resolveList(context, $stops) ?? defaultValue.stops,
      tileMode: MixHelpers.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform:
          MixHelpers.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientMix merge(LinearGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return LinearGradientMix.raw(
      begin: MixHelpers.merge($begin, other.$begin),
      end: MixHelpers.merge($end, other.$end),
      tileMode: MixHelpers.merge($tileMode, other.$tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  List<Object?> get props => [
    $begin,
    $end,
    $tileMode,
    $transform,
    $colors,
    $stops,
  ];

  @override
  LinearGradient get defaultValue => const LinearGradient(colors: []);
}

/// Mix-compatible representation of [RadialGradient] with token support and merging behavior.
final class RadialGradientMix extends GradientMix<RadialGradient> {
  final Prop<AlignmentGeometry>? $center;
  final Prop<double>? $radius;
  final Prop<TileMode>? $tileMode;
  final Prop<AlignmentGeometry>? $focal;
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
  }) : this.raw(
         center: Prop.maybe(center),
         radius: Prop.maybe(radius),
         tileMode: Prop.maybe(tileMode),
         focal: Prop.maybe(focal),
         focalRadius: Prop.maybe(focalRadius),
         transform: Prop.maybe(transform),
         colors: colors?.map((c) => Prop(c)).toList(),
         stops: stops?.map(Prop.new).toList(),
       );

  const RadialGradientMix.raw({
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

  /// Creates a [RadialGradientMix] from an existing [RadialGradient].
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

  /// Creates a radial gradient with the specified center alignment.
  factory RadialGradientMix.center(AlignmentGeometry value) {
    return RadialGradientMix(center: value);
  }

  /// Creates a radial gradient with the specified radius.
  factory RadialGradientMix.radius(double value) {
    return RadialGradientMix(radius: value);
  }

  /// Creates a radial gradient with the specified tile mode.
  factory RadialGradientMix.tileMode(TileMode value) {
    return RadialGradientMix(tileMode: value);
  }

  /// Creates a radial gradient with the specified focal point.
  factory RadialGradientMix.focal(AlignmentGeometry value) {
    return RadialGradientMix(focal: value);
  }

  /// Creates a radial gradient with the specified focal radius.
  factory RadialGradientMix.focalRadius(double value) {
    return RadialGradientMix(focalRadius: value);
  }

  /// Creates a radial gradient with the specified transform.
  factory RadialGradientMix.transform(GradientTransform value) {
    return RadialGradientMix(transform: value);
  }

  /// Creates a radial gradient with the specified colors.
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

  /// Returns a copy with the specified tile mode.
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

  /// Returns a copy with the specified transform.
  RadialGradientMix transform(GradientTransform value) {
    return merge(RadialGradientMix.transform(value));
  }

  /// Returns a copy with the specified colors.
  RadialGradientMix colors(List<Color> value) {
    return merge(RadialGradientMix.colors(value));
  }

  /// Returns a copy with the specified color stops.
  RadialGradientMix stops(List<double> value) {
    return merge(RadialGradientMix.stops(value));
  }

  @override
  RadialGradient resolve(BuildContext context) {
    return RadialGradient(
      center: MixHelpers.resolve(context, $center) ?? defaultValue.center,
      radius: MixHelpers.resolve(context, $radius) ?? defaultValue.radius,
      colors:
          $colors?.map((c) => c.resolve(context)).toList() ??
          defaultValue.colors,
      stops: MixHelpers.resolveList(context, $stops) ?? defaultValue.stops,
      tileMode: MixHelpers.resolve(context, $tileMode) ?? defaultValue.tileMode,
      focal: MixHelpers.resolve(context, $focal) ?? defaultValue.focal,
      focalRadius:
          MixHelpers.resolve(context, $focalRadius) ?? defaultValue.focalRadius,
      transform:
          MixHelpers.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientMix merge(RadialGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return RadialGradientMix.raw(
      center: MixHelpers.merge($center, other.$center),
      radius: MixHelpers.merge($radius, other.$radius),
      tileMode: MixHelpers.merge($tileMode, other.$tileMode),
      focal: MixHelpers.merge($focal, other.$focal),
      focalRadius: MixHelpers.merge($focalRadius, other.$focalRadius),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  List<Object?> get props => [
    $center,
    $radius,
    $tileMode,
    $focal,
    $focalRadius,
    $transform,
    $colors,
    $stops,
  ];

  @override
  RadialGradient get defaultValue => const RadialGradient(colors: []);
}

/// Mix-compatible representation of [SweepGradient] with token support and merging behavior.

final class SweepGradientMix extends GradientMix<SweepGradient> {
  final Prop<AlignmentGeometry>? $center;
  final Prop<double>? $startAngle;
  final Prop<double>? $endAngle;
  final Prop<TileMode>? $tileMode;

  SweepGradientMix({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this.raw(
         center: Prop.maybe(center),
         startAngle: Prop.maybe(startAngle),
         endAngle: Prop.maybe(endAngle),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: colors?.map((c) => Prop(c)).toList(),
         stops: stops?.map(Prop.new).toList(),
       );

  const SweepGradientMix.raw({
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

  /// Creates a [SweepGradientMix] from an existing [SweepGradient].
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

  /// Creates a sweep gradient with the specified center alignment.
  factory SweepGradientMix.center(AlignmentGeometry value) {
    return SweepGradientMix(center: value);
  }

  /// Creates a sweep gradient with the specified start angle.
  factory SweepGradientMix.startAngle(double value) {
    return SweepGradientMix(startAngle: value);
  }

  /// Creates a sweep gradient with the specified end angle.
  factory SweepGradientMix.endAngle(double value) {
    return SweepGradientMix(endAngle: value);
  }

  /// Creates a sweep gradient with the specified tile mode.
  factory SweepGradientMix.tileMode(TileMode value) {
    return SweepGradientMix(tileMode: value);
  }

  /// Creates a sweep gradient with the specified transform.
  factory SweepGradientMix.transform(GradientTransform value) {
    return SweepGradientMix(transform: value);
  }

  /// Creates a sweep gradient with the specified colors.
  factory SweepGradientMix.colors(List<Color> value) {
    return SweepGradientMix(colors: value);
  }

  /// Creates a sweep gradient with the specified color stops.
  factory SweepGradientMix.stops(List<double> value) {
    return SweepGradientMix(stops: value);
  }

  /// Creates a [SweepGradientMix] from a nullable [SweepGradient].
  ///
  /// Returns null if the input is null.
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

  /// Returns a copy with the specified tile mode.
  SweepGradientMix tileMode(TileMode value) {
    return merge(SweepGradientMix.tileMode(value));
  }

  /// Returns a copy with the specified transform.
  SweepGradientMix transform(GradientTransform value) {
    return merge(SweepGradientMix.transform(value));
  }

  /// Returns a copy with the specified colors.
  SweepGradientMix colors(List<Color> value) {
    return merge(SweepGradientMix.colors(value));
  }

  /// Returns a copy with the specified color stops.
  SweepGradientMix stops(List<double> value) {
    return merge(SweepGradientMix.stops(value));
  }

  @override
  SweepGradient resolve(BuildContext context) {
    return SweepGradient(
      center: MixHelpers.resolve(context, $center) ?? defaultValue.center,
      startAngle:
          MixHelpers.resolve(context, $startAngle) ?? defaultValue.startAngle,
      endAngle: MixHelpers.resolve(context, $endAngle) ?? defaultValue.endAngle,
      colors:
          $colors?.map((c) => c.resolve(context)).toList() ??
          defaultValue.colors,
      stops: MixHelpers.resolveList(context, $stops) ?? defaultValue.stops,
      tileMode: MixHelpers.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform:
          MixHelpers.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientMix merge(SweepGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return SweepGradientMix.raw(
      center: MixHelpers.merge($center, other.$center),
      startAngle: MixHelpers.merge($startAngle, other.$startAngle),
      endAngle: MixHelpers.merge($endAngle, other.$endAngle),
      tileMode: MixHelpers.merge($tileMode, other.$tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  List<Object?> get props => [
    $center,
    $startAngle,
    $endAngle,
    $tileMode,
    $transform,
    $colors,
    $stops,
  ];

  @override
  SweepGradient get defaultValue => const SweepGradient(colors: []);
}

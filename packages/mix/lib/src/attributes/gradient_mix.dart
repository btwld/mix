// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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

  static RadialGradientMix radial(RadialGradientMix value) {
    return value;
  }

  static LinearGradientMix linear(LinearGradientMix value) {
    return value;
  }

  static SweepGradientMix sweep(SweepGradientMix value) {
    return value;
  }

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

  LinearGradientMix.only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this(
         begin: Prop.maybe(begin),
         end: Prop.maybe(end),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: colors?.map(Prop.new).toList(),
         stops: stops?.map(Prop.new).toList(),
       );

  const LinearGradientMix({
    Prop<AlignmentGeometry>? begin,
    Prop<AlignmentGeometry>? end,
    Prop<TileMode>? tileMode,
    super.transform,
    super.colors,
    super.stops,
  }) : $begin = begin,
       $end = end,
       $tileMode = tileMode;

  /// Constructor that accepts a [LinearGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [LinearGradient] instances to [LinearGradientMix].
  ///
  /// ```dart
  /// const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = LinearGradientMix.value(gradient);
  /// ```
  LinearGradientMix.value(LinearGradient gradient)
    : this.only(
        begin: gradient.begin,
        end: gradient.end,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Constructor that accepts a nullable [LinearGradient] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [LinearGradientMix.value].
  ///
  /// ```dart
  /// const LinearGradient? gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = LinearGradientMix.maybeValue(gradient); // Returns LinearGradientMix or null
  /// ```
  factory LinearGradientMix.begin(AlignmentGeometry value) {
    return LinearGradientMix.only(begin: value);
  }

  factory LinearGradientMix.end(AlignmentGeometry value) {
    return LinearGradientMix.only(end: value);
  }

  factory LinearGradientMix.tileMode(TileMode value) {
    return LinearGradientMix.only(tileMode: value);
  }

  factory LinearGradientMix.transform(GradientTransform value) {
    return LinearGradientMix.only(transform: value);
  }

  factory LinearGradientMix.colors(List<Color> value) {
    return LinearGradientMix.only(colors: value);
  }

  factory LinearGradientMix.stops(List<double> value) {
    return LinearGradientMix.only(stops: value);
  }

  static LinearGradientMix? maybeValue(LinearGradient? gradient) {
    return gradient != null ? LinearGradientMix.value(gradient) : null;
  }

  /// Creates a new [LinearGradientMix] with the provided begin,
  /// merging it with the current instance.
  LinearGradientMix begin(AlignmentGeometry value) {
    return merge(LinearGradientMix.only(begin: value));
  }

  /// Creates a new [LinearGradientMix] with the provided end,
  /// merging it with the current instance.
  LinearGradientMix end(AlignmentGeometry value) {
    return merge(LinearGradientMix.only(end: value));
  }

  /// Creates a new [LinearGradientMix] with the provided tileMode,
  /// merging it with the current instance.
  LinearGradientMix tileMode(TileMode value) {
    return merge(LinearGradientMix.only(tileMode: value));
  }

  /// Creates a new [LinearGradientMix] with the provided transform,
  /// merging it with the current instance.
  LinearGradientMix transform(GradientTransform value) {
    return merge(LinearGradientMix.only(transform: value));
  }

  /// Creates a new [LinearGradientMix] with the provided colors,
  /// merging it with the current instance.
  LinearGradientMix colors(List<Color> value) {
    return merge(LinearGradientMix.only(colors: value));
  }

  /// Creates a new [LinearGradientMix] with the provided stops,
  /// merging it with the current instance.
  LinearGradientMix stops(List<double> value) {
    return merge(LinearGradientMix.only(stops: value));
  }

  @override
  LinearGradient resolve(BuildContext context) {
    return LinearGradient(
      begin: MixHelpers.resolve(context, $begin) ?? defaultValue.begin,
      end: MixHelpers.resolve(context, $end) ?? defaultValue.end,
      colors: MixHelpers.resolveList(context, $colors) ?? defaultValue.colors,
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

    return LinearGradientMix(
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

  RadialGradientMix.only({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this(
         center: Prop.maybe(center),
         radius: Prop.maybe(radius),
         tileMode: Prop.maybe(tileMode),
         focal: Prop.maybe(focal),
         focalRadius: Prop.maybe(focalRadius),
         transform: Prop.maybe(transform),
         colors: colors?.map(Prop.new).toList(),
         stops: stops?.map(Prop.new).toList(),
       );

  const RadialGradientMix({
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

  /// Constructor that accepts a [RadialGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [RadialGradient] instances to [RadialGradientMix].
  ///
  /// ```dart
  /// const gradient = RadialGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = RadialGradientMix.value(gradient);
  /// ```
  RadialGradientMix.value(RadialGradient gradient)
    : this.only(
        center: gradient.center,
        radius: gradient.radius,
        tileMode: gradient.tileMode,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Constructor that accepts a nullable [RadialGradient] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [RadialGradientMix.value].
  ///
  /// ```dart
  /// const RadialGradient? gradient = RadialGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = RadialGradientMix.maybeValue(gradient); // Returns RadialGradientMix or null
  /// ```
  factory RadialGradientMix.center(AlignmentGeometry value) {
    return RadialGradientMix.only(center: value);
  }

  factory RadialGradientMix.radius(double value) {
    return RadialGradientMix.only(radius: value);
  }

  factory RadialGradientMix.tileMode(TileMode value) {
    return RadialGradientMix.only(tileMode: value);
  }

  factory RadialGradientMix.focal(AlignmentGeometry value) {
    return RadialGradientMix.only(focal: value);
  }

  factory RadialGradientMix.focalRadius(double value) {
    return RadialGradientMix.only(focalRadius: value);
  }

  factory RadialGradientMix.transform(GradientTransform value) {
    return RadialGradientMix.only(transform: value);
  }

  factory RadialGradientMix.colors(List<Color> value) {
    return RadialGradientMix.only(colors: value);
  }

  factory RadialGradientMix.stops(List<double> value) {
    return RadialGradientMix.only(stops: value);
  }

  static RadialGradientMix? maybeValue(RadialGradient? gradient) {
    return gradient != null ? RadialGradientMix.value(gradient) : null;
  }

  /// Creates a new [RadialGradientMix] with the provided center,
  /// merging it with the current instance.
  RadialGradientMix center(AlignmentGeometry value) {
    return merge(RadialGradientMix.only(center: value));
  }

  /// Creates a new [RadialGradientMix] with the provided radius,
  /// merging it with the current instance.
  RadialGradientMix radius(double value) {
    return merge(RadialGradientMix.only(radius: value));
  }

  /// Creates a new [RadialGradientMix] with the provided tileMode,
  /// merging it with the current instance.
  RadialGradientMix tileMode(TileMode value) {
    return merge(RadialGradientMix.only(tileMode: value));
  }

  /// Creates a new [RadialGradientMix] with the provided focal,
  /// merging it with the current instance.
  RadialGradientMix focal(AlignmentGeometry value) {
    return merge(RadialGradientMix.only(focal: value));
  }

  /// Creates a new [RadialGradientMix] with the provided focalRadius,
  /// merging it with the current instance.
  RadialGradientMix focalRadius(double value) {
    return merge(RadialGradientMix.only(focalRadius: value));
  }

  /// Creates a new [RadialGradientMix] with the provided transform,
  /// merging it with the current instance.
  RadialGradientMix transform(GradientTransform value) {
    return merge(RadialGradientMix.only(transform: value));
  }

  /// Creates a new [RadialGradientMix] with the provided colors,
  /// merging it with the current instance.
  RadialGradientMix colors(List<Color> value) {
    return merge(RadialGradientMix.only(colors: value));
  }

  /// Creates a new [RadialGradientMix] with the provided stops,
  /// merging it with the current instance.
  RadialGradientMix stops(List<double> value) {
    return merge(RadialGradientMix.only(stops: value));
  }

  @override
  RadialGradient resolve(BuildContext context) {
    return RadialGradient(
      center: MixHelpers.resolve(context, $center) ?? defaultValue.center,
      radius: MixHelpers.resolve(context, $radius) ?? defaultValue.radius,
      colors: MixHelpers.resolveList(context, $colors) ?? defaultValue.colors,
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

    return RadialGradientMix(
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

  SweepGradientMix.only({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) : this(
         center: Prop.maybe(center),
         startAngle: Prop.maybe(startAngle),
         endAngle: Prop.maybe(endAngle),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: colors?.map(Prop.new).toList(),
         stops: stops?.map(Prop.new).toList(),
       );

  const SweepGradientMix({
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

  /// Constructor that accepts a [SweepGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [SweepGradient] instances to [SweepGradientMix].
  ///
  /// ```dart
  /// const gradient = SweepGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = SweepGradientMix.value(gradient);
  /// ```
  SweepGradientMix.value(SweepGradient gradient)
    : this.only(
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: gradient.colors,
        stops: gradient.stops,
      );

  /// Constructor that accepts a nullable [SweepGradient] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [SweepGradientMix.value].
  ///
  /// ```dart
  /// const SweepGradient? gradient = SweepGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = SweepGradientMix.maybeValue(gradient); // Returns SweepGradientMix or null
  /// ```
  factory SweepGradientMix.center(AlignmentGeometry value) {
    return SweepGradientMix.only(center: value);
  }

  factory SweepGradientMix.startAngle(double value) {
    return SweepGradientMix.only(startAngle: value);
  }

  factory SweepGradientMix.endAngle(double value) {
    return SweepGradientMix.only(endAngle: value);
  }

  factory SweepGradientMix.tileMode(TileMode value) {
    return SweepGradientMix.only(tileMode: value);
  }

  factory SweepGradientMix.transform(GradientTransform value) {
    return SweepGradientMix.only(transform: value);
  }

  factory SweepGradientMix.colors(List<Color> value) {
    return SweepGradientMix.only(colors: value);
  }

  factory SweepGradientMix.stops(List<double> value) {
    return SweepGradientMix.only(stops: value);
  }

  static SweepGradientMix? maybeValue(SweepGradient? gradient) {
    return gradient != null ? SweepGradientMix.value(gradient) : null;
  }

  /// Creates a new [SweepGradientMix] with the provided center,
  /// merging it with the current instance.
  SweepGradientMix center(AlignmentGeometry value) {
    return merge(SweepGradientMix.only(center: value));
  }

  /// Creates a new [SweepGradientMix] with the provided startAngle,
  /// merging it with the current instance.
  SweepGradientMix startAngle(double value) {
    return merge(SweepGradientMix.only(startAngle: value));
  }

  /// Creates a new [SweepGradientMix] with the provided endAngle,
  /// merging it with the current instance.
  SweepGradientMix endAngle(double value) {
    return merge(SweepGradientMix.only(endAngle: value));
  }

  /// Creates a new [SweepGradientMix] with the provided tileMode,
  /// merging it with the current instance.
  SweepGradientMix tileMode(TileMode value) {
    return merge(SweepGradientMix.only(tileMode: value));
  }

  /// Creates a new [SweepGradientMix] with the provided transform,
  /// merging it with the current instance.
  SweepGradientMix transform(GradientTransform value) {
    return merge(SweepGradientMix.only(transform: value));
  }

  /// Creates a new [SweepGradientMix] with the provided colors,
  /// merging it with the current instance.
  SweepGradientMix colors(List<Color> value) {
    return merge(SweepGradientMix.only(colors: value));
  }

  /// Creates a new [SweepGradientMix] with the provided stops,
  /// merging it with the current instance.
  SweepGradientMix stops(List<double> value) {
    return merge(SweepGradientMix.only(stops: value));
  }

  @override
  SweepGradient resolve(BuildContext context) {
    return SweepGradient(
      center: MixHelpers.resolve(context, $center) ?? defaultValue.center,
      startAngle:
          MixHelpers.resolve(context, $startAngle) ?? defaultValue.startAngle,
      endAngle: MixHelpers.resolve(context, $endAngle) ?? defaultValue.endAngle,
      colors: MixHelpers.resolveList(context, $colors) ?? defaultValue.colors,
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

    return SweepGradientMix(
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

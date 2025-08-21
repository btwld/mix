import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for gradient styling.
///
/// Supports tokens and type-aware merging.
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
  Map<String, dynamic> mergeCommonProperties(GradientMix other) {
    return {
      'transform': MixOps.merge($transform, other.$transform),
      'colors': MixOps.mergeList($colors, other.$colors),
      'stops': MixOps.mergeList($stops, other.$stops),
    };
  }

  @override
  GradientMix<T> merge(covariant GradientMix<T>? other);
}

/// Mix representation of [LinearGradient].

final class LinearGradientMix extends GradientMix<LinearGradient>
    with Diagnosticable {
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
  }) : this.create(
         begin: Prop.maybe(begin),
         end: Prop.maybe(end),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: colors?.map((c) => Prop.value(c)).toList(),
         stops: stops?.map(Prop.value).toList(),
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
  LinearGradient resolve(BuildContext context) {
    return LinearGradient(
      begin: MixOps.resolve(context, $begin) ?? defaultValue.begin,
      end: MixOps.resolve(context, $end) ?? defaultValue.end,
      colors:
          $colors?.map((c) => c.resolveProp(context)).toList() ??
          defaultValue.colors,
      stops: MixOps.resolveList(context, $stops) ?? defaultValue.stops,
      tileMode: MixOps.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform: MixOps.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientMix merge(LinearGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return LinearGradientMix.create(
      begin: MixOps.merge($begin, other.$begin),
      end: MixOps.merge($end, other.$end),
      tileMode: MixOps.merge($tileMode, other.$tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('begin', $begin))
      ..add(DiagnosticsProperty('end', $end))
      ..add(DiagnosticsProperty('tileMode', $tileMode))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('colors', $colors))
      ..add(DiagnosticsProperty('stops', $stops));
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

/// Mix representation of [RadialGradient].
final class RadialGradientMix extends GradientMix<RadialGradient>
    with Diagnosticable {
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
  }) : this.create(
         center: Prop.maybe(center),
         radius: Prop.maybe(radius),
         tileMode: Prop.maybe(tileMode),
         focal: Prop.maybe(focal),
         focalRadius: Prop.maybe(focalRadius),
         transform: Prop.maybe(transform),
         colors: colors?.map((c) => Prop.value(c)).toList(),
         stops: stops?.map(Prop.value).toList(),
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
  RadialGradient resolve(BuildContext context) {
    return RadialGradient(
      center: MixOps.resolve(context, $center) ?? defaultValue.center,
      radius: MixOps.resolve(context, $radius) ?? defaultValue.radius,
      colors:
          $colors?.map((c) => c.resolveProp(context)).toList() ??
          defaultValue.colors,
      stops: MixOps.resolveList(context, $stops) ?? defaultValue.stops,
      tileMode: MixOps.resolve(context, $tileMode) ?? defaultValue.tileMode,
      focal: MixOps.resolve(context, $focal) ?? defaultValue.focal,
      focalRadius:
          MixOps.resolve(context, $focalRadius) ?? defaultValue.focalRadius,
      transform: MixOps.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientMix merge(RadialGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return RadialGradientMix.create(
      center: MixOps.merge($center, other.$center),
      radius: MixOps.merge($radius, other.$radius),
      tileMode: MixOps.merge($tileMode, other.$tileMode),
      focal: MixOps.merge($focal, other.$focal),
      focalRadius: MixOps.merge($focalRadius, other.$focalRadius),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('center', $center))
      ..add(DiagnosticsProperty('radius', $radius))
      ..add(DiagnosticsProperty('tileMode', $tileMode))
      ..add(DiagnosticsProperty('focal', $focal))
      ..add(DiagnosticsProperty('focalRadius', $focalRadius))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('colors', $colors))
      ..add(DiagnosticsProperty('stops', $stops));
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

/// Mix representation of [SweepGradient].

final class SweepGradientMix extends GradientMix<SweepGradient>
    with Diagnosticable {
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
  }) : this.create(
         center: Prop.maybe(center),
         startAngle: Prop.maybe(startAngle),
         endAngle: Prop.maybe(endAngle),
         tileMode: Prop.maybe(tileMode),
         transform: Prop.maybe(transform),
         colors: colors?.map((c) => Prop.value(c)).toList(),
         stops: stops?.map(Prop.value).toList(),
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
  SweepGradient resolve(BuildContext context) {
    return SweepGradient(
      center: MixOps.resolve(context, $center) ?? defaultValue.center,
      startAngle:
          MixOps.resolve(context, $startAngle) ?? defaultValue.startAngle,
      endAngle: MixOps.resolve(context, $endAngle) ?? defaultValue.endAngle,
      colors:
          $colors?.map((c) => c.resolveProp(context)).toList() ??
          defaultValue.colors,
      stops: MixOps.resolveList(context, $stops) ?? defaultValue.stops,
      tileMode: MixOps.resolve(context, $tileMode) ?? defaultValue.tileMode,
      transform: MixOps.resolve(context, $transform) ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientMix merge(SweepGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return SweepGradientMix.create(
      center: MixOps.merge($center, other.$center),
      startAngle: MixOps.merge($startAngle, other.$startAngle),
      endAngle: MixOps.merge($endAngle, other.$endAngle),
      tileMode: MixOps.merge($tileMode, other.$tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('center', $center))
      ..add(DiagnosticsProperty('startAngle', $startAngle))
      ..add(DiagnosticsProperty('endAngle', $endAngle))
      ..add(DiagnosticsProperty('tileMode', $tileMode))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('colors', $colors))
      ..add(DiagnosticsProperty('stops', $stops));
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

// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Represents a base Data transfer object of [Gradient]
///
/// This is used to allow for resolvable value tokens and proper merge behavior.
/// Supports same-type merging and simple override behavior for different types.
@immutable
sealed class GradientMix<T extends Gradient> extends Mix<T>
    with DefaultValue<T> {
  final List<Prop<double>>? stops;
  final List<Prop<Color>>? colors;
  final Prop<GradientTransform>? transform;
  const GradientMix({this.stops, this.colors, this.transform});

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
      'transform': MixHelpers.merge(transform, other.transform),
      'colors': MixHelpers.mergeList(colors, other.colors),
      'stops': MixHelpers.mergeList(stops, other.stops),
    };
  }

  @override
  GradientMix<T> merge(covariant GradientMix<T>? other);
}

/// Represents a Data transfer object of [LinearGradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[LinearGradient]

final class LinearGradientMix extends GradientMix<LinearGradient> {
  final Prop<AlignmentGeometry>? begin;
  final Prop<AlignmentGeometry>? end;
  final Prop<TileMode>? tileMode;

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
    this.begin,
    this.end,
    this.tileMode,
    super.transform,
    super.colors,
    super.stops,
  });

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
  static LinearGradientMix? maybeValue(LinearGradient? gradient) {
    return gradient != null ? LinearGradientMix.value(gradient) : null;
  }

  @override
  LinearGradient resolve(BuildContext context) {
    return LinearGradient(
      begin: MixHelpers.resolve(context, begin) ?? defaultValue.begin,
      end: MixHelpers.resolve(context, end) ?? defaultValue.end,
      colors: MixHelpers.resolveList(context, colors) ?? defaultValue.colors,
      stops: MixHelpers.resolveList(context, stops) ?? defaultValue.stops,
      tileMode: MixHelpers.resolve(context, tileMode) ?? defaultValue.tileMode,
      transform:
          MixHelpers.resolve(context, transform) ?? defaultValue.transform,
    );
  }

  @override
  LinearGradientMix merge(LinearGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return LinearGradientMix(
      begin: MixHelpers.merge(begin, other.begin),
      end: MixHelpers.merge(end, other.end),
      tileMode: MixHelpers.merge(tileMode, other.tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
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

  @override
  LinearGradient get defaultValue => const LinearGradient(colors: []);
}

/// Represents a Data transfer object of [RadialGradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[RadialGradient]
final class RadialGradientMix extends GradientMix<RadialGradient> {
  final Prop<AlignmentGeometry>? center;
  final Prop<double>? radius;
  final Prop<TileMode>? tileMode;
  final Prop<AlignmentGeometry>? focal;
  final Prop<double>? focalRadius;

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
    this.center,
    this.radius,
    this.tileMode,
    this.focal,
    this.focalRadius,
    super.transform,
    super.colors,
    super.stops,
  });

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
  static RadialGradientMix? maybeValue(RadialGradient? gradient) {
    return gradient != null ? RadialGradientMix.value(gradient) : null;
  }

  @override
  RadialGradient resolve(BuildContext context) {
    return RadialGradient(
      center: MixHelpers.resolve(context, center) ?? defaultValue.center,
      radius: MixHelpers.resolve(context, radius) ?? defaultValue.radius,
      colors: MixHelpers.resolveList(context, colors) ?? defaultValue.colors,
      stops: MixHelpers.resolveList(context, stops) ?? defaultValue.stops,
      tileMode: MixHelpers.resolve(context, tileMode) ?? defaultValue.tileMode,
      focal: MixHelpers.resolve(context, focal) ?? defaultValue.focal,
      focalRadius:
          MixHelpers.resolve(context, focalRadius) ?? defaultValue.focalRadius,
      transform:
          MixHelpers.resolve(context, transform) ?? defaultValue.transform,
    );
  }

  @override
  RadialGradientMix merge(RadialGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return RadialGradientMix(
      center: MixHelpers.merge(center, other.center),
      radius: MixHelpers.merge(radius, other.radius),
      tileMode: MixHelpers.merge(tileMode, other.tileMode),
      focal: MixHelpers.merge(focal, other.focal),
      focalRadius: MixHelpers.merge(focalRadius, other.focalRadius),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
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

  @override
  RadialGradient get defaultValue => const RadialGradient(colors: []);
}

/// Represents a Data transfer object of [SweepGradient]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[SweepGradient]

final class SweepGradientMix extends GradientMix<SweepGradient> {
  final Prop<AlignmentGeometry>? center;
  final Prop<double>? startAngle;
  final Prop<double>? endAngle;
  final Prop<TileMode>? tileMode;

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
    this.center,
    this.startAngle,
    this.endAngle,
    this.tileMode,
    super.transform,
    super.colors,
    super.stops,
  });

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
  static SweepGradientMix? maybeValue(SweepGradient? gradient) {
    return gradient != null ? SweepGradientMix.value(gradient) : null;
  }

  @override
  SweepGradient resolve(BuildContext context) {
    return SweepGradient(
      center: MixHelpers.resolve(context, center) ?? defaultValue.center,
      startAngle:
          MixHelpers.resolve(context, startAngle) ?? defaultValue.startAngle,
      endAngle: MixHelpers.resolve(context, endAngle) ?? defaultValue.endAngle,
      colors: MixHelpers.resolveList(context, colors) ?? defaultValue.colors,
      stops: MixHelpers.resolveList(context, stops) ?? defaultValue.stops,
      tileMode: MixHelpers.resolve(context, tileMode) ?? defaultValue.tileMode,
      transform:
          MixHelpers.resolve(context, transform) ?? defaultValue.transform,
    );
  }

  @override
  SweepGradientMix merge(SweepGradientMix? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return SweepGradientMix(
      center: MixHelpers.merge(center, other.center),
      startAngle: MixHelpers.merge(startAngle, other.startAngle),
      endAngle: MixHelpers.merge(endAngle, other.endAngle),
      tileMode: MixHelpers.merge(tileMode, other.tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
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

  @override
  SweepGradient get defaultValue => const SweepGradient(colors: []);
}

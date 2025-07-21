// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Represents a base Data transfer object of [Gradient]
///
/// This is used to allow for resolvable value tokens and proper merge behavior.
/// Supports same-type merging and simple override behavior for different types.
@immutable
sealed class GradientDto<T extends Gradient> extends Mix<T>
    with MixDefaultValue<T> {
  final List<Prop<double>>? stops;
  final List<Prop<Color>>? colors;
  final Prop<GradientTransform>? transform;
  const GradientDto({this.stops, this.colors, this.transform});

  factory GradientDto.value(T value) {
    return switch (value) {
      (LinearGradient v) => LinearGradientDto.value(v) as GradientDto<T>,
      (RadialGradient v) => RadialGradientDto.value(v) as GradientDto<T>,
      (SweepGradient v) => SweepGradientDto.value(v) as GradientDto<T>,
      _ => throw ArgumentError(
        'Unsupported Gradient type: ${value.runtimeType}',
      ),
    };
  }

  static RadialGradientDto radial(RadialGradientDto value) {
    return value;
  }

  static LinearGradientDto linear(LinearGradientDto value) {
    return value;
  }

  static SweepGradientDto sweep(SweepGradientDto value) {
    return value;
  }

  static GradientDto<T>? maybeValue<T extends Gradient>(T? value) {
    return value != null ? GradientDto.value(value) : null;
  }

  static GradientDto? tryToMerge(GradientDto? a, GradientDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    // Simple override behavior for different types (follows KISS principle)
    return a.runtimeType == b.runtimeType ? a.merge(b) : b;
  }

  /// Helper method to merge common gradient properties (transform, colors, stops)
  /// This follows DRY principle by consolidating shared merge logic
  @protected
  Map<String, dynamic> mergeCommonProperties(GradientDto other) {
    return {
      'transform': MixHelpers.merge(transform, other.transform),
      'colors': MixHelpers.mergeList(colors, other.colors),
      'stops': MixHelpers.mergeList(stops, other.stops),
    };
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

  LinearGradientDto.only({
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

  const LinearGradientDto({
    this.begin,
    this.end,
    this.tileMode,
    super.transform,
    super.colors,
    super.stops,
  });

  /// Constructor that accepts a [LinearGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [LinearGradient] instances to [LinearGradientDto].
  ///
  /// ```dart
  /// const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = LinearGradientDto.value(gradient);
  /// ```
  LinearGradientDto.value(LinearGradient gradient)
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
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return LinearGradientDto(
      begin: MixHelpers.merge(begin, other.begin),
      end: MixHelpers.merge(end, other.end),
      tileMode: MixHelpers.merge(tileMode, other.tileMode),
      transform: commonProps['transform'],
      colors: commonProps['colors'],
      stops: commonProps['stops'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinearGradientDto &&
        other.begin == begin &&
        other.end == end &&
        other.tileMode == tileMode &&
        other.transform == transform &&
        listEquals(other.colors, colors) &&
        listEquals(other.stops, stops);
  }

  @override
  LinearGradient get defaultValue => const LinearGradient(colors: []);

  @override
  int get hashCode {
    return begin.hashCode ^
        end.hashCode ^
        tileMode.hashCode ^
        transform.hashCode ^
        colors.hashCode ^
        stops.hashCode;
  }
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

  RadialGradientDto.only({
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

  /// Constructor that accepts a [RadialGradient] value and extracts its properties.
  ///
  /// This is useful for converting existing [RadialGradient] instances to [RadialGradientDto].
  ///
  /// ```dart
  /// const gradient = RadialGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = RadialGradientDto.value(gradient);
  /// ```
  RadialGradientDto.value(RadialGradient gradient)
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
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return RadialGradientDto(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RadialGradientDto &&
        other.center == center &&
        other.radius == radius &&
        other.tileMode == tileMode &&
        other.focal == focal &&
        other.focalRadius == focalRadius &&
        other.transform == transform &&
        listEquals(other.colors, colors) &&
        listEquals(other.stops, stops);
  }

  @override
  RadialGradient get defaultValue => const RadialGradient(colors: []);

  @override
  int get hashCode {
    return center.hashCode ^
        radius.hashCode ^
        tileMode.hashCode ^
        focal.hashCode ^
        focalRadius.hashCode ^
        transform.hashCode ^
        colors.hashCode ^
        stops.hashCode;
  }
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

  SweepGradientDto.only({
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

  const SweepGradientDto({
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
  /// This is useful for converting existing [SweepGradient] instances to [SweepGradientDto].
  ///
  /// ```dart
  /// const gradient = SweepGradient(colors: [Colors.red, Colors.blue]);
  /// final dto = SweepGradientDto.value(gradient);
  /// ```
  SweepGradientDto.value(SweepGradient gradient)
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
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return this;

    final commonProps = mergeCommonProperties(other);

    return SweepGradientDto(
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SweepGradientDto &&
        other.center == center &&
        other.startAngle == startAngle &&
        other.endAngle == endAngle &&
        other.tileMode == tileMode &&
        other.transform == transform &&
        listEquals(other.colors, colors) &&
        listEquals(other.stops, stops);
  }

  @override
  SweepGradient get defaultValue => const SweepGradient(colors: []);

  @override
  int get hashCode {
    return center.hashCode ^
        startAngle.hashCode ^
        endAngle.hashCode ^
        tileMode.hashCode ^
        transform.hashCode ^
        colors.hashCode ^
        stops.hashCode;
  }
}

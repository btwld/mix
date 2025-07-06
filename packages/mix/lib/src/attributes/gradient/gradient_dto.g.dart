// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradient_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [LinearGradientDto].
mixin _$LinearGradientDto
    on Mixable<LinearGradient>, HasDefaultValue<LinearGradient> {
  /// Resolves to [LinearGradient] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final linearGradient = LinearGradientDto(...).resolve(mix);
  /// ```
  @override
  LinearGradient resolve(MixContext mix) {
    return LinearGradient(
      begin: _$this.begin ?? defaultValue.begin,
      end: _$this.end ?? defaultValue.end,
      tileMode: _$this.tileMode ?? defaultValue.tileMode,
      transform: _$this.transform ?? defaultValue.transform,
      colors: _$this.colors ?? defaultValue.colors,
      stops: _$this.stops?.map((e) => e.resolve(mix)).toList() ??
          defaultValue.stops,
    );
  }

  /// Merges the properties of this [LinearGradientDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [LinearGradientDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  LinearGradientDto merge(LinearGradientDto? other) {
    if (other == null) return _$this;

    return LinearGradientDto(
      begin: other.begin ?? _$this.begin,
      end: other.end ?? _$this.end,
      tileMode: other.tileMode ?? _$this.tileMode,
      transform: other.transform ?? _$this.transform,
      colors: MixHelpers.mergeList(_$this.colors, other.colors),
      stops: MixHelpers.mergeList(_$this.stops, other.stops),
    );
  }

  /// The list of properties that constitute the state of this [LinearGradientDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LinearGradientDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.begin,
        _$this.end,
        _$this.tileMode,
        _$this.transform,
        _$this.colors,
        _$this.stops,
      ];

  /// Returns this instance as a [LinearGradientDto].
  LinearGradientDto get _$this => this as LinearGradientDto;
}

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
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));

  /// Utility for defining [LinearGradientDto.stops]
  late final stops = ListUtility<T, SpaceDto>((v) => only(stops: v));

  LinearGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [LinearGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<SpaceDto>? stops,
  }) {
    return builder(LinearGradientDto(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    ));
  }

  T call({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<double>? stops,
  }) {
    return only(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops?.toDto(),
    );
  }
}

/// Extension methods to convert [LinearGradient] to [LinearGradientDto].
extension LinearGradientMixExt on LinearGradient {
  /// Converts this [LinearGradient] to a [LinearGradientDto].
  LinearGradientDto toDto() {
    return LinearGradientDto(
      begin: begin,
      end: end,
      tileMode: tileMode,
      transform: transform,
      colors: colors.map((e) => e.toDto()).toList(),
      stops: stops?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert List<[LinearGradient]> to List<[LinearGradientDto]>.
extension ListLinearGradientMixExt on List<LinearGradient> {
  /// Converts this List<[LinearGradient]> to a List<[LinearGradientDto]>.
  List<LinearGradientDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [RadialGradientDto].
mixin _$RadialGradientDto
    on Mixable<RadialGradient>, HasDefaultValue<RadialGradient> {
  /// Resolves to [RadialGradient] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final radialGradient = RadialGradientDto(...).resolve(mix);
  /// ```
  @override
  RadialGradient resolve(MixContext mix) {
    return RadialGradient(
      center: _$this.center ?? defaultValue.center,
      radius: _$this.radius?.resolve(mix) ?? defaultValue.radius,
      tileMode: _$this.tileMode ?? defaultValue.tileMode,
      focal: _$this.focal ?? defaultValue.focal,
      focalRadius: _$this.focalRadius?.resolve(mix) ?? defaultValue.focalRadius,
      transform: _$this.transform ?? defaultValue.transform,
      colors: _$this.colors ?? defaultValue.colors,
      stops: _$this.stops?.map((e) => e.resolve(mix)).toList() ??
          defaultValue.stops,
    );
  }

  /// Merges the properties of this [RadialGradientDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RadialGradientDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RadialGradientDto merge(RadialGradientDto? other) {
    if (other == null) return _$this;

    return RadialGradientDto(
      center: other.center ?? _$this.center,
      radius: _$this.radius?.merge(other.radius) ?? other.radius,
      tileMode: other.tileMode ?? _$this.tileMode,
      focal: other.focal ?? _$this.focal,
      focalRadius:
          _$this.focalRadius?.merge(other.focalRadius) ?? other.focalRadius,
      transform: other.transform ?? _$this.transform,
      colors: MixHelpers.mergeList(_$this.colors, other.colors),
      stops: MixHelpers.mergeList(_$this.stops, other.stops),
    );
  }

  /// The list of properties that constitute the state of this [RadialGradientDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RadialGradientDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.center,
        _$this.radius,
        _$this.tileMode,
        _$this.focal,
        _$this.focalRadius,
        _$this.transform,
        _$this.colors,
        _$this.stops,
      ];

  /// Returns this instance as a [RadialGradientDto].
  RadialGradientDto get _$this => this as RadialGradientDto;
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
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));

  /// Utility for defining [RadialGradientDto.stops]
  late final stops = ListUtility<T, SpaceDto>((v) => only(stops: v));

  RadialGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [RadialGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? center,
    SpaceDto? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    SpaceDto? focalRadius,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<SpaceDto>? stops,
  }) {
    return builder(RadialGradientDto(
      center: center,
      radius: radius,
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius,
      transform: transform,
      colors: colors,
      stops: stops,
    ));
  }

  T call({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<double>? stops,
  }) {
    return only(
      center: center,
      radius: radius?.toDto(),
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius?.toDto(),
      transform: transform,
      colors: colors,
      stops: stops?.toDto(),
    );
  }
}

/// Extension methods to convert [RadialGradient] to [RadialGradientDto].
extension RadialGradientMixExt on RadialGradient {
  /// Converts this [RadialGradient] to a [RadialGradientDto].
  RadialGradientDto toDto() {
    return RadialGradientDto(
      center: center,
      radius: radius.toDto(),
      tileMode: tileMode,
      focal: focal,
      focalRadius: focalRadius.toDto(),
      transform: transform,
      colors: colors.map((e) => e.toDto()).toList(),
      stops: stops?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert List<[RadialGradient]> to List<[RadialGradientDto]>.
extension ListRadialGradientMixExt on List<RadialGradient> {
  /// Converts this List<[RadialGradient]> to a List<[RadialGradientDto]>.
  List<RadialGradientDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [SweepGradientDto].
mixin _$SweepGradientDto
    on Mixable<SweepGradient>, HasDefaultValue<SweepGradient> {
  /// Resolves to [SweepGradient] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final sweepGradient = SweepGradientDto(...).resolve(mix);
  /// ```
  @override
  SweepGradient resolve(MixContext mix) {
    return SweepGradient(
      center: _$this.center ?? defaultValue.center,
      startAngle: _$this.startAngle?.resolve(mix) ?? defaultValue.startAngle,
      endAngle: _$this.endAngle?.resolve(mix) ?? defaultValue.endAngle,
      tileMode: _$this.tileMode ?? defaultValue.tileMode,
      transform: _$this.transform ?? defaultValue.transform,
      colors: _$this.colors ?? defaultValue.colors,
      stops: _$this.stops?.map((e) => e.resolve(mix)).toList() ??
          defaultValue.stops,
    );
  }

  /// Merges the properties of this [SweepGradientDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SweepGradientDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SweepGradientDto merge(SweepGradientDto? other) {
    if (other == null) return _$this;

    return SweepGradientDto(
      center: other.center ?? _$this.center,
      startAngle:
          _$this.startAngle?.merge(other.startAngle) ?? other.startAngle,
      endAngle: _$this.endAngle?.merge(other.endAngle) ?? other.endAngle,
      tileMode: other.tileMode ?? _$this.tileMode,
      transform: other.transform ?? _$this.transform,
      colors: MixHelpers.mergeList(_$this.colors, other.colors),
      stops: MixHelpers.mergeList(_$this.stops, other.stops),
    );
  }

  /// The list of properties that constitute the state of this [SweepGradientDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SweepGradientDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.center,
        _$this.startAngle,
        _$this.endAngle,
        _$this.tileMode,
        _$this.transform,
        _$this.colors,
        _$this.stops,
      ];

  /// Returns this instance as a [SweepGradientDto].
  SweepGradientDto get _$this => this as SweepGradientDto;
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
  late final colors = ListUtility<T, Mixable<Color>>((v) => only(colors: v));

  /// Utility for defining [SweepGradientDto.stops]
  late final stops = ListUtility<T, SpaceDto>((v) => only(stops: v));

  SweepGradientUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [SweepGradientDto] with the specified properties.
  @override
  T only({
    AlignmentGeometry? center,
    SpaceDto? startAngle,
    SpaceDto? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<SpaceDto>? stops,
  }) {
    return builder(SweepGradientDto(
      center: center,
      startAngle: startAngle,
      endAngle: endAngle,
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops,
    ));
  }

  T call({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Mixable<Color>>? colors,
    List<double>? stops,
  }) {
    return only(
      center: center,
      startAngle: startAngle?.toDto(),
      endAngle: endAngle?.toDto(),
      tileMode: tileMode,
      transform: transform,
      colors: colors,
      stops: stops?.toDto(),
    );
  }
}

/// Extension methods to convert [SweepGradient] to [SweepGradientDto].
extension SweepGradientMixExt on SweepGradient {
  /// Converts this [SweepGradient] to a [SweepGradientDto].
  SweepGradientDto toDto() {
    return SweepGradientDto(
      center: center,
      startAngle: startAngle.toDto(),
      endAngle: endAngle.toDto(),
      tileMode: tileMode,
      transform: transform,
      colors: colors.map((e) => e.toDto()).toList(),
      stops: stops?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert List<[SweepGradient]> to List<[SweepGradientDto]>.
extension ListSweepGradientMixExt on List<SweepGradient> {
  /// Converts this List<[SweepGradient]> to a List<[SweepGradientDto]>.
  List<SweepGradientDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

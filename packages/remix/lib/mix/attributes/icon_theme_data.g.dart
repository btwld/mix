// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_theme_data.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [IconThemeDataDto].
mixin _$IconThemeDataDto on Mixable<IconThemeData> {
  /// Resolves to [IconThemeData] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final iconThemeData = IconThemeDataDto(...).resolve(mix);
  /// ```
  @override
  IconThemeData resolve(MixContext mix) {
    return IconThemeData(
      size: _$this.size,
      fill: _$this.fill,
      weight: _$this.weight,
      grade: _$this.grade,
      opticalSize: _$this.opticalSize,
      color: _$this.color?.resolve(mix),
      opacity: _$this.opacity,
      shadows: _$this.shadows?.map((e) => e.resolve(mix)).toList(),
      applyTextScaling: _$this.applyTextScaling,
    );
  }

  /// Merges the properties of this [IconThemeDataDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IconThemeDataDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IconThemeDataDto merge(IconThemeDataDto? other) {
    if (other == null) return _$this;

    return IconThemeDataDto(
      size: other.size ?? _$this.size,
      fill: other.fill ?? _$this.fill,
      weight: other.weight ?? _$this.weight,
      grade: other.grade ?? _$this.grade,
      opticalSize: other.opticalSize ?? _$this.opticalSize,
      color: _$this.color?.merge(other.color) ?? other.color,
      opacity: other.opacity ?? _$this.opacity,
      shadows: MixHelpers.mergeList(_$this.shadows, other.shadows),
      applyTextScaling: other.applyTextScaling ?? _$this.applyTextScaling,
    );
  }

  /// The list of properties that constitute the state of this [IconThemeDataDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IconThemeDataDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.size,
        _$this.fill,
        _$this.weight,
        _$this.grade,
        _$this.opticalSize,
        _$this.color,
        _$this.opacity,
        _$this.shadows,
        _$this.applyTextScaling,
      ];

  /// Returns this instance as a [IconThemeDataDto].
  IconThemeDataDto get _$this => this as IconThemeDataDto;
}

/// Utility class for configuring [IconThemeData] properties.
///
/// This class provides methods to set individual properties of a [IconThemeData].
/// Use the methods of this class to configure specific properties of a [IconThemeData].
class IconThemeDataUtility<T extends StyleElement>
    extends DtoUtility<T, IconThemeDataDto, IconThemeData> {
  /// Utility for defining [IconThemeDataDto.size]
  late final size = DoubleUtility((v) => only(size: v));

  /// Utility for defining [IconThemeDataDto.fill]
  late final fill = DoubleUtility((v) => only(fill: v));

  /// Utility for defining [IconThemeDataDto.weight]
  late final weight = DoubleUtility((v) => only(weight: v));

  /// Utility for defining [IconThemeDataDto.grade]
  late final grade = DoubleUtility((v) => only(grade: v));

  /// Utility for defining [IconThemeDataDto.opticalSize]
  late final opticalSize = DoubleUtility((v) => only(opticalSize: v));

  /// Utility for defining [IconThemeDataDto.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [IconThemeDataDto.opacity]
  late final opacity = DoubleUtility((v) => only(opacity: v));

  /// Utility for defining [IconThemeDataDto.shadows]
  late final shadows = ShadowListUtility((v) => only(shadows: v));

  /// Utility for defining [IconThemeDataDto.applyTextScaling]
  late final applyTextScaling = BoolUtility((v) => only(applyTextScaling: v));

  IconThemeDataUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [IconThemeDataDto] with the specified properties.
  @override
  T only({
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    ColorDto? color,
    double? opacity,
    List<ShadowDto>? shadows,
    bool? applyTextScaling,
  }) {
    return builder(IconThemeDataDto(
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color,
      opacity: opacity,
      shadows: shadows,
      applyTextScaling: applyTextScaling,
    ));
  }

  T call({
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    double? opacity,
    List<Shadow>? shadows,
    bool? applyTextScaling,
  }) {
    return only(
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color?.toDto(),
      opacity: opacity,
      shadows: shadows?.map((e) => e.toDto()).toList(),
      applyTextScaling: applyTextScaling,
    );
  }
}

/// Extension methods to convert [IconThemeData] to [IconThemeDataDto].
extension IconThemeDataMixExt on IconThemeData {
  /// Converts this [IconThemeData] to a [IconThemeDataDto].
  IconThemeDataDto toDto() {
    return IconThemeDataDto(
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color?.toDto(),
      opacity: opacity,
      shadows: shadows?.map((e) => e.toDto()).toList(),
      applyTextScaling: applyTextScaling,
    );
  }
}

/// Extension methods to convert List<[IconThemeData]> to List<[IconThemeDataDto]>.
extension ListIconThemeDataMixExt on List<IconThemeData> {
  /// Converts this List<[IconThemeData]> to a List<[IconThemeDataDto]>.
  List<IconThemeDataDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

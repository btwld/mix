// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoration_image_dto.dart';

// **************************************************************************
// MixableDtoGenerator
// **************************************************************************

mixin _$DecorationImageDto on Dto<DecorationImage> {
  /// Resolves to [DecorationImage] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final decorationImage = DecorationImageDto(...).resolve(mix);
  /// ```
  @override
  DecorationImage resolve(MixData mix) {
    return DecorationImage(
      image: _$this.image ?? defaultValue.image,
      fit: _$this.fit ?? defaultValue.fit,
      alignment: _$this.alignment ?? defaultValue.alignment,
      centerSlice: _$this.centerSlice ?? defaultValue.centerSlice,
      repeat: _$this.repeat ?? defaultValue.repeat,
      filterQuality: _$this.filterQuality ?? defaultValue.filterQuality,
      invertColors: _$this.invertColors ?? defaultValue.invertColors,
      isAntiAlias: _$this.isAntiAlias ?? defaultValue.isAntiAlias,
    );
  }

  /// Merges the properties of this [DecorationImageDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DecorationImageDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DecorationImageDto merge(DecorationImageDto? other) {
    if (other == null) return _$this;

    return DecorationImageDto(
      image: other.image ?? _$this.image,
      fit: other.fit ?? _$this.fit,
      alignment: other.alignment ?? _$this.alignment,
      centerSlice: other.centerSlice ?? _$this.centerSlice,
      repeat: other.repeat ?? _$this.repeat,
      filterQuality: other.filterQuality ?? _$this.filterQuality,
      invertColors: other.invertColors ?? _$this.invertColors,
      isAntiAlias: other.isAntiAlias ?? _$this.isAntiAlias,
    );
  }

  /// The list of properties that constitute the state of this [DecorationImageDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DecorationImageDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.image,
        _$this.fit,
        _$this.alignment,
        _$this.centerSlice,
        _$this.repeat,
        _$this.filterQuality,
        _$this.invertColors,
        _$this.isAntiAlias,
      ];

  DecorationImageDto get _$this => this as DecorationImageDto;
}

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
class DecorationImageUtility<T extends Attribute>
    extends DtoUtility<T, DecorationImageDto, DecorationImage> {
  /// Utility for defining [DecorationImageDto.image]
  late final provider = ImageProviderUtility((v) => only(image: v));

  /// Utility for defining [DecorationImageDto.fit]
  late final fit = BoxFitUtility((v) => only(fit: v));

  /// Utility for defining [DecorationImageDto.alignment]
  late final alignment = AlignmentGeometryUtility((v) => only(alignment: v));

  /// Utility for defining [DecorationImageDto.centerSlice]
  late final centerSlice = RectUtility((v) => only(centerSlice: v));

  /// Utility for defining [DecorationImageDto.repeat]
  late final repeat = ImageRepeatUtility((v) => only(repeat: v));

  /// Utility for defining [DecorationImageDto.filterQuality]
  late final filterQuality =
      FilterQualityUtility((v) => only(filterQuality: v));

  /// Utility for defining [DecorationImageDto.invertColors]
  late final invertColors = BoolUtility((v) => only(invertColors: v));

  /// Utility for defining [DecorationImageDto.isAntiAlias]
  late final isAntiAlias = BoolUtility((v) => only(isAntiAlias: v));

  DecorationImageUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [DecorationImageDto] with the specified properties.
  @override
  T only({
    ImageProvider<Object>? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) {
    return builder(DecorationImageDto(
      image: image,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      filterQuality: filterQuality,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
    ));
  }

  T call({
    ImageProvider<Object>? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) {
    return only(
      image: image,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      filterQuality: filterQuality,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
    );
  }
}

extension DecorationImageMixExt on DecorationImage {
  DecorationImageDto toDto() {
    return DecorationImageDto(
      image: image,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      filterQuality: filterQuality,
      invertColors: invertColors,
      isAntiAlias: isAntiAlias,
    );
  }
}

extension ListDecorationImageMixExt on List<DecorationImage> {
  List<DecorationImageDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

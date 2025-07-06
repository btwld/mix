// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class DecorationImageDto extends Mixable<DecorationImage>
    with HasDefaultValue<DecorationImage> {
  final ImageProvider? image;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final ImageRepeat? repeat;
  final FilterQuality? filterQuality;
  final bool? invertColors;
  final bool? isAntiAlias;

  const DecorationImageDto({
    this.image,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.repeat,
    this.filterQuality,
    this.invertColors,
    this.isAntiAlias,
  });
  @override
  DecorationImage get defaultValue =>
      const DecorationImage(image: AssetImage('NONE'));

  /// Resolves to [DecorationImage] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final decorationImage = DecorationImageDto(...).resolve(mix);
  /// ```
  @override
  DecorationImage resolve(MixContext mix) {
    return DecorationImage(
      image: image ?? defaultValue.image,
      fit: fit ?? defaultValue.fit,
      alignment: alignment ?? defaultValue.alignment,
      centerSlice: centerSlice ?? defaultValue.centerSlice,
      repeat: repeat ?? defaultValue.repeat,
      filterQuality: filterQuality ?? defaultValue.filterQuality,
      invertColors: invertColors ?? defaultValue.invertColors,
      isAntiAlias: isAntiAlias ?? defaultValue.isAntiAlias,
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
    if (other == null) return this;

    return DecorationImageDto(
      image: other.image ?? image,
      fit: other.fit ?? fit,
      alignment: other.alignment ?? alignment,
      centerSlice: other.centerSlice ?? centerSlice,
      repeat: other.repeat ?? repeat,
      filterQuality: other.filterQuality ?? filterQuality,
      invertColors: other.invertColors ?? invertColors,
      isAntiAlias: other.isAntiAlias ?? isAntiAlias,
    );
  }

  /// The list of properties that constitute the state of this [DecorationImageDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [DecorationImageDto] instances for equality.
  @override
  List<Object?> get props => [
        image,
        fit,
        alignment,
        centerSlice,
        repeat,
        filterQuality,
        invertColors,
        isAntiAlias,
      ];
}

/// Utility class for configuring [DecorationImage] properties.
///
/// This class provides methods to set individual properties of a [DecorationImage].
/// Use the methods of this class to configure specific properties of a [DecorationImage].
class DecorationImageUtility<T extends StyleElement>
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

/// Extension methods to convert [DecorationImage] to [DecorationImageDto].
extension DecorationImageMixExt on DecorationImage {
  /// Converts this [DecorationImage] to a [DecorationImageDto].
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

/// Extension methods to convert List<[DecorationImage]> to List<[DecorationImageDto]>.
extension ListDecorationImageMixExt on List<DecorationImage> {
  /// Converts this List<[DecorationImage]> to a List<[DecorationImageDto]>.
  List<DecorationImageDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class DecorationImageDto extends Mix<DecorationImage>
    with HasDefaultValue<DecorationImage> {
  // Properties use MixableProperty for cleaner merging
  final MixProperty<ImageProvider> image;
  final MixProperty<BoxFit> fit;
  final MixProperty<AlignmentGeometry> alignment;
  final MixProperty<Rect> centerSlice;
  final MixProperty<ImageRepeat> repeat;
  final MixProperty<FilterQuality> filterQuality;
  final MixProperty<bool> invertColors;
  final MixProperty<bool> isAntiAlias;

  // Main constructor accepts real values
  factory DecorationImageDto({
    ImageProvider? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) {
    return DecorationImageDto.raw(
      image: MixProperty.prop(image),
      fit: MixProperty.prop(fit),
      alignment: MixProperty.prop(alignment),
      centerSlice: MixProperty.prop(centerSlice),
      repeat: MixProperty.prop(repeat),
      filterQuality: MixProperty.prop(filterQuality),
      invertColors: MixProperty.prop(invertColors),
      isAntiAlias: MixProperty.prop(isAntiAlias),
    );
  }

  // Factory that accepts MixableProperty instances
  const DecorationImageDto.raw({
    required this.image,
    required this.fit,
    required this.alignment,
    required this.centerSlice,
    required this.repeat,
    required this.filterQuality,
    required this.invertColors,
    required this.isAntiAlias,
  });

  // Factory from DecorationImage
  factory DecorationImageDto.from(DecorationImage decorationImage) {
    return DecorationImageDto(
      image: decorationImage.image,
      fit: decorationImage.fit,
      alignment: decorationImage.alignment,
      centerSlice: decorationImage.centerSlice,
      repeat: decorationImage.repeat,
      filterQuality: decorationImage.filterQuality,
      invertColors: decorationImage.invertColors,
      isAntiAlias: decorationImage.isAntiAlias,
    );
  }

  // Nullable factory from DecorationImage
  static DecorationImageDto? maybeFrom(DecorationImage? decorationImage) {
    return decorationImage != null
        ? DecorationImageDto.from(decorationImage)
        : null;
  }

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
      image: image.resolve(mix) ?? defaultValue.image,
      fit: fit.resolve(mix) ?? defaultValue.fit,
      alignment: alignment.resolve(mix) ?? defaultValue.alignment,
      centerSlice: centerSlice.resolve(mix) ?? defaultValue.centerSlice,
      repeat: repeat.resolve(mix) ?? defaultValue.repeat,
      filterQuality: filterQuality.resolve(mix) ?? defaultValue.filterQuality,
      invertColors: invertColors.resolve(mix) ?? defaultValue.invertColors,
      isAntiAlias: isAntiAlias.resolve(mix) ?? defaultValue.isAntiAlias,
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

    return DecorationImageDto.raw(
      image: image.merge(other.image),
      fit: fit.merge(other.fit),
      alignment: alignment.merge(other.alignment),
      centerSlice: centerSlice.merge(other.centerSlice),
      repeat: repeat.merge(other.repeat),
      filterQuality: filterQuality.merge(other.filterQuality),
      invertColors: invertColors.merge(other.invertColors),
      isAntiAlias: isAntiAlias.merge(other.isAntiAlias),
    );
  }

  @override
  DecorationImage get defaultValue =>
      const DecorationImage(image: AssetImage('NONE'));

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
  late final provider = ImageProviderUtility((v) => only(image: Mix.value(v)));

  /// Utility for defining [DecorationImageDto.fit]
  late final fit = BoxFitUtility((v) => only(fit: Mix.value(v)));

  /// Utility for defining [DecorationImageDto.alignment]
  late final alignment = AlignmentGeometryUtility(
    (v) => only(alignment: Mix.value(v)),
  );

  /// Utility for defining [DecorationImageDto.centerSlice]
  late final centerSlice = RectUtility((v) => only(centerSlice: Mix.value(v)));

  /// Utility for defining [DecorationImageDto.repeat]
  late final repeat = ImageRepeatUtility((v) => only(repeat: Mix.value(v)));

  /// Utility for defining [DecorationImageDto.filterQuality]
  late final filterQuality = FilterQualityUtility(
    (v) => only(filterQuality: Mix.value(v)),
  );

  /// Utility for defining [DecorationImageDto.invertColors]
  late final invertColors = BoolUtility(
    (v) => only(invertColors: Mix.value(v)),
  );

  /// Utility for defining [DecorationImageDto.isAntiAlias]
  late final isAntiAlias = BoolUtility((v) => only(isAntiAlias: Mix.value(v)));

  DecorationImageUtility(super.builder)
    : super(valueToDto: (v) => DecorationImageDto.from(v));

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
    return builder(
      DecorationImageDto(
        image: image,
        fit: fit,
        alignment: alignment,
        centerSlice: centerSlice,
        repeat: repeat,
        filterQuality: filterQuality,
        invertColors: invertColors,
        isAntiAlias: isAntiAlias,
      ),
    );
  }

  /// Returns a new [DecorationImageDto] with the specified properties.
  @override
  T only({
    Mix<ImageProvider>? image,
    Mix<BoxFit>? fit,
    Mix<AlignmentGeometry>? alignment,
    Mix<Rect>? centerSlice,
    Mix<ImageRepeat>? repeat,
    Mix<FilterQuality>? filterQuality,
    Mix<bool>? invertColors,
    Mix<bool>? isAntiAlias,
  }) {
    return builder(
      DecorationImageDto.raw(
        image: MixProperty(image),
        fit: MixProperty(fit),
        alignment: MixProperty(alignment),
        centerSlice: MixProperty(centerSlice),
        repeat: MixProperty(repeat),
        filterQuality: MixProperty(filterQuality),
        invertColors: MixProperty(invertColors),
        isAntiAlias: MixProperty(isAntiAlias),
      ),
    );
  }
}

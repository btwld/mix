// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class DecorationImageDto extends Mix<DecorationImage>
    with HasDefaultValue<DecorationImage> {
  // Properties use MixProp for cleaner merging
  final MixProp<ImageProvider> image;
  final MixProp<BoxFit> fit;
  final MixProp<AlignmentGeometry> alignment;
  final MixProp<Rect> centerSlice;
  final MixProp<ImageRepeat> repeat;
  final MixProp<FilterQuality> filterQuality;
  final MixProp<bool> invertColors;
  final MixProp<bool> isAntiAlias;

  // Main constructor accepts Mix values
  factory DecorationImageDto({
    Mix<ImageProvider>? image,
    Mix<BoxFit>? fit,
    Mix<AlignmentGeometry>? alignment,
    Mix<Rect>? centerSlice,
    Mix<ImageRepeat>? repeat,
    Mix<FilterQuality>? filterQuality,
    Mix<bool>? invertColors,
    Mix<bool>? isAntiAlias,
  }) {
    return DecorationImageDto._(
      image: MixProp(image),
      fit: MixProp(fit),
      alignment: MixProp(alignment),
      centerSlice: MixProp(centerSlice),
      repeat: MixProp(repeat),
      filterQuality: MixProp(filterQuality),
      invertColors: MixProp(invertColors),
      isAntiAlias: MixProp(isAntiAlias),
    );
  }

  // Private constructor that accepts MixProp instances
  const DecorationImageDto._({
    required this.image,
    required this.fit,
    required this.alignment,
    required this.centerSlice,
    required this.repeat,
    required this.filterQuality,
    required this.invertColors,
    required this.isAntiAlias,
  });

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

    return DecorationImageDto._(
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


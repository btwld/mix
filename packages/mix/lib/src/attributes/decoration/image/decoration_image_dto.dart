// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class DecorationImageDto extends Mix<DecorationImage> {
  // Properties use MixProp for cleaner merging
  final Prop<ImageProvider>? image;
  final Prop<BoxFit>? fit;
  final Prop<AlignmentGeometry>? alignment;
  final Prop<Rect>? centerSlice;
  final Prop<ImageRepeat>? repeat;
  final Prop<FilterQuality>? filterQuality;
  final Prop<bool>? invertColors;
  final Prop<bool>? isAntiAlias;

  // Main constructor accepts raw values
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
    return DecorationImageDto.props(
      image: Prop.maybeValue(image),
      fit: Prop.maybeValue(fit),
      alignment: Prop.maybeValue(alignment),
      centerSlice: Prop.maybeValue(centerSlice),
      repeat: Prop.maybeValue(repeat),
      filterQuality: Prop.maybeValue(filterQuality),
      invertColors: Prop.maybeValue(invertColors),
      isAntiAlias: Prop.maybeValue(isAntiAlias),
    );
  }

  /// Constructor that accepts a [DecorationImage] value and extracts its properties.
  ///
  /// This is useful for converting existing [DecorationImage] instances to [DecorationImageDto].
  ///
  /// ```dart
  /// const decorationImage = DecorationImage(image: AssetImage('assets/image.png'));
  /// final dto = DecorationImageDto.value(decorationImage);
  /// ```
  factory DecorationImageDto.value(DecorationImage decorationImage) {
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

  // Private constructor that accepts MixProp instances
  const DecorationImageDto.props({
    this.image,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.repeat,
    this.filterQuality,
    this.invertColors,
    this.isAntiAlias,
  });

  /// Constructor that accepts a nullable [DecorationImage] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [DecorationImageDto.value].
  ///
  /// ```dart
  /// const DecorationImage? decorationImage = DecorationImage(image: AssetImage('assets/image.png'));
  /// final dto = DecorationImageDto.maybeValue(decorationImage); // Returns DecorationImageDto or null
  /// ```
  static DecorationImageDto? maybeValue(DecorationImage? decorationImage) {
    return decorationImage != null
        ? DecorationImageDto.value(decorationImage)
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
  DecorationImage resolve(MixContext context) {
    final resolvedImage = resolveProp(context, image);
    if (resolvedImage == null) {
      throw StateError('DecorationImage requires an image provider');
    }

    return DecorationImage(
      image: resolvedImage,
      fit: resolveProp(context, fit),
      alignment: resolveProp(context, alignment) ?? Alignment.center,
      centerSlice: resolveProp(context, centerSlice),
      repeat: resolveProp(context, repeat) ?? ImageRepeat.noRepeat,
      filterQuality: resolveProp(context, filterQuality) ?? FilterQuality.low,
      invertColors: resolveProp(context, invertColors) ?? false,
      isAntiAlias: resolveProp(context, isAntiAlias) ?? false,
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

    return DecorationImageDto.props(
      image: mergeProp(image, other.image),
      fit: mergeProp(fit, other.fit),
      alignment: mergeProp(alignment, other.alignment),
      centerSlice: mergeProp(centerSlice, other.centerSlice),
      repeat: mergeProp(repeat, other.repeat),
      filterQuality: mergeProp(filterQuality, other.filterQuality),
      invertColors: mergeProp(invertColors, other.invertColors),
      isAntiAlias: mergeProp(isAntiAlias, other.isAntiAlias),
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

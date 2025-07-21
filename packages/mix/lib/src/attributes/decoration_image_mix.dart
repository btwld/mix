// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

final class DecorationImageMix extends Mix<DecorationImage>
    with Diagnosticable {
  // Properties use MixProp for cleaner merging
  final Prop<ImageProvider>? image;
  final Prop<BoxFit>? fit;
  final Prop<AlignmentGeometry>? alignment;
  final Prop<Rect>? centerSlice;
  final Prop<ImageRepeat>? repeat;
  final Prop<FilterQuality>? filterQuality;
  final Prop<bool>? invertColors;
  final Prop<bool>? isAntiAlias;

  DecorationImageMix.only({
    ImageProvider? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) : this(
         image: Prop.maybe(image),
         fit: Prop.maybe(fit),
         alignment: Prop.maybe(alignment),
         centerSlice: Prop.maybe(centerSlice),
         repeat: Prop.maybe(repeat),
         filterQuality: Prop.maybe(filterQuality),
         invertColors: Prop.maybe(invertColors),
         isAntiAlias: Prop.maybe(isAntiAlias),
       );

  const DecorationImageMix({
    this.image,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.repeat,
    this.filterQuality,
    this.invertColors,
    this.isAntiAlias,
  });

  /// Constructor that accepts a [DecorationImage] value and extracts its properties.
  ///
  /// This is useful for converting existing [DecorationImage] instances to [DecorationImageMix].
  ///
  /// ```dart
  /// const decorationImage = DecorationImage(image: AssetImage('assets/image.png'));
  /// final dto = DecorationImageMix.value(decorationImage);
  /// ```
  DecorationImageMix.value(DecorationImage decorationImage)
    : this.only(
        image: decorationImage.image,
        fit: decorationImage.fit,
        alignment: decorationImage.alignment,
        centerSlice: decorationImage.centerSlice,
        repeat: decorationImage.repeat,
        filterQuality: decorationImage.filterQuality,
        invertColors: decorationImage.invertColors,
        isAntiAlias: decorationImage.isAntiAlias,
      );

  /// Constructor that accepts a nullable [DecorationImage] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [DecorationImageMix.value].
  ///
  /// ```dart
  /// const DecorationImage? decorationImage = DecorationImage(image: AssetImage('assets/image.png'));
  /// final dto = DecorationImageMix.maybeValue(decorationImage); // Returns DecorationImageMix or null
  /// ```
  static DecorationImageMix? maybeValue(DecorationImage? decorationImage) {
    return decorationImage != null
        ? DecorationImageMix.value(decorationImage)
        : null;
  }

  /// Resolves to [DecorationImage] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final decorationImage = DecorationImageMix(...).resolve(mix);
  /// ```
  @override
  DecorationImage resolve(BuildContext context) {
    final resolvedImage = MixHelpers.resolve(context, image);
    if (resolvedImage == null) {
      throw StateError('DecorationImage requires an image provider');
    }

    return DecorationImage(
      image: resolvedImage,
      fit: MixHelpers.resolve(context, fit),
      alignment: MixHelpers.resolve(context, alignment) ?? Alignment.center,
      centerSlice: MixHelpers.resolve(context, centerSlice),
      repeat: MixHelpers.resolve(context, repeat) ?? ImageRepeat.noRepeat,
      filterQuality:
          MixHelpers.resolve(context, filterQuality) ?? FilterQuality.low,
      invertColors: MixHelpers.resolve(context, invertColors) ?? false,
      isAntiAlias: MixHelpers.resolve(context, isAntiAlias) ?? false,
    );
  }

  /// Merges the properties of this [DecorationImageMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [DecorationImageMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  DecorationImageMix merge(DecorationImageMix? other) {
    if (other == null) return this;

    return DecorationImageMix(
      image: MixHelpers.merge(image, other.image),
      fit: MixHelpers.merge(fit, other.fit),
      alignment: MixHelpers.merge(alignment, other.alignment),
      centerSlice: MixHelpers.merge(centerSlice, other.centerSlice),
      repeat: MixHelpers.merge(repeat, other.repeat),
      filterQuality: MixHelpers.merge(filterQuality, other.filterQuality),
      invertColors: MixHelpers.merge(invertColors, other.invertColors),
      isAntiAlias: MixHelpers.merge(isAntiAlias, other.isAntiAlias),
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is DecorationImageMix &&
        image == other.image &&
        fit == other.fit &&
        alignment == other.alignment &&
        centerSlice == other.centerSlice &&
        repeat == other.repeat &&
        filterQuality == other.filterQuality &&
        invertColors == other.invertColors &&
        isAntiAlias == other.isAntiAlias;
  }

  @override
  int get hashCode => Object.hash(
    image,
    fit,
    alignment,
    centerSlice,
    repeat,
    filterQuality,
    invertColors,
    isAntiAlias,
  );
}

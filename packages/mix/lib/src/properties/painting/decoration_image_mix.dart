import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Mix-compatible representation of Flutter's [DecorationImage] for background styling.
///
/// Configures how images are displayed within decorations, including fit, alignment,
/// repeat behavior, and quality settings with token support and merging capabilities.
final class DecorationImageMix extends Mix<DecorationImage>
    with Diagnosticable {
  final Prop<ImageProvider>? $image;
  final Prop<BoxFit>? $fit;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Rect>? $centerSlice;
  final Prop<ImageRepeat>? $repeat;
  final Prop<FilterQuality>? $filterQuality;
  final Prop<bool>? $invertColors;
  final Prop<bool>? $isAntiAlias;

  DecorationImageMix({
    ImageProvider? image,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    ImageRepeat? repeat,
    FilterQuality? filterQuality,
    bool? invertColors,
    bool? isAntiAlias,
  }) : this.raw(
         image: Prop.maybe(image),
         fit: Prop.maybe(fit),
         alignment: Prop.maybe(alignment),
         centerSlice: Prop.maybe(centerSlice),
         repeat: Prop.maybe(repeat),
         filterQuality: Prop.maybe(filterQuality),
         invertColors: Prop.maybe(invertColors),
         isAntiAlias: Prop.maybe(isAntiAlias),
       );

  const DecorationImageMix.raw({
    Prop<ImageProvider>? image,
    Prop<BoxFit>? fit,
    Prop<AlignmentGeometry>? alignment,
    Prop<Rect>? centerSlice,
    Prop<ImageRepeat>? repeat,
    Prop<FilterQuality>? filterQuality,
    Prop<bool>? invertColors,
    Prop<bool>? isAntiAlias,
  }) : $image = image,
       $fit = fit,
       $alignment = alignment,
       $centerSlice = centerSlice,
       $repeat = repeat,
       $filterQuality = filterQuality,
       $invertColors = invertColors,
       $isAntiAlias = isAntiAlias;

  /// Creates a [DecorationImageMix] from an existing [DecorationImage].
  ///
  /// ```dart
  /// const decorationImage = DecorationImage(image: AssetImage('assets/image.png'));
  /// final dto = DecorationImageMix.value(decorationImage);
  /// ```
  DecorationImageMix.value(DecorationImage decorationImage)
    : this(
        image: decorationImage.image,
        fit: decorationImage.fit,
        alignment: decorationImage.alignment,
        centerSlice: decorationImage.centerSlice,
        repeat: decorationImage.repeat,
        filterQuality: decorationImage.filterQuality,
        invertColors: decorationImage.invertColors,
        isAntiAlias: decorationImage.isAntiAlias,
      );

  /// Creates a decoration image with the specified image provider.
  factory DecorationImageMix.image(ImageProvider value) {
    return DecorationImageMix(image: value);
  }

  /// Creates a decoration image with the specified fit behavior.
  factory DecorationImageMix.fit(BoxFit value) {
    return DecorationImageMix(fit: value);
  }

  /// Creates a decoration image with the specified alignment.
  factory DecorationImageMix.alignment(AlignmentGeometry value) {
    return DecorationImageMix(alignment: value);
  }

  /// Creates a decoration image with the specified center slice for nine-patch scaling.
  factory DecorationImageMix.centerSlice(Rect value) {
    return DecorationImageMix(centerSlice: value);
  }

  /// Creates a decoration image with the specified repeat behavior.
  factory DecorationImageMix.repeat(ImageRepeat value) {
    return DecorationImageMix(repeat: value);
  }

  /// Creates a decoration image with the specified filter quality.
  factory DecorationImageMix.filterQuality(FilterQuality value) {
    return DecorationImageMix(filterQuality: value);
  }

  /// Creates a decoration image with color inversion enabled or disabled.
  factory DecorationImageMix.invertColors(bool value) {
    return DecorationImageMix(invertColors: value);
  }

  /// Creates a decoration image with anti-aliasing enabled or disabled.
  factory DecorationImageMix.isAntiAlias(bool value) {
    return DecorationImageMix(isAntiAlias: value);
  }

  /// Creates a [DecorationImageMix] from a nullable [DecorationImage].
  ///
  /// Returns null if the input is null.
  static DecorationImageMix? maybeValue(DecorationImage? decorationImage) {
    return decorationImage != null
        ? DecorationImageMix.value(decorationImage)
        : null;
  }

  /// Returns a copy with the specified image provider.
  DecorationImageMix image(ImageProvider value) {
    return merge(DecorationImageMix.image(value));
  }

  /// Returns a copy with the specified fit behavior.
  DecorationImageMix fit(BoxFit value) {
    return merge(DecorationImageMix.fit(value));
  }

  /// Returns a copy with the specified alignment.
  DecorationImageMix alignment(AlignmentGeometry value) {
    return merge(DecorationImageMix.alignment(value));
  }

  /// Returns a copy with the specified center slice for nine-patch scaling.
  DecorationImageMix centerSlice(Rect value) {
    return merge(DecorationImageMix.centerSlice(value));
  }

  /// Returns a copy with the specified repeat behavior.
  DecorationImageMix repeat(ImageRepeat value) {
    return merge(DecorationImageMix.repeat(value));
  }

  /// Returns a copy with the specified filter quality.
  DecorationImageMix filterQuality(FilterQuality value) {
    return merge(DecorationImageMix.filterQuality(value));
  }

  /// Returns a copy with color inversion enabled or disabled.
  DecorationImageMix invertColors(bool value) {
    return merge(DecorationImageMix.invertColors(value));
  }

  /// Returns a copy with anti-aliasing enabled or disabled.
  DecorationImageMix isAntiAlias(bool value) {
    return merge(DecorationImageMix.isAntiAlias(value));
  }

  /// Resolves to [DecorationImage] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final decorationImage = DecorationImageMix(...).resolve(mix);
  /// ```
  @override
  DecorationImage resolve(BuildContext context) {
    final resolvedImage = MixHelpers.resolve(context, $image);
    if (resolvedImage == null) {
      throw StateError('DecorationImage requires an image provider');
    }

    return DecorationImage(
      image: resolvedImage,
      fit: MixHelpers.resolve(context, $fit),
      alignment: MixHelpers.resolve(context, $alignment) ?? Alignment.center,
      centerSlice: MixHelpers.resolve(context, $centerSlice),
      repeat: MixHelpers.resolve(context, $repeat) ?? ImageRepeat.noRepeat,
      filterQuality:
          MixHelpers.resolve(context, $filterQuality) ?? FilterQuality.medium,
      invertColors: MixHelpers.resolve(context, $invertColors) ?? false,
      isAntiAlias: MixHelpers.resolve(context, $isAntiAlias) ?? false,
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

    return DecorationImageMix.raw(
      image: $image.tryMerge(other.$image),
      fit: $fit.tryMerge(other.$fit),
      alignment: $alignment.tryMerge(other.$alignment),
      centerSlice: $centerSlice.tryMerge(other.$centerSlice),
      repeat: $repeat.tryMerge(other.$repeat),
      filterQuality: $filterQuality.tryMerge(other.$filterQuality),
      invertColors: $invertColors.tryMerge(other.$invertColors),
      isAntiAlias: $isAntiAlias.tryMerge(other.$isAntiAlias),
    );
  }

  @override
  List<Object?> get props => [
    $image,
    $fit,
    $alignment,
    $centerSlice,
    $repeat,
    $filterQuality,
    $invertColors,
    $isAntiAlias,
  ];
}

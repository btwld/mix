import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Mix representation of [DecorationImage].
///
/// Controls image display with fit, alignment, and quality.
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
  }) : this.create(
         image: Prop.maybe(image),
         fit: Prop.maybe(fit),
         alignment: Prop.maybe(alignment),
         centerSlice: Prop.maybe(centerSlice),
         repeat: Prop.maybe(repeat),
         filterQuality: Prop.maybe(filterQuality),
         invertColors: Prop.maybe(invertColors),
         isAntiAlias: Prop.maybe(isAntiAlias),
       );

  const DecorationImageMix.create({
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

  /// Creates from [DecorationImage].
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

  /// Creates with image provider.
  factory DecorationImageMix.image(ImageProvider value) {
    return DecorationImageMix(image: value);
  }

  /// Creates with fit behavior.
  factory DecorationImageMix.fit(BoxFit value) {
    return DecorationImageMix(fit: value);
  }

  /// Creates with alignment.
  factory DecorationImageMix.alignment(AlignmentGeometry value) {
    return DecorationImageMix(alignment: value);
  }

  /// Creates with center slice.
  factory DecorationImageMix.centerSlice(Rect value) {
    return DecorationImageMix(centerSlice: value);
  }

  /// Creates with repeat behavior.
  factory DecorationImageMix.repeat(ImageRepeat value) {
    return DecorationImageMix(repeat: value);
  }

  /// Creates with filter quality.
  factory DecorationImageMix.filterQuality(FilterQuality value) {
    return DecorationImageMix(filterQuality: value);
  }

  /// Creates with color inversion.
  factory DecorationImageMix.invertColors(bool value) {
    return DecorationImageMix(invertColors: value);
  }

  /// Creates with anti-aliasing.
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
    final resolvedImage = MixOps.resolve(context, $image);
    if (resolvedImage == null) {
      throw StateError('DecorationImage requires an image provider');
    }

    return DecorationImage(
      image: resolvedImage,
      fit: MixOps.resolve(context, $fit),
      alignment: MixOps.resolve(context, $alignment) ?? Alignment.center,
      centerSlice: MixOps.resolve(context, $centerSlice),
      repeat: MixOps.resolve(context, $repeat) ?? ImageRepeat.noRepeat,
      filterQuality:
          MixOps.resolve(context, $filterQuality) ?? FilterQuality.medium,
      invertColors: MixOps.resolve(context, $invertColors) ?? false,
      isAntiAlias: MixOps.resolve(context, $isAntiAlias) ?? false,
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
    return DecorationImageMix.create(
      image: MixOps.merge($image, other?.$image),
      fit: MixOps.merge($fit, other?.$fit),
      alignment: MixOps.merge($alignment, other?.$alignment),
      centerSlice: MixOps.merge($centerSlice, other?.$centerSlice),
      repeat: MixOps.merge($repeat, other?.$repeat),
      filterQuality: MixOps.merge($filterQuality, other?.$filterQuality),
      invertColors: MixOps.merge($invertColors, other?.$invertColors),
      isAntiAlias: MixOps.merge($isAntiAlias, other?.$isAntiAlias),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('image', $image))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('centerSlice', $centerSlice))
      ..add(DiagnosticsProperty('repeat', $repeat))
      ..add(DiagnosticsProperty('filterQuality', $filterQuality))
      ..add(DiagnosticsProperty('invertColors', $invertColors))
      ..add(DiagnosticsProperty('isAntiAlias', $isAntiAlias));
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

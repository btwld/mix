import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'image_spec.dart';

class ImageMix extends Style<ImageSpec>
    with
        Diagnosticable,
        StyleModifierMixin<ImageMix, ImageSpec>,
        StyleVariantMixin<ImageMix, ImageSpec> {
  final Prop<double>? $width;
  final Prop<double>? $height;
  final Prop<Color>? $color;
  final Prop<ImageRepeat>? $repeat;
  final Prop<BoxFit>? $fit;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<Rect>? $centerSlice;
  final Prop<FilterQuality>? $filterQuality;
  final Prop<BlendMode>? $colorBlendMode;

  /// Factory for image width
  factory ImageMix.width(double value) {
    return ImageMix(width: value);
  }

  /// Factory for image height
  factory ImageMix.height(double value) {
    return ImageMix(height: value);
  }

  /// Factory for image color
  factory ImageMix.color(Color value) {
    return ImageMix(color: value);
  }

  /// Factory for image repeat
  factory ImageMix.repeat(ImageRepeat value) {
    return ImageMix(repeat: value);
  }

  /// Factory for image fit
  factory ImageMix.fit(BoxFit value) {
    return ImageMix(fit: value);
  }

  /// Factory for image alignment
  factory ImageMix.alignment(AlignmentGeometry value) {
    return ImageMix(alignment: value);
  }

  /// Factory for center slice
  factory ImageMix.centerSlice(Rect value) {
    return ImageMix(centerSlice: value);
  }

  /// Factory for filter quality
  factory ImageMix.filterQuality(FilterQuality value) {
    return ImageMix(filterQuality: value);
  }

  /// Factory for color blend mode
  factory ImageMix.colorBlendMode(BlendMode value) {
    return ImageMix(colorBlendMode: value);
  }

  /// Factory for animation
  factory ImageMix.animate(AnimationConfig animation) {
    return ImageMix(animation: animation);
  }

  /// Factory for variant
  factory ImageMix.variant(Variant variant, ImageMix value) {
    return ImageMix(variants: [VariantStyleAttribute(variant, value)]);
  }

  const ImageMix.raw({
    Prop<double>? width,
    Prop<double>? height,
    Prop<Color>? color,
    Prop<ImageRepeat>? repeat,
    Prop<BoxFit>? fit,
    Prop<AlignmentGeometry>? alignment,
    Prop<Rect>? centerSlice,
    Prop<FilterQuality>? filterQuality,
    Prop<BlendMode>? colorBlendMode,
    super.animation,
    super.modifiers,
    super.variants,
    super.orderOfModifiers,
    super.inherit,
  }) : $width = width,
       $height = height,
       $color = color,
       $repeat = repeat,
       $fit = fit,
       $alignment = alignment,
       $centerSlice = centerSlice,
       $filterQuality = filterQuality,
       $colorBlendMode = colorBlendMode;

  ImageMix({
    double? width,
    double? height,
    Color? color,
    ImageRepeat? repeat,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    Rect? centerSlice,
    FilterQuality? filterQuality,
    BlendMode? colorBlendMode,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<ImageSpec>>? variants,
    List<Type>? orderOfModifiers,
  }) : this.raw(
         width: Prop.maybe(width),
         height: Prop.maybe(height),
         color: Prop.maybe(color),
         repeat: Prop.maybe(repeat),
         fit: Prop.maybe(fit),
         alignment: Prop.maybe(alignment),
         centerSlice: Prop.maybe(centerSlice),
         filterQuality: Prop.maybe(filterQuality),
         colorBlendMode: Prop.maybe(colorBlendMode),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
         orderOfModifiers: orderOfModifiers,
       );

  /// Constructor that accepts an [ImageSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ImageSpec] instances to [ImageMix].
  ///
  /// ```dart
  /// const spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.value(spec);
  /// ```
  ImageMix.value(ImageSpec spec)
    : this(
        width: spec.width,
        height: spec.height,
        color: spec.color,
        repeat: spec.repeat,
        fit: spec.fit,
        alignment: spec.alignment,
        centerSlice: spec.centerSlice,
        filterQuality: spec.filterQuality,
        colorBlendMode: spec.colorBlendMode,
      );

  /// Constructor that accepts a nullable [ImageSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ImageSpecAttribute.value].
  ///
  /// ```dart
  /// const ImageSpec? spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageSpecAttribute.maybeValue(spec); // Returns ImageSpecAttribute or null
  /// ```
  static ImageMix? maybeValue(ImageSpec? spec) {
    return spec != null ? ImageMix.value(spec) : null;
  }

  /// Sets image width
  ImageMix width(double value) {
    return merge(ImageMix.width(value));
  }

  /// Sets image height
  ImageMix height(double value) {
    return merge(ImageMix.height(value));
  }

  /// Sets image color
  ImageMix color(Color value) {
    return merge(ImageMix.color(value));
  }

  /// Sets image repeat
  ImageMix repeat(ImageRepeat value) {
    return merge(ImageMix.repeat(value));
  }

  /// Sets image fit
  ImageMix fit(BoxFit value) {
    return merge(ImageMix.fit(value));
  }

  /// Sets image alignment
  ImageMix alignment(AlignmentGeometry value) {
    return merge(ImageMix.alignment(value));
  }

  /// Sets center slice
  ImageMix centerSlice(Rect value) {
    return merge(ImageMix.centerSlice(value));
  }

  /// Sets filter quality
  ImageMix filterQuality(FilterQuality value) {
    return merge(ImageMix.filterQuality(value));
  }

  /// Sets color blend mode
  ImageMix colorBlendMode(BlendMode value) {
    return merge(ImageMix.colorBlendMode(value));
  }

  /// Convenience method for animating the ImageSpec
  ImageMix animate(AnimationConfig animation) {
    return merge(ImageMix.animate(animation));
  }

  @override
  ImageMix variants(List<VariantStyleAttribute<ImageSpec>> variants) {
    return merge(ImageMix(variants: variants));
  }

  @override
  ImageMix modifiers(List<ModifierAttribute> modifiers) {
    return merge(ImageMix(modifiers: modifiers));
  }

  @override
  ImageSpec resolve(BuildContext context) {
    return ImageSpec(
      width: MixHelpers.resolve(context, $width),
      height: MixHelpers.resolve(context, $height),
      color: MixHelpers.resolve(context, $color),
      repeat: MixHelpers.resolve(context, $repeat),
      fit: MixHelpers.resolve(context, $fit),
      alignment: MixHelpers.resolve(context, $alignment),
      centerSlice: MixHelpers.resolve(context, $centerSlice),
      filterQuality: MixHelpers.resolve(context, $filterQuality),
      colorBlendMode: MixHelpers.resolve(context, $colorBlendMode),
    );
  }

  @override
  ImageMix merge(ImageMix? other) {
    if (other == null) return this;

    return ImageMix.raw(
      width: MixHelpers.merge($width, other.$width),
      height: MixHelpers.merge($height, other.$height),
      color: MixHelpers.merge($color, other.$color),
      repeat: MixHelpers.merge($repeat, other.$repeat),
      fit: MixHelpers.merge($fit, other.$fit),
      alignment: MixHelpers.merge($alignment, other.$alignment),
      centerSlice: MixHelpers.merge($centerSlice, other.$centerSlice),
      filterQuality: MixHelpers.merge($filterQuality, other.$filterQuality),
      colorBlendMode: MixHelpers.merge($colorBlendMode, other.$colorBlendMode),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', $width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', $height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', $color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', $repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', $fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', $alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', $centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', $filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'colorBlendMode',
        $colorBlendMode,
        defaultValue: null,
      ),
    );
  }

  @override
  ImageMix variant(Variant variant, ImageMix style) {
    return merge(ImageMix(variants: [VariantStyleAttribute(variant, style)]));
  }

  @override
  List<Object?> get props => [
    $width,
    $height,
    $color,
    $repeat,
    $fit,
    $alignment,
    $centerSlice,
    $filterQuality,
    $colorBlendMode,
    $animation,
    $modifiers,
    $variants,
  ];
}

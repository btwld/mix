import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_config.dart';
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
  final Prop<String>? $semanticLabel;
  final Prop<bool>? $excludeFromSemantics;
  final Prop<bool>? $gaplessPlayback;
  final Prop<bool>? $isAntiAlias;
  final Prop<bool>? $matchTextDirection;

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

  /// Factory for semantic label
  factory ImageMix.semanticLabel(String value) {
    return ImageMix(semanticLabel: value);
  }

  /// Factory for exclude from semantics
  factory ImageMix.excludeFromSemantics(bool value) {
    return ImageMix(excludeFromSemantics: value);
  }

  /// Factory for gapless playback
  factory ImageMix.gaplessPlayback(bool value) {
    return ImageMix(gaplessPlayback: value);
  }

  /// Factory for is anti alias
  factory ImageMix.isAntiAlias(bool value) {
    return ImageMix(isAntiAlias: value);
  }

  /// Factory for match text direction
  factory ImageMix.matchTextDirection(bool value) {
    return ImageMix(matchTextDirection: value);
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
    Prop<String>? semanticLabel,
    Prop<bool>? excludeFromSemantics,
    Prop<bool>? gaplessPlayback,
    Prop<bool>? isAntiAlias,
    Prop<bool>? matchTextDirection,
    super.animation,
    super.modifierConfig,
    super.variants,

    super.inherit,
  }) : $width = width,
       $height = height,
       $color = color,
       $repeat = repeat,
       $fit = fit,
       $alignment = alignment,
       $centerSlice = centerSlice,
       $filterQuality = filterQuality,
       $colorBlendMode = colorBlendMode,
       $semanticLabel = semanticLabel,
       $excludeFromSemantics = excludeFromSemantics,
       $gaplessPlayback = gaplessPlayback,
       $isAntiAlias = isAntiAlias,
       $matchTextDirection = matchTextDirection;

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
    String? semanticLabel,
    bool? excludeFromSemantics,
    bool? gaplessPlayback,
    bool? isAntiAlias,
    bool? matchTextDirection,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<ImageSpec>>? variants,
    bool? inherit,
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
         semanticLabel: Prop.maybe(semanticLabel),
         excludeFromSemantics: Prop.maybe(excludeFromSemantics),
         gaplessPlayback: Prop.maybe(gaplessPlayback),
         isAntiAlias: Prop.maybe(isAntiAlias),
         matchTextDirection: Prop.maybe(matchTextDirection),
         animation: animation,
         modifierConfig: modifierConfig,
         variants: variants,
         inherit: inherit,
       );

  /// Constructor that accepts an [ImageSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ImageSpec] instances to [ImageMix].
  ///
  /// ```dart
  /// const spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageMix.value(spec);
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
        semanticLabel: spec.semanticLabel,
        excludeFromSemantics: spec.excludeFromSemantics,
        gaplessPlayback: spec.gaplessPlayback,
        isAntiAlias: spec.isAntiAlias,
        matchTextDirection: spec.matchTextDirection,
      );

  /// Constructor that accepts a nullable [ImageSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ImageMix.value].
  ///
  /// ```dart
  /// const ImageSpec? spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageMix.maybeValue(spec); // Returns ImageMix or null
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

  /// Sets semantic label
  ImageMix semanticLabel(String value) {
    return merge(ImageMix.semanticLabel(value));
  }

  /// Sets exclude from semantics
  ImageMix excludeFromSemantics(bool value) {
    return merge(ImageMix.excludeFromSemantics(value));
  }

  /// Sets gapless playback
  ImageMix gaplessPlayback(bool value) {
    return merge(ImageMix.gaplessPlayback(value));
  }

  /// Sets is anti alias
  ImageMix isAntiAlias(bool value) {
    return merge(ImageMix.isAntiAlias(value));
  }

  /// Sets match text direction
  ImageMix matchTextDirection(bool value) {
    return merge(ImageMix.matchTextDirection(value));
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
  ImageMix modifier(ModifierConfig value) {
    return merge(ImageMix(modifierConfig: value));
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
      semanticLabel: MixHelpers.resolve(context, $semanticLabel),
      excludeFromSemantics: MixHelpers.resolve(context, $excludeFromSemantics),
      gaplessPlayback: MixHelpers.resolve(context, $gaplessPlayback),
      isAntiAlias: MixHelpers.resolve(context, $isAntiAlias),
      matchTextDirection: MixHelpers.resolve(context, $matchTextDirection),
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
      semanticLabel: MixHelpers.merge($semanticLabel, other.$semanticLabel),
      excludeFromSemantics: MixHelpers.merge($excludeFromSemantics, other.$excludeFromSemantics),
      gaplessPlayback: MixHelpers.merge($gaplessPlayback, other.$gaplessPlayback),
      isAntiAlias: MixHelpers.merge($isAntiAlias, other.$isAntiAlias),
      matchTextDirection: MixHelpers.merge($matchTextDirection, other.$matchTextDirection),
      animation: other.$animation ?? $animation,
      modifierConfig:
          $modifierConfig?.merge(other.$modifierConfig) ??
          other.$modifierConfig,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
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
    properties.add(
      DiagnosticsProperty('semanticLabel', $semanticLabel, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('excludeFromSemantics', $excludeFromSemantics, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('gaplessPlayback', $gaplessPlayback, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('isAntiAlias', $isAntiAlias, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('matchTextDirection', $matchTextDirection, defaultValue: null),
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
    $semanticLabel,
    $excludeFromSemantics,
    $gaplessPlayback,
    $isAntiAlias,
    $matchTextDirection,
    $animation,
    $modifierConfig,
    $variants,
  ];
}

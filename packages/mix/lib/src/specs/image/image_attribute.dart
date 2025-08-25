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
import 'image_widget.dart';

typedef ImageMix = ImageStyle;

class ImageStyle extends Style<ImageWidgetSpec>
    with
        Diagnosticable,
        StyleModifierMixin<ImageStyle, ImageWidgetSpec>,
        StyleVariantMixin<ImageStyle, ImageWidgetSpec> {
  final Prop<ImageProvider<Object>>? $image;
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

  /// Factory for image provider
  factory ImageStyle.image(ImageProvider<Object> value) {
    return ImageStyle(image: value);
  }

  /// Factory for image width
  factory ImageStyle.width(double value) {
    return ImageStyle(width: value);
  }

  /// Factory for image height
  factory ImageStyle.height(double value) {
    return ImageStyle(height: value);
  }

  /// Factory for image color
  factory ImageStyle.color(Color value) {
    return ImageStyle(color: value);
  }

  /// Factory for image repeat
  factory ImageStyle.repeat(ImageRepeat value) {
    return ImageStyle(repeat: value);
  }

  /// Factory for image fit
  factory ImageStyle.fit(BoxFit value) {
    return ImageStyle(fit: value);
  }

  /// Factory for image alignment
  factory ImageStyle.alignment(AlignmentGeometry value) {
    return ImageStyle(alignment: value);
  }

  /// Factory for center slice
  factory ImageStyle.centerSlice(Rect value) {
    return ImageStyle(centerSlice: value);
  }

  /// Factory for filter quality
  factory ImageStyle.filterQuality(FilterQuality value) {
    return ImageStyle(filterQuality: value);
  }

  /// Factory for color blend mode
  factory ImageStyle.colorBlendMode(BlendMode value) {
    return ImageStyle(colorBlendMode: value);
  }

  /// Factory for semantic label
  factory ImageStyle.semanticLabel(String value) {
    return ImageStyle(semanticLabel: value);
  }

  /// Factory for exclude from semantics
  factory ImageStyle.excludeFromSemantics(bool value) {
    return ImageStyle(excludeFromSemantics: value);
  }

  /// Factory for gapless playback
  factory ImageStyle.gaplessPlayback(bool value) {
    return ImageStyle(gaplessPlayback: value);
  }

  /// Factory for is anti alias
  factory ImageStyle.isAntiAlias(bool value) {
    return ImageStyle(isAntiAlias: value);
  }

  /// Factory for match text direction
  factory ImageStyle.matchTextDirection(bool value) {
    return ImageStyle(matchTextDirection: value);
  }

  /// Factory for animation
  factory ImageStyle.animate(AnimationConfig animation) {
    return ImageStyle(animation: animation);
  }

  /// Factory for variant
  factory ImageStyle.variant(Variant variant, ImageStyle value) {
    return ImageStyle(variants: [VariantStyle(variant, value)]);
  }

  /// Factory for widget modifier
  factory ImageStyle.modifier(ModifierConfig modifier) {
    return ImageStyle(modifier: modifier);
  }

  /// Factory for widget modifier
  factory ImageStyle.wrap(ModifierConfig value) {
    return ImageStyle(modifier: value);
  }

  const ImageStyle.create({
    Prop<ImageProvider<Object>>? image,
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
    super.modifier,
    super.variants,

    super.inherit,
  }) : $image = image,
       $width = width,
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

  ImageStyle({
    ImageProvider<Object>? image,
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
    ModifierConfig? modifier,
    List<VariantStyle<ImageWidgetSpec>>? variants,
    bool? inherit,
  }) : this.create(
         image: Prop.maybe(image),
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
         modifier: modifier,
         variants: variants,
         inherit: inherit,
       );

  /// Constructor that accepts an [ImageWidgetSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [ImageWidgetSpec] instances to [ImageStyle].
  ///
  /// ```dart
  /// const spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageMix.value(spec);
  /// ```
  ImageStyle.value(ImageWidgetSpec spec)
    : this(
        image: spec.image,
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

  /// Constructor that accepts a nullable [ImageWidgetSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ImageMix.value].
  ///
  /// ```dart
  /// const ImageSpec? spec = ImageSpec(width: 100, height: 100, fit: BoxFit.cover);
  /// final attr = ImageMix.maybeValue(spec); // Returns ImageMix or null
  /// ```
  static ImageStyle? maybeValue(ImageWidgetSpec? spec) {
    return spec != null ? ImageStyle.value(spec) : null;
  }

  /// Sets image provider
  ImageStyle image(ImageProvider<Object> value) {
    return merge(ImageStyle.image(value));
  }

  /// Sets image width
  ImageStyle width(double value) {
    return merge(ImageStyle.width(value));
  }

  /// Sets image height
  ImageStyle height(double value) {
    return merge(ImageStyle.height(value));
  }

  /// Sets image color
  ImageStyle color(Color value) {
    return merge(ImageStyle.color(value));
  }

  /// Sets image repeat
  ImageStyle repeat(ImageRepeat value) {
    return merge(ImageStyle.repeat(value));
  }

  /// Sets image fit
  ImageStyle fit(BoxFit value) {
    return merge(ImageStyle.fit(value));
  }

  /// Sets image alignment
  ImageStyle alignment(AlignmentGeometry value) {
    return merge(ImageStyle.alignment(value));
  }

  StyledImage call({
    ImageProvider? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage(
      style: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      image: image,
      opacity: opacity,
    );
  }

  /// Sets center slice
  ImageStyle centerSlice(Rect value) {
    return merge(ImageStyle.centerSlice(value));
  }

  /// Sets filter quality
  ImageStyle filterQuality(FilterQuality value) {
    return merge(ImageStyle.filterQuality(value));
  }

  /// Sets color blend mode
  ImageStyle colorBlendMode(BlendMode value) {
    return merge(ImageStyle.colorBlendMode(value));
  }

  /// Sets semantic label
  ImageStyle semanticLabel(String value) {
    return merge(ImageStyle.semanticLabel(value));
  }

  /// Sets exclude from semantics
  ImageStyle excludeFromSemantics(bool value) {
    return merge(ImageStyle.excludeFromSemantics(value));
  }

  /// Sets gapless playback
  ImageStyle gaplessPlayback(bool value) {
    return merge(ImageStyle.gaplessPlayback(value));
  }

  /// Sets is anti alias
  ImageStyle isAntiAlias(bool value) {
    return merge(ImageStyle.isAntiAlias(value));
  }

  /// Sets match text direction
  ImageStyle matchTextDirection(bool value) {
    return merge(ImageStyle.matchTextDirection(value));
  }

  ImageStyle modifier(ModifierConfig value) {
    return merge(ImageStyle(modifier: value));
  }

  /// Convenience method for animating the ImageSpec
  ImageStyle animate(AnimationConfig animation) {
    return merge(ImageStyle.animate(animation));
  }

  @override
  ImageStyle variants(List<VariantStyle<ImageWidgetSpec>> variants) {
    return merge(ImageStyle(variants: variants));
  }

  @override
  ImageWidgetSpec resolve(BuildContext context) {
    return ImageWidgetSpec(
      image: MixOps.resolve(context, $image),
      width: MixOps.resolve(context, $width),
      height: MixOps.resolve(context, $height),
      color: MixOps.resolve(context, $color),
      repeat: MixOps.resolve(context, $repeat),
      fit: MixOps.resolve(context, $fit),
      alignment: MixOps.resolve(context, $alignment),
      centerSlice: MixOps.resolve(context, $centerSlice),
      filterQuality: MixOps.resolve(context, $filterQuality),
      colorBlendMode: MixOps.resolve(context, $colorBlendMode),
      semanticLabel: MixOps.resolve(context, $semanticLabel),
      excludeFromSemantics: MixOps.resolve(context, $excludeFromSemantics),
      gaplessPlayback: MixOps.resolve(context, $gaplessPlayback),
      isAntiAlias: MixOps.resolve(context, $isAntiAlias),
      matchTextDirection: MixOps.resolve(context, $matchTextDirection),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  @override
  ImageStyle merge(ImageStyle? other) {
    if (other == null) return this;

    return ImageStyle.create(
      image: MixOps.merge($image, other.$image),
      width: MixOps.merge($width, other.$width),
      height: MixOps.merge($height, other.$height),
      color: MixOps.merge($color, other.$color),
      repeat: MixOps.merge($repeat, other.$repeat),
      fit: MixOps.merge($fit, other.$fit),
      alignment: MixOps.merge($alignment, other.$alignment),
      centerSlice: MixOps.merge($centerSlice, other.$centerSlice),
      filterQuality: MixOps.merge($filterQuality, other.$filterQuality),
      colorBlendMode: MixOps.merge($colorBlendMode, other.$colorBlendMode),
      semanticLabel: MixOps.merge($semanticLabel, other.$semanticLabel),
      excludeFromSemantics: MixOps.merge(
        $excludeFromSemantics,
        other.$excludeFromSemantics,
      ),
      gaplessPlayback: MixOps.merge($gaplessPlayback, other.$gaplessPlayback),
      isAntiAlias: MixOps.merge($isAntiAlias, other.$isAntiAlias),
      matchTextDirection: MixOps.merge(
        $matchTextDirection,
        other.$matchTextDirection,
      ),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('image', $image))
      ..add(DiagnosticsProperty('width', $width))
      ..add(DiagnosticsProperty('height', $height))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('repeat', $repeat))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('centerSlice', $centerSlice))
      ..add(DiagnosticsProperty('filterQuality', $filterQuality))
      ..add(DiagnosticsProperty('colorBlendMode', $colorBlendMode))
      ..add(DiagnosticsProperty('semanticLabel', $semanticLabel))
      ..add(DiagnosticsProperty('excludeFromSemantics', $excludeFromSemantics))
      ..add(DiagnosticsProperty('gaplessPlayback', $gaplessPlayback))
      ..add(DiagnosticsProperty('isAntiAlias', $isAntiAlias))
      ..add(DiagnosticsProperty('matchTextDirection', $matchTextDirection));
  }

  @override
  ImageStyle variant(Variant variant, ImageStyle style) {
    return merge(ImageStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  ImageStyle wrap(ModifierConfig value) {
    return modifier(value);
  }

  @override
  List<Object?> get props => [
    $image,
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
    $modifier,
    $variants,
  ];
}

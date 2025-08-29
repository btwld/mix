import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'image_spec.dart';
import 'image_util.dart';
import 'image_widget.dart';

typedef ImageMix = ImageStyle;

class ImageStyle extends Style<ImageSpec>
    with
        Diagnosticable,
        StyleModifierMixin<ImageStyle, ImageSpec>,
        StyleVariantMixin<ImageStyle, ImageSpec> {
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
    List<VariantStyle<ImageSpec>>? variants,
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
       );

  factory ImageStyle.builder(ImageStyle Function(BuildContext) fn) {
    return ImageStyle().builder(fn);
  }

  static ImageSpecUtility get chain => ImageSpecUtility(ImageStyle());



  /// Sets image provider
  ImageStyle image(ImageProvider<Object> value) {
    return merge(ImageStyle(image: value));
  }

  /// Sets image width
  ImageStyle width(double value) {
    return merge(ImageStyle(width: value));
  }

  /// Sets image height
  ImageStyle height(double value) {
    return merge(ImageStyle(height: value));
  }

  /// Sets image color
  ImageStyle color(Color value) {
    return merge(ImageStyle(color: value));
  }

  /// Sets image repeat
  ImageStyle repeat(ImageRepeat value) {
    return merge(ImageStyle(repeat: value));
  }

  /// Sets image fit
  ImageStyle fit(BoxFit value) {
    return merge(ImageStyle(fit: value));
  }

  /// Sets image alignment
  ImageStyle alignment(AlignmentGeometry value) {
    return merge(ImageStyle(alignment: value));
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
    return merge(ImageStyle(centerSlice: value));
  }

  /// Sets filter quality
  ImageStyle filterQuality(FilterQuality value) {
    return merge(ImageStyle(filterQuality: value));
  }

  /// Sets color blend mode
  ImageStyle colorBlendMode(BlendMode value) {
    return merge(ImageStyle(colorBlendMode: value));
  }

  /// Sets semantic label
  ImageStyle semanticLabel(String value) {
    return merge(ImageStyle(semanticLabel: value));
  }

  /// Sets exclude from semantics
  ImageStyle excludeFromSemantics(bool value) {
    return merge(ImageStyle(excludeFromSemantics: value));
  }

  /// Sets gapless playback
  ImageStyle gaplessPlayback(bool value) {
    return merge(ImageStyle(gaplessPlayback: value));
  }

  /// Sets is anti alias
  ImageStyle isAntiAlias(bool value) {
    return merge(ImageStyle(isAntiAlias: value));
  }

  /// Sets match text direction
  ImageStyle matchTextDirection(bool value) {
    return merge(ImageStyle(matchTextDirection: value));
  }

  ImageStyle modifier(ModifierConfig value) {
    return merge(ImageStyle(modifier: value));
  }

  /// Convenience method for animating the ImageWidgetSpec
  ImageStyle animate(AnimationConfig animation) {
    return merge(ImageStyle(animation: animation));
  }

  @override
  ImageStyle variants(List<VariantStyle<ImageSpec>> variants) {
    return merge(ImageStyle(variants: variants));
  }

  @override
  StyleSpec<ImageSpec> resolve(BuildContext context) {
    final imageSpec = ImageSpec(
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
    );
    
    return StyleSpec(
      spec: imageSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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

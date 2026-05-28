// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'image_widget.dart';

import 'image_spec.dart';

class ImageStyler extends MixStyler<ImageStyler, ImageSpec>
    with _$ImageStylerMixin {
  @override
  final Prop<ImageProvider<Object>>? $image;
  @override
  final Prop<double>? $width;
  @override
  final Prop<double>? $height;
  @override
  final Prop<Color>? $color;
  @override
  final Prop<ImageRepeat>? $repeat;
  @override
  final Prop<BoxFit>? $fit;
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<Rect>? $centerSlice;
  @override
  final Prop<FilterQuality>? $filterQuality;
  @override
  final Prop<BlendMode>? $colorBlendMode;
  @override
  final Prop<String>? $semanticLabel;
  @override
  final Prop<bool>? $excludeFromSemantics;
  @override
  final Prop<bool>? $gaplessPlayback;
  @override
  final Prop<bool>? $isAntiAlias;
  @override
  final Prop<bool>? $matchTextDirection;

  const ImageStyler.create({
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
    super.variants,
    super.modifier,
    super.animation,
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

  ImageStyler({
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
    WidgetModifierConfig? modifier,
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
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ImageStyler.image(ImageProvider<Object> value) =>
      ImageStyler().image(value);
  factory ImageStyler.width(double value) => ImageStyler().width(value);
  factory ImageStyler.height(double value) => ImageStyler().height(value);
  factory ImageStyler.color(Color value) => ImageStyler().color(value);
  factory ImageStyler.repeat(ImageRepeat value) => ImageStyler().repeat(value);
  factory ImageStyler.fit(BoxFit value) => ImageStyler().fit(value);
  factory ImageStyler.alignment(AlignmentGeometry value) =>
      ImageStyler().alignment(value);
  factory ImageStyler.centerSlice(Rect value) =>
      ImageStyler().centerSlice(value);
  factory ImageStyler.filterQuality(FilterQuality value) =>
      ImageStyler().filterQuality(value);
  factory ImageStyler.colorBlendMode(BlendMode value) =>
      ImageStyler().colorBlendMode(value);
  factory ImageStyler.gaplessPlayback(bool value) =>
      ImageStyler().gaplessPlayback(value);
  factory ImageStyler.isAntiAlias(bool value) =>
      ImageStyler().isAntiAlias(value);
  factory ImageStyler.matchTextDirection(bool value) =>
      ImageStyler().matchTextDirection(value);

  StyledImage call({
    Key? key,
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage(
      key: key,
      style: this,
      image: image,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      opacity: opacity,
    );
  }
}

mixin _$ImageStylerMixin on Style<ImageSpec>, Diagnosticable {
  Prop<ImageProvider<Object>>? get $image;
  Prop<double>? get $width;
  Prop<double>? get $height;
  Prop<Color>? get $color;
  Prop<ImageRepeat>? get $repeat;
  Prop<BoxFit>? get $fit;
  Prop<AlignmentGeometry>? get $alignment;
  Prop<Rect>? get $centerSlice;
  Prop<FilterQuality>? get $filterQuality;
  Prop<BlendMode>? get $colorBlendMode;
  Prop<String>? get $semanticLabel;
  Prop<bool>? get $excludeFromSemantics;
  Prop<bool>? get $gaplessPlayback;
  Prop<bool>? get $isAntiAlias;
  Prop<bool>? get $matchTextDirection;

  /// Sets the image.
  ImageStyler image(ImageProvider<Object> value) {
    return merge(ImageStyler(image: value));
  }

  /// Sets the width.
  ImageStyler width(double value) {
    return merge(ImageStyler(width: value));
  }

  /// Sets the height.
  ImageStyler height(double value) {
    return merge(ImageStyler(height: value));
  }

  /// Sets the color.
  ImageStyler color(Color value) {
    return merge(ImageStyler(color: value));
  }

  /// Sets the repeat.
  ImageStyler repeat(ImageRepeat value) {
    return merge(ImageStyler(repeat: value));
  }

  /// Sets the fit.
  ImageStyler fit(BoxFit value) {
    return merge(ImageStyler(fit: value));
  }

  /// Sets the alignment.
  ImageStyler alignment(AlignmentGeometry value) {
    return merge(ImageStyler(alignment: value));
  }

  /// Sets the centerSlice.
  ImageStyler centerSlice(Rect value) {
    return merge(ImageStyler(centerSlice: value));
  }

  /// Sets the filterQuality.
  ImageStyler filterQuality(FilterQuality value) {
    return merge(ImageStyler(filterQuality: value));
  }

  /// Sets the colorBlendMode.
  ImageStyler colorBlendMode(BlendMode value) {
    return merge(ImageStyler(colorBlendMode: value));
  }

  /// Sets the semanticLabel.
  ImageStyler semanticLabel(String value) {
    return merge(ImageStyler(semanticLabel: value));
  }

  /// Sets the excludeFromSemantics.
  ImageStyler excludeFromSemantics(bool value) {
    return merge(ImageStyler(excludeFromSemantics: value));
  }

  /// Sets the gaplessPlayback.
  ImageStyler gaplessPlayback(bool value) {
    return merge(ImageStyler(gaplessPlayback: value));
  }

  /// Sets the isAntiAlias.
  ImageStyler isAntiAlias(bool value) {
    return merge(ImageStyler(isAntiAlias: value));
  }

  /// Sets the matchTextDirection.
  ImageStyler matchTextDirection(bool value) {
    return merge(ImageStyler(matchTextDirection: value));
  }

  /// Sets the animation configuration.
  ImageStyler animate(AnimationConfig value) {
    return merge(ImageStyler(animation: value));
  }

  /// Sets the style variants.
  ImageStyler variants(List<VariantStyle<ImageSpec>> value) {
    return merge(ImageStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  ImageStyler wrap(WidgetModifierConfig value) {
    return merge(ImageStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ImageStyler modifier(WidgetModifierConfig value) {
    return merge(ImageStyler(modifier: value));
  }

  /// Merges with another [ImageStyler].
  @override
  ImageStyler merge(ImageStyler? other) {
    return ImageStyler.create(
      image: MixOps.merge($image, other?.$image),
      width: MixOps.merge($width, other?.$width),
      height: MixOps.merge($height, other?.$height),
      color: MixOps.merge($color, other?.$color),
      repeat: MixOps.merge($repeat, other?.$repeat),
      fit: MixOps.merge($fit, other?.$fit),
      alignment: MixOps.merge($alignment, other?.$alignment),
      centerSlice: MixOps.merge($centerSlice, other?.$centerSlice),
      filterQuality: MixOps.merge($filterQuality, other?.$filterQuality),
      colorBlendMode: MixOps.merge($colorBlendMode, other?.$colorBlendMode),
      semanticLabel: MixOps.merge($semanticLabel, other?.$semanticLabel),
      excludeFromSemantics: MixOps.merge(
        $excludeFromSemantics,
        other?.$excludeFromSemantics,
      ),
      gaplessPlayback: MixOps.merge($gaplessPlayback, other?.$gaplessPlayback),
      isAntiAlias: MixOps.merge($isAntiAlias, other?.$isAntiAlias),
      matchTextDirection: MixOps.merge(
        $matchTextDirection,
        other?.$matchTextDirection,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ImageSpec>] using [context].
  @override
  StyleSpec<ImageSpec> resolve(BuildContext context) {
    final spec = ImageSpec(
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
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'image_spec.dart';
import 'image_style.dart';
import 'image_widget.dart';

/// Mix class for configuring ImageSpec properties (non-Style).
///
/// Provides a builder-like API with factory and chainable methods to compose
/// ImageSpec values. Does NOT include animation, variants, modifier, or inherit.
final class ImageMix extends Mix<ImageSpec> with Diagnosticable {
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

  /// Main constructor using raw values; wraps them into Prop for internal use.
  ImageMix({
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
       );

  /// Create constructor with `Prop<T> `fields; useful for merges.
  const ImageMix.create({
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

  /// Factory constructor to create ImageMix from ImageSpec.
  static ImageMix value(ImageSpec spec) {
    return ImageMix(
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
  }

  /// Nullable convenience.
  static ImageMix? maybeValue(ImageSpec? spec) {
    return spec != null ? ImageMix.value(spec) : null;
  }

  // Chainable instance methods
  ImageMix image(ImageProvider<Object> value) => merge(ImageMix(image: value));
  ImageMix width(double value) => merge(ImageMix(width: value));
  ImageMix height(double value) => merge(ImageMix(height: value));
  ImageMix color(Color value) => merge(ImageMix(color: value));
  ImageMix repeat(ImageRepeat value) => merge(ImageMix(repeat: value));
  ImageMix fit(BoxFit value) => merge(ImageMix(fit: value));
  ImageMix alignment(AlignmentGeometry value) =>
      merge(ImageMix(alignment: value));
  ImageMix centerSlice(Rect value) => merge(ImageMix(centerSlice: value));
  ImageMix filterQuality(FilterQuality value) =>
      merge(ImageMix(filterQuality: value));
  ImageMix colorBlendMode(BlendMode value) =>
      merge(ImageMix(colorBlendMode: value));
  ImageMix semanticLabel(String value) => merge(ImageMix(semanticLabel: value));
  ImageMix excludeFromSemantics(bool value) =>
      merge(ImageMix(excludeFromSemantics: value));
  ImageMix gaplessPlayback(bool value) =>
      merge(ImageMix(gaplessPlayback: value));
  ImageMix isAntiAlias(bool value) => merge(ImageMix(isAntiAlias: value));
  ImageMix matchTextDirection(bool value) =>
      merge(ImageMix(matchTextDirection: value));

  /// Builds a StyledImage using this mix converted to a Style.
  StyledImage call({
    ImageProvider<Object>? image,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    Animation<double>? opacity,
  }) {
    return StyledImage(
      style: toStyle(),
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      image: image,
      opacity: opacity,
    );
  }

  // Resolve to concrete ImageSpec
  @override
  ImageSpec resolve(BuildContext context) {
    return ImageSpec(
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
  }

  // Merge two ImageMix instances
  @override
  ImageMix merge(ImageMix? other) {
    if (other == null) return this;

    return ImageMix.create(
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
  ];
}

extension ImageMixToStyle on ImageMix {
  /// Converts this ImageMix to an ImageStyle (without adding animation/modifier/variants).
  ImageStyle toStyle() => ImageStyle.create(
    image: $image,
    width: $width,
    height: $height,
    color: $color,
    repeat: $repeat,
    fit: $fit,
    alignment: $alignment,
    centerSlice: $centerSlice,
    filterQuality: $filterQuality,
    colorBlendMode: $colorBlendMode,
    semanticLabel: $semanticLabel,
    excludeFromSemantics: $excludeFromSemantics,
    gaplessPlayback: $gaplessPlayback,
    isAntiAlias: $isAntiAlias,
    matchTextDirection: $matchTextDirection,
  );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$ImageStylerMixin on Style<ImageSpec>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<Rect>? get $centerSlice;
  Prop<Color>? get $color;
  Prop<BlendMode>? get $colorBlendMode;
  Prop<bool>? get $excludeFromSemantics;
  Prop<FilterQuality>? get $filterQuality;
  Prop<BoxFit>? get $fit;
  Prop<bool>? get $gaplessPlayback;
  Prop<double>? get $height;
  Prop<ImageProvider<Object>>? get $image;
  Prop<bool>? get $isAntiAlias;
  Prop<bool>? get $matchTextDirection;
  Prop<ImageRepeat>? get $repeat;
  Prop<String>? get $semanticLabel;
  Prop<double>? get $width;

  /// Sets the alignment.
  ImageStyler alignment(AlignmentGeometry value) {
    return merge(ImageStyler(alignment: value));
  }

  /// Sets the centerSlice.
  ImageStyler centerSlice(Rect value) {
    return merge(ImageStyler(centerSlice: value));
  }

  /// Sets the color.
  ImageStyler color(Color value) {
    return merge(ImageStyler(color: value));
  }

  /// Sets the colorBlendMode.
  ImageStyler colorBlendMode(BlendMode value) {
    return merge(ImageStyler(colorBlendMode: value));
  }

  /// Sets the excludeFromSemantics.
  ImageStyler excludeFromSemantics(bool value) {
    return merge(ImageStyler(excludeFromSemantics: value));
  }

  /// Sets the filterQuality.
  ImageStyler filterQuality(FilterQuality value) {
    return merge(ImageStyler(filterQuality: value));
  }

  /// Sets the fit.
  ImageStyler fit(BoxFit value) {
    return merge(ImageStyler(fit: value));
  }

  /// Sets the gaplessPlayback.
  ImageStyler gaplessPlayback(bool value) {
    return merge(ImageStyler(gaplessPlayback: value));
  }

  /// Sets the height.
  ImageStyler height(double value) {
    return merge(ImageStyler(height: value));
  }

  /// Sets the image.
  ImageStyler image(ImageProvider<Object> value) {
    return merge(ImageStyler(image: value));
  }

  /// Sets the isAntiAlias.
  ImageStyler isAntiAlias(bool value) {
    return merge(ImageStyler(isAntiAlias: value));
  }

  /// Sets the matchTextDirection.
  ImageStyler matchTextDirection(bool value) {
    return merge(ImageStyler(matchTextDirection: value));
  }

  /// Sets the repeat.
  ImageStyler repeat(ImageRepeat value) {
    return merge(ImageStyler(repeat: value));
  }

  /// Sets the semanticLabel.
  ImageStyler semanticLabel(String value) {
    return merge(ImageStyler(semanticLabel: value));
  }

  /// Sets the width.
  ImageStyler width(double value) {
    return merge(ImageStyler(width: value));
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

  /// Merges with another [ImageStyler].
  @override
  ImageStyler merge(ImageStyler? other) {
    return ImageStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      centerSlice: MixOps.merge($centerSlice, other?.$centerSlice),
      color: MixOps.merge($color, other?.$color),
      colorBlendMode: MixOps.merge($colorBlendMode, other?.$colorBlendMode),
      excludeFromSemantics: MixOps.merge(
        $excludeFromSemantics,
        other?.$excludeFromSemantics,
      ),
      filterQuality: MixOps.merge($filterQuality, other?.$filterQuality),
      fit: MixOps.merge($fit, other?.$fit),
      gaplessPlayback: MixOps.merge($gaplessPlayback, other?.$gaplessPlayback),
      height: MixOps.merge($height, other?.$height),
      image: MixOps.merge($image, other?.$image),
      isAntiAlias: MixOps.merge($isAntiAlias, other?.$isAntiAlias),
      matchTextDirection: MixOps.merge(
        $matchTextDirection,
        other?.$matchTextDirection,
      ),
      repeat: MixOps.merge($repeat, other?.$repeat),
      semanticLabel: MixOps.merge($semanticLabel, other?.$semanticLabel),
      width: MixOps.merge($width, other?.$width),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ImageSpec>] using context.
  @override
  StyleSpec<ImageSpec> resolve(BuildContext context) {
    final spec = ImageSpec(
      alignment: MixOps.resolve(context, $alignment),
      centerSlice: MixOps.resolve(context, $centerSlice),
      color: MixOps.resolve(context, $color),
      colorBlendMode: MixOps.resolve(context, $colorBlendMode),
      excludeFromSemantics: MixOps.resolve(context, $excludeFromSemantics),
      filterQuality: MixOps.resolve(context, $filterQuality),
      fit: MixOps.resolve(context, $fit),
      gaplessPlayback: MixOps.resolve(context, $gaplessPlayback),
      height: MixOps.resolve(context, $height),
      image: MixOps.resolve(context, $image),
      isAntiAlias: MixOps.resolve(context, $isAntiAlias),
      matchTextDirection: MixOps.resolve(context, $matchTextDirection),
      repeat: MixOps.resolve(context, $repeat),
      semanticLabel: MixOps.resolve(context, $semanticLabel),
      width: MixOps.resolve(context, $width),
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
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('centerSlice', $centerSlice))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('colorBlendMode', $colorBlendMode))
      ..add(DiagnosticsProperty('excludeFromSemantics', $excludeFromSemantics))
      ..add(DiagnosticsProperty('filterQuality', $filterQuality))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('gaplessPlayback', $gaplessPlayback))
      ..add(DiagnosticsProperty('height', $height))
      ..add(DiagnosticsProperty('image', $image))
      ..add(DiagnosticsProperty('isAntiAlias', $isAntiAlias))
      ..add(DiagnosticsProperty('matchTextDirection', $matchTextDirection))
      ..add(DiagnosticsProperty('repeat', $repeat))
      ..add(DiagnosticsProperty('semanticLabel', $semanticLabel))
      ..add(DiagnosticsProperty('width', $width));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $centerSlice,
    $color,
    $colorBlendMode,
    $excludeFromSemantics,
    $filterQuality,
    $fit,
    $gaplessPlayback,
    $height,
    $image,
    $isAntiAlias,
    $matchTextDirection,
    $repeat,
    $semanticLabel,
    $width,
    $animation,
    $modifier,
    $variants,
  ];
}

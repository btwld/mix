// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ImageSpec implements Spec<ImageSpec>, Diagnosticable {
  ImageProvider<Object>? get image;
  double? get width;
  double? get height;
  Color? get color;
  ImageRepeat? get repeat;
  BoxFit? get fit;
  AlignmentGeometry? get alignment;
  Rect? get centerSlice;
  FilterQuality? get filterQuality;
  BlendMode? get colorBlendMode;
  String? get semanticLabel;
  bool? get excludeFromSemantics;
  bool? get gaplessPlayback;
  bool? get isAntiAlias;
  bool? get matchTextDirection;

  @override
  Type get type => ImageSpec;

  @override
  ImageSpec copyWith({
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
  }) {
    return ImageSpec(
      image: image ?? this.image,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      repeat: repeat ?? this.repeat,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      centerSlice: centerSlice ?? this.centerSlice,
      filterQuality: filterQuality ?? this.filterQuality,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
      gaplessPlayback: gaplessPlayback ?? this.gaplessPlayback,
      isAntiAlias: isAntiAlias ?? this.isAntiAlias,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
    );
  }

  @override
  ImageSpec lerp(ImageSpec? other, double t) {
    return ImageSpec(
      image: MixOps.lerpSnap(image, other?.image, t),
      width: MixOps.lerp(width, other?.width, t),
      height: MixOps.lerp(height, other?.height, t),
      color: MixOps.lerp(color, other?.color, t),
      repeat: MixOps.lerpSnap(repeat, other?.repeat, t),
      fit: MixOps.lerpSnap(fit, other?.fit, t),
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      centerSlice: MixOps.lerp(centerSlice, other?.centerSlice, t),
      filterQuality: MixOps.lerpSnap(filterQuality, other?.filterQuality, t),
      colorBlendMode: MixOps.lerpSnap(colorBlendMode, other?.colorBlendMode, t),
      semanticLabel: MixOps.lerpSnap(semanticLabel, other?.semanticLabel, t),
      excludeFromSemantics: MixOps.lerpSnap(
        excludeFromSemantics,
        other?.excludeFromSemantics,
        t,
      ),
      gaplessPlayback: MixOps.lerpSnap(
        gaplessPlayback,
        other?.gaplessPlayback,
        t,
      ),
      isAntiAlias: MixOps.lerpSnap(isAntiAlias, other?.isAntiAlias, t),
      matchTextDirection: MixOps.lerpSnap(
        matchTextDirection,
        other?.matchTextDirection,
        t,
      ),
    );
  }

  @override
  List<Object?> get props => [
    image,
    width,
    height,
    color,
    repeat,
    fit,
    alignment,
    centerSlice,
    filterQuality,
    colorBlendMode,
    semanticLabel,
    excludeFromSemantics,
    gaplessPlayback,
    isAntiAlias,
    matchTextDirection,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ImageSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('image', image))
      ..add(DoubleProperty('width', width))
      ..add(DoubleProperty('height', height))
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<ImageRepeat>('repeat', repeat))
      ..add(EnumProperty<BoxFit>('fit', fit))
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('centerSlice', centerSlice))
      ..add(EnumProperty<FilterQuality>('filterQuality', filterQuality))
      ..add(EnumProperty<BlendMode>('colorBlendMode', colorBlendMode))
      ..add(StringProperty('semanticLabel', semanticLabel))
      ..add(
        FlagProperty(
          'excludeFromSemantics',
          value: excludeFromSemantics,
          ifTrue: 'excluded from semantics',
        ),
      )
      ..add(
        FlagProperty(
          'gaplessPlayback',
          value: gaplessPlayback,
          ifTrue: 'gapless playback',
        ),
      )
      ..add(
        FlagProperty('isAntiAlias', value: isAntiAlias, ifTrue: 'anti-aliased'),
      )
      ..add(
        FlagProperty(
          'matchTextDirection',
          value: matchTextDirection,
          ifTrue: 'matches text direction',
        ),
      );
  }
}

@Deprecated(
  'Rename to `_\$ImageSpec` and migrate the class declaration to `class ImageSpec with _\$ImageSpec`. The `_\$ImageSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ImageSpecMethods = _$ImageSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ImageStyler extends MixStyler<ImageStyler, ImageSpec> {
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
  ///
  /// When [reverse] is provided, it is used as the exit transition
  /// config when leaving this style.
  @override
  ImageStyler animate(AnimationConfig value, {AnimationConfig? reverse}) {
    final config = reverse == null
        ? value
        : ReversibleAnimationConfig(forward: value, reverse: reverse);

    return merge(ImageStyler(animation: config));
  }

  /// Sets the style variants.
  @override
  ImageStyler variants(List<VariantStyle<ImageSpec>> value) {
    return merge(ImageStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ImageStyler wrap(WidgetModifierConfig value) {
    return merge(ImageStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ImageStyler modifier(WidgetModifierConfig value) {
    return merge(ImageStyler(modifier: value));
  }

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

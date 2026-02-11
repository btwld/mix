// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ImageSpecMethods on Spec<ImageSpec>, Diagnosticable {
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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
}

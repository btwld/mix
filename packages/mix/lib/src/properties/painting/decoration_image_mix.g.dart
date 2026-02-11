// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoration_image_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$DecorationImageMixMixin on Mix<DecorationImage>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<Rect>? get $centerSlice;
  Prop<FilterQuality>? get $filterQuality;
  Prop<BoxFit>? get $fit;
  Prop<ImageProvider<Object>>? get $image;
  Prop<bool>? get $invertColors;
  Prop<bool>? get $isAntiAlias;
  Prop<ImageRepeat>? get $repeat;

  /// Merges with another [DecorationImageMix].
  @override
  DecorationImageMix merge(DecorationImageMix? other) {
    return DecorationImageMix.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      centerSlice: MixOps.merge($centerSlice, other?.$centerSlice),
      filterQuality: MixOps.merge($filterQuality, other?.$filterQuality),
      fit: MixOps.merge($fit, other?.$fit),
      image: MixOps.merge($image, other?.$image),
      invertColors: MixOps.merge($invertColors, other?.$invertColors),
      isAntiAlias: MixOps.merge($isAntiAlias, other?.$isAntiAlias),
      repeat: MixOps.merge($repeat, other?.$repeat),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('centerSlice', $centerSlice))
      ..add(DiagnosticsProperty('filterQuality', $filterQuality))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('image', $image))
      ..add(DiagnosticsProperty('invertColors', $invertColors))
      ..add(DiagnosticsProperty('isAntiAlias', $isAntiAlias))
      ..add(DiagnosticsProperty('repeat', $repeat));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $centerSlice,
    $filterQuality,
    $fit,
    $image,
    $invertColors,
    $isAntiAlias,
    $repeat,
  ];
}

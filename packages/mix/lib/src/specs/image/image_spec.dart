import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

final class ImageSpec extends Spec<ImageSpec> with Diagnosticable {
  final ImageProvider<Object>? image;
  final double? width, height;
  final Color? color;
  final ImageRepeat? repeat;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final Rect? centerSlice;
  final FilterQuality? filterQuality;

  final BlendMode? colorBlendMode;
  final String? semanticLabel;
  final bool? excludeFromSemantics;
  final bool? gaplessPlayback;
  final bool? isAntiAlias;
  final bool? matchTextDirection;

  const ImageSpec({
    this.image,
    this.width,
    this.height,
    this.color,
    this.repeat,
    this.fit,
    this.alignment,
    this.centerSlice,
    this.filterQuality,
    this.colorBlendMode,
    this.semanticLabel,
    this.excludeFromSemantics,
    this.gaplessPlayback,
    this.isAntiAlias,
    this.matchTextDirection,
  });

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('image', image, defaultValue: null));
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty('repeat', repeat, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('centerSlice', centerSlice, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('filterQuality', filterQuality, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('colorBlendMode', colorBlendMode, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('semanticLabel', semanticLabel, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('excludeFromSemantics', excludeFromSemantics, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('gaplessPlayback', gaplessPlayback, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('isAntiAlias', isAntiAlias, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('matchTextDirection', matchTextDirection, defaultValue: null),
    );
  }

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
    if (other == null) return this;

    return ImageSpec(
      image: t < 0.5 ? image : other.image,
      width: MixHelpers.lerpDouble(width, other.width, t),
      height: MixHelpers.lerpDouble(height, other.height, t),
      color: Color.lerp(color, other.color, t),
      repeat: t < 0.5 ? repeat : other.repeat,
      fit: t < 0.5 ? fit : other.fit,
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      centerSlice: Rect.lerp(centerSlice, other.centerSlice, t),
      filterQuality: t < 0.5 ? filterQuality : other.filterQuality,
      colorBlendMode: t < 0.5 ? colorBlendMode : other.colorBlendMode,
      semanticLabel: t < 0.5 ? semanticLabel : other.semanticLabel,
      excludeFromSemantics: t < 0.5 ? excludeFromSemantics : other.excludeFromSemantics,
      gaplessPlayback: t < 0.5 ? gaplessPlayback : other.gaplessPlayback,
      isAntiAlias: t < 0.5 ? isAntiAlias : other.isAntiAlias,
      matchTextDirection: t < 0.5 ? matchTextDirection : other.matchTextDirection,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
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

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/modifier.dart';
import '../../core/widget_spec.dart';

final class ImageWidgetSpec extends WidgetSpec<ImageWidgetSpec> {
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

  const ImageWidgetSpec({
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
    super.animation,
    super.widgetModifiers,
    super.inherit,
  });

  @override
  ImageWidgetSpec copyWith({
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
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return ImageWidgetSpec(
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
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  ImageWidgetSpec lerp(ImageWidgetSpec? other, double t) {
    return ImageWidgetSpec(
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
      // Meta fields: use confirmed policy other?.field ?? this.field
      animation: other?.animation ?? animation,
      widgetModifiers: MixOps.lerp(widgetModifiers, other?.widgetModifiers, t),
      inherit: other?.inherit ?? inherit,
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
    ...super.props,
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

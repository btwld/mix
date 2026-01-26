// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoration_mix.dart';

// **************************************************************************
// MixableGenerator
// **************************************************************************

mixin _$BoxDecorationMixMixin
    on Mix<BoxDecoration>, DefaultValue<BoxDecoration>, Diagnosticable {
  Prop<BlendMode>? get $backgroundBlendMode;
  Prop<BoxBorder>? get $border;
  Prop<BorderRadiusGeometry>? get $borderRadius;
  Prop<List<BoxShadow>>? get $boxShadow;
  Prop<Color>? get $color;
  Prop<Gradient>? get $gradient;
  Prop<DecorationImage>? get $image;
  Prop<BoxShape>? get $shape;

  @override
  BoxDecorationMix merge(BoxDecorationMix? other) {
    return BoxDecorationMix.create(
      backgroundBlendMode: MixOps.merge(
        $backgroundBlendMode,
        other?.$backgroundBlendMode,
      ),
      border: MixOps.merge($border, other?.$border),
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      boxShadow: MixOps.merge($boxShadow, other?.$boxShadow),
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      image: MixOps.merge($image, other?.$image),
      shape: MixOps.merge($shape, other?.$shape),
    );
  }

  @override
  BoxDecoration resolve(BuildContext context) {
    return BoxDecoration(
      backgroundBlendMode:
          MixOps.resolve(context, $backgroundBlendMode) ??
          defaultValue.backgroundBlendMode,
      border: MixOps.resolve(context, $border) ?? defaultValue.border,
      borderRadius:
          MixOps.resolve(context, $borderRadius) ?? defaultValue.borderRadius,
      boxShadow: MixOps.resolve(context, $boxShadow) ?? defaultValue.boxShadow,
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      gradient: MixOps.resolve(context, $gradient) ?? defaultValue.gradient,
      image: MixOps.resolve(context, $image) ?? defaultValue.image,
      shape: MixOps.resolve(context, $shape) ?? defaultValue.shape,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('backgroundBlendMode', $backgroundBlendMode))
      ..add(DiagnosticsProperty('border', $border))
      ..add(DiagnosticsProperty('borderRadius', $borderRadius))
      ..add(DiagnosticsProperty('boxShadow', $boxShadow))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('gradient', $gradient))
      ..add(DiagnosticsProperty('image', $image))
      ..add(DiagnosticsProperty('shape', $shape));
  }

  @override
  List<Object?> get props => [
    $backgroundBlendMode,
    $border,
    $borderRadius,
    $boxShadow,
    $color,
    $gradient,
    $image,
    $shape,
  ];
}

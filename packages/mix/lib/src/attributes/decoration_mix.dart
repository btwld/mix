// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart' hide $image;

/// A Data transfer object that represents a [Decoration] value.
///
/// This DTO is used to resolve a [Decoration] value from a [MixContext] instance.
@immutable
sealed class DecorationMix<T extends Decoration> extends Mix<T> {
  final Prop<Color>? $color;
  final MixProp<Gradient>? $gradient;
  final MixProp<DecorationImage>? $image;
  final List<MixProp<BoxShadow>>? $boxShadow;

  const DecorationMix({
    Prop<Color>? color,
    MixProp<Gradient>? gradient,
    List<MixProp<BoxShadow>>? boxShadow,
    MixProp<DecorationImage>? image,
  }) : $color = color,
       $gradient = gradient,
       $boxShadow = boxShadow,
       $image = image;

  /// Constructor that accepts a [Decoration] value and converts it to the appropriate DTO.
  factory DecorationMix.value(Decoration decoration) {
    return switch (decoration) {
          BoxDecoration d => BoxDecorationMix.value(d),
          ShapeDecoration d => ShapeDecorationMix.value(d),
          _ => throw ArgumentError(
            'Unsupported Decoration type: ${decoration.runtimeType}',
          ),
        }
        as DecorationMix<T>;
  }

  static BoxDecorationMix color(Color value) {
    return BoxDecorationMix.only(color: value);
  }

  static BoxDecorationMix gradient(GradientMix value) {
    return BoxDecorationMix.only(gradient: value);
  }

  static BoxDecorationMix image(DecorationImageMix value) {
    return BoxDecorationMix.only(image: value);
  }

  static BoxDecorationMix boxShadow(List<BoxShadowMix> value) {
    return BoxDecorationMix.only(boxShadow: value);
  }

  static BoxDecorationMix shape(BoxShape value) {
    return BoxDecorationMix.only(shape: value);
  }

  static BoxDecorationMix border(BoxBorderMix value) {
    return BoxDecorationMix.only(border: value);
  }

  // borderRadius
  static BoxDecorationMix borderRadius(BorderRadiusGeometryMix value) {
    return BoxDecorationMix.only(borderRadius: value);
  }

  static ShapeDecorationMix shapeDecoration(ShapeDecorationMix value) {
    return value;
  }

  /// Constructor that accepts a nullable [Decoration] value and converts it to the appropriate DTO.
  static DecorationMix? maybeValue(Decoration? decoration) {
    return decoration != null ? DecorationMix.value(decoration) : null;
  }

  /// Merges with another decoration of the same type.
  /// This method is implemented by subclasses to handle type-specific merging.
  @protected
  DecorationMix<T> mergeDecoration(covariant DecorationMix<T> other);

  /// Merges two DecorationMix instances.
  ///
  /// If both are the same type, delegates to [mergeDecoration].
  /// If different types, returns [other] (override behavior).
  /// If [other] is null, returns this instance.
  @override
  DecorationMix<T> merge(covariant DecorationMix<T>? other) {
    if (other == null) return this;

    return switch ((this, other)) {
          (BoxDecorationMix a, BoxDecorationMix b) => a.mergeDecoration(b),
          (ShapeDecorationMix a, ShapeDecorationMix b) => a.mergeDecoration(b),
          _ => other, // Different types: override with other
        }
        as DecorationMix<T>;
  }
}

/// Represents a Data transfer object of [BoxDecoration]
final class BoxDecorationMix extends DecorationMix<BoxDecoration> {
  final MixProp<BoxBorder>? $border;
  final MixProp<BorderRadiusGeometry>? $borderRadius;
  final Prop<BoxShape>? $shape;
  final Prop<BlendMode>? $backgroundBlendMode;

  BoxDecorationMix.only({
    BoxBorderMix? border,
    BorderRadiusGeometryMix? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? boxShadow,
  }) : this(
         border: MixProp.maybe(border),
         borderRadius: MixProp.maybe(borderRadius),
         shape: Prop.maybe(shape),
         backgroundBlendMode: Prop.maybe(backgroundBlendMode),
         color: Prop.maybe(color),
         image: MixProp.maybe(image),
         gradient: MixProp.maybe(gradient),
         boxShadow: boxShadow?.map(MixProp<BoxShadow>.new).toList(),
       );

  BoxDecorationMix.border(BoxBorderMix border) : this.only(border: border);

  BoxDecorationMix.borderDirectional(BorderDirectionalMix border)
    : this.only(border: border);

  BoxDecorationMix.borderRadius(BorderRadiusGeometryMix borderRadius)
    : this.only(borderRadius: borderRadius);

  BoxDecorationMix.shape(BoxShape shape) : this.only(shape: shape);

  BoxDecorationMix.backgroundBlendMode(BlendMode backgroundBlendMode)
    : this.only(backgroundBlendMode: backgroundBlendMode);

  BoxDecorationMix.color(Color? color) : this.only(color: color);

  BoxDecorationMix.image(DecorationImageMix? image) : this.only(image: image);

  BoxDecorationMix.gradient(GradientMix? gradient)
    : this.only(gradient: gradient);

  BoxDecorationMix.boxShadow(List<BoxShadowMix>? boxShadow)
    : this.only(boxShadow: boxShadow);

  /// Constructor that accepts a [BoxDecoration] value and extracts its properties.
  BoxDecorationMix.value(BoxDecoration decoration)
    : this.only(
        border: BoxBorderMix.maybeValue(decoration.border),
        borderRadius: BorderRadiusGeometryMix.maybeValue(
          decoration.borderRadius,
        ),
        shape: decoration.shape,
        backgroundBlendMode: decoration.backgroundBlendMode,
        color: decoration.color,
        image: DecorationImageMix.maybeValue(decoration.image),
        gradient: GradientMix.maybeValue(decoration.gradient),
        boxShadow: decoration.boxShadow?.map(BoxShadowMix.value).toList(),
      );

  const BoxDecorationMix({
    MixProp<BoxBorder>? border,
    MixProp<BorderRadiusGeometry>? borderRadius,
    Prop<BoxShape>? shape,
    Prop<BlendMode>? backgroundBlendMode,
    super.color,
    super.image,
    super.gradient,
    super.boxShadow,
  }) : $border = border,
       $borderRadius = borderRadius,
       $shape = shape,
       $backgroundBlendMode = backgroundBlendMode;

  /// Constructor that accepts a nullable [BoxDecoration] value and extracts its properties.
  static BoxDecorationMix? maybeValue(BoxDecoration? decoration) {
    return decoration != null ? BoxDecorationMix.value(decoration) : null;
  }

  BoxDecorationMix gradient(GradientMix value) {
    return mergeDecoration(BoxDecorationMix.only(gradient: value));
  }

  BoxDecorationMix image(DecorationImageMix? image) {
    return mergeDecoration(BoxDecorationMix.only(image: image));
  }

  BoxDecorationMix color(Color? value) {
    return mergeDecoration(BoxDecorationMix.only(color: value));
  }

  BoxDecorationMix boxShadow(List<BoxShadowMix>? value) {
    return mergeDecoration(BoxDecorationMix.only(boxShadow: value));
  }

  BoxDecorationMix border(BoxBorderMix value) {
    return mergeDecoration(BoxDecorationMix.only(border: value));
  }

  BoxDecorationMix borderRadius(BorderRadiusGeometryMix value) {
    return mergeDecoration(BoxDecorationMix.only(borderRadius: value));
  }

  BoxDecorationMix shape(BoxShape value) {
    return mergeDecoration(BoxDecorationMix.only(shape: value));
  }

  BoxDecorationMix backgroundBlendMode(BlendMode value) {
    return mergeDecoration(BoxDecorationMix.only(backgroundBlendMode: value));
  }

  /// Resolves to [BoxDecoration] using the provided [BuildContext].
  @override
  BoxDecoration resolve(BuildContext context) {
    return BoxDecoration(
      color: MixHelpers.resolve(context, $color),
      image: MixHelpers.resolve(context, $image),
      border: MixHelpers.resolve(context, $border),
      borderRadius: MixHelpers.resolve(context, $borderRadius),
      boxShadow: MixHelpers.resolveList(context, $boxShadow),
      gradient: MixHelpers.resolve(context, $gradient),
      backgroundBlendMode: MixHelpers.resolve(context, $backgroundBlendMode),
      shape: MixHelpers.resolve(context, $shape) ?? BoxShape.rectangle,
    );
  }

  /// Merges the properties of this [BoxDecorationMix] with the properties of [other].
  @override
  BoxDecorationMix mergeDecoration(BoxDecorationMix other) {
    return BoxDecorationMix(
      border: MixHelpers.merge($border, other.$border),
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      shape: MixHelpers.merge($shape, other.$shape),
      backgroundBlendMode: MixHelpers.merge(
        $backgroundBlendMode,
        other.$backgroundBlendMode,
      ),
      color: MixHelpers.merge($color, other.$color),
      image: MixHelpers.merge($image, other.$image),
      gradient: MixHelpers.merge($gradient, other.$gradient),
      boxShadow: MixHelpers.mergeList($boxShadow, other.$boxShadow),
    );
  }

  @override
  List<Object?> get props => [
    $border,
    $borderRadius,
    $shape,
    $backgroundBlendMode,
    $color,
    $image,
    $gradient,
    $boxShadow,
  ];
}

final class ShapeDecorationMix extends DecorationMix<ShapeDecoration>
    with DefaultValue<ShapeDecoration> {
  final MixProp<ShapeBorder>? $shape;

  ShapeDecorationMix.only({
    ShapeBorderMix? shape,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? shadows,
  }) : this(
         shape: MixProp.maybe(shape),
         color: Prop.maybe(color),
         image: MixProp.maybe(image),
         gradient: MixProp.maybe(gradient),
         shadows: shadows?.map(MixProp<BoxShadow>.new).toList(),
       );

  const ShapeDecorationMix({
    MixProp<ShapeBorder>? shape,
    super.color,
    super.image,
    super.gradient,
    List<MixProp<BoxShadow>>? shadows,
  }) : $shape = shape,
       super(boxShadow: shadows);

  /// Constructor that accepts a [ShapeDecoration] value and extracts its properties.
  ShapeDecorationMix.value(ShapeDecoration decoration)
    : this.only(
        shape: ShapeBorderMix.maybeValue(decoration.shape),
        color: decoration.color,
        image: DecorationImageMix.maybeValue(decoration.image),
        gradient: GradientMix.maybeValue(decoration.gradient),
        shadows: decoration.shadows?.map(BoxShadowMix.value).toList(),
      );

  /// Constructor that accepts a nullable [ShapeDecoration] value and extracts its properties.
  static ShapeDecorationMix? maybeValue(ShapeDecoration? decoration) {
    return decoration != null ? ShapeDecorationMix.value(decoration) : null;
  }

  List<MixProp<BoxShadow>>? get shadows => $boxShadow;

  /// Resolves to [ShapeDecoration] using the provided [BuildContext].
  @override
  ShapeDecoration resolve(BuildContext context) {
    return ShapeDecoration(
      color: MixHelpers.resolve(context, $color) ?? defaultValue.color,
      image: MixHelpers.resolve(context, $image) ?? defaultValue.image,
      gradient: MixHelpers.resolve(context, $gradient) ?? defaultValue.gradient,
      shadows: MixHelpers.resolveList(context, $boxShadow),

      shape: MixHelpers.resolve(context, $shape) ?? defaultValue.shape,
    );
  }

  /// Merges the properties of this [ShapeDecorationMix] with the properties of [other].
  @override
  ShapeDecorationMix mergeDecoration(ShapeDecorationMix other) {
    return ShapeDecorationMix(
      shape: MixHelpers.merge($shape, other.$shape),
      color: MixHelpers.merge($color, other.$color),
      image: MixHelpers.merge($image, other.$image),
      gradient: MixHelpers.merge($gradient, other.$gradient),
      shadows: MixHelpers.mergeList(shadows, other.shadows),
    );
  }

  @override
  List<Object?> get props => [$shape, $color, $image, $gradient, shadows];

  @override
  ShapeDecoration get defaultValue =>
      const ShapeDecoration(shape: RoundedRectangleBorder());
}

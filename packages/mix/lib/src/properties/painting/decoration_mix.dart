// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/widgets.dart';

import '../../core/decoration_merge.dart';
import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'border_mix.dart';
import 'border_radius_mix.dart';
import 'decoration_image_mix.dart';
import 'gradient_mix.dart';
import 'shadow_mix.dart';
import 'shape_border_mix.dart';

/// Base class for decoration styling.
///
/// Supports color, gradient, image, and shadow properties.
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

  /// Creates from [Decoration].
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

  /// Creates with color.
  static BoxDecorationMix color(Color value) {
    return BoxDecorationMix(color: value);
  }

  /// Creates with gradient.
  static BoxDecorationMix gradient(GradientMix value) {
    return BoxDecorationMix(gradient: value);
  }

  /// Creates with image.
  static BoxDecorationMix image(DecorationImageMix value) {
    return BoxDecorationMix(image: value);
  }

  /// Creates with box shadows.
  static BoxDecorationMix boxShadow(List<BoxShadowMix> value) {
    return BoxDecorationMix(boxShadow: value);
  }

  /// Creates with shape.
  static BoxDecorationMix shape(BoxShape value) {
    return BoxDecorationMix(shape: value);
  }

  /// Creates with border.
  static BoxDecorationMix border(BoxBorderMix value) {
    return BoxDecorationMix(border: value);
  }

  /// Creates with border radius.
  static BoxDecorationMix borderRadius(BorderRadiusGeometryMix value) {
    return BoxDecorationMix(borderRadius: value);
  }

  /// Identity function for shape decoration.
  static ShapeDecorationMix shapeDecoration(ShapeDecorationMix value) {
    return value;
  }

  /// Creates from nullable [Decoration].
  static DecorationMix? maybeValue(Decoration? decoration) {
    return decoration != null ? DecorationMix.value(decoration) : null;
  }

  /// Merges decoration instances.
  static DecorationMix? tryMerge(DecorationMix? a, DecorationMix? b) {
    return DecorationMerger().tryMerge(a, b);
  }

  /// True if mergeable with other types.
  bool get isMergeable;

  /// Merges with another decoration.
  @override
  DecorationMix<T> merge(covariant DecorationMix<T>? other);
}

/// Mix representation of [BoxDecoration].
final class BoxDecorationMix extends DecorationMix<BoxDecoration> {
  final MixProp<BoxBorder>? $border;
  final MixProp<BorderRadiusGeometry>? $borderRadius;
  final Prop<BoxShape>? $shape;
  final Prop<BlendMode>? $backgroundBlendMode;

  BoxDecorationMix({
    BoxBorderMix? border,
    BorderRadiusGeometryMix? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? boxShadow,
  }) : this.create(
         border: MixProp.maybe(border),
         borderRadius: MixProp.maybe(borderRadius),
         shape: Prop.maybe(shape),
         backgroundBlendMode: Prop.maybe(backgroundBlendMode),
         color: Prop.maybe(color),
         image: MixProp.maybe(image),
         gradient: MixProp.maybe(gradient),
         boxShadow: boxShadow?.map(MixProp<BoxShadow>.new).toList(),
       );

  /// Creates with border only.
  BoxDecorationMix.border(BoxBorderMix border) : this(border: border);

  /// Creates with border radius only.
  BoxDecorationMix.borderRadius(BorderRadiusGeometryMix borderRadius)
    : this(borderRadius: borderRadius);

  /// Creates with shape only.
  BoxDecorationMix.shape(BoxShape shape) : this(shape: shape);

  /// Creates with blend mode only.
  BoxDecorationMix.backgroundBlendMode(BlendMode backgroundBlendMode)
    : this(backgroundBlendMode: backgroundBlendMode);

  /// Creates with color only.
  BoxDecorationMix.color(Color color) : this(color: color);

  /// Creates a box decoration with only the background image specified.
  BoxDecorationMix.image(DecorationImageMix image) : this(image: image);

  /// Creates a box decoration with only the gradient specified.
  BoxDecorationMix.gradient(GradientMix gradient) : this(gradient: gradient);

  /// Creates a box decoration with only the box shadows specified.
  BoxDecorationMix.boxShadow(List<BoxShadowMix> boxShadow)
    : this(boxShadow: boxShadow);

  /// Creates a [BoxDecorationMix] from an existing [BoxDecoration].
  BoxDecorationMix.value(BoxDecoration decoration)
    : this(
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

  const BoxDecorationMix.create({
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

  /// Creates a [BoxDecorationMix] from a nullable [BoxDecoration].
  ///
  /// Returns null if the input is null.
  static BoxDecorationMix? maybeValue(BoxDecoration? decoration) {
    return decoration != null ? BoxDecorationMix.value(decoration) : null;
  }

  /// Returns a copy with the specified gradient.
  BoxDecorationMix gradient(GradientMix value) {
    return merge(BoxDecorationMix.gradient(value));
  }

  /// Returns a copy with the specified background image.
  BoxDecorationMix image(DecorationImageMix image) {
    return merge(BoxDecorationMix.image(image));
  }

  /// Returns a copy with the specified color.
  BoxDecorationMix color(Color value) {
    return merge(BoxDecorationMix.color(value));
  }

  /// Returns a copy with the specified box shadows.
  BoxDecorationMix boxShadow(List<BoxShadowMix> value) {
    return merge(BoxDecorationMix.boxShadow(value));
  }

  /// Returns a copy with the specified border.
  BoxDecorationMix border(BoxBorderMix value) {
    return merge(BoxDecorationMix.border(value));
  }

  /// Returns a copy with the specified border radius.
  BoxDecorationMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(BoxDecorationMix.borderRadius(value));
  }

  /// Returns a copy with the specified shape.
  BoxDecorationMix shape(BoxShape value) {
    return merge(BoxDecorationMix.shape(value));
  }

  /// Returns a copy with the specified background blend mode.
  BoxDecorationMix backgroundBlendMode(BlendMode value) {
    return merge(BoxDecorationMix.backgroundBlendMode(value));
  }

  /// Resolves to [BoxDecoration] using the provided [BuildContext].
  @override
  BoxDecoration resolve(BuildContext context) {
    return BoxDecoration(
      color: MixOps.resolve(context, $color),
      image: MixOps.resolve(context, $image),
      border: MixOps.resolve(context, $border),
      borderRadius: MixOps.resolve(context, $borderRadius),
      boxShadow: MixOps.resolveList(context, $boxShadow),
      gradient: MixOps.resolve(context, $gradient),
      backgroundBlendMode: MixOps.resolve(context, $backgroundBlendMode),
      shape: MixOps.resolve(context, $shape) ?? BoxShape.rectangle,
    );
  }

  /// Merges the properties of this [BoxDecorationMix] with the properties of [other].
  @override
  BoxDecorationMix merge(BoxDecorationMix? other) {
    if (other == null) return this;

    return BoxDecorationMix.create(
      border: MixOps.merge($border, other.$border),
      borderRadius: MixOps.merge($borderRadius, other.$borderRadius),
      shape: MixOps.merge($shape, other.$shape),
      backgroundBlendMode: MixOps.merge(
        $backgroundBlendMode,
        other.$backgroundBlendMode,
      ),
      color: MixOps.merge($color, other.$color),
      image: MixOps.merge($image, other.$image),
      gradient: MixOps.merge($gradient, other.$gradient),
      boxShadow: MixOps.mergeList($boxShadow, other.$boxShadow),
    );
  }

  @override
  bool get isMergeable {
    // Cannot merge if has backgroundBlendMode (ShapeDecoration doesn't support it)
    if ($backgroundBlendMode != null) return false;

    // For now, assume mergeable if we can't inspect values without BuildContext
    // More precise validation will happen during actual merge attempts
    return true;
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

/// Mix-compatible representation of Flutter's [ShapeDecoration] with custom shape support.
///
/// Allows decoration with custom shape borders, color, gradient, image, and shadows
/// with token support and merging capabilities.
final class ShapeDecorationMix extends DecorationMix<ShapeDecoration>
    with DefaultValue<ShapeDecoration> {
  final MixProp<ShapeBorder>? $shape;

  ShapeDecorationMix({
    ShapeBorderMix? shape,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? shadows,
  }) : this.create(
         shape: MixProp.maybe(shape),
         color: Prop.maybe(color),
         image: MixProp.maybe(image),
         gradient: MixProp.maybe(gradient),
         shadows: shadows?.map(MixProp<BoxShadow>.new).toList(),
       );

  const ShapeDecorationMix.create({
    MixProp<ShapeBorder>? shape,
    super.color,
    super.image,
    super.gradient,
    List<MixProp<BoxShadow>>? shadows,
  }) : $shape = shape,
       super(boxShadow: shadows);

  /// Creates a [ShapeDecorationMix] from an existing [ShapeDecoration].
  ShapeDecorationMix.value(ShapeDecoration decoration)
    : this(
        shape: ShapeBorderMix.maybeValue(decoration.shape),
        color: decoration.color,
        image: DecorationImageMix.maybeValue(decoration.image),
        gradient: GradientMix.maybeValue(decoration.gradient),
        shadows: decoration.shadows?.map(BoxShadowMix.value).toList(),
      );

  /// Creates a [ShapeDecorationMix] from a nullable [ShapeDecoration].
  ///
  /// Returns null if the input is null.
  static ShapeDecorationMix? maybeValue(ShapeDecoration? decoration) {
    return decoration != null ? ShapeDecorationMix.value(decoration) : null;
  }

  List<MixProp<BoxShadow>>? get $shadows => $boxShadow;

  /// Resolves to [ShapeDecoration] using the provided [BuildContext].
  @override
  ShapeDecoration resolve(BuildContext context) {
    return ShapeDecoration(
      color: MixOps.resolve(context, $color) ?? defaultValue.color,
      image: MixOps.resolve(context, $image) ?? defaultValue.image,
      gradient: MixOps.resolve(context, $gradient) ?? defaultValue.gradient,
      shadows: MixOps.resolveList(context, $boxShadow),
      shape: MixOps.resolve(context, $shape) ?? defaultValue.shape,
    );
  }

  /// Merges the properties of this [ShapeDecorationMix] with the properties of [other].
  @override
  ShapeDecorationMix merge(ShapeDecorationMix? other) {
    if (other == null) return this;

    return ShapeDecorationMix.create(
      shape: MixOps.merge($shape, other.$shape),
      color: MixOps.merge($color, other.$color),
      image: MixOps.merge($image, other.$image),
      gradient: MixOps.merge($gradient, other.$gradient),
      shadows: MixOps.mergeList($boxShadow, other.$boxShadow),
    );
  }

  @override
  bool get isMergeable {
    final shape = $shape;
    if (shape == null) return true;

    // Check if it's a CircleBorderMix without eccentricity or RoundedRectangleBorderMix
    if (shape is MixProp<CircleBorder>) {
      // For now, we consider all CircleBorderMix as mergeable
      // In the future, we might need to check eccentricity
      return true;
    }

    return shape is MixProp<RoundedRectangleBorder>;
  }

  @override
  List<Object?> get props => [$shape, $color, $image, $gradient, $shadows];

  @override
  ShapeDecoration get defaultValue =>
      const ShapeDecoration(shape: RoundedRectangleBorder());
}

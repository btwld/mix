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

/// Base class for decoration styling that supports color, gradient, image, and shadow properties.
///
/// Provides factory methods for common decoration types and merging capabilities.
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

  /// Creates the appropriate decoration mix type from a Flutter [Decoration].
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

  /// Creates a box decoration with the specified color.
  static BoxDecorationMix color(Color value) {
    return BoxDecorationMix(color: value);
  }

  /// Creates a box decoration with the specified gradient.
  static BoxDecorationMix gradient(GradientMix value) {
    return BoxDecorationMix(gradient: value);
  }

  /// Creates a box decoration with the specified background image.
  static BoxDecorationMix image(DecorationImageMix value) {
    return BoxDecorationMix(image: value);
  }

  /// Creates a box decoration with the specified box shadows.
  static BoxDecorationMix boxShadow(List<BoxShadowMix> value) {
    return BoxDecorationMix(boxShadow: value);
  }

  /// Creates a box decoration with the specified shape.
  static BoxDecorationMix shape(BoxShape value) {
    return BoxDecorationMix(shape: value);
  }

  /// Creates a box decoration with the specified border.
  static BoxDecorationMix border(BoxBorderMix value) {
    return BoxDecorationMix(border: value);
  }

  /// Creates a box decoration with the specified border radius.
  static BoxDecorationMix borderRadius(BorderRadiusGeometryMix value) {
    return BoxDecorationMix(borderRadius: value);
  }

  /// Returns the provided shape decoration (identity function for consistency).
  static ShapeDecorationMix shapeDecoration(ShapeDecorationMix value) {
    return value;
  }

  /// Creates the appropriate decoration mix type from a nullable Flutter [Decoration].
  ///
  /// Returns null if the input is null.
  static DecorationMix? maybeValue(Decoration? decoration) {
    return decoration != null ? DecorationMix.value(decoration) : null;
  }

  /// Merges two DecorationMix instances.
  ///
  /// Delegates to [DecorationMerger.tryMerge] for all merge operations including
  /// same-type and cross-type merging with proper validation.
  static DecorationMix? tryMerge(DecorationMix? a, DecorationMix? b) {
    return DecorationMerger().tryMerge(a, b);
  }

  /// Returns true if this decoration can be merged with other decoration types.
  bool get isMergeable;

  /// Merges with another decoration of the same type.
  /// This method is implemented by subclasses to handle type-specific merging.
  @override
  DecorationMix<T> merge(covariant DecorationMix<T>? other);
}

/// Mix-compatible representation of [BoxDecoration] for styling.
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
  }) : this.raw(
         border: MixProp.maybe(border),
         borderRadius: MixProp.maybe(borderRadius),
         shape: Prop.maybe(shape),
         backgroundBlendMode: Prop.maybe(backgroundBlendMode),
         color: Prop.maybe(color),
         image: MixProp.maybe(image),
         gradient: MixProp.maybe(gradient),
         boxShadow: boxShadow?.map(MixProp<BoxShadow>.new).toList(),
       );

  /// Creates a box decoration with only the border specified.
  BoxDecorationMix.border(BoxBorderMix border) : this(border: border);

  /// Creates a box decoration with only the border radius specified.
  BoxDecorationMix.borderRadius(BorderRadiusGeometryMix borderRadius)
    : this(borderRadius: borderRadius);

  /// Creates a box decoration with only the shape specified.
  BoxDecorationMix.shape(BoxShape shape) : this(shape: shape);

  /// Creates a box decoration with only the background blend mode specified.
  BoxDecorationMix.backgroundBlendMode(BlendMode backgroundBlendMode)
    : this(backgroundBlendMode: backgroundBlendMode);

  /// Creates a box decoration with only the color specified.
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

  const BoxDecorationMix.raw({
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
  BoxDecorationMix merge(BoxDecorationMix? other) {
    if (other == null) return this;

    return BoxDecorationMix.raw(
      border: $border.tryMerge(other.$border),
      borderRadius: $borderRadius.tryMerge(other.$borderRadius),
      shape: $shape.tryMerge(other.$shape),
      backgroundBlendMode: $backgroundBlendMode.tryMerge(
        other.$backgroundBlendMode,
      ),
      color: $color.tryMerge(other.$color),
      image: $image.tryMerge(other.$image),
      gradient: $gradient.tryMerge(other.$gradient),
      boxShadow: $boxShadow.tryMerge(other.$boxShadow),
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
  }) : this.raw(
         shape: MixProp.maybe(shape),
         color: Prop.maybe(color),
         image: MixProp.maybe(image),
         gradient: MixProp.maybe(gradient),
         shadows: shadows?.map(MixProp<BoxShadow>.new).toList(),
       );

  const ShapeDecorationMix.raw({
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
      color: MixHelpers.resolve(context, $color) ?? defaultValue.color,
      image: MixHelpers.resolve(context, $image) ?? defaultValue.image,
      gradient: MixHelpers.resolve(context, $gradient) ?? defaultValue.gradient,
      shadows: MixHelpers.resolveList(context, $boxShadow),
      shape: MixHelpers.resolve(context, $shape) ?? defaultValue.shape,
    );
  }

  /// Merges the properties of this [ShapeDecorationMix] with the properties of [other].
  @override
  ShapeDecorationMix merge(ShapeDecorationMix? other) {
    if (other == null) return this;

    return ShapeDecorationMix.raw(
      shape: $shape.tryMerge(other.$shape),
      color: $color.tryMerge(other.$color),
      image: $image.tryMerge(other.$image),
      gradient: $gradient.tryMerge(other.$gradient),
      shadows: $boxShadow.tryMerge(other.$boxShadow),
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

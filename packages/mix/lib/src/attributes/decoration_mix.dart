// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// A Data transfer object that represents a [Decoration] value.
///
/// This DTO is used to resolve a [Decoration] value from a [MixContext] instance.
@immutable
sealed class DecorationMix<T extends Decoration> extends Mix<T> {
  final Prop<Color>? color;
  final MixProp<Gradient>? gradient;
  final MixProp<DecorationImage>? image;
  final List<MixProp<BoxShadow>>? boxShadow;

  const DecorationMix({this.color, this.gradient, this.boxShadow, this.image});

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
  DecorationMix<T> merge(DecorationMix<T>? other) {
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
  final MixProp<BoxBorder>? border;
  final MixProp<BorderRadiusGeometry>? borderRadius;
  final Prop<BoxShape>? shape;
  final Prop<BlendMode>? backgroundBlendMode;

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
    this.border,
    this.borderRadius,
    this.shape,
    this.backgroundBlendMode,
    super.color,
    super.image,
    super.gradient,
    super.boxShadow,
  });

  /// Constructor that accepts a nullable [BoxDecoration] value and extracts its properties.
  static BoxDecorationMix? maybeValue(BoxDecoration? decoration) {
    return decoration != null ? BoxDecorationMix.value(decoration) : null;
  }

  /// Resolves to [BoxDecoration] using the provided [BuildContext].
  @override
  BoxDecoration resolve(BuildContext context) {
    return BoxDecoration(
      color: MixHelpers.resolve(context, color),
      image: MixHelpers.resolve(context, image),
      border: MixHelpers.resolve(context, border),
      borderRadius: MixHelpers.resolve(context, borderRadius),
      boxShadow: MixHelpers.resolveList(context, boxShadow),
      gradient: MixHelpers.resolve(context, gradient),
      backgroundBlendMode: MixHelpers.resolve(context, backgroundBlendMode),
      shape: MixHelpers.resolve(context, shape) ?? BoxShape.rectangle,
    );
  }

  /// Merges the properties of this [BoxDecorationMix] with the properties of [other].
  @override
  BoxDecorationMix mergeDecoration(BoxDecorationMix other) {
    return BoxDecorationMix(
      border: MixHelpers.merge(border, other.border),
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      shape: MixHelpers.merge(shape, other.shape),
      backgroundBlendMode: MixHelpers.merge(
        backgroundBlendMode,
        other.backgroundBlendMode,
      ),
      color: MixHelpers.merge(color, other.color),
      image: MixHelpers.merge(image, other.image),
      gradient: MixHelpers.merge(gradient, other.gradient),
      boxShadow: MixHelpers.mergeList(boxShadow, other.boxShadow),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxDecorationMix &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        other.shape == shape &&
        other.backgroundBlendMode == backgroundBlendMode &&
        other.color == color &&
        other.image == image &&
        other.gradient == gradient &&
        listEquals(other.boxShadow, boxShadow);
  }

  @override
  int get hashCode {
    return border.hashCode ^
        borderRadius.hashCode ^
        shape.hashCode ^
        backgroundBlendMode.hashCode ^
        color.hashCode ^
        image.hashCode ^
        gradient.hashCode ^
        boxShadow.hashCode;
  }
}

final class ShapeDecorationMix extends DecorationMix<ShapeDecoration>
    with MixDefaultValue<ShapeDecoration> {
  final MixProp<ShapeBorder>? shape;

  ShapeDecorationMix.only({
    ShapeBorderMix? shape,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? shadows,
  }) : this(
         shape: MixProp.maybe(shape),
         color: Prop.maybe(color),
         image: image != null ? MixProp(image) : null,
         gradient: gradient != null ? MixProp(gradient) : null,
         shadows: shadows?.map(MixProp<BoxShadow>.new).toList(),
       );

  const ShapeDecorationMix({
    this.shape,
    super.color,
    super.image,
    super.gradient,
    List<MixProp<BoxShadow>>? shadows,
  }) : super(boxShadow: shadows);

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

  List<MixProp<BoxShadow>>? get shadows => boxShadow;

  /// Resolves to [ShapeDecoration] using the provided [BuildContext].
  @override
  ShapeDecoration resolve(BuildContext context) {
    return ShapeDecoration(
      color: MixHelpers.resolve(context, color) ?? defaultValue.color,
      image: MixHelpers.resolve(context, image) ?? defaultValue.image,
      gradient: MixHelpers.resolve(context, gradient) ?? defaultValue.gradient,
      shadows:
          shadows?.map((e) => e.resolve(context)).toList() ??
          defaultValue.shadows,
      shape: MixHelpers.resolve(context, shape) ?? defaultValue.shape,
    );
  }

  /// Merges the properties of this [ShapeDecorationMix] with the properties of [other].
  @override
  ShapeDecorationMix mergeDecoration(ShapeDecorationMix other) {
    return ShapeDecorationMix(
      shape: MixHelpers.merge(shape, other.shape),
      color: MixHelpers.merge(color, other.color),
      image: MixHelpers.merge(image, other.image),
      gradient: MixHelpers.merge(gradient, other.gradient),
      shadows: MixHelpers.mergeList(shadows, other.shadows),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShapeDecorationMix &&
        other.shape == shape &&
        other.color == color &&
        other.image == image &&
        other.gradient == gradient &&
        listEquals(other.shadows, shadows);
  }

  @override
  ShapeDecoration get defaultValue =>
      const ShapeDecoration(shape: RoundedRectangleBorder());

  @override
  int get hashCode {
    return shape.hashCode ^
        color.hashCode ^
        image.hashCode ^
        gradient.hashCode ^
        shadows.hashCode;
  }
}

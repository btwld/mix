// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// A Data transfer object that represents a [Decoration] value.
///
/// This DTO is used to resolve a [Decoration] value from a [MixContext] instance.
@immutable
sealed class DecorationDto<T extends Decoration> extends Mix<T> {
  final Prop<Color>? color;
  final MixProp<Gradient>? gradient;
  final MixProp<DecorationImage>? image;
  final List<MixProp<BoxShadow>>? boxShadow;

  const DecorationDto({this.color, this.gradient, this.boxShadow, this.image});

  /// Constructor that accepts a [Decoration] value and converts it to the appropriate DTO.
  static DecorationDto value(Decoration decoration) {
    return switch (decoration) {
      BoxDecoration d => BoxDecorationDto.value(d),
      ShapeDecoration d => ShapeDecorationDto.value(d),
      _ => throw ArgumentError(
        'Unsupported Decoration type: ${decoration.runtimeType}',
      ),
    };
  }

  /// Constructor that accepts a nullable [Decoration] value and converts it to the appropriate DTO.
  static DecorationDto? maybeValue(Decoration? decoration) {
    return decoration != null ? DecorationDto.value(decoration) : null;
  }

  /// Merges with another decoration of the same type.
  /// This method is implemented by subclasses to handle type-specific merging.
  @protected
  DecorationDto<T> mergeDecoration(covariant DecorationDto<T> other);

  /// Merges two DecorationDto instances.
  ///
  /// If both are the same type, delegates to [mergeDecoration].
  /// If different types, returns [other] (override behavior).
  /// If [other] is null, returns this instance.
  @override
  DecorationDto<T> merge(DecorationDto<T>? other) {
    if (other == null) return this;

    return switch ((this, other)) {
          (BoxDecorationDto a, BoxDecorationDto b) => a.mergeDecoration(b),
          (ShapeDecorationDto a, ShapeDecorationDto b) => a.mergeDecoration(b),
          _ => other, // Different types: override with other
        }
        as DecorationDto<T>;
  }
}

/// Represents a Data transfer object of [BoxDecoration]
final class BoxDecorationDto extends DecorationDto<BoxDecoration> {
  final MixProp<BoxBorder>? border;
  final MixProp<BorderRadiusGeometry>? borderRadius;
  final Prop<BoxShape>? shape;
  final Prop<BlendMode>? backgroundBlendMode;

  BoxDecorationDto.only({
    BoxBorderDto? border,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? boxShadow,
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

  BoxDecorationDto.border(BoxBorderDto border) : this.only(border: border);

  BoxDecorationDto.borderDirectional(BorderDirectionalDto border)
    : this.only(border: border);

  BoxDecorationDto.borderRadius(BorderRadiusGeometryDto borderRadius)
    : this.only(borderRadius: borderRadius);

  BoxDecorationDto.shape(BoxShape shape) : this.only(shape: shape);

  BoxDecorationDto.backgroundBlendMode(BlendMode backgroundBlendMode)
    : this.only(backgroundBlendMode: backgroundBlendMode);

  BoxDecorationDto.color(Color? color) : this.only(color: color);

  BoxDecorationDto.image(DecorationImageDto? image) : this.only(image: image);

  BoxDecorationDto.gradient(GradientDto? gradient)
    : this.only(gradient: gradient);

  BoxDecorationDto.boxShadow(List<BoxShadowDto>? boxShadow)
    : this.only(boxShadow: boxShadow);

  /// Constructor that accepts a [BoxDecoration] value and extracts its properties.
  BoxDecorationDto.value(BoxDecoration decoration)
    : this.only(
        border: BoxBorderDto.maybeValue(decoration.border),
        borderRadius: BorderRadiusGeometryDto.maybeValue(
          decoration.borderRadius,
        ),
        shape: decoration.shape,
        backgroundBlendMode: decoration.backgroundBlendMode,
        color: decoration.color,
        image: DecorationImageDto.maybeValue(decoration.image),
        gradient: GradientDto.maybeValue(decoration.gradient),
        boxShadow: decoration.boxShadow?.map(BoxShadowDto.value).toList(),
      );

  const BoxDecorationDto({
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
  static BoxDecorationDto? maybeValue(BoxDecoration? decoration) {
    return decoration != null ? BoxDecorationDto.value(decoration) : null;
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

  /// Merges the properties of this [BoxDecorationDto] with the properties of [other].
  @override
  BoxDecorationDto mergeDecoration(BoxDecorationDto other) {
    return BoxDecorationDto(
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

    return other is BoxDecorationDto &&
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

final class ShapeDecorationDto extends DecorationDto<ShapeDecoration>
    with HasDefaultValue<ShapeDecoration> {
  final MixProp<ShapeBorder>? shape;

  ShapeDecorationDto.only({
    ShapeBorderDto? shape,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
  }) : this(
         shape: MixProp.maybe(shape),
         color: Prop.maybe(color),
         image: image != null ? MixProp(image) : null,
         gradient: gradient != null ? MixProp(gradient) : null,
         shadows: shadows?.map(MixProp<BoxShadow>.new).toList(),
       );

  const ShapeDecorationDto({
    this.shape,
    super.color,
    super.image,
    super.gradient,
    List<MixProp<BoxShadow>>? shadows,
  }) : super(boxShadow: shadows);

  /// Constructor that accepts a [ShapeDecoration] value and extracts its properties.
  ShapeDecorationDto.value(ShapeDecoration decoration)
    : this.only(
        shape: ShapeBorderDto.maybeValue(decoration.shape),
        color: decoration.color,
        image: DecorationImageDto.maybeValue(decoration.image),
        gradient: GradientDto.maybeValue(decoration.gradient),
        shadows: decoration.shadows?.map(BoxShadowDto.value).toList(),
      );

  /// Constructor that accepts a nullable [ShapeDecoration] value and extracts its properties.
  static ShapeDecorationDto? maybeValue(ShapeDecoration? decoration) {
    return decoration != null ? ShapeDecorationDto.value(decoration) : null;
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

  /// Merges the properties of this [ShapeDecorationDto] with the properties of [other].
  @override
  ShapeDecorationDto mergeDecoration(ShapeDecorationDto other) {
    return ShapeDecorationDto(
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

    return other is ShapeDecorationDto &&
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

// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

typedef _BaseDecorProperties = ({
  Prop<Color>? color,
  GradientDto? gradient,
  List<BoxShadowDto>? boxShadow,
  DecorationImageDto? image,
});

/// A Data transfer object that represents a [Decoration] value.
///
/// This DTO is used to resolve a [Decoration] value from a [MixContext] instance.
///
/// This class needs to have the different properties that are not found in the [Modifiers] class.
/// In order to support merging of [Decoration] values, and reusable of common properties.
@immutable
sealed class DecorationDto<T extends Decoration> extends Mix<T> {
  final Prop<Color>? color;
  final GradientDto? gradient;
  final DecorationImageDto? image;
  final List<BoxShadowDto>? boxShadow;

  const DecorationDto({
    required this.color,
    required this.gradient,
    required this.boxShadow,
    required this.image,
  });

  static DecorationDto? tryToMerge(DecorationDto? a, DecorationDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    if (a.runtimeType == b.runtimeType) {
      return a.merge(b);
    }

    if (b.isMergeable) {
      return a.mergeableDecor(b);
    }

    if (b is BoxDecorationDto) {
      return _toBoxDecorationDto(a as ShapeDecorationDto).merge(b);
    }

    if (b is ShapeDecorationDto) {
      return _toShapeDecorationDto(a as BoxDecorationDto).merge(b);
    }

    throw UnimplementedError('Merging of $a and $b is not supported.');
  }

  _BaseDecorProperties _getBaseDecor() {
    return (
      color: color,
      gradient: gradient,
      boxShadow: boxShadow,
      image: image,
    );
  }

  bool get isMergeable;

  DecorationDto? mergeableDecor(covariant DecorationDto? other);

  @override
  DecorationDto<T> merge(covariant DecorationDto<T>? other);
}

/// Represents a Data transfer object of [BoxDecoration]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxDecoration]
final class BoxDecorationDto extends DecorationDto<BoxDecoration> {
  final BoxBorderDto? border;
  final BorderRadiusGeometryDto? borderRadius;
  final Prop<BoxShape>? shape;
  final Prop<BlendMode>? backgroundBlendMode;

  factory BoxDecorationDto({
    BoxBorderDto? border,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? boxShadow,
  }) {
    return BoxDecorationDto._(
      border: border,
      borderRadius: borderRadius,
      shape: Prop.maybeValue(shape),
      backgroundBlendMode: Prop.maybeValue(backgroundBlendMode),
      color: Prop.maybeValue(color),
      image: image,
      gradient: gradient,
      boxShadow: boxShadow,
    );
  }

  const BoxDecorationDto._({
    this.border,
    this.borderRadius,
    this.shape,
    this.backgroundBlendMode,
    required super.color,
    super.image,
    super.gradient,
    super.boxShadow,
  });

  @override
  BoxDecorationDto mergeableDecor(ShapeDecorationDto? other) {
    if (other == null) return this;

    final (:boxShadow, :color, :gradient, :image) = other._getBaseDecor();

    final (:borderRadius, :boxShape, :side) = ShapeBorderDto.extract(
      other.shape,
    );

    return merge(
      BoxDecorationDto._(
        border: side != null ? BorderDto.all(side) : null,
        borderRadius: borderRadius,
        shape: Prop.maybeValue(boxShape),
        backgroundBlendMode: null,
        color: color,
        image: image,
        gradient: gradient,
        boxShadow: boxShadow,
      ),
    );
  }

  /// Resolves to [BoxDecoration] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxDecoration = BoxDecorationDto(...).resolve(mix);
  /// ```
  @override
  BoxDecoration resolve(MixContext mix) {
    return BoxDecoration(
      color: resolveProp(mix, color),
      image: image?.resolve(mix),
      border: border?.resolve(mix),
      borderRadius: borderRadius?.resolve(mix),
      boxShadow: boxShadow?.map((e) => e.resolve(mix)).toList(),
      gradient: gradient?.resolve(mix),
      backgroundBlendMode: resolveProp(mix, backgroundBlendMode),
      shape: resolveProp(mix, shape) ?? BoxShape.rectangle,
    );
  }

  /// Merges the properties of this [BoxDecorationDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxDecorationDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxDecorationDto merge(BoxDecorationDto? other) {
    if (other == null) return this;

    return BoxDecorationDto._(
      border: BoxBorderDto.tryToMerge(border, other.border),
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      shape: mergeProp(shape, other.shape),
      backgroundBlendMode: mergeProp(backgroundBlendMode, other.backgroundBlendMode),
      color: mergeProp(color, other.color),
      image: image?.merge(other.image) ?? other.image,
      gradient: GradientDto.tryToMerge(gradient, other.gradient),
      boxShadow: MixHelpers.mergeList(boxShadow, other.boxShadow),
    );
  }

  @override
  bool get isMergeable => backgroundBlendMode == null;

  /// The list of properties that constitute the state of this [BoxDecorationDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxDecorationDto] instances for equality.
  @override
  List<Object?> get props => [
    border,
    borderRadius,
    shape,
    backgroundBlendMode,
    color,
    image,
    gradient,
    boxShadow,
  ];
}

final class ShapeDecorationDto extends DecorationDto<ShapeDecoration>
    with HasDefaultValue<ShapeDecoration> {
  final ShapeBorderDto? shape;

  factory ShapeDecorationDto({
    ShapeBorderDto? shape,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
  }) {
    return ShapeDecorationDto._(
      shape: shape,
      color: Prop.maybeValue(color),
      image: image,
      gradient: gradient,
      shadows: shadows,
    );
  }

  const ShapeDecorationDto._({
    this.shape,
    required super.color,
    super.image,
    super.gradient,
    List<BoxShadowDto>? shadows,
  }) : super(boxShadow: shadows);

  List<BoxShadowDto>? get shadows => boxShadow;

  @override
  ShapeDecorationDto mergeableDecor(BoxDecorationDto? other) {
    if (other == null) return this;

    assert(
      other.border == null || other.border!.isUniform,
      'Border to use with ShapeDecoration must be uniform.',
    );

    final (:boxShadow, :color, :gradient, :image) = other._getBaseDecor();

    // For mergeable operations, we assume rectangle shape if not resolvable
    // This maintains backward compatibility
    final shapeBorder = _fromBoxShape(
      shape: BoxShape.rectangle,
      side: other.border?.top,
      borderRadius: other.borderRadius,
    );

    return merge(
      ShapeDecorationDto._(
        shape: shapeBorder,
        color: color,
        image: image,
        gradient: gradient,
        shadows: boxShadow,
      ),
    );
  }

  /// Resolves to [ShapeDecoration] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final shapeDecoration = ShapeDecorationDto(...).resolve(mix);
  /// ```
  @override
  ShapeDecoration resolve(MixContext mix) {
    return ShapeDecoration(
      color: resolveProp(mix, color) ?? defaultValue.color,
      image: image?.resolve(mix) ?? defaultValue.image,
      gradient: gradient?.resolve(mix) ?? defaultValue.gradient,
      shadows:
          shadows?.map((e) => e.resolve(mix)).toList() ?? defaultValue.shadows,
      shape: shape?.resolve(mix) ?? defaultValue.shape,
    );
  }

  /// Merges the properties of this [ShapeDecorationDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ShapeDecorationDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ShapeDecorationDto merge(ShapeDecorationDto? other) {
    if (other == null) return this;

    return ShapeDecorationDto._(
      shape: ShapeBorderDto.tryToMerge(shape, other.shape),
      color: mergeProp(color, other.color),
      image: image?.merge(other.image) ?? other.image,
      gradient: GradientDto.tryToMerge(gradient, other.gradient),
      shadows: MixHelpers.mergeList(shadows, other.shadows),
    );
  }

  @override
  bool get isMergeable =>
      (shape == null ||
      shape is CircleBorderDto ||
      shape is RoundedRectangleBorderDto);

  @override
  ShapeDecoration get defaultValue =>
      const ShapeDecoration(shape: RoundedRectangleBorder());

  /// The list of properties that constitute the state of this [ShapeDecorationDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ShapeDecorationDto] instances for equality.
  @override
  List<Object?> get props => [shape, color, image, gradient, shadows];
}

/// Converts a [ShapeDecorationDto] to a [BoxDecorationDto].
BoxDecorationDto _toBoxDecorationDto(ShapeDecorationDto dto) {
  final (:boxShadow, :color, :gradient, :image) = dto._getBaseDecor();
  final (:borderRadius, :boxShape, :side) = ShapeBorderDto.extract(dto.shape);

  return BoxDecorationDto._(
    border: side != null ? BorderDto.all(side) : null,
    borderRadius: borderRadius,
    shape: Prop.maybeValue(boxShape),
    backgroundBlendMode: null,
    color: color,
    image: image,
    gradient: gradient,
    boxShadow: boxShadow,
  );
}

ShapeDecorationDto _toShapeDecorationDto(BoxDecorationDto dto) {
  final (:boxShadow, :color, :gradient, :image) = dto._getBaseDecor();
  
  // For conversion operations, we assume rectangle shape if not resolvable
  // This maintains backward compatibility
  final shapeBorder = _fromBoxShape(
    shape: BoxShape.rectangle,
    side: dto.border?.top,
    borderRadius: dto.borderRadius,
  );

  return ShapeDecorationDto._(
    shape: shapeBorder,
    color: color,
    image: image,
    gradient: gradient,
    shadows: boxShadow,
  );
}

ShapeBorderDto? _fromBoxShape({
  required BoxShape? shape,
  required BorderSideDto? side,
  required BorderRadiusGeometryDto? borderRadius,
}) {
  switch (shape) {
    case BoxShape.circle:
      return CircleBorderDto(side: side);
    case BoxShape.rectangle:
      return RoundedRectangleBorderDto(borderRadius: borderRadius, side: side);
    default:
      if (side != null || borderRadius != null) {
        return RoundedRectangleBorderDto(
          borderRadius: borderRadius,
          side: side,
        );
      }

      return null;
  }
}

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

  /// Constructor that accepts a [BoxDecoration] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxDecoration] instances to [BoxDecorationDto].
  ///
  /// ```dart
  /// const decoration = BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8));
  /// final dto = BoxDecorationDto.value(decoration);
  /// ```
  factory BoxDecorationDto.value(BoxDecoration decoration) {
    return BoxDecorationDto._(
      border: _convertBoxBorder(decoration.border),
      borderRadius: _convertBorderRadius(decoration.borderRadius),
      shape: Prop.maybeValue(
        decoration.shape != BoxShape.rectangle ? decoration.shape : null,
      ),
      backgroundBlendMode: Prop.maybeValue(decoration.backgroundBlendMode),
      color: Prop.maybeValue(decoration.color),
      image: DecorationImageDto.maybeValue(decoration.image),
      gradient: _convertGradient(decoration.gradient),
      boxShadow: decoration.boxShadow?.map(BoxShadowDto.value).toList(),
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

  /// Constructor that accepts a nullable [BoxDecoration] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxDecorationDto.value].
  ///
  /// ```dart
  /// const BoxDecoration? decoration = BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8));
  /// final dto = BoxDecorationDto.maybeValue(decoration); // Returns BoxDecorationDto or null
  /// ```
  static BoxDecorationDto? maybeValue(BoxDecoration? decoration) {
    return decoration != null ? BoxDecorationDto.value(decoration) : null;
  }

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
  BoxDecoration resolve(MixContext context) {
    return BoxDecoration(
      color: resolveProp(context, color),
      image: image?.resolve(context),
      border: border?.resolve(context),
      borderRadius: borderRadius?.resolve(context),
      boxShadow: boxShadow?.map((e) => e.resolve(context)).toList(),
      gradient: gradient?.resolve(context),
      backgroundBlendMode: resolveProp(context, backgroundBlendMode),
      shape: resolveProp(context, shape) ?? BoxShape.rectangle,
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
      backgroundBlendMode: mergeProp(
        backgroundBlendMode,
        other.backgroundBlendMode,
      ),
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

  /// Constructor that accepts a [ShapeDecoration] value and extracts its properties.
  ///
  /// This is useful for converting existing [ShapeDecoration] instances to [ShapeDecorationDto].
  ///
  /// ```dart
  /// const decoration = ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder());
  /// final dto = ShapeDecorationDto.value(decoration);
  /// ```
  factory ShapeDecorationDto.value(ShapeDecoration decoration) {
    return ShapeDecorationDto._(
      shape: _convertShapeBorder(decoration.shape),
      color: Prop.maybeValue(decoration.color),
      image: DecorationImageDto.maybeValue(decoration.image),
      gradient: _convertGradient(decoration.gradient),
      shadows: decoration.shadows?.map(BoxShadowDto.value).toList(),
    );
  }

  const ShapeDecorationDto._({
    this.shape,
    required super.color,
    super.image,
    super.gradient,
    List<BoxShadowDto>? shadows,
  }) : super(boxShadow: shadows);

  /// Constructor that accepts a nullable [ShapeDecoration] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ShapeDecorationDto.value].
  ///
  /// ```dart
  /// const ShapeDecoration? decoration = ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder());
  /// final dto = ShapeDecorationDto.maybeValue(decoration); // Returns ShapeDecorationDto or null
  /// ```
  static ShapeDecorationDto? maybeValue(ShapeDecoration? decoration) {
    return decoration != null ? ShapeDecorationDto.value(decoration) : null;
  }

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
  ShapeDecoration resolve(MixContext context) {
    return ShapeDecoration(
      color: resolveProp(context, color) ?? defaultValue.color,
      image: image?.resolve(context) ?? defaultValue.image,
      gradient: gradient?.resolve(context) ?? defaultValue.gradient,
      shadows:
          shadows?.map((e) => e.resolve(context)).toList() ?? defaultValue.shadows,
      shape: shape?.resolve(context) ?? defaultValue.shape,
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

// Helper methods for converting Flutter types to DTOs
BoxBorderDto? _convertBoxBorder(BoxBorder? border) {
  if (border == null) return null;
  if (border is Border) {
    return BorderDto.value(border);
  } else if (border is BorderDirectional) {
    return BorderDirectionalDto.value(border);
  }

  return null;
}

BorderRadiusGeometryDto? _convertBorderRadius(
  BorderRadiusGeometry? borderRadius,
) {
  if (borderRadius == null) return null;
  if (borderRadius is BorderRadius) {
    return BorderRadiusDto.value(borderRadius);
  } else if (borderRadius is BorderRadiusDirectional) {
    return BorderRadiusDirectionalDto.value(borderRadius);
  }

  return null;
}

GradientDto? _convertGradient(Gradient? gradient) {
  if (gradient == null) return null;
  if (gradient is LinearGradient) {
    return LinearGradientDto.value(gradient);
  } else if (gradient is RadialGradient) {
    return RadialGradientDto.value(gradient);
  } else if (gradient is SweepGradient) {
    return SweepGradientDto.value(gradient);
  }

  return null;
}

ShapeBorderDto? _convertShapeBorder(ShapeBorder? shapeBorder) {
  if (shapeBorder == null) return null;

  // This would need to be implemented based on the available ShapeBorderDto types
  // For now, return null as a placeholder
  return null;
}

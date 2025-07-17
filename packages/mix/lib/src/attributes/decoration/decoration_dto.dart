// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

typedef _BaseDecorProperties = ({
  Prop<Color>? color,
  MixProp<Gradient, GradientDto>? gradient,
  List<MixProp<BoxShadow, BoxShadowDto>>? boxShadow,
  MixProp<DecorationImage, DecorationImageDto>? image,
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
  final MixProp<Gradient, GradientDto>? gradient;
  final MixProp<DecorationImage, DecorationImageDto>? image;
  final List<MixProp<BoxShadow, BoxShadowDto>>? boxShadow;

  const DecorationDto({
    required this.color,
    required this.gradient,
    required this.boxShadow,
    required this.image,
  });

  /// Constructor that accepts a [Decoration] value and converts it to the appropriate DTO.
  ///
  /// This is useful for converting existing [Decoration] instances to [DecorationDto].
  ///
  /// ```dart
  /// const decoration = BoxDecoration(color: Colors.blue);
  /// final dto = DecorationDto.value(decoration);
  /// ```
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
  ///
  /// Returns null if the input is null, otherwise uses [DecorationDto.value].
  ///
  /// ```dart
  /// const Decoration? decoration = BoxDecoration(color: Colors.blue);
  /// final dto = DecorationDto.maybeValue(decoration); // Returns DecorationDto or null
  /// ```
  static DecorationDto? maybeValue(Decoration? decoration) {
    return decoration != null ? DecorationDto.value(decoration) : null;
  }

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
  final MixProp<BoxBorder, BoxBorderDto>? border;
  final MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>? borderRadius;
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
    return BoxDecorationDto.props(
      border: MixProp.maybeValue(border),
      borderRadius: MixProp.maybeValue(borderRadius),
      shape: Prop.maybeValue(shape),
      backgroundBlendMode: Prop.maybeValue(backgroundBlendMode),
      color: Prop.maybeValue(color),
      image: MixProp.maybeValue(image),
      gradient: MixProp.maybeValue(gradient),
      boxShadow: boxShadow
          ?.map(MixProp<BoxShadow, BoxShadowDto>.fromValue)
          .toList(),
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
    return BoxDecorationDto(
      border: BoxBorderDto.maybeValue(decoration.border),
      borderRadius: BorderRadiusGeometryDto.maybeValue(decoration.borderRadius),
      shape: decoration.shape,
      backgroundBlendMode: decoration.backgroundBlendMode,
      color: decoration.color,
      image: DecorationImageDto.maybeValue(decoration.image),
      gradient: GradientDto.maybeValue(decoration.gradient),
      boxShadow: decoration.boxShadow?.map(BoxShadowDto.value).toList(),
    );
  }

  const BoxDecorationDto.props({
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
      other.shape?.mixValue,
    );

    return merge(
      BoxDecorationDto.props(
        border: side?.mixValue != null
            ? MixProp.fromValue(BorderDto.all(side!.mixValue!))
            : null,
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
  BoxDecoration resolve(BuildContext context) {
    return BoxDecoration(
      color: resolveProp(context, color),
      image: resolveMixProp(context, image),
      border: resolveMixProp(context, border),
      borderRadius: resolveMixProp(context, borderRadius),
      boxShadow: resolveMixPropList(context, boxShadow),
      gradient: resolveMixProp(context, gradient),
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

    return BoxDecorationDto.props(
      border: mergeMixProp(border, other.border),
      borderRadius: mergeMixProp(borderRadius, other.borderRadius),
      shape: mergeProp(shape, other.shape),
      backgroundBlendMode: mergeProp(
        backgroundBlendMode,
        other.backgroundBlendMode,
      ),
      color: mergeProp(color, other.color),
      image: mergeMixProp(image, other.image),
      gradient: mergeMixProp(gradient, other.gradient),
      boxShadow: mergeMixPropList(boxShadow, other.boxShadow),
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
  final MixProp<ShapeBorder, ShapeBorderDto>? shape;

  factory ShapeDecorationDto({
    ShapeBorderDto? shape,
    Color? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
  }) {
    return ShapeDecorationDto.props(
      shape: MixProp.maybeValue(shape),
      color: Prop.maybeValue(color),
      image: image != null ? MixProp.fromValue(image) : null,
      gradient: gradient != null ? MixProp.fromValue(gradient) : null,
      shadows: shadows
          ?.map(MixProp<BoxShadow, BoxShadowDto>.fromValue)
          .toList(),
    );
  }

  /// Constructor that accepts Prop values directly
  const ShapeDecorationDto.props({
    this.shape,
    required super.color,
    super.image,
    super.gradient,
    List<MixProp<BoxShadow, BoxShadowDto>>? shadows,
  }) : super(boxShadow: shadows);

  /// Constructor that accepts a [ShapeDecoration] value and extracts its properties.
  ///
  /// This is useful for converting existing [ShapeDecoration] instances to [ShapeDecorationDto].
  ///
  /// ```dart
  /// const decoration = ShapeDecoration(color: Colors.red, shape: RoundedRectangleBorder());
  /// final dto = ShapeDecorationDto.value(decoration);
  /// ```
  factory ShapeDecorationDto.value(ShapeDecoration decoration) {
    return ShapeDecorationDto(
      shape: ShapeBorderDto.maybeValue(decoration.shape),

      color: decoration.color,
      image: DecorationImageDto.maybeValue(decoration.image),
      gradient: GradientDto.maybeValue(decoration.gradient),
      shadows: decoration.shadows?.map(BoxShadowDto.value).toList(),
    );
  }

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

  List<MixProp<BoxShadow, BoxShadowDto>>? get shadows => boxShadow;

  @override
  ShapeDecorationDto mergeableDecor(BoxDecorationDto? other) {
    if (other == null) return this;

    assert(
      other.border == null || (other.border?.mixValue?.isUniform ?? true),
      'Border to use with ShapeDecoration must be uniform.',
    );

    final (:boxShadow, :color, :gradient, :image) = other._getBaseDecor();

    // For mergeable operations, we assume rectangle shape if not resolvable
    // This maintains backward compatibility
    final topSide = other.border?.mixValue is BorderDto
        ? (other.border!.mixValue! as BorderDto).top?.mixValue
        : null;
    final shapeBorder = _fromBoxShape(
      shape: BoxShape.rectangle,
      side: topSide != null ? MixProp.fromValue(topSide) : null,
      borderRadius: other.borderRadius,
    );

    return merge(
      ShapeDecorationDto.props(
        shape: MixProp.maybeValue(shapeBorder),
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
  ShapeDecoration resolve(BuildContext context) {
    return ShapeDecoration(
      color: resolveProp(context, color) ?? defaultValue.color,
      image: resolveMixProp(context, image) ?? defaultValue.image,
      gradient: resolveMixProp(context, gradient) ?? defaultValue.gradient,
      shadows:
          shadows?.map((e) => e.resolve(context)).toList() ??
          defaultValue.shadows,
      shape: resolveMixProp(context, shape) ?? defaultValue.shape,
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

    return ShapeDecorationDto.props(
      shape: mergeMixProp(shape, other.shape),
      color: mergeProp(color, other.color),
      image: mergeMixProp(image, other.image),
      gradient: mergeMixProp(gradient, other.gradient),
      shadows: mergeMixPropList(shadows, other.shadows),
    );
  }

  @override
  bool get isMergeable =>
      (shape == null ||
      shape?.mixValue is CircleBorderDto ||
      shape?.mixValue is RoundedRectangleBorderDto);

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
  final (:borderRadius, :boxShape, :side) = ShapeBorderDto.extract(
    dto.shape?.mixValue,
  );

  return BoxDecorationDto.props(
    border: side?.mixValue != null
        ? MixProp.fromValue(BorderDto.all(side!.mixValue!))
        : null,
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
  final topSide = dto.border?.mixValue is BorderDto
      ? (dto.border!.mixValue! as BorderDto).top?.mixValue
      : null;
  final shapeBorder = _fromBoxShape(
    shape: BoxShape.rectangle,
    side: topSide != null ? MixProp.fromValue(topSide) : null,
    borderRadius: dto.borderRadius,
  );

  return ShapeDecorationDto.props(
    shape: shapeBorder != null ? MixProp.fromValue(shapeBorder) : null,
    color: color,
    image: image,
    gradient: gradient,
    shadows: boxShadow,
  );
}

ShapeBorderDto? _fromBoxShape({
  required BoxShape? shape,
  required MixProp<BorderSide, BorderSideDto>? side,
  required MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>? borderRadius,
}) {
  switch (shape) {
    case BoxShape.circle:
      return CircleBorderDto(side: side?.mixValue);
    case BoxShape.rectangle:
      return RoundedRectangleBorderDto(
        borderRadius: borderRadius?.mixValue,
        side: side?.mixValue,
      );
    default:
      if (side?.mixValue != null || borderRadius?.mixValue != null) {
        return RoundedRectangleBorderDto(
          borderRadius: borderRadius?.mixValue,
          side: side?.mixValue,
        );
      }

      return null;
  }
}

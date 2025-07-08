// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

typedef _BaseDecorProperties = ({
  MixProperty<Color> color,
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
  final MixProperty<Color> color;
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
  final BoxShape? shape;
  final BlendMode? backgroundBlendMode;

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
    return BoxDecorationDto.raw(
      border: border,
      borderRadius: borderRadius,
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: MixProperty.prop(color),
      image: image,
      gradient: gradient,
      boxShadow: boxShadow,
    );
  }

  const BoxDecorationDto.raw({
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
      BoxDecorationDto.raw(
        border: side != null ? BorderDto.all(side) : null,
        borderRadius: borderRadius,
        shape: boxShape,
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
      color: color.resolve(mix),
      image: image?.resolve(mix),
      border: border?.resolve(mix),
      borderRadius: borderRadius?.resolve(mix),
      boxShadow: boxShadow?.map((e) => e.resolve(mix)).toList(),
      gradient: gradient?.resolve(mix),
      backgroundBlendMode: backgroundBlendMode,
      shape: shape ?? BoxShape.rectangle,
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

    return BoxDecorationDto.raw(
      border: BoxBorderDto.tryToMerge(border, other.border),
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      shape: other.shape ?? shape,
      backgroundBlendMode: other.backgroundBlendMode ?? backgroundBlendMode,
      color: color.merge(other.color),
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
    return ShapeDecorationDto.raw(
      shape: shape,
      color: MixProperty.prop(color),
      image: image,
      gradient: gradient,
      shadows: shadows,
    );
  }

  const ShapeDecorationDto.raw({
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

    final shapeBorder = _fromBoxShape(
      shape: other.shape,
      side: other.border?.top,
      borderRadius: other.borderRadius,
    );

    return merge(
      ShapeDecorationDto.raw(
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
      color: color.resolve(mix) ?? defaultValue.color,
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

    return ShapeDecorationDto.raw(
      shape: ShapeBorderDto.tryToMerge(shape, other.shape),
      color: color.merge(other.color),
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

  return BoxDecorationDto.raw(
    border: side != null ? BorderDto.all(side) : null,
    borderRadius: borderRadius,
    shape: boxShape,
    color: color,
    image: image,
    gradient: gradient,
    boxShadow: boxShadow,
  );
}

ShapeDecorationDto _toShapeDecorationDto(BoxDecorationDto dto) {
  final (:boxShadow, :color, :gradient, :image) = dto._getBaseDecor();
  final shapeBorder = _fromBoxShape(
    shape: dto.shape,
    side: dto.border?.top,
    borderRadius: dto.borderRadius,
  );

  return ShapeDecorationDto.raw(
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

class DecorationUtility<T extends StyleElement>
    extends MixUtility<T, DecorationDto> {
  const DecorationUtility(super.builder);

  BoxDecorationUtility<T> get box => BoxDecorationUtility(builder);

  ShapeDecorationUtility<T> get shape => ShapeDecorationUtility(builder);
}

/// Utility class for configuring [BoxDecoration] properties.
///
/// This class provides methods to set individual properties of a [BoxDecoration].
/// Use the methods of this class to configure specific properties of a [BoxDecoration].
class BoxDecorationUtility<T extends StyleElement>
    extends DtoUtility<T, BoxDecorationDto, BoxDecoration> {
  /// Utility for defining [BoxDecorationDto.border]
  late final border = BoxBorderUtility((v) => only(border: v));

  /// Utility for defining [BoxDecorationDto.border.directional]
  late final borderDirectional = border.directional;

  /// Utility for defining [BoxDecorationDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [BoxDecorationDto.borderRadius.directional]
  late final borderRadiusDirectional = borderRadius.directional;

  /// Utility for defining [BoxDecorationDto.shape]
  late final shape = BoxShapeUtility((v) => only(shape: v));

  /// Utility for defining [BoxDecorationDto.backgroundBlendMode]
  late final backgroundBlendMode = BlendModeUtility(
    (v) => only(backgroundBlendMode: v),
  );

  /// Utility for defining [BoxDecorationDto.color]
  late final color = ColorUtility((v) => only(color: MixProperty(v)));

  /// Utility for defining [BoxDecorationDto.image]
  late final image = DecorationImageUtility((v) => only(image: v));

  /// Utility for defining [BoxDecorationDto.gradient]
  late final gradient = GradientUtility((v) => only(gradient: v));

  /// Utility for defining [BoxDecorationDto.boxShadow]
  late final boxShadows = BoxShadowListUtility((v) => only(boxShadow: v));

  /// Utility for defining [BoxDecorationDto.boxShadows.add]
  late final boxShadow = boxShadows.add;

  /// Utility for defining [BoxDecorationDto.boxShadow]
  late final elevation = ElevationUtility((v) => only(boxShadow: v));

  BoxDecorationUtility(super.builder)
    : super(
        valueToDto: (v) => throw UnimplementedError(
          'BoxDecoration to DTO conversion not implemented yet. Use only() method instead.',
        ),
      );

  T call({
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
  }) {
    return only(
      border: border != null ? this.border.fromValue(border) : null,
      borderRadius: borderRadius != null
          ? this.borderRadius.fromValue(borderRadius)
          : null,
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: color != null ? MixProperty(Mix.value(color)) : null,
      image: image != null ? this.image.fromValue(image) : null,
      gradient: gradient != null
          ? switch (gradient) {
              LinearGradient() => this.gradient.linear.fromValue(gradient),
              RadialGradient() => this.gradient.radial.fromValue(gradient),
              SweepGradient() => this.gradient.sweep.fromValue(gradient),
              _ => throw ArgumentError(
                'Unsupported gradient type: ${gradient.runtimeType}',
              ),
            }
          : null,
      boxShadow: boxShadow?.map((shadow) => BoxShadowDto.from(shadow)).toList(),
    );
  }

  /// Returns a new [BoxDecorationDto] with the specified properties.
  @override
  T only({
    BoxBorderDto? border,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    MixProperty<Color>? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? boxShadow,
  }) {
    return builder(
      BoxDecorationDto.raw(
        border: border,
        borderRadius: borderRadius,
        shape: shape,
        backgroundBlendMode: backgroundBlendMode,
        color: color ?? const MixProperty(),
        image: image,
        gradient: gradient,
        boxShadow: boxShadow,
      ),
    );
  }
}

/// Utility class for configuring [ShapeDecoration] properties.
///
/// This class provides methods to set individual properties of a [ShapeDecoration].
/// Use the methods of this class to configure specific properties of a [ShapeDecoration].
class ShapeDecorationUtility<T extends StyleElement>
    extends DtoUtility<T, ShapeDecorationDto, ShapeDecoration> {
  /// Utility for defining [ShapeDecorationDto.shape]
  late final shape = ShapeBorderUtility((v) => only(shape: v));

  /// Utility for defining [ShapeDecorationDto.color]
  late final color = ColorUtility((v) => only(color: MixProperty(v)));

  /// Utility for defining [ShapeDecorationDto.image]
  late final image = DecorationImageUtility((v) => only(image: v));

  /// Utility for defining [ShapeDecorationDto.gradient]
  late final gradient = GradientUtility((v) => only(gradient: v));

  /// Utility for defining [ShapeDecorationDto.shadows]
  late final shadows = BoxShadowListUtility((v) => only(shadows: v));

  ShapeDecorationUtility(super.builder)
    : super(
        valueToDto: (v) => throw UnimplementedError(
          'ShapeDecoration to DTO conversion not implemented yet. Use only() method instead.',
        ),
      );

  T call({
    ShapeBorder? shape,
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? shadows,
  }) {
    return only(
      shape: shape != null
          ? switch (shape) {
              RoundedRectangleBorder() => this.shape.roundedRectangle.fromValue(
                shape,
              ),
              BeveledRectangleBorder() => this.shape.beveledRectangle.fromValue(
                shape,
              ),
              ContinuousRectangleBorder() =>
                this.shape.continuousRectangle.fromValue(shape),
              CircleBorder() => this.shape.circle.fromValue(shape),
              StadiumBorder() => this.shape.stadium.fromValue(shape),
              StarBorder() => this.shape.star.fromValue(shape),
              LinearBorder() => this.shape.linear.fromValue(shape),
              _ => throw ArgumentError(
                'Unsupported shape border type: ${shape.runtimeType}',
              ),
            }
          : null,
      color: color != null ? MixProperty(Mix.value(color)) : null,
      image: image != null ? this.image.fromValue(image) : null,
      gradient: gradient != null
          ? switch (gradient) {
              LinearGradient() => this.gradient.linear.fromValue(gradient),
              RadialGradient() => this.gradient.radial.fromValue(gradient),
              SweepGradient() => this.gradient.sweep.fromValue(gradient),
              _ => throw ArgumentError(
                'Unsupported gradient type: ${gradient.runtimeType}',
              ),
            }
          : null,
      shadows: shadows?.map((shadow) => BoxShadowDto.from(shadow)).toList(),
    );
  }

  /// Returns a new [ShapeDecorationDto] with the specified properties.
  @override
  T only({
    ShapeBorderDto? shape,
    MixProperty<Color>? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
  }) {
    return builder(
      ShapeDecorationDto.raw(
        shape: shape,
        color: color ?? const MixProperty(),
        image: image,
        gradient: gradient,
        shadows: shadows,
      ),
    );
  }
}

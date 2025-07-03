// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoration_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [BoxDecorationDto].
mixin _$BoxDecorationDto on Mixable<BoxDecoration> {
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
      border: _$this.border?.resolve(mix),
      borderRadius: _$this.borderRadius?.resolve(mix),
      shape: _$this.shape ?? BoxShape.rectangle,
      backgroundBlendMode: _$this.backgroundBlendMode,
      color: _$this.color?.resolve(mix),
      image: _$this.image?.resolve(mix),
      gradient: _$this.gradient?.resolve(mix),
      boxShadow: _$this.boxShadow?.map((e) => e.resolve(mix)).toList(),
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
    if (other == null) return _$this;

    return BoxDecorationDto(
      border: BoxBorderDto.tryToMerge(_$this.border, other.border),
      borderRadius:
          _$this.borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      shape: other.shape ?? _$this.shape,
      backgroundBlendMode:
          other.backgroundBlendMode ?? _$this.backgroundBlendMode,
      color: _$this.color?.merge(other.color) ?? other.color,
      image: _$this.image?.merge(other.image) ?? other.image,
      gradient: GradientDto.tryToMerge(_$this.gradient, other.gradient),
      boxShadow: MixHelpers.mergeList(_$this.boxShadow, other.boxShadow),
    );
  }

  /// The list of properties that constitute the state of this [BoxDecorationDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxDecorationDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.border,
        _$this.borderRadius,
        _$this.shape,
        _$this.backgroundBlendMode,
        _$this.color,
        _$this.image,
        _$this.gradient,
        _$this.boxShadow,
      ];

  /// Returns this instance as a [BoxDecorationDto].
  BoxDecorationDto get _$this => this as BoxDecorationDto;
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
  late final borderRadius =
      BorderRadiusGeometryUtility((v) => only(borderRadius: v));

  /// Utility for defining [BoxDecorationDto.borderRadius.directional]
  late final borderRadiusDirectional = borderRadius.directional;

  /// Utility for defining [BoxDecorationDto.shape]
  late final shape = BoxShapeUtility((v) => only(shape: v));

  /// Utility for defining [BoxDecorationDto.backgroundBlendMode]
  late final backgroundBlendMode =
      BlendModeUtility((v) => only(backgroundBlendMode: v));

  /// Utility for defining [BoxDecorationDto.color]
  late final color = ColorUtility((v) => only(color: v));

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

  BoxDecorationUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [BoxDecorationDto] with the specified properties.
  @override
  T only({
    BoxBorderDto? border,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    ColorDto? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? boxShadow,
  }) {
    return builder(BoxDecorationDto(
      border: border,
      borderRadius: borderRadius,
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: color,
      image: image,
      gradient: gradient,
      boxShadow: boxShadow,
    ));
  }

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
      border: border?.toDto(),
      borderRadius: borderRadius?.toDto(),
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: color?.toDto(),
      image: image?.toDto(),
      gradient: gradient?.toDto(),
      boxShadow: boxShadow?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert [BoxDecoration] to [BoxDecorationDto].
extension BoxDecorationMixExt on BoxDecoration {
  /// Converts this [BoxDecoration] to a [BoxDecorationDto].
  BoxDecorationDto toDto() {
    return BoxDecorationDto(
      border: border?.toDto(),
      borderRadius: borderRadius?.toDto(),
      shape: shape,
      backgroundBlendMode: backgroundBlendMode,
      color: color?.toDto(),
      image: image?.toDto(),
      gradient: gradient?.toDto(),
      boxShadow: boxShadow?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert List<[BoxDecoration]> to List<[BoxDecorationDto]>.
extension ListBoxDecorationMixExt on List<BoxDecoration> {
  /// Converts this List<[BoxDecoration]> to a List<[BoxDecorationDto]>.
  List<BoxDecorationDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [ShapeDecorationDto].
mixin _$ShapeDecorationDto
    on Mixable<ShapeDecoration>, HasDefaultValue<ShapeDecoration> {
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
      shape: _$this.shape?.resolve(mix) ?? defaultValue.shape,
      color: _$this.color?.resolve(mix) ?? defaultValue.color,
      image: _$this.image?.resolve(mix) ?? defaultValue.image,
      gradient: _$this.gradient?.resolve(mix) ?? defaultValue.gradient,
      shadows: _$this.shadows?.map((e) => e.resolve(mix)).toList() ??
          defaultValue.shadows,
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
    if (other == null) return _$this;

    return ShapeDecorationDto(
      shape: ShapeBorderDto.tryToMerge(_$this.shape, other.shape),
      color: _$this.color?.merge(other.color) ?? other.color,
      image: _$this.image?.merge(other.image) ?? other.image,
      gradient: GradientDto.tryToMerge(_$this.gradient, other.gradient),
      shadows: MixHelpers.mergeList(_$this.shadows, other.shadows),
    );
  }

  /// The list of properties that constitute the state of this [ShapeDecorationDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ShapeDecorationDto] instances for equality.
  @override
  List<Object?> get props => [
        _$this.shape,
        _$this.color,
        _$this.image,
        _$this.gradient,
        _$this.shadows,
      ];

  /// Returns this instance as a [ShapeDecorationDto].
  ShapeDecorationDto get _$this => this as ShapeDecorationDto;
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
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [ShapeDecorationDto.image]
  late final image = DecorationImageUtility((v) => only(image: v));

  /// Utility for defining [ShapeDecorationDto.gradient]
  late final gradient = GradientUtility((v) => only(gradient: v));

  /// Utility for defining [ShapeDecorationDto.shadows]
  late final shadows = BoxShadowListUtility((v) => only(shadows: v));

  ShapeDecorationUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [ShapeDecorationDto] with the specified properties.
  @override
  T only({
    ShapeBorderDto? shape,
    ColorDto? color,
    DecorationImageDto? image,
    GradientDto? gradient,
    List<BoxShadowDto>? shadows,
  }) {
    return builder(ShapeDecorationDto(
      shape: shape,
      color: color,
      image: image,
      gradient: gradient,
      shadows: shadows,
    ));
  }

  T call({
    ShapeBorder? shape,
    Color? color,
    DecorationImage? image,
    Gradient? gradient,
    List<BoxShadow>? shadows,
  }) {
    return only(
      shape: shape?.toDto(),
      color: color?.toDto(),
      image: image?.toDto(),
      gradient: gradient?.toDto(),
      shadows: shadows?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert [ShapeDecoration] to [ShapeDecorationDto].
extension ShapeDecorationMixExt on ShapeDecoration {
  /// Converts this [ShapeDecoration] to a [ShapeDecorationDto].
  ShapeDecorationDto toDto() {
    return ShapeDecorationDto(
      shape: shape.toDto(),
      color: color?.toDto(),
      image: image?.toDto(),
      gradient: gradient?.toDto(),
      shadows: shadows?.map((e) => e.toDto()).toList(),
    );
  }
}

/// Extension methods to convert List<[ShapeDecoration]> to List<[ShapeDecorationDto]>.
extension ListShapeDecorationMixExt on List<ShapeDecoration> {
  /// Converts this List<[ShapeDecoration]> to a List<[ShapeDecorationDto]>.
  List<ShapeDecorationDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

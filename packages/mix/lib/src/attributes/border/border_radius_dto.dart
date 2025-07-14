// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Represents a [Mix] Data transfer object of [BorderRadiusGeometry]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [BorderRadiusGeometry]
///
/// This Dto implements `BorderRadius` and `BorderRadiusDirectional` Flutter classes to allow for
/// better merging support, and cleaner API for the utilities
///
/// See also:
/// - [BorderRadiusGeometry], which is the Flutter counterpart of this class.
@immutable
sealed class BorderRadiusGeometryDto<T extends BorderRadiusGeometry>
    extends Mix<T> {
  const BorderRadiusGeometryDto();

  factory BorderRadiusGeometryDto.value(BorderRadiusGeometry value) {
    return switch (value) {
      BorderRadius() =>
        BorderRadiusDto.value(value) as BorderRadiusGeometryDto<T>,
      BorderRadiusDirectional() =>
        BorderRadiusDirectionalDto.value(value) as BorderRadiusGeometryDto<T>,
      _ => throw ArgumentError(
        'Unsupported BorderRadiusGeometry type: ${value.runtimeType}',
      ),
    };
  }

  static BorderRadiusGeometryDto<T>? maybeValue<T extends BorderRadiusGeometry>(
    T? value,
  ) {
    if (value == null) return null;

    return BorderRadiusGeometryDto.value(value);
  }

  /// Common getters for accessing radius properties
  /// These return null for types that don't support these properties
  Prop<Radius>? get topLeft => null;
  Prop<Radius>? get topRight => null;
  Prop<Radius>? get bottomLeft => null;

  Prop<Radius>? get bottomRight => null;

  @override
  BorderRadiusGeometryDto<T> merge(covariant BorderRadiusGeometryDto<T>? other);
}

final class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius> {
  @override
  final Prop<Radius>? topLeft;

  @override
  final Prop<Radius>? topRight;

  @override
  final Prop<Radius>? bottomLeft;

  @override
  final Prop<Radius>? bottomRight;

  // Main constructor accepts raw values
  factory BorderRadiusDto({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return BorderRadiusDto._(
      topLeft: Prop.maybeValue(topLeft),
      topRight: Prop.maybeValue(topRight),
      bottomLeft: Prop.maybeValue(bottomLeft),
      bottomRight: Prop.maybeValue(bottomRight),
    );
  }

  /// Constructor that accepts a [BorderRadius] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderRadius] instances to [BorderRadiusDto].
  ///
  /// ```dart
  /// const borderRadius = BorderRadius.circular(12.0);
  /// final dto = BorderRadiusDto.value(borderRadius);
  /// ```
  factory BorderRadiusDto.value(BorderRadius borderRadius) {
    return BorderRadiusDto._(
      topLeft: Prop.value(borderRadius.topLeft),
      topRight: Prop.value(borderRadius.topRight),
      bottomLeft: Prop.value(borderRadius.bottomLeft),
      bottomRight: Prop.value(borderRadius.bottomRight),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BorderRadiusDto._({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  /// Constructor that accepts a nullable [BorderRadius] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderRadiusDto.value].
  ///
  /// ```dart
  /// const BorderRadius? borderRadius = BorderRadius.circular(12.0);
  /// final dto = BorderRadiusDto.maybeValue(borderRadius); // Returns BorderRadiusDto or null
  /// ```
  static BorderRadiusDto? maybeValue(BorderRadius? borderRadius) {
    return borderRadius != null ? BorderRadiusDto.value(borderRadius) : null;
  }

  @override
  BorderRadius resolve(MixContext context) {
    return BorderRadius.only(
      topLeft: resolveProp(context, topLeft) ?? Radius.zero,
      topRight: resolveProp(context, topRight) ?? Radius.zero,
      bottomLeft: resolveProp(context, bottomLeft) ?? Radius.zero,
      bottomRight: resolveProp(context, bottomRight) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDto merge(BorderRadiusDto? other) {
    if (other == null) return this;

    return BorderRadiusDto._(
      topLeft: mergeProp(topLeft, other.topLeft),
      topRight: mergeProp(topRight, other.topRight),
      bottomLeft: mergeProp(bottomLeft, other.bottomLeft),
      bottomRight: mergeProp(bottomRight, other.bottomRight),
    );
  }

  @override
  List<Object?> get props => [topLeft, topRight, bottomLeft, bottomRight];
}

final class BorderRadiusDirectionalDto
    extends BorderRadiusGeometryDto<BorderRadiusDirectional> {
  final Prop<Radius>? topStart;
  final Prop<Radius>? topEnd;
  final Prop<Radius>? bottomStart;
  final Prop<Radius>? bottomEnd;

  // Main constructor accepts raw values
  factory BorderRadiusDirectionalDto({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    return BorderRadiusDirectionalDto._(
      topStart: Prop.maybeValue(topStart),
      topEnd: Prop.maybeValue(topEnd),
      bottomStart: Prop.maybeValue(bottomStart),
      bottomEnd: Prop.maybeValue(bottomEnd),
    );
  }

  /// Constructor that accepts a [BorderRadiusDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderRadiusDirectional] instances to [BorderRadiusDirectionalDto].
  ///
  /// ```dart
  /// const borderRadius = BorderRadiusDirectional.circular(12.0);
  /// final dto = BorderRadiusDirectionalDto.value(borderRadius);
  /// ```
  factory BorderRadiusDirectionalDto.value(
    BorderRadiusDirectional borderRadius,
  ) {
    return BorderRadiusDirectionalDto._(
      topStart: Prop.value(borderRadius.topStart),
      topEnd: Prop.value(borderRadius.topEnd),
      bottomStart: Prop.value(borderRadius.bottomStart),
      bottomEnd: Prop.value(borderRadius.bottomEnd),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BorderRadiusDirectionalDto._({
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
  });

  /// Constructor that accepts a nullable [BorderRadiusDirectional] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderRadiusDirectionalDto.value].
  ///
  /// ```dart
  /// const BorderRadiusDirectional? borderRadius = BorderRadiusDirectional.circular(12.0);
  /// final dto = BorderRadiusDirectionalDto.maybeValue(borderRadius); // Returns BorderRadiusDirectionalDto or null
  /// ```
  static BorderRadiusDirectionalDto? maybeValue(
    BorderRadiusDirectional? borderRadius,
  ) {
    return borderRadius != null
        ? BorderRadiusDirectionalDto.value(borderRadius)
        : null;
  }

  @override
  BorderRadiusDirectional resolve(MixContext context) {
    return BorderRadiusDirectional.only(
      topStart: resolveProp(context, topStart) ?? Radius.zero,
      topEnd: resolveProp(context, topEnd) ?? Radius.zero,
      bottomStart: resolveProp(context, bottomStart) ?? Radius.zero,
      bottomEnd: resolveProp(context, bottomEnd) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDirectionalDto merge(BorderRadiusDirectionalDto? other) {
    if (other == null) return this;

    return BorderRadiusDirectionalDto._(
      topStart: mergeProp(topStart, other.topStart),
      topEnd: mergeProp(topEnd, other.topEnd),
      bottomStart: mergeProp(bottomStart, other.bottomStart),
      bottomEnd: mergeProp(bottomEnd, other.bottomEnd),
    );
  }

  @override
  List<Object?> get props => [topStart, topEnd, bottomStart, bottomEnd];

  /// These getters return null for BorderRadiusDirectional as they don't apply
  /// to directional border radius (which uses topStart/topEnd instead of topLeft/topRight)
  @override
  Prop<Radius>? get topLeft => null;
  @override
  Prop<Radius>? get topRight => null;
  @override
  Prop<Radius>? get bottomLeft => null;
  @override
  Prop<Radius>? get bottomRight => null;
}

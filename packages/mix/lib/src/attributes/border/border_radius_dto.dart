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

  /// Will try to merge two border radius geometries, the type will resolve to type of
  /// `b` if its not null and `a` otherwise.
  static BorderRadiusGeometryDto? tryToMerge(
    BorderRadiusGeometryDto? a,
    BorderRadiusGeometryDto? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<
    A extends BorderRadiusGeometryDto,
    B extends BorderRadiusGeometryDto
  >(A a, B b) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (BorderRadiusDto g) => a._asBorderRadius().merge(g) as B,
      (BorderRadiusDirectionalDto g) =>
        a._asBorderRadiusDirectional().merge(g) as B,
    };
  }

  @protected
  BorderRadiusDto _asBorderRadius() {
    if (this is BorderRadiusDto) return this as BorderRadiusDto;

    // For BorderRadiusDirectionalDto converting to BorderRadiusDto
    // topStart -> topLeft, topEnd -> topRight, bottomStart -> bottomLeft, bottomEnd -> bottomRight
    final directional = this as BorderRadiusDirectionalDto;

    return BorderRadiusDto.props(
      topLeft: directional.topStart,
      topRight: directional.topEnd,
      bottomLeft: directional.bottomStart,
      bottomRight: directional.bottomEnd,
    );
  }

  @protected
  BorderRadiusDirectionalDto _asBorderRadiusDirectional() {
    if (this is BorderRadiusDirectionalDto) {
      return this as BorderRadiusDirectionalDto;
    }

    // For BorderRadiusDto converting to BorderRadiusDirectionalDto
    // topLeft -> topStart, topRight -> topEnd, bottomLeft -> bottomStart, bottomRight -> bottomEnd
    return BorderRadiusDirectionalDto.props(
      topStart: topLeft,
      topEnd: topRight,
      bottomStart: bottomLeft,
      bottomEnd: bottomRight,
    );
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
    return BorderRadiusDto.props(
      topLeft: Prop.maybe(topLeft),
      topRight: Prop.maybe(topRight),
      bottomLeft: Prop.maybe(bottomLeft),
      bottomRight: Prop.maybe(bottomRight),
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
    return BorderRadiusDto(
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BorderRadiusDto.props({
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
  BorderRadius resolve(BuildContext context) {
    return BorderRadius.only(
      topLeft: MixHelpers.resolve(context, topLeft) ?? Radius.zero,
      topRight: MixHelpers.resolve(context, topRight) ?? Radius.zero,
      bottomLeft: MixHelpers.resolve(context, bottomLeft) ?? Radius.zero,
      bottomRight: MixHelpers.resolve(context, bottomRight) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDto merge(BorderRadiusDto? other) {
    if (other == null) return this;

    return BorderRadiusDto.props(
      topLeft: MixHelpers.merge(topLeft, other.topLeft),
      topRight: MixHelpers.merge(topRight, other.topRight),
      bottomLeft: MixHelpers.merge(bottomLeft, other.bottomLeft),
      bottomRight: MixHelpers.merge(bottomRight, other.bottomRight),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderRadiusDto &&
        other.topLeft == topLeft &&
        other.topRight == topRight &&
        other.bottomLeft == bottomLeft &&
        other.bottomRight == bottomRight;
  }

  @override
  int get hashCode {
    return topLeft.hashCode ^
        topRight.hashCode ^
        bottomLeft.hashCode ^
        bottomRight.hashCode;
  }
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
    return BorderRadiusDirectionalDto.props(
      topStart: Prop.maybe(topStart),
      topEnd: Prop.maybe(topEnd),
      bottomStart: Prop.maybe(bottomStart),
      bottomEnd: Prop.maybe(bottomEnd),
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
    return BorderRadiusDirectionalDto(
      topStart: borderRadius.topStart,
      topEnd: borderRadius.topEnd,
      bottomStart: borderRadius.bottomStart,
      bottomEnd: borderRadius.bottomEnd,
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BorderRadiusDirectionalDto.props({
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
  BorderRadiusDirectional resolve(BuildContext context) {
    return BorderRadiusDirectional.only(
      topStart: MixHelpers.resolve(context, topStart) ?? Radius.zero,
      topEnd: MixHelpers.resolve(context, topEnd) ?? Radius.zero,
      bottomStart: MixHelpers.resolve(context, bottomStart) ?? Radius.zero,
      bottomEnd: MixHelpers.resolve(context, bottomEnd) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDirectionalDto merge(BorderRadiusDirectionalDto? other) {
    if (other == null) return this;

    return BorderRadiusDirectionalDto.props(
      topStart: MixHelpers.merge(topStart, other.topStart),
      topEnd: MixHelpers.merge(topEnd, other.topEnd),
      bottomStart: MixHelpers.merge(bottomStart, other.bottomStart),
      bottomEnd: MixHelpers.merge(bottomEnd, other.bottomEnd),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderRadiusDirectionalDto &&
        other.topStart == topStart &&
        other.topEnd == topEnd &&
        other.bottomStart == bottomStart &&
        other.bottomEnd == bottomEnd;
  }

  @override
  int get hashCode {
    return topStart.hashCode ^
        topEnd.hashCode ^
        bottomStart.hashCode ^
        bottomEnd.hashCode;
  }

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

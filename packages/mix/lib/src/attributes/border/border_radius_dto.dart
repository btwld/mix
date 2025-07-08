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

  // Factory from BorderRadiusGeometry
  static BorderRadiusGeometryDto from(BorderRadiusGeometry geometry) {
    return switch (geometry) {
      BorderRadius() => BorderRadiusDto.from(geometry),
      BorderRadiusDirectional() => BorderRadiusDirectionalDto.from(geometry),
      _ => throw ArgumentError(
        'Unsupported BorderRadiusGeometry type: ${geometry.runtimeType}',
      ),
    };
  }

  // Nullable factory from BorderRadiusGeometry
  static BorderRadiusGeometryDto? maybeFrom(BorderRadiusGeometry? geometry) {
    return geometry != null ? BorderRadiusGeometryDto.from(geometry) : null;
  }

  /// Common getters for accessing radius properties
  /// These return null for types that don't support these properties
  MixProperty<Radius>? get topLeft => null;
  MixProperty<Radius>? get topRight => null;

  MixProperty<Radius>? get bottomLeft => null;

  MixProperty<Radius>? get bottomRight => null;

  @override
  BorderRadiusGeometryDto<T> merge(covariant BorderRadiusGeometryDto<T>? other);
}

final class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius> {
  @override
  final MixProperty<Radius>? topLeft;

  @override
  final MixProperty<Radius>? topRight;

  @override
  final MixProperty<Radius>? bottomLeft;

  @override
  final MixProperty<Radius>? bottomRight;

  // Main constructor accepts real values
  factory BorderRadiusDto({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return BorderRadiusDto.raw(
      topLeft: MixProperty.prop(topLeft),
      topRight: MixProperty.prop(topRight),
      bottomLeft: MixProperty.prop(bottomLeft),
      bottomRight: MixProperty.prop(bottomRight),
    );
  }

  // Factory that accepts MixableProperty instances
  const BorderRadiusDto.raw({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  // Factory from BorderRadius
  factory BorderRadiusDto.from(BorderRadius radius) {
    return BorderRadiusDto(
      topLeft: radius.topLeft,
      topRight: radius.topRight,
      bottomLeft: radius.bottomLeft,
      bottomRight: radius.bottomRight,
    );
  }

  // Nullable factory from BorderRadius
  static BorderRadiusDto? maybeFrom(BorderRadius? radius) {
    return radius != null ? BorderRadiusDto.from(radius) : null;
  }

  /// Returns the radius value for a given Mixable<Radius>, resolving it with the provided MixContext.
  /// If the radius is null, returns Radius.zero.
  Radius getRadiusValue(MixContext mix, MixProperty<Radius>? radius) {
    return radius?.resolve(mix) ?? Radius.zero;
  }

  @override
  BorderRadius resolve(MixContext mix) {
    return BorderRadius.only(
      topLeft: topLeft?.resolve(mix) ?? Radius.zero,
      topRight: topRight?.resolve(mix) ?? Radius.zero,
      bottomLeft: bottomLeft?.resolve(mix) ?? Radius.zero,
      bottomRight: bottomRight?.resolve(mix) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDto merge(BorderRadiusDto? other) {
    if (other == null) return this;

    return BorderRadiusDto.raw(
      topLeft: topLeft != null && other.topLeft != null
          ? topLeft!.merge(other.topLeft!)
          : (other.topLeft ?? topLeft),
      topRight: topRight != null && other.topRight != null
          ? topRight!.merge(other.topRight!)
          : (other.topRight ?? topRight),
      bottomLeft: bottomLeft != null && other.bottomLeft != null
          ? bottomLeft!.merge(other.bottomLeft!)
          : (other.bottomLeft ?? bottomLeft),
      bottomRight: bottomRight != null && other.bottomRight != null
          ? bottomRight!.merge(other.bottomRight!)
          : (other.bottomRight ?? bottomRight),
    );
  }

  @override
  List<Object?> get props => [topLeft, topRight, bottomLeft, bottomRight];
}

final class BorderRadiusDirectionalDto
    extends BorderRadiusGeometryDto<BorderRadiusDirectional> {
  final MixProperty<Radius>? topStart;

  final MixProperty<Radius>? topEnd;

  final MixProperty<Radius>? bottomStart;

  final MixProperty<Radius>? bottomEnd;

  // Main constructor accepts real values
  factory BorderRadiusDirectionalDto({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    return BorderRadiusDirectionalDto.raw(
      topStart: MixProperty.prop(topStart),
      topEnd: MixProperty.prop(topEnd),
      bottomStart: MixProperty.prop(bottomStart),
      bottomEnd: MixProperty.prop(bottomEnd),
    );
  }

  // Factory that accepts MixableProperty instances
  const BorderRadiusDirectionalDto.raw({
    required this.topStart,
    required this.topEnd,
    required this.bottomStart,
    required this.bottomEnd,
  });

  // Factory from BorderRadiusDirectional
  factory BorderRadiusDirectionalDto.from(BorderRadiusDirectional radius) {
    return BorderRadiusDirectionalDto(
      topStart: radius.topStart,
      topEnd: radius.topEnd,
      bottomStart: radius.bottomStart,
      bottomEnd: radius.bottomEnd,
    );
  }

  // Nullable factory from BorderRadiusDirectional
  static BorderRadiusDirectionalDto? maybeFrom(
    BorderRadiusDirectional? radius,
  ) {
    return radius != null ? BorderRadiusDirectionalDto.from(radius) : null;
  }

  @override
  BorderRadiusDirectional resolve(MixContext mix) {
    return BorderRadiusDirectional.only(
      topStart: topStart?.resolve(mix) ?? Radius.zero,
      topEnd: topEnd?.resolve(mix) ?? Radius.zero,
      bottomStart: bottomStart?.resolve(mix) ?? Radius.zero,
      bottomEnd: bottomEnd?.resolve(mix) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDirectionalDto merge(BorderRadiusDirectionalDto? other) {
    if (other == null) return this;

    return BorderRadiusDirectionalDto.raw(
      topStart: topStart != null && other.topStart != null
          ? topStart!.merge(other.topStart!)
          : (other.topStart ?? topStart),
      topEnd: topEnd != null && other.topEnd != null
          ? topEnd!.merge(other.topEnd!)
          : (other.topEnd ?? topEnd),
      bottomStart: bottomStart != null && other.bottomStart != null
          ? bottomStart!.merge(other.bottomStart!)
          : (other.bottomStart ?? bottomStart),
      bottomEnd: bottomEnd != null && other.bottomEnd != null
          ? bottomEnd!.merge(other.bottomEnd!)
          : (other.bottomEnd ?? bottomEnd),
    );
  }

  @override
  List<Object?> get props => [topStart, topEnd, bottomStart, bottomEnd];

  /// These getters return null for BorderRadiusDirectional as they don't apply
  /// to directional border radius (which uses topStart/topEnd instead of topLeft/topRight)
  @override
  MixProperty<Radius>? get topLeft => null;
  @override
  MixProperty<Radius>? get topRight => null;
  @override
  MixProperty<Radius>? get bottomLeft => null;
  @override
  MixProperty<Radius>? get bottomRight => null;
}

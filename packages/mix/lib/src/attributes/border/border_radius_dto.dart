// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../core/mix_property.dart';

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



  /// Common getters for accessing radius properties
  /// These return null for types that don't support these properties
  MixProp<Radius> get topLeft => const MixProp.empty();
  MixProp<Radius> get topRight => const MixProp.empty();
  MixProp<Radius> get bottomLeft => const MixProp.empty();
  MixProp<Radius> get bottomRight => const MixProp.empty();

  @override
  BorderRadiusGeometryDto<T> merge(covariant BorderRadiusGeometryDto<T>? other);
}

final class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius> {
  @override
  final MixProp<Radius> topLeft;

  @override
  final MixProp<Radius> topRight;

  @override
  final MixProp<Radius> bottomLeft;

  @override
  final MixProp<Radius> bottomRight;

  // Main constructor accepts Mix values
  factory BorderRadiusDto({
    Mix<Radius>? topLeft,
    Mix<Radius>? topRight,
    Mix<Radius>? bottomLeft,
    Mix<Radius>? bottomRight,
  }) {
    return BorderRadiusDto._(
      topLeft: MixProp(topLeft),
      topRight: MixProp(topRight),
      bottomLeft: MixProp(bottomLeft),
      bottomRight: MixProp(bottomRight),
    );
  }

  // Private constructor that accepts MixProp instances
  const BorderRadiusDto._({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });




  @override
  BorderRadius resolve(MixContext mix) {
    return BorderRadius.only(
      topLeft: topLeft.resolve(mix) ?? Radius.zero,
      topRight: topRight.resolve(mix) ?? Radius.zero,
      bottomLeft: bottomLeft.resolve(mix) ?? Radius.zero,
      bottomRight: bottomRight.resolve(mix) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDto merge(BorderRadiusDto? other) {
    if (other == null) return this;

    return BorderRadiusDto._(
      topLeft: topLeft.merge(other.topLeft),
      topRight: topRight.merge(other.topRight),
      bottomLeft: bottomLeft.merge(other.bottomLeft),
      bottomRight: bottomRight.merge(other.bottomRight),
    );
  }

  @override
  List<Object?> get props => [topLeft, topRight, bottomLeft, bottomRight];
}

final class BorderRadiusDirectionalDto
    extends BorderRadiusGeometryDto<BorderRadiusDirectional> {
  final MixProp<Radius> topStart;
  final MixProp<Radius> topEnd;
  final MixProp<Radius> bottomStart;
  final MixProp<Radius> bottomEnd;

  // Main constructor accepts Mix values
  factory BorderRadiusDirectionalDto({
    Mix<Radius>? topStart,
    Mix<Radius>? topEnd,
    Mix<Radius>? bottomStart,
    Mix<Radius>? bottomEnd,
  }) {
    return BorderRadiusDirectionalDto._(
      topStart: MixProp(topStart),
      topEnd: MixProp(topEnd),
      bottomStart: MixProp(bottomStart),
      bottomEnd: MixProp(bottomEnd),
    );
  }

  // Private constructor that accepts MixProp instances
  const BorderRadiusDirectionalDto._({
    required this.topStart,
    required this.topEnd,
    required this.bottomStart,
    required this.bottomEnd,
  });



  @override
  BorderRadiusDirectional resolve(MixContext mix) {
    return BorderRadiusDirectional.only(
      topStart: topStart.resolve(mix) ?? Radius.zero,
      topEnd: topEnd.resolve(mix) ?? Radius.zero,
      bottomStart: bottomStart.resolve(mix) ?? Radius.zero,
      bottomEnd: bottomEnd.resolve(mix) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDirectionalDto merge(BorderRadiusDirectionalDto? other) {
    if (other == null) return this;

    return BorderRadiusDirectionalDto._(
      topStart: topStart.merge(other.topStart),
      topEnd: topEnd.merge(other.topEnd),
      bottomStart: bottomStart.merge(other.bottomStart),
      bottomEnd: bottomEnd.merge(other.bottomEnd),
    );
  }

  @override
  List<Object?> get props => [topStart, topEnd, bottomStart, bottomEnd];

  /// These getters return empty for BorderRadiusDirectional as they don't apply
  /// to directional border radius (which uses topStart/topEnd instead of topLeft/topRight)
  @override
  MixProp<Radius> get topLeft => const MixProp.empty();
  @override
  MixProp<Radius> get topRight => const MixProp.empty();
  @override
  MixProp<Radius> get bottomLeft => const MixProp.empty();
  @override
  MixProp<Radius> get bottomRight => const MixProp.empty();
}

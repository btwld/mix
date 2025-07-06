// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../internal/mix_error.dart';

/// Represents a [Mixable] Data transfer object of [BorderRadiusGeometry]
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
    extends Mixable<T> {
  const BorderRadiusGeometryDto();

  @override
  BorderRadiusGeometryDto<T> merge(covariant BorderRadiusGeometryDto<T>? other);
}

final class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius> {
  final Mixable<Radius>? topLeft;

  final Mixable<Radius>? topRight;

  final Mixable<Radius>? bottomLeft;

  final Mixable<Radius>? bottomRight;

  const BorderRadiusDto({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

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

    return BorderRadiusDto(
      topLeft: other.topLeft ?? topLeft,
      topRight: other.topRight ?? topRight,
      bottomLeft: other.bottomLeft ?? bottomLeft,
      bottomRight: other.bottomRight ?? bottomRight,
    );
  }

  @override
  List<Object?> get props => [
    topLeft,
    topRight,
    bottomLeft,
    bottomRight,
  ];
}

final class BorderRadiusDirectionalDto
    extends BorderRadiusGeometryDto<BorderRadiusDirectional> {
  final Mixable<Radius>? topStart;

  final Mixable<Radius>? topEnd;

  final Mixable<Radius>? bottomStart;

  final Mixable<Radius>? bottomEnd;

  const BorderRadiusDirectionalDto({
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
  });

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

    return BorderRadiusDirectionalDto(
      topStart: other.topStart ?? topStart,
      topEnd: other.topEnd ?? topEnd,
      bottomStart: other.bottomStart ?? bottomStart,
      bottomEnd: other.bottomEnd ?? bottomEnd,
    );
  }

  @override
  List<Object?> get props => [
    topStart,
    topEnd,
    bottomStart,
    bottomEnd,
  ];
}

extension BorderRadiusGeometryMixExt on BorderRadiusGeometry {
  BorderRadiusGeometryDto toDto() {
    final self = this;
    if (self is BorderRadius) {
      return BorderRadiusDto(
        topLeft: Mixable.value(self.topLeft),
        topRight: Mixable.value(self.topRight),
        bottomLeft: Mixable.value(self.bottomLeft),
        bottomRight: Mixable.value(self.bottomRight),
      );
    }
    if (self is BorderRadiusDirectional) {
      return BorderRadiusDirectionalDto(
        topStart: Mixable.value(self.topStart),
        topEnd: Mixable.value(self.topEnd),
        bottomStart: Mixable.value(self.bottomStart),
        bottomEnd: Mixable.value(self.bottomEnd),
      );
    }

    throw MixError.unsupportedTypeInDto(BorderRadiusGeometry, [
      'BorderRadius',
      'BorderRadiusDirectional',
    ]);
  }
}

extension BorderRadiusMixExt on BorderRadius {
  BorderRadiusDto toDto() {
    return BorderRadiusDto(
      topLeft: Mixable.value(topLeft),
      topRight: Mixable.value(topRight),
      bottomLeft: Mixable.value(bottomLeft),
      bottomRight: Mixable.value(bottomRight),
    );
  }
}

extension ListBorderRadiusMixExt on List<BorderRadius> {
  List<BorderRadiusDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

extension BorderRadiusDirectionalMixExt on BorderRadiusDirectional {
  BorderRadiusDirectionalDto toDto() {
    return BorderRadiusDirectionalDto(
      topStart: Mixable.value(topStart),
      topEnd: Mixable.value(topEnd),
      bottomStart: Mixable.value(bottomStart),
      bottomEnd: Mixable.value(bottomEnd),
    );
  }
}

extension ListBorderRadiusDirectionalMixExt on List<BorderRadiusDirectional> {
  List<BorderRadiusDirectionalDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

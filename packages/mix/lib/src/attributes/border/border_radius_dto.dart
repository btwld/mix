// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../internal/mix_error.dart';
import '../scalars/radius_dto.dart';

part 'border_radius_dto.g.dart';

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
    extends Mixable<T> with Diagnosticable {
  const BorderRadiusGeometryDto();

  @override
  BorderRadiusGeometryDto<T> merge(covariant BorderRadiusGeometryDto<T>? other);
}

@MixableType(components: GeneratedPropertyComponents.skipUtility)
final class BorderRadiusDto extends BorderRadiusGeometryDto<BorderRadius>
    with _$BorderRadiusDto {
  final RadiusDto? topLeft;

  final RadiusDto? topRight;

  final RadiusDto? bottomLeft;

  final RadiusDto? bottomRight;

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
}

@MixableType(components: GeneratedPropertyComponents.skipUtility)
final class BorderRadiusDirectionalDto
    extends BorderRadiusGeometryDto<BorderRadiusDirectional>
    with _$BorderRadiusDirectionalDto {
  final RadiusDto? topStart;

  final RadiusDto? topEnd;

  final RadiusDto? bottomStart;

  final RadiusDto? bottomEnd;

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
}

extension BorderRadiusGeometryMixExt on BorderRadiusGeometry {
  BorderRadiusGeometryDto toDto() {
    final self = this;
    if (self is BorderRadius) {
      return BorderRadiusDto(
        topLeft: self.topLeft.toDto(),
        topRight: self.topRight.toDto(),
        bottomLeft: self.bottomLeft.toDto(),
        bottomRight: self.bottomRight.toDto(),
      );
    }
    if (self is BorderRadiusDirectional) {
      return BorderRadiusDirectionalDto(
        topStart: self.topStart.toDto(),
        topEnd: self.topEnd.toDto(),
        bottomStart: self.bottomStart.toDto(),
        bottomEnd: self.bottomEnd.toDto(),
      );
    }

    throw MixError.unsupportedTypeInDto(
      BorderRadiusGeometry,
      ['BorderRadius', 'BorderRadiusDirectional'],
    );
  }
}

/// Extension methods to convert [BorderRadius] to [BorderRadiusDto].
extension BorderRadiusMixExt on BorderRadius {
  /// Converts this [BorderRadius] to a [BorderRadiusDto].
  BorderRadiusDto toDto() {
    return BorderRadiusDto(
      topLeft: topLeft.toDto(),
      topRight: topRight.toDto(),
      bottomLeft: bottomLeft.toDto(),
      bottomRight: bottomRight.toDto(),
    );
  }
}

/// Extension methods to convert [BorderRadiusDirectional] to [BorderRadiusDirectionalDto].
extension BorderRadiusDirectionalMixExt on BorderRadiusDirectional {
  /// Converts this [BorderRadiusDirectional] to a [BorderRadiusDirectionalDto].
  BorderRadiusDirectionalDto toDto() {
    return BorderRadiusDirectionalDto(
      topStart: topStart.toDto(),
      topEnd: topEnd.toDto(),
      bottomStart: bottomStart.toDto(),
      bottomEnd: bottomEnd.toDto(),
    );
  }
}

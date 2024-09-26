// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'shape_border_dto.g.dart';

@immutable
sealed class ShapeBorderDto<T extends ShapeBorder> extends Dto<T> {
  const ShapeBorderDto();

  static ShapeBorderDto? tryToMerge(ShapeBorderDto? a, ShapeBorderDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    if (b is! OutlinedBorderDto || a is! OutlinedBorderDto) {
      // Not merge anything besides OutlinedBorderDto
      return b;
    }

    return OutlinedBorderDto.tryToMerge(a, b);
  }

  static ({
    BorderSideDto? side,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? boxShape,
  }) extract(ShapeBorderDto? dto) {
    return dto is OutlinedBorderDto
        ? (
            side: dto.side,
            borderRadius: dto.borderRadiusGetter,
            boxShape: dto._toBoxShape(),
          )
        : (side: null, borderRadius: null, boxShape: null);
  }

  @override
  ShapeBorderDto<T> merge(covariant ShapeBorderDto<T>? other);

  @override
  T resolve(MixData mix);
}

@immutable
abstract class OutlinedBorderDto<T extends OutlinedBorder>
    extends ShapeBorderDto<T> {
  final BorderSideDto? side;

  const OutlinedBorderDto({this.side});

  static OutlinedBorderDto? tryToMerge(
    OutlinedBorderDto? a,
    OutlinedBorderDto? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<A extends OutlinedBorderDto,
      B extends OutlinedBorderDto>(A a, B b) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    final adaptedA = b.adapt(a) as B;

    return adaptedA.merge(b) as B;
  }

  BoxShape? _toBoxShape() {
    if (this is CircleBorderDto) {
      return BoxShape.circle;
    } else if (this is RoundedRectangleBorderDto) {
      return BoxShape.rectangle;
    }

    return null;
  }

  @protected
  BorderRadiusGeometryDto? get borderRadiusGetter;

  OutlinedBorderDto<T> adapt(OutlinedBorderDto other);

  @override
  OutlinedBorderDto<T> merge(covariant OutlinedBorderDto<T>? other);

  @override
  T resolve(MixData mix);
}

@MixableDto()
final class RoundedRectangleBorderDto
    extends OutlinedBorderDto<RoundedRectangleBorder>
    with _$RoundedRectangleBorderDto {
  @MixableProperty(dto: MixableFieldDto(type: BorderRadiusGeometryDto))
  final BorderRadiusGeometryDto? borderRadius;

  const RoundedRectangleBorderDto({this.borderRadius, super.side});

  @override
  RoundedRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is RoundedRectangleBorderDto) return other;

    return RoundedRectangleBorderDto(
      borderRadius: other.borderRadiusGetter,
      side: other.side,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => borderRadius;

  @override
  RoundedRectangleBorder get defaultValue => const RoundedRectangleBorder();
}

@MixableDto()
final class BeveledRectangleBorderDto
    extends OutlinedBorderDto<BeveledRectangleBorder>
    with _$BeveledRectangleBorderDto {
  final BorderRadiusGeometryDto? borderRadius;

  const BeveledRectangleBorderDto({this.borderRadius, super.side});

  @override
  BeveledRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is BeveledRectangleBorderDto) return other;

    return BeveledRectangleBorderDto(
      borderRadius: other.borderRadiusGetter,
      side: other.side,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => borderRadius;

  @override
  BeveledRectangleBorder get defaultValue => const BeveledRectangleBorder();
}

@MixableDto()
final class ContinuousRectangleBorderDto
    extends OutlinedBorderDto<ContinuousRectangleBorder>
    with _$ContinuousRectangleBorderDto {
  final BorderRadiusGeometryDto? borderRadius;

  const ContinuousRectangleBorderDto({this.borderRadius, super.side});

  @override
  ContinuousRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is ContinuousRectangleBorderDto) {
      return other;
    }

    return ContinuousRectangleBorderDto(
      borderRadius: other.borderRadiusGetter,
      side: other.side,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => borderRadius;
  @override
  ContinuousRectangleBorder get defaultValue =>
      const ContinuousRectangleBorder();
}

@MixableDto()
final class CircleBorderDto extends OutlinedBorderDto<CircleBorder>
    with _$CircleBorderDto {
  final double? eccentricity;

  const CircleBorderDto({super.side, this.eccentricity});

  @override
  CircleBorderDto adapt(OutlinedBorderDto other) {
    if (other is CircleBorderDto) {
      return other;
    }

    return CircleBorderDto(side: other.side);
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;
  @override
  CircleBorder get defaultValue => const CircleBorder();
}

@MixableDto()
final class StarBorderDto extends OutlinedBorderDto<StarBorder>
    with _$StarBorderDto {
  final double? points;
  final double? innerRadiusRatio;
  final double? pointRounding;
  final double? valleyRounding;
  final double? rotation;
  final double? squash;

  const StarBorderDto({
    super.side,
    this.points,
    this.innerRadiusRatio,
    this.pointRounding,
    this.valleyRounding,
    this.rotation,
    this.squash,
  });

  @override
  StarBorderDto adapt(OutlinedBorderDto other) {
    return StarBorderDto(side: other.side);
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;
  @override
  StarBorder get defaultValue => const StarBorder();
}

@MixableDto()
final class LinearBorderDto extends OutlinedBorderDto<LinearBorder>
    with _$LinearBorderDto {
  final LinearBorderEdgeDto? start;
  final LinearBorderEdgeDto? end;
  final LinearBorderEdgeDto? top;
  final LinearBorderEdgeDto? bottom;

  const LinearBorderDto({
    super.side,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  @override
  LinearBorderDto adapt(OutlinedBorderDto other) {
    if (other is LinearBorderDto) {
      return other;
    }

    return LinearBorderDto(side: other.side);
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;
  @override
  LinearBorder get defaultValue => const LinearBorder();
}

@MixableDto()
final class LinearBorderEdgeDto extends Dto<LinearBorderEdge>
    with _$LinearBorderEdgeDto {
  final double? size;
  final double? alignment;

  const LinearBorderEdgeDto({this.size, this.alignment});

  @override
  LinearBorderEdge get defaultValue => const LinearBorderEdge();
}

@MixableDto()
final class StadiumBorderDto extends OutlinedBorderDto<StadiumBorder>
    with _$StadiumBorderDto {
  const StadiumBorderDto({super.side});

  @override
  StadiumBorderDto adapt(OutlinedBorderDto other) {
    if (other is StadiumBorderDto) {
      return other;
    }

    return StadiumBorderDto(side: other.side);
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;
  @override
  StadiumBorder get defaultValue => const StadiumBorder();
}

abstract class MixOutlinedBorder<T extends OutlinedBorderDto>
    extends OutlinedBorder {
  const MixOutlinedBorder({super.side = BorderSide.none});
  T toDto();
}

extension ShapeBorderExt on ShapeBorder {
  ShapeBorderDto toDto() {
    final self = this;
    if (self is BeveledRectangleBorder) return (self).toDto();
    if (self is CircleBorder) return (self).toDto();
    if (self is ContinuousRectangleBorder) return (self).toDto();
    if (self is LinearBorder) return (self).toDto();
    if (self is RoundedRectangleBorder) return (self).toDto();
    if (self is StadiumBorder) return (self).toDto();
    if (self is StarBorder) return (self).toDto();
    if (self is MixOutlinedBorder) return (self).toDto();

    throw ArgumentError.value(
      this,
      'shapeBorder',
      'Unsupported ShapeBorder type.\n'
          'If you are trying to create a custom ShapeBorder, it must extend MixOutlinedBorder.'
          ' Otherwise, use a built-in Mix shape.\n'
          'Custom ShapeBorders that do not extend MixOutlinedBorder will not work with Mix.',
    );
  }
}

class ShapeBorderUtility<T extends Attribute>
    extends MixUtility<T, ShapeBorderDto> {
  late final beveledRectangle = BeveledRectangleBorderUtility(builder);

  late final circle = CircleBorderUtility(builder);

  late final continuousRectangle = ContinuousRectangleBorderUtility(builder);

  late final linear = LinearBorderUtility(builder);

  late final roundedRectangle = RoundedRectangleBorderUtility(builder);

  late final stadium = StadiumBorderUtility(builder);

  late final star = StarBorderUtility(builder);

  late final shapeBuilder = builder;

  ShapeBorderUtility(super.builder);
}

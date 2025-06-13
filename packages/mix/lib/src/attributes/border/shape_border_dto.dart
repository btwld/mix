// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'shape_border_dto.g.dart';

@immutable
sealed class ShapeBorderDto<T extends ShapeBorder> extends Mixable<T> {
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
}

@MixableType()
final class RoundedRectangleBorderDto
    extends OutlinedBorderDto<RoundedRectangleBorder>
    with _$RoundedRectangleBorderDto {
  @MixableField(dto: MixableFieldType(type: BorderRadiusGeometryDto))
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
}

@MixableType()
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
}

@MixableType()
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
}

@MixableType()
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
}

@MixableType()
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
}

@MixableType()
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
}

@MixableType()
final class LinearBorderEdgeDto extends Mixable<LinearBorderEdge>
    with _$LinearBorderEdgeDto {
  final double? size;
  final double? alignment;

  const LinearBorderEdgeDto({this.size, this.alignment});
}

@MixableType()
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

    throw FlutterError.fromParts([
      ErrorSummary('Unsupported ShapeBorder type.'),
      ErrorDescription(
        'If you are trying to create a custom ShapeBorder, it must extend MixOutlinedBorder. '
        'Otherwise, use a built-in Mix shape such as BeveledRectangleBorder, CircleBorder, '
        'ContinuousRectangleBorder, LinearBorder, RoundedRectangleBorder, StadiumBorder, or StarBorder.',
      ),
      ErrorHint(
        'Custom ShapeBorders that do not extend MixOutlinedBorder will not work with Mix.',
      ),
      DiagnosticsProperty<ShapeBorder>('The unsupported ShapeBorder was', this),
    ]);
  }
}

class ShapeBorderUtility<T extends StyleElement>
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

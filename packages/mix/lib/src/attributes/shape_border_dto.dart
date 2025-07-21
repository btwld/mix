// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// A Data transfer object that represents a [ShapeBorder] value.
@immutable
sealed class ShapeBorderDto<T extends ShapeBorder> extends Mix<T> {
  const ShapeBorderDto();

  /// Constructor that accepts a [ShapeBorder] value and converts it to the appropriate DTO.
  static ShapeBorderDto value(ShapeBorder border) {
    return switch (border) {
      RoundedRectangleBorder b => RoundedRectangleBorderDto.value(b),
      BeveledRectangleBorder b => BeveledRectangleBorderDto.value(b),
      ContinuousRectangleBorder b => ContinuousRectangleBorderDto.value(b),
      CircleBorder b => CircleBorderDto.value(b),
      StarBorder b => StarBorderDto.value(b),
      LinearBorder b => LinearBorderDto.value(b),
      StadiumBorder b => StadiumBorderDto.value(b),
      _ => throw ArgumentError(
        'Unsupported ShapeBorder type: ${border.runtimeType}',
      ),
    };
  }

  /// Constructor that accepts a nullable [ShapeBorder] value and converts it to the appropriate DTO.
  static ShapeBorderDto? maybeValue(ShapeBorder? border) {
    return border != null ? ShapeBorderDto.value(border) : null;
  }

  /// Merges with another shape border of the same type.
  /// This method is implemented by subclasses to handle type-specific merging.
  @protected
  ShapeBorderDto<T> mergeShapeBorder(covariant ShapeBorderDto<T> other);

  /// Merges two ShapeBorderDto instances.
  ///
  /// If both are the same type, delegates to [mergeShapeBorder].
  /// If different types, returns [other] (override behavior).
  /// If [other] is null, returns this instance.
  @override
  ShapeBorderDto<T> merge(covariant ShapeBorderDto<T>? other) {
    if (other == null) return this;

    // Use pattern matching for type-safe merging
    return switch ((this, other)) {
          (RoundedRectangleBorderDto a, RoundedRectangleBorderDto b) =>
            a.mergeShapeBorder(b),
          (BeveledRectangleBorderDto a, BeveledRectangleBorderDto b) =>
            a.mergeShapeBorder(b),
          (ContinuousRectangleBorderDto a, ContinuousRectangleBorderDto b) =>
            a.mergeShapeBorder(b),
          (CircleBorderDto a, CircleBorderDto b) => a.mergeShapeBorder(b),
          (StarBorderDto a, StarBorderDto b) => a.mergeShapeBorder(b),
          (LinearBorderDto a, LinearBorderDto b) => a.mergeShapeBorder(b),
          (StadiumBorderDto a, StadiumBorderDto b) => a.mergeShapeBorder(b),
          _ => other, // Different types: override with other
        }
        as ShapeBorderDto<T>;
  }
}

/// Base class for borders that extend OutlinedBorder and have a side property.
@immutable
abstract class OutlinedBorderDto<T extends OutlinedBorder>
    extends ShapeBorderDto<T> {
  final MixProp<BorderSide>? side;

  const OutlinedBorderDto({this.side});
}

final class RoundedRectangleBorderDto
    extends OutlinedBorderDto<RoundedRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? borderRadius;

  RoundedRectangleBorderDto.only({
    BorderRadiusGeometryDto? borderRadius,
    BorderSideDto? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );
  const RoundedRectangleBorderDto({this.borderRadius, super.side});

  RoundedRectangleBorderDto.value(RoundedRectangleBorder border)
    : this.only(
        borderRadius: BorderRadiusGeometryDto.value(border.borderRadius),
        side: BorderSideDto.maybeValue(border.side),
      );

  static RoundedRectangleBorderDto? maybeValue(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderDto.value(border) : null;
  }

  @override
  RoundedRectangleBorder resolve(BuildContext context) {
    return RoundedRectangleBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedRectangleBorderDto mergeShapeBorder(RoundedRectangleBorderDto other) {
    return RoundedRectangleBorderDto(
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      side: MixHelpers.merge(side, other.side),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoundedRectangleBorderDto &&
        other.borderRadius == borderRadius &&
        other.side == side;
  }

  @override
  int get hashCode => borderRadius.hashCode ^ side.hashCode;
}

final class BeveledRectangleBorderDto
    extends OutlinedBorderDto<BeveledRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? borderRadius;

  BeveledRectangleBorderDto.only({
    BorderRadiusGeometryDto? borderRadius,
    BorderSideDto? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const BeveledRectangleBorderDto({this.borderRadius, super.side});

  BeveledRectangleBorderDto.value(BeveledRectangleBorder border)
    : this.only(
        borderRadius: BorderRadiusGeometryDto.value(border.borderRadius),
        side: BorderSideDto.maybeValue(border.side),
      );

  static BeveledRectangleBorderDto? maybeValue(BeveledRectangleBorder? border) {
    return border != null ? BeveledRectangleBorderDto.value(border) : null;
  }

  @override
  BeveledRectangleBorder resolve(BuildContext context) {
    return BeveledRectangleBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  BeveledRectangleBorderDto mergeShapeBorder(BeveledRectangleBorderDto other) {
    return BeveledRectangleBorderDto(
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      side: MixHelpers.merge(side, other.side),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BeveledRectangleBorderDto &&
        other.borderRadius == borderRadius &&
        other.side == side;
  }

  @override
  int get hashCode => borderRadius.hashCode ^ side.hashCode;
}

final class ContinuousRectangleBorderDto
    extends OutlinedBorderDto<ContinuousRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? borderRadius;

  ContinuousRectangleBorderDto.only({
    BorderRadiusGeometryDto? borderRadius,
    BorderSideDto? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const ContinuousRectangleBorderDto({this.borderRadius, super.side});

  ContinuousRectangleBorderDto.value(ContinuousRectangleBorder border)
    : this.only(
        borderRadius: BorderRadiusGeometryDto.value(border.borderRadius),
        side: BorderSideDto.maybeValue(border.side),
      );

  static ContinuousRectangleBorderDto? maybeValue(
    ContinuousRectangleBorder? border,
  ) {
    return border != null ? ContinuousRectangleBorderDto.value(border) : null;
  }

  @override
  ContinuousRectangleBorder resolve(BuildContext context) {
    return ContinuousRectangleBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  ContinuousRectangleBorderDto mergeShapeBorder(
    ContinuousRectangleBorderDto other,
  ) {
    return ContinuousRectangleBorderDto(
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      side: MixHelpers.merge(side, other.side),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContinuousRectangleBorderDto &&
        other.borderRadius == borderRadius &&
        other.side == side;
  }

  @override
  int get hashCode => borderRadius.hashCode ^ side.hashCode;
}

final class CircleBorderDto extends OutlinedBorderDto<CircleBorder> {
  final Prop<double>? eccentricity;

  CircleBorderDto.only({BorderSideDto? side, double? eccentricity})
    : this(side: MixProp.maybe(side), eccentricity: Prop.maybe(eccentricity));

  const CircleBorderDto({super.side, this.eccentricity});

  CircleBorderDto.value(CircleBorder border)
    : this.only(
        side: BorderSideDto.maybeValue(border.side),
        eccentricity: border.eccentricity,
      );

  static CircleBorderDto? maybeValue(CircleBorder? border) {
    return border != null ? CircleBorderDto.value(border) : null;
  }

  @override
  CircleBorder resolve(BuildContext context) {
    return CircleBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      eccentricity: MixHelpers.resolve(context, eccentricity) ?? 0.0,
    );
  }

  @override
  CircleBorderDto mergeShapeBorder(CircleBorderDto other) {
    return CircleBorderDto(
      side: MixHelpers.merge(side, other.side),
      eccentricity: MixHelpers.merge(eccentricity, other.eccentricity),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircleBorderDto &&
        other.side == side &&
        other.eccentricity == eccentricity;
  }

  @override
  int get hashCode => side.hashCode ^ eccentricity.hashCode;
}

final class StarBorderDto extends OutlinedBorderDto<StarBorder> {
  final Prop<double>? points;
  final Prop<double>? innerRadiusRatio;
  final Prop<double>? pointRounding;
  final Prop<double>? valleyRounding;
  final Prop<double>? rotation;
  final Prop<double>? squash;

  StarBorderDto.only({
    BorderSideDto? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) : this(
         side: MixProp.maybe(side),
         points: Prop.maybe(points),
         innerRadiusRatio: Prop.maybe(innerRadiusRatio),
         pointRounding: Prop.maybe(pointRounding),
         valleyRounding: Prop.maybe(valleyRounding),
         rotation: Prop.maybe(rotation),
         squash: Prop.maybe(squash),
       );

  StarBorderDto.value(StarBorder border)
    : this.only(
        side: BorderSideDto.maybeValue(border.side),
        points: border.points,
        innerRadiusRatio: border.innerRadiusRatio,
        pointRounding: border.pointRounding,
        valleyRounding: border.valleyRounding,
        rotation: border.rotation,
        squash: border.squash,
      );

  const StarBorderDto({
    super.side,
    this.points,
    this.innerRadiusRatio,
    this.pointRounding,
    this.valleyRounding,
    this.rotation,
    this.squash,
  });

  static StarBorderDto? maybeValue(StarBorder? border) {
    return border != null ? StarBorderDto.value(border) : null;
  }

  @override
  StarBorder resolve(BuildContext context) {
    return StarBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      points: MixHelpers.resolve(context, points) ?? 5,
      innerRadiusRatio: MixHelpers.resolve(context, innerRadiusRatio) ?? 0.4,
      pointRounding: MixHelpers.resolve(context, pointRounding) ?? 0,
      valleyRounding: MixHelpers.resolve(context, valleyRounding) ?? 0,
      rotation: MixHelpers.resolve(context, rotation) ?? 0,
      squash: MixHelpers.resolve(context, squash) ?? 0,
    );
  }

  @override
  StarBorderDto mergeShapeBorder(StarBorderDto other) {
    return StarBorderDto(
      side: MixHelpers.merge(side, other.side),
      points: MixHelpers.merge(points, other.points),
      innerRadiusRatio: MixHelpers.merge(
        innerRadiusRatio,
        other.innerRadiusRatio,
      ),
      pointRounding: MixHelpers.merge(pointRounding, other.pointRounding),
      valleyRounding: MixHelpers.merge(valleyRounding, other.valleyRounding),
      rotation: MixHelpers.merge(rotation, other.rotation),
      squash: MixHelpers.merge(squash, other.squash),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StarBorderDto &&
        other.side == side &&
        other.points == points &&
        other.innerRadiusRatio == innerRadiusRatio &&
        other.pointRounding == pointRounding &&
        other.valleyRounding == valleyRounding &&
        other.rotation == rotation &&
        other.squash == squash;
  }

  @override
  int get hashCode {
    return side.hashCode ^
        points.hashCode ^
        innerRadiusRatio.hashCode ^
        pointRounding.hashCode ^
        valleyRounding.hashCode ^
        rotation.hashCode ^
        squash.hashCode;
  }
}

final class LinearBorderDto extends OutlinedBorderDto<LinearBorder> {
  final MixProp<LinearBorderEdge>? start;
  final MixProp<LinearBorderEdge>? end;
  final MixProp<LinearBorderEdge>? top;
  final MixProp<LinearBorderEdge>? bottom;

  LinearBorderDto.only({
    BorderSideDto? side,
    LinearBorderEdgeDto? start,
    LinearBorderEdgeDto? end,
    LinearBorderEdgeDto? top,
    LinearBorderEdgeDto? bottom,
  }) : this(
         side: MixProp.maybe(side),
         start: MixProp.maybe(start),
         end: MixProp.maybe(end),
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
       );
  const LinearBorderDto({
    super.side,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  LinearBorderDto.value(LinearBorder border)
    : this.only(
        side: BorderSideDto.maybeValue(border.side),
        start: LinearBorderEdgeDto.maybeValue(border.start),
        end: LinearBorderEdgeDto.maybeValue(border.end),
        top: LinearBorderEdgeDto.maybeValue(border.top),
        bottom: LinearBorderEdgeDto.maybeValue(border.bottom),
      );

  static LinearBorderDto? maybeValue(LinearBorder? border) {
    return border != null ? LinearBorderDto.value(border) : null;
  }

  @override
  LinearBorder resolve(BuildContext context) {
    return LinearBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      start: MixHelpers.resolve(context, start),
      end: MixHelpers.resolve(context, end),
      top: MixHelpers.resolve(context, top),
      bottom: MixHelpers.resolve(context, bottom),
    );
  }

  @override
  LinearBorderDto mergeShapeBorder(LinearBorderDto other) {
    return LinearBorderDto(
      side: MixHelpers.merge(side, other.side),
      start: MixHelpers.merge(start, other.start),
      end: MixHelpers.merge(end, other.end),
      top: MixHelpers.merge(top, other.top),
      bottom: MixHelpers.merge(bottom, other.bottom),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinearBorderDto &&
        other.side == side &&
        other.start == start &&
        other.end == end &&
        other.top == top &&
        other.bottom == bottom;
  }

  @override
  int get hashCode {
    return side.hashCode ^
        start.hashCode ^
        end.hashCode ^
        top.hashCode ^
        bottom.hashCode;
  }
}

final class LinearBorderEdgeDto extends Mix<LinearBorderEdge> {
  final Prop<double>? size;
  final Prop<double>? alignment;

  LinearBorderEdgeDto.only({double? size, double? alignment})
    : this(size: Prop.maybe(size), alignment: Prop.maybe(alignment));
  LinearBorderEdgeDto.value(LinearBorderEdge edge)
    : this.only(size: edge.size, alignment: edge.alignment);
  const LinearBorderEdgeDto({this.size, this.alignment});

  static LinearBorderEdgeDto? maybeValue(LinearBorderEdge? edge) {
    return edge != null ? LinearBorderEdgeDto.value(edge) : null;
  }

  @override
  LinearBorderEdge resolve(BuildContext context) {
    return LinearBorderEdge(
      size: MixHelpers.resolve(context, size) ?? 1.0,
      alignment: MixHelpers.resolve(context, alignment) ?? 0.0,
    );
  }

  @override
  LinearBorderEdgeDto merge(LinearBorderEdgeDto? other) {
    if (other == null) return this;

    return LinearBorderEdgeDto(
      size: MixHelpers.merge(size, other.size),
      alignment: MixHelpers.merge(alignment, other.alignment),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinearBorderEdgeDto &&
        other.size == size &&
        other.alignment == alignment;
  }

  @override
  int get hashCode => size.hashCode ^ alignment.hashCode;
}

final class StadiumBorderDto extends OutlinedBorderDto<StadiumBorder> {
  StadiumBorderDto.only({BorderSideDto? side})
    : this(side: MixProp.maybe(side));

  const StadiumBorderDto({super.side});

  StadiumBorderDto.value(StadiumBorder border)
    : this.only(side: BorderSideDto.maybeValue(border.side));

  static StadiumBorderDto? maybeValue(StadiumBorder? border) {
    return border != null ? StadiumBorderDto.value(border) : null;
  }

  @override
  StadiumBorder resolve(BuildContext context) {
    return StadiumBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
    );
  }

  @override
  StadiumBorderDto mergeShapeBorder(StadiumBorderDto other) {
    return StadiumBorderDto(side: MixHelpers.merge(side, other.side));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StadiumBorderDto && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;
}

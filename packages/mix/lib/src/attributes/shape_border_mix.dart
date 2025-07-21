// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// A Data transfer object that represents a [ShapeBorder] value.
@immutable
sealed class ShapeBorderMix<T extends ShapeBorder> extends Mix<T> {
  const ShapeBorderMix();

  /// Constructor that accepts a [ShapeBorder] value and converts it to the appropriate DTO.
  static ShapeBorderMix value(ShapeBorder border) {
    return switch (border) {
      RoundedRectangleBorder b => RoundedRectangleBorderMix.value(b),
      BeveledRectangleBorder b => BeveledRectangleBorderMix.value(b),
      ContinuousRectangleBorder b => ContinuousRectangleBorderMix.value(b),
      CircleBorder b => CircleBorderMix.value(b),
      StarBorder b => StarBorderMix.value(b),
      LinearBorder b => LinearBorderMix.value(b),
      StadiumBorder b => StadiumBorderMix.value(b),
      _ => throw ArgumentError(
        'Unsupported ShapeBorder type: ${border.runtimeType}',
      ),
    };
  }

  /// Constructor that accepts a nullable [ShapeBorder] value and converts it to the appropriate DTO.
  static ShapeBorderMix? maybeValue(ShapeBorder? border) {
    return border != null ? ShapeBorderMix.value(border) : null;
  }

  /// Merges with another shape border of the same type.
  /// This method is implemented by subclasses to handle type-specific merging.
  @protected
  ShapeBorderMix<T> mergeShapeBorder(covariant ShapeBorderMix<T> other);

  /// Merges two ShapeBorderMix instances.
  ///
  /// If both are the same type, delegates to [mergeShapeBorder].
  /// If different types, returns [other] (override behavior).
  /// If [other] is null, returns this instance.
  @override
  ShapeBorderMix<T> merge(covariant ShapeBorderMix<T>? other) {
    if (other == null) return this;

    // Use pattern matching for type-safe merging
    return switch ((this, other)) {
          (RoundedRectangleBorderMix a, RoundedRectangleBorderMix b) =>
            a.mergeShapeBorder(b),
          (BeveledRectangleBorderMix a, BeveledRectangleBorderMix b) =>
            a.mergeShapeBorder(b),
          (ContinuousRectangleBorderMix a, ContinuousRectangleBorderMix b) =>
            a.mergeShapeBorder(b),
          (CircleBorderMix a, CircleBorderMix b) => a.mergeShapeBorder(b),
          (StarBorderMix a, StarBorderMix b) => a.mergeShapeBorder(b),
          (LinearBorderMix a, LinearBorderMix b) => a.mergeShapeBorder(b),
          (StadiumBorderMix a, StadiumBorderMix b) => a.mergeShapeBorder(b),
          _ => other, // Different types: override with other
        }
        as ShapeBorderMix<T>;
  }
}

/// Base class for borders that extend OutlinedBorder and have a side property.
@immutable
abstract class OutlinedBorderMix<T extends OutlinedBorder>
    extends ShapeBorderMix<T> {
  final MixProp<BorderSide>? side;

  const OutlinedBorderMix({this.side});
}

final class RoundedRectangleBorderMix
    extends OutlinedBorderMix<RoundedRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? borderRadius;

  RoundedRectangleBorderMix.only({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );
  const RoundedRectangleBorderMix({this.borderRadius, super.side});

  RoundedRectangleBorderMix.value(RoundedRectangleBorder border)
    : this.only(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  static RoundedRectangleBorderMix? maybeValue(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderMix.value(border) : null;
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
  RoundedRectangleBorderMix mergeShapeBorder(RoundedRectangleBorderMix other) {
    return RoundedRectangleBorderMix(
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      side: MixHelpers.merge(side, other.side),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoundedRectangleBorderMix &&
        other.borderRadius == borderRadius &&
        other.side == side;
  }

  @override
  int get hashCode => borderRadius.hashCode ^ side.hashCode;
}

final class BeveledRectangleBorderMix
    extends OutlinedBorderMix<BeveledRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? borderRadius;

  BeveledRectangleBorderMix.only({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const BeveledRectangleBorderMix({this.borderRadius, super.side});

  BeveledRectangleBorderMix.value(BeveledRectangleBorder border)
    : this.only(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  static BeveledRectangleBorderMix? maybeValue(BeveledRectangleBorder? border) {
    return border != null ? BeveledRectangleBorderMix.value(border) : null;
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
  BeveledRectangleBorderMix mergeShapeBorder(BeveledRectangleBorderMix other) {
    return BeveledRectangleBorderMix(
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      side: MixHelpers.merge(side, other.side),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BeveledRectangleBorderMix &&
        other.borderRadius == borderRadius &&
        other.side == side;
  }

  @override
  int get hashCode => borderRadius.hashCode ^ side.hashCode;
}

final class ContinuousRectangleBorderMix
    extends OutlinedBorderMix<ContinuousRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? borderRadius;

  ContinuousRectangleBorderMix.only({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const ContinuousRectangleBorderMix({this.borderRadius, super.side});

  ContinuousRectangleBorderMix.value(ContinuousRectangleBorder border)
    : this.only(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  static ContinuousRectangleBorderMix? maybeValue(
    ContinuousRectangleBorder? border,
  ) {
    return border != null ? ContinuousRectangleBorderMix.value(border) : null;
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
  ContinuousRectangleBorderMix mergeShapeBorder(
    ContinuousRectangleBorderMix other,
  ) {
    return ContinuousRectangleBorderMix(
      borderRadius: MixHelpers.merge(borderRadius, other.borderRadius),
      side: MixHelpers.merge(side, other.side),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContinuousRectangleBorderMix &&
        other.borderRadius == borderRadius &&
        other.side == side;
  }

  @override
  int get hashCode => borderRadius.hashCode ^ side.hashCode;
}

final class CircleBorderMix extends OutlinedBorderMix<CircleBorder> {
  final Prop<double>? eccentricity;

  CircleBorderMix.only({BorderSideMix? side, double? eccentricity})
    : this(side: MixProp.maybe(side), eccentricity: Prop.maybe(eccentricity));

  const CircleBorderMix({super.side, this.eccentricity});

  CircleBorderMix.value(CircleBorder border)
    : this.only(
        side: BorderSideMix.maybeValue(border.side),
        eccentricity: border.eccentricity,
      );

  static CircleBorderMix? maybeValue(CircleBorder? border) {
    return border != null ? CircleBorderMix.value(border) : null;
  }

  @override
  CircleBorder resolve(BuildContext context) {
    return CircleBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
      eccentricity: MixHelpers.resolve(context, eccentricity) ?? 0.0,
    );
  }

  @override
  CircleBorderMix mergeShapeBorder(CircleBorderMix other) {
    return CircleBorderMix(
      side: MixHelpers.merge(side, other.side),
      eccentricity: MixHelpers.merge(eccentricity, other.eccentricity),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircleBorderMix &&
        other.side == side &&
        other.eccentricity == eccentricity;
  }

  @override
  int get hashCode => side.hashCode ^ eccentricity.hashCode;
}

final class StarBorderMix extends OutlinedBorderMix<StarBorder> {
  final Prop<double>? points;
  final Prop<double>? innerRadiusRatio;
  final Prop<double>? pointRounding;
  final Prop<double>? valleyRounding;
  final Prop<double>? rotation;
  final Prop<double>? squash;

  StarBorderMix.only({
    BorderSideMix? side,
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

  StarBorderMix.value(StarBorder border)
    : this.only(
        side: BorderSideMix.maybeValue(border.side),
        points: border.points,
        innerRadiusRatio: border.innerRadiusRatio,
        pointRounding: border.pointRounding,
        valleyRounding: border.valleyRounding,
        rotation: border.rotation,
        squash: border.squash,
      );

  const StarBorderMix({
    super.side,
    this.points,
    this.innerRadiusRatio,
    this.pointRounding,
    this.valleyRounding,
    this.rotation,
    this.squash,
  });

  static StarBorderMix? maybeValue(StarBorder? border) {
    return border != null ? StarBorderMix.value(border) : null;
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
  StarBorderMix mergeShapeBorder(StarBorderMix other) {
    return StarBorderMix(
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

    return other is StarBorderMix &&
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

final class LinearBorderMix extends OutlinedBorderMix<LinearBorder> {
  final MixProp<LinearBorderEdge>? start;
  final MixProp<LinearBorderEdge>? end;
  final MixProp<LinearBorderEdge>? top;
  final MixProp<LinearBorderEdge>? bottom;

  LinearBorderMix.only({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) : this(
         side: MixProp.maybe(side),
         start: MixProp.maybe(start),
         end: MixProp.maybe(end),
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
       );
  const LinearBorderMix({
    super.side,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  LinearBorderMix.value(LinearBorder border)
    : this.only(
        side: BorderSideMix.maybeValue(border.side),
        start: LinearBorderEdgeMix.maybeValue(border.start),
        end: LinearBorderEdgeMix.maybeValue(border.end),
        top: LinearBorderEdgeMix.maybeValue(border.top),
        bottom: LinearBorderEdgeMix.maybeValue(border.bottom),
      );

  static LinearBorderMix? maybeValue(LinearBorder? border) {
    return border != null ? LinearBorderMix.value(border) : null;
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
  LinearBorderMix mergeShapeBorder(LinearBorderMix other) {
    return LinearBorderMix(
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

    return other is LinearBorderMix &&
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

final class LinearBorderEdgeMix extends Mix<LinearBorderEdge> {
  final Prop<double>? size;
  final Prop<double>? alignment;

  LinearBorderEdgeMix.only({double? size, double? alignment})
    : this(size: Prop.maybe(size), alignment: Prop.maybe(alignment));
  LinearBorderEdgeMix.value(LinearBorderEdge edge)
    : this.only(size: edge.size, alignment: edge.alignment);
  const LinearBorderEdgeMix({this.size, this.alignment});

  static LinearBorderEdgeMix? maybeValue(LinearBorderEdge? edge) {
    return edge != null ? LinearBorderEdgeMix.value(edge) : null;
  }

  @override
  LinearBorderEdge resolve(BuildContext context) {
    return LinearBorderEdge(
      size: MixHelpers.resolve(context, size) ?? 1.0,
      alignment: MixHelpers.resolve(context, alignment) ?? 0.0,
    );
  }

  @override
  LinearBorderEdgeMix merge(LinearBorderEdgeMix? other) {
    if (other == null) return this;

    return LinearBorderEdgeMix(
      size: MixHelpers.merge(size, other.size),
      alignment: MixHelpers.merge(alignment, other.alignment),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinearBorderEdgeMix &&
        other.size == size &&
        other.alignment == alignment;
  }

  @override
  int get hashCode => size.hashCode ^ alignment.hashCode;
}

final class StadiumBorderMix extends OutlinedBorderMix<StadiumBorder> {
  StadiumBorderMix.only({BorderSideMix? side})
    : this(side: MixProp.maybe(side));

  const StadiumBorderMix({super.side});

  StadiumBorderMix.value(StadiumBorder border)
    : this.only(side: BorderSideMix.maybeValue(border.side));

  static StadiumBorderMix? maybeValue(StadiumBorder? border) {
    return border != null ? StadiumBorderMix.value(border) : null;
  }

  @override
  StadiumBorder resolve(BuildContext context) {
    return StadiumBorder(
      side: MixHelpers.resolve(context, side) ?? BorderSide.none,
    );
  }

  @override
  StadiumBorderMix mergeShapeBorder(StadiumBorderMix other) {
    return StadiumBorderMix(side: MixHelpers.merge(side, other.side));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StadiumBorderMix && other.side == side;
  }

  @override
  int get hashCode => side.hashCode;
}

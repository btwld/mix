import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'border_mix.dart';
import 'border_radius_mix.dart';

/// Base class for Mix shape border types.
///
/// Converts Flutter [ShapeBorder] types with merging.
@immutable
sealed class ShapeBorderMix<T extends ShapeBorder> extends Mix<T> {
  const ShapeBorderMix();

  /// Creates from [ShapeBorder].
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

  /// Creates from nullable [ShapeBorder].
  static ShapeBorderMix? maybeValue(ShapeBorder? border) {
    return border != null ? ShapeBorderMix.value(border) : null;
  }

  /// Merges instances of the same type.
  @override
  ShapeBorderMix<T> merge(covariant ShapeBorderMix<T>? other) {
    // Use pattern matching for type-safe same-type merging only
    return switch ((this, other)) {
          (RoundedRectangleBorderMix a, RoundedRectangleBorderMix b) => a.merge(
            b,
          ),
          (BeveledRectangleBorderMix a, BeveledRectangleBorderMix b) => a.merge(
            b,
          ),
          (ContinuousRectangleBorderMix a, ContinuousRectangleBorderMix b) =>
            a.merge(b),
          (RoundedSuperellipseBorderMix a, RoundedSuperellipseBorderMix b) =>
            a.merge(b),
          (CircleBorderMix a, CircleBorderMix b) => a.merge(b),
          (StarBorderMix a, StarBorderMix b) => a.merge(b),
          (LinearBorderMix a, LinearBorderMix b) => a.merge(b),
          (StadiumBorderMix a, StadiumBorderMix b) => a.merge(b),
          _ => throw ArgumentError(
            'Cannot merge different ShapeBorder types: $runtimeType and ${other.runtimeType}. '
            'Cross-type merging should be handled by ShapeBorderMerger.',
          ),
        }
        as ShapeBorderMix<T>;
  }
}

/// Base class for outlined shape borders.
///
/// Common border side functionality for outlined shapes.
@immutable
abstract class OutlinedBorderMix<T extends OutlinedBorder>
    extends ShapeBorderMix<T> {
  final Prop<BorderSide>? $side;

  const OutlinedBorderMix({Prop<BorderSide>? side}) : $side = side;
}

/// Mix representation of [RoundedRectangleBorder].
final class RoundedRectangleBorderMix
    extends OutlinedBorderMix<RoundedRectangleBorder> {
  final Prop<BorderRadiusGeometry>? $borderRadius;

  RoundedRectangleBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.create(
         borderRadius: Prop.maybeMix(borderRadius),
         side: Prop.maybeMix(side),
       );
  const RoundedRectangleBorderMix.create({
    Prop<BorderRadiusGeometry>? borderRadius,
    super.side,
  }) : $borderRadius = borderRadius;

  RoundedRectangleBorderMix.value(RoundedRectangleBorder border)
    : this(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  /// Creates with border radius.
  factory RoundedRectangleBorderMix.borderRadius(
    BorderRadiusGeometryMix value,
  ) {
    return RoundedRectangleBorderMix(borderRadius: value);
  }

  /// Creates with border side.
  factory RoundedRectangleBorderMix.side(BorderSideMix value) {
    return RoundedRectangleBorderMix(side: value);
  }

  /// Creates with circular radius.
  factory RoundedRectangleBorderMix.circular(double radius) {
    return RoundedRectangleBorderMix(
      borderRadius: BorderRadiusMix.circular(radius),
    );
  }

  static RoundedRectangleBorderMix? maybeValue(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderMix.value(border) : null;
  }

  /// Copy with border radius.
  RoundedRectangleBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(RoundedRectangleBorderMix.borderRadius(value));
  }

  /// Copy with border side.
  RoundedRectangleBorderMix side(BorderSideMix value) {
    return merge(RoundedRectangleBorderMix.side(value));
  }

  @override
  RoundedRectangleBorder resolve(BuildContext context) {
    return RoundedRectangleBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedRectangleBorderMix merge(RoundedRectangleBorderMix? other) {
    return RoundedRectangleBorderMix.create(
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      side: MixOps.merge($side, other?.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [RoundedSuperellipseBorder] with smoother corners.
final class RoundedSuperellipseBorderMix
    extends OutlinedBorderMix<RoundedSuperellipseBorder> {
  final Prop<BorderRadiusGeometry>? $borderRadius;

  RoundedSuperellipseBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.create(
         borderRadius: Prop.maybeMix(borderRadius),
         side: Prop.maybeMix(side),
       );
  const RoundedSuperellipseBorderMix.create({
    Prop<BorderRadiusGeometry>? borderRadius,
    super.side,
  }) : $borderRadius = borderRadius;

  RoundedSuperellipseBorderMix.value(RoundedSuperellipseBorder border)
    : this(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  /// Creates a rounded superellipse border with the specified border radius.
  factory RoundedSuperellipseBorderMix.borderRadius(
    BorderRadiusGeometryMix value,
  ) {
    return RoundedSuperellipseBorderMix(borderRadius: value);
  }

  /// Creates a rounded superellipse border with the specified border side.
  factory RoundedSuperellipseBorderMix.side(BorderSideMix value) {
    return RoundedSuperellipseBorderMix(side: value);
  }

  static RoundedSuperellipseBorderMix? maybeValue(
    RoundedSuperellipseBorder? border,
  ) {
    return border != null ? RoundedSuperellipseBorderMix.value(border) : null;
  }

  /// Copy with border radius.
  RoundedSuperellipseBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(RoundedSuperellipseBorderMix.borderRadius(value));
  }

  /// Copy with border side.
  RoundedSuperellipseBorderMix side(BorderSideMix value) {
    return merge(RoundedSuperellipseBorderMix.side(value));
  }

  @override
  RoundedSuperellipseBorder resolve(BuildContext context) {
    return RoundedSuperellipseBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedSuperellipseBorderMix merge(RoundedSuperellipseBorderMix? other) {
    return RoundedSuperellipseBorderMix.create(
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      side: MixOps.merge($side, other?.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [BeveledRectangleBorder] with beveled corners.
final class BeveledRectangleBorderMix
    extends OutlinedBorderMix<BeveledRectangleBorder> {
  final Prop<BorderRadiusGeometry>? $borderRadius;

  BeveledRectangleBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.create(
         borderRadius: Prop.maybeMix(borderRadius),
         side: Prop.maybeMix(side),
       );

  const BeveledRectangleBorderMix.create({
    Prop<BorderRadiusGeometry>? borderRadius,
    super.side,
  }) : $borderRadius = borderRadius;

  BeveledRectangleBorderMix.value(BeveledRectangleBorder border)
    : this(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  /// Creates a beveled rectangle border with the specified border radius.
  factory BeveledRectangleBorderMix.borderRadius(
    BorderRadiusGeometryMix value,
  ) {
    return BeveledRectangleBorderMix(borderRadius: value);
  }

  /// Creates a beveled rectangle border with the specified border side.
  factory BeveledRectangleBorderMix.side(BorderSideMix value) {
    return BeveledRectangleBorderMix(side: value);
  }

  static BeveledRectangleBorderMix? maybeValue(BeveledRectangleBorder? border) {
    return border != null ? BeveledRectangleBorderMix.value(border) : null;
  }

  /// Copy with border radius.
  BeveledRectangleBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(BeveledRectangleBorderMix.borderRadius(value));
  }

  /// Copy with border side.
  BeveledRectangleBorderMix side(BorderSideMix value) {
    return merge(BeveledRectangleBorderMix.side(value));
  }

  @override
  BeveledRectangleBorder resolve(BuildContext context) {
    return BeveledRectangleBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  BeveledRectangleBorderMix merge(BeveledRectangleBorderMix? other) {
    return BeveledRectangleBorderMix.create(
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      side: MixOps.merge($side, other?.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [ContinuousRectangleBorder] with smooth curved corners.
final class ContinuousRectangleBorderMix
    extends OutlinedBorderMix<ContinuousRectangleBorder> {
  final Prop<BorderRadiusGeometry>? $borderRadius;

  ContinuousRectangleBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.create(
         borderRadius: Prop.maybeMix(borderRadius),
         side: Prop.maybeMix(side),
       );

  const ContinuousRectangleBorderMix.create({
    Prop<BorderRadiusGeometry>? borderRadius,
    super.side,
  }) : $borderRadius = borderRadius;

  ContinuousRectangleBorderMix.value(ContinuousRectangleBorder border)
    : this(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  /// Creates a continuous rectangle border with the specified border radius.
  factory ContinuousRectangleBorderMix.borderRadius(
    BorderRadiusGeometryMix value,
  ) {
    return ContinuousRectangleBorderMix(borderRadius: value);
  }

  /// Creates a continuous rectangle border with the specified border side.
  factory ContinuousRectangleBorderMix.side(BorderSideMix value) {
    return ContinuousRectangleBorderMix(side: value);
  }

  static ContinuousRectangleBorderMix? maybeValue(
    ContinuousRectangleBorder? border,
  ) {
    return border != null ? ContinuousRectangleBorderMix.value(border) : null;
  }

  /// Copy with border radius.
  ContinuousRectangleBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(ContinuousRectangleBorderMix.borderRadius(value));
  }

  /// Copy with border side.
  ContinuousRectangleBorderMix side(BorderSideMix value) {
    return merge(ContinuousRectangleBorderMix.side(value));
  }

  @override
  ContinuousRectangleBorder resolve(BuildContext context) {
    return ContinuousRectangleBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  ContinuousRectangleBorderMix merge(ContinuousRectangleBorderMix? other) {
    return ContinuousRectangleBorderMix.create(
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      side: MixOps.merge($side, other?.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix representation of [CircleBorder].
final class CircleBorderMix extends OutlinedBorderMix<CircleBorder> {
  final Prop<double>? $eccentricity;

  CircleBorderMix({BorderSideMix? side, double? eccentricity})
    : this.create(
        side: Prop.maybeMix(side),
        eccentricity: Prop.maybe(eccentricity),
      );

  const CircleBorderMix.create({super.side, Prop<double>? eccentricity})
    : $eccentricity = eccentricity;

  CircleBorderMix.value(CircleBorder border)
    : this(
        side: BorderSideMix.maybeValue(border.side),
        eccentricity: border.eccentricity,
      );

  /// Creates with border side.
  factory CircleBorderMix.side(BorderSideMix value) {
    return CircleBorderMix(side: value);
  }

  /// Creates with eccentricity.
  factory CircleBorderMix.eccentricity(double value) {
    return CircleBorderMix(eccentricity: value);
  }

  static CircleBorderMix? maybeValue(CircleBorder? border) {
    return border != null ? CircleBorderMix.value(border) : null;
  }

  /// Copy with border side.
  CircleBorderMix side(BorderSideMix value) {
    return merge(CircleBorderMix.side(value));
  }

  /// Copy with eccentricity.
  CircleBorderMix eccentricity(double value) {
    return merge(CircleBorderMix.eccentricity(value));
  }

  @override
  CircleBorder resolve(BuildContext context) {
    return CircleBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      eccentricity: MixOps.resolve(context, $eccentricity) ?? 0.0,
    );
  }

  @override
  CircleBorderMix merge(CircleBorderMix? other) {
    return CircleBorderMix.create(
      side: MixOps.merge($side, other?.$side),
      eccentricity: MixOps.merge($eccentricity, other?.$eccentricity),
    );
  }

  @override
  List<Object?> get props => [$side, $eccentricity];
}

/// Mix representation of [StarBorder].
final class StarBorderMix extends OutlinedBorderMix<StarBorder> {
  final Prop<double>? $points;
  final Prop<double>? $innerRadiusRatio;
  final Prop<double>? $pointRounding;
  final Prop<double>? $valleyRounding;
  final Prop<double>? $rotation;
  final Prop<double>? $squash;

  StarBorderMix({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) : this.create(
         side: Prop.maybeMix(side),
         points: Prop.maybe(points),
         innerRadiusRatio: Prop.maybe(innerRadiusRatio),
         pointRounding: Prop.maybe(pointRounding),
         valleyRounding: Prop.maybe(valleyRounding),
         rotation: Prop.maybe(rotation),
         squash: Prop.maybe(squash),
       );

  StarBorderMix.value(StarBorder border)
    : this(
        side: BorderSideMix.maybeValue(border.side),
        points: border.points,
        innerRadiusRatio: border.innerRadiusRatio,
        pointRounding: border.pointRounding,
        valleyRounding: border.valleyRounding,
        rotation: border.rotation,
        squash: border.squash,
      );

  const StarBorderMix.create({
    super.side,
    Prop<double>? points,
    Prop<double>? innerRadiusRatio,
    Prop<double>? pointRounding,
    Prop<double>? valleyRounding,
    Prop<double>? rotation,
    Prop<double>? squash,
  }) : $points = points,
       $innerRadiusRatio = innerRadiusRatio,
       $pointRounding = pointRounding,
       $valleyRounding = valleyRounding,
       $rotation = rotation,
       $squash = squash;

  /// Creates with points.
  factory StarBorderMix.points(double value) {
    return StarBorderMix(points: value);
  }

  /// Creates with inner radius ratio.
  factory StarBorderMix.innerRadiusRatio(double value) {
    return StarBorderMix(innerRadiusRatio: value);
  }

  /// Creates with point rounding.
  factory StarBorderMix.pointRounding(double value) {
    return StarBorderMix(pointRounding: value);
  }

  /// Creates with valley rounding.
  factory StarBorderMix.valleyRounding(double value) {
    return StarBorderMix(valleyRounding: value);
  }

  /// Creates a star border with the specified rotation.
  factory StarBorderMix.rotation(double value) {
    return StarBorderMix(rotation: value);
  }

  /// Creates a star border with the specified squash factor.
  factory StarBorderMix.squash(double value) {
    return StarBorderMix(squash: value);
  }

  /// Creates a star border with the specified border side.
  factory StarBorderMix.side(BorderSideMix value) {
    return StarBorderMix(side: value);
  }

  static StarBorderMix? maybeValue(StarBorder? border) {
    return border != null ? StarBorderMix.value(border) : null;
  }

  /// Returns a copy with the specified number of points.
  StarBorderMix points(double value) {
    return merge(StarBorderMix.points(value));
  }

  /// Returns a copy with the specified inner radius ratio.
  StarBorderMix innerRadiusRatio(double value) {
    return merge(StarBorderMix.innerRadiusRatio(value));
  }

  /// Returns a copy with the specified point rounding.
  StarBorderMix pointRounding(double value) {
    return merge(StarBorderMix.pointRounding(value));
  }

  /// Returns a copy with the specified valley rounding.
  StarBorderMix valleyRounding(double value) {
    return merge(StarBorderMix.valleyRounding(value));
  }

  /// Returns a copy with the specified rotation.
  StarBorderMix rotation(double value) {
    return merge(StarBorderMix.rotation(value));
  }

  /// Returns a copy with the specified squash factor.
  StarBorderMix squash(double value) {
    return merge(StarBorderMix.squash(value));
  }

  /// Copy with border side.
  StarBorderMix side(BorderSideMix value) {
    return merge(StarBorderMix.side(value));
  }

  @override
  StarBorder resolve(BuildContext context) {
    return StarBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      points: MixOps.resolve(context, $points) ?? 5,
      innerRadiusRatio: MixOps.resolve(context, $innerRadiusRatio) ?? 0.4,
      pointRounding: MixOps.resolve(context, $pointRounding) ?? 0,
      valleyRounding: MixOps.resolve(context, $valleyRounding) ?? 0,
      rotation: MixOps.resolve(context, $rotation) ?? 0,
      squash: MixOps.resolve(context, $squash) ?? 0,
    );
  }

  @override
  StarBorderMix merge(StarBorderMix? other) {
    return StarBorderMix.create(
      side: MixOps.merge($side, other?.$side),
      points: MixOps.merge($points, other?.$points),
      innerRadiusRatio: MixOps.merge(
        $innerRadiusRatio,
        other?.$innerRadiusRatio,
      ),
      pointRounding: MixOps.merge($pointRounding, other?.$pointRounding),
      valleyRounding: MixOps.merge($valleyRounding, other?.$valleyRounding),
      rotation: MixOps.merge($rotation, other?.$rotation),
      squash: MixOps.merge($squash, other?.$squash),
    );
  }

  @override
  List<Object?> get props => [
    $side,
    $points,
    $innerRadiusRatio,
    $pointRounding,
    $valleyRounding,
    $rotation,
    $squash,
  ];
}

/// Mix-compatible representation of Flutter's [LinearBorder] with configurable edge styling.
final class LinearBorderMix extends OutlinedBorderMix<LinearBorder> {
  final Prop<LinearBorderEdge>? $start;
  final Prop<LinearBorderEdge>? $end;
  final Prop<LinearBorderEdge>? $top;
  final Prop<LinearBorderEdge>? $bottom;

  LinearBorderMix({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) : this.create(
         side: Prop.maybeMix(side),
         start: Prop.maybeMix(start),
         end: Prop.maybeMix(end),
         top: Prop.maybeMix(top),
         bottom: Prop.maybeMix(bottom),
       );
  const LinearBorderMix.create({
    super.side,
    Prop<LinearBorderEdge>? start,
    Prop<LinearBorderEdge>? end,
    Prop<LinearBorderEdge>? top,
    Prop<LinearBorderEdge>? bottom,
  }) : $start = start,
       $end = end,
       $top = top,
       $bottom = bottom;

  LinearBorderMix.value(LinearBorder border)
    : this(
        side: BorderSideMix.maybeValue(border.side),
        start: LinearBorderEdgeMix.maybeValue(border.start),
        end: LinearBorderEdgeMix.maybeValue(border.end),
        top: LinearBorderEdgeMix.maybeValue(border.top),
        bottom: LinearBorderEdgeMix.maybeValue(border.bottom),
      );

  /// Creates a linear border with the specified start edge.
  factory LinearBorderMix.start(LinearBorderEdgeMix value) {
    return LinearBorderMix(start: value);
  }

  /// Creates a linear border with the specified end edge.
  factory LinearBorderMix.end(LinearBorderEdgeMix value) {
    return LinearBorderMix(end: value);
  }

  /// Creates a linear border with the specified top edge.
  factory LinearBorderMix.top(LinearBorderEdgeMix value) {
    return LinearBorderMix(top: value);
  }

  /// Creates a linear border with the specified bottom edge.
  factory LinearBorderMix.bottom(LinearBorderEdgeMix value) {
    return LinearBorderMix(bottom: value);
  }

  /// Creates a linear border with the specified border side.
  factory LinearBorderMix.side(BorderSideMix value) {
    return LinearBorderMix(side: value);
  }

  static LinearBorderMix? maybeValue(LinearBorder? border) {
    return border != null ? LinearBorderMix.value(border) : null;
  }

  /// Returns a copy with the specified start edge.
  LinearBorderMix start(LinearBorderEdgeMix value) {
    return merge(LinearBorderMix.start(value));
  }

  /// Returns a copy with the specified end edge.
  LinearBorderMix end(LinearBorderEdgeMix value) {
    return merge(LinearBorderMix.end(value));
  }

  /// Returns a copy with the specified top edge.
  LinearBorderMix top(LinearBorderEdgeMix value) {
    return merge(LinearBorderMix.top(value));
  }

  /// Returns a copy with the specified bottom edge.
  LinearBorderMix bottom(LinearBorderEdgeMix value) {
    return merge(LinearBorderMix.bottom(value));
  }

  /// Copy with border side.
  LinearBorderMix side(BorderSideMix value) {
    return merge(LinearBorderMix.side(value));
  }

  @override
  LinearBorder resolve(BuildContext context) {
    return LinearBorder(
      side: MixOps.resolve(context, $side) ?? .none,
      start: MixOps.resolve(context, $start),
      end: MixOps.resolve(context, $end),
      top: MixOps.resolve(context, $top),
      bottom: MixOps.resolve(context, $bottom),
    );
  }

  @override
  LinearBorderMix merge(LinearBorderMix? other) {
    return LinearBorderMix.create(
      side: MixOps.merge($side, other?.$side),
      start: MixOps.merge($start, other?.$start),
      end: MixOps.merge($end, other?.$end),
      top: MixOps.merge($top, other?.$top),
      bottom: MixOps.merge($bottom, other?.$bottom),
    );
  }

  @override
  List<Object?> get props => [$side, $start, $end, $top, $bottom];
}

/// Mix-compatible representation of [LinearBorderEdge] with size and alignment properties.
final class LinearBorderEdgeMix extends Mix<LinearBorderEdge>
    with Diagnosticable {
  final Prop<double>? $size;
  final Prop<double>? $alignment;

  LinearBorderEdgeMix({double? size, double? alignment})
    : this.create(size: Prop.maybe(size), alignment: Prop.maybe(alignment));
  LinearBorderEdgeMix.value(LinearBorderEdge edge)
    : this(size: edge.size, alignment: edge.alignment);
  const LinearBorderEdgeMix.create({
    Prop<double>? size,
    Prop<double>? alignment,
  }) : $size = size,
       $alignment = alignment;

  /// Creates a linear border edge with the specified size.
  factory LinearBorderEdgeMix.size(double value) {
    return LinearBorderEdgeMix(size: value);
  }

  /// Creates a linear border edge with the specified alignment.
  factory LinearBorderEdgeMix.alignment(double value) {
    return LinearBorderEdgeMix(alignment: value);
  }

  static LinearBorderEdgeMix? maybeValue(LinearBorderEdge? edge) {
    return edge != null ? LinearBorderEdgeMix.value(edge) : null;
  }

  /// Returns a copy with the specified size.
  LinearBorderEdgeMix size(double value) {
    return merge(LinearBorderEdgeMix.size(value));
  }

  /// Returns a copy with the specified alignment.
  LinearBorderEdgeMix alignment(double value) {
    return merge(LinearBorderEdgeMix.alignment(value));
  }

  @override
  LinearBorderEdge resolve(BuildContext context) {
    return LinearBorderEdge(
      size: MixOps.resolve(context, $size) ?? 1.0,
      alignment: MixOps.resolve(context, $alignment) ?? 0.0,
    );
  }

  @override
  LinearBorderEdgeMix merge(LinearBorderEdgeMix? other) {
    return LinearBorderEdgeMix.create(
      size: MixOps.merge($size, other?.$size),
      alignment: MixOps.merge($alignment, other?.$alignment),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('alignment', $alignment));
  }

  @override
  List<Object?> get props => [$size, $alignment];
}

/// Mix-compatible representation of Flutter's [StadiumBorder] with rounded stadium shape.
final class StadiumBorderMix extends OutlinedBorderMix<StadiumBorder> {
  StadiumBorderMix({BorderSideMix? side})
    : this.create(side: Prop.maybeMix(side));

  const StadiumBorderMix.create({super.side});

  StadiumBorderMix.value(StadiumBorder border)
    : this(side: BorderSideMix.maybeValue(border.side));

  /// Creates a stadium border with the specified border side.
  factory StadiumBorderMix.side(BorderSideMix value) {
    return StadiumBorderMix(side: value);
  }

  static StadiumBorderMix? maybeValue(StadiumBorder? border) {
    return border != null ? StadiumBorderMix.value(border) : null;
  }

  /// Copy with border side.
  StadiumBorderMix side(BorderSideMix value) {
    return merge(StadiumBorderMix.side(value));
  }

  @override
  StadiumBorder resolve(BuildContext context) {
    return StadiumBorder(side: MixOps.resolve(context, $side) ?? .none);
  }

  @override
  StadiumBorderMix merge(StadiumBorderMix? other) {
    return StadiumBorderMix.create(side: MixOps.merge($side, other?.$side));
  }

  @override
  List<Object?> get props => [$side];
}

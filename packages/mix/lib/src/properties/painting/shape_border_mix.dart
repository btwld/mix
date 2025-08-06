import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import 'border_mix.dart';
import 'border_radius_mix.dart';

/// Base class for Mix-compatible shape border styling with token support.
///
/// Provides factory methods for converting Flutter [ShapeBorder] types to their
/// corresponding Mix representations with merging capabilities.
@immutable
sealed class ShapeBorderMix<T extends ShapeBorder> extends Mix<T> {
  const ShapeBorderMix();

  /// Creates the appropriate shape border mix type from a Flutter [ShapeBorder].
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

  /// Creates the appropriate shape border mix type from a nullable Flutter [ShapeBorder].
  ///
  /// Returns null if the input is null.
  static ShapeBorderMix? maybeValue(ShapeBorder? border) {
    return border != null ? ShapeBorderMix.value(border) : null;
  }

  /// Merges two ShapeBorderMix instances of the same type.
  ///
  /// Only handles same-type merging. Cross-type merging is handled by ShapeBorderMerger
  /// when ShapeBorderMix instances are merged through MixProp accumulation.
  /// If [other] is null, returns this instance.
  @override
  ShapeBorderMix<T> merge(covariant ShapeBorderMix<T>? other) {
    if (other == null) return this;

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

/// Base class for outlined shape borders with border side styling.
///
/// Provides common border side functionality for outlined border types like
/// rounded rectangles, circles, and other outlined shapes.
@immutable
abstract class OutlinedBorderMix<T extends OutlinedBorder>
    extends ShapeBorderMix<T> {
  final MixProp<BorderSide>? $side;

  const OutlinedBorderMix({MixProp<BorderSide>? side}) : $side = side;
}

/// Mix-compatible representation of Flutter's [RoundedRectangleBorder] with customizable radius and border side.
final class RoundedRectangleBorderMix
    extends OutlinedBorderMix<RoundedRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  RoundedRectangleBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.raw(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );
  const RoundedRectangleBorderMix.raw({
    MixProp<BorderRadiusGeometry>? borderRadius,
    super.side,
  }) : $borderRadius = borderRadius;

  RoundedRectangleBorderMix.value(RoundedRectangleBorder border)
    : this(
        borderRadius: BorderRadiusGeometryMix.value(border.borderRadius),
        side: BorderSideMix.maybeValue(border.side),
      );

  /// Creates a rounded rectangle border with the specified border radius.
  factory RoundedRectangleBorderMix.borderRadius(
    BorderRadiusGeometryMix value,
  ) {
    return RoundedRectangleBorderMix(borderRadius: value);
  }

  /// Creates a rounded rectangle border with the specified border side.
  factory RoundedRectangleBorderMix.side(BorderSideMix value) {
    return RoundedRectangleBorderMix(side: value);
  }

  /// Creates a rounded rectangle border with circular radius.
  factory RoundedRectangleBorderMix.circular(double radius) {
    return RoundedRectangleBorderMix(
      borderRadius: BorderRadiusMix.circular(radius),
    );
  }

  static RoundedRectangleBorderMix? maybeValue(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderMix.value(border) : null;
  }

  /// Returns a copy with the specified border radius.
  RoundedRectangleBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(RoundedRectangleBorderMix.borderRadius(value));
  }

  /// Returns a copy with the specified border side.
  RoundedRectangleBorderMix side(BorderSideMix value) {
    return merge(RoundedRectangleBorderMix.side(value));
  }

  @override
  RoundedRectangleBorder resolve(BuildContext context) {
    return RoundedRectangleBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedRectangleBorderMix merge(RoundedRectangleBorderMix? other) {
    if (other == null) return this;

    return RoundedRectangleBorderMix.raw(
      borderRadius: $borderRadius.tryMerge(other.$borderRadius),
      side: $side.tryMerge(other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [RoundedSuperellipseBorder] with smoother corners.
final class RoundedSuperellipseBorderMix
    extends OutlinedBorderMix<RoundedSuperellipseBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  RoundedSuperellipseBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.raw(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );
  const RoundedSuperellipseBorderMix.raw({
    MixProp<BorderRadiusGeometry>? borderRadius,
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

  /// Returns a copy with the specified border radius.
  RoundedSuperellipseBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(RoundedSuperellipseBorderMix.borderRadius(value));
  }

  /// Returns a copy with the specified border side.
  RoundedSuperellipseBorderMix side(BorderSideMix value) {
    return merge(RoundedSuperellipseBorderMix.side(value));
  }

  @override
  RoundedSuperellipseBorder resolve(BuildContext context) {
    return RoundedSuperellipseBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedSuperellipseBorderMix merge(RoundedSuperellipseBorderMix? other) {
    if (other == null) return this;

    return RoundedSuperellipseBorderMix.raw(
      borderRadius: $borderRadius.tryMerge(other.$borderRadius),
      side: $side.tryMerge(other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [BeveledRectangleBorder] with beveled corners.
final class BeveledRectangleBorderMix
    extends OutlinedBorderMix<BeveledRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  BeveledRectangleBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.raw(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const BeveledRectangleBorderMix.raw({
    MixProp<BorderRadiusGeometry>? borderRadius,
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

  /// Returns a copy with the specified border radius.
  BeveledRectangleBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(BeveledRectangleBorderMix.borderRadius(value));
  }

  /// Returns a copy with the specified border side.
  BeveledRectangleBorderMix side(BorderSideMix value) {
    return merge(BeveledRectangleBorderMix.side(value));
  }

  @override
  BeveledRectangleBorder resolve(BuildContext context) {
    return BeveledRectangleBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  BeveledRectangleBorderMix merge(BeveledRectangleBorderMix? other) {
    if (other == null) return this;

    return BeveledRectangleBorderMix.raw(
      borderRadius: $borderRadius.tryMerge(other.$borderRadius),
      side: $side.tryMerge(other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [ContinuousRectangleBorder] with smooth curved corners.
final class ContinuousRectangleBorderMix
    extends OutlinedBorderMix<ContinuousRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  ContinuousRectangleBorderMix({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this.raw(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const ContinuousRectangleBorderMix.raw({
    MixProp<BorderRadiusGeometry>? borderRadius,
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

  /// Returns a copy with the specified border radius.
  ContinuousRectangleBorderMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(ContinuousRectangleBorderMix.borderRadius(value));
  }

  /// Returns a copy with the specified border side.
  ContinuousRectangleBorderMix side(BorderSideMix value) {
    return merge(ContinuousRectangleBorderMix.side(value));
  }

  @override
  ContinuousRectangleBorder resolve(BuildContext context) {
    return ContinuousRectangleBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
      borderRadius: MixOps.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  ContinuousRectangleBorderMix merge(ContinuousRectangleBorderMix? other) {
    if (other == null) return this;

    return ContinuousRectangleBorderMix.raw(
      borderRadius: $borderRadius.tryMerge(other.$borderRadius),
      side: $side.tryMerge(other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

/// Mix-compatible representation of Flutter's [CircleBorder] with configurable eccentricity.
final class CircleBorderMix extends OutlinedBorderMix<CircleBorder> {
  final Prop<double>? $eccentricity;

  CircleBorderMix({BorderSideMix? side, double? eccentricity})
    : this.raw(
        side: MixProp.maybe(side),
        eccentricity: Prop.maybe(eccentricity),
      );

  const CircleBorderMix.raw({super.side, Prop<double>? eccentricity})
    : $eccentricity = eccentricity;

  CircleBorderMix.value(CircleBorder border)
    : this(
        side: BorderSideMix.maybeValue(border.side),
        eccentricity: border.eccentricity,
      );

  /// Creates a circle border with the specified border side.
  factory CircleBorderMix.side(BorderSideMix value) {
    return CircleBorderMix(side: value);
  }

  /// Creates a circle border with the specified eccentricity.
  factory CircleBorderMix.eccentricity(double value) {
    return CircleBorderMix(eccentricity: value);
  }

  static CircleBorderMix? maybeValue(CircleBorder? border) {
    return border != null ? CircleBorderMix.value(border) : null;
  }

  /// Returns a copy with the specified border side.
  CircleBorderMix side(BorderSideMix value) {
    return merge(CircleBorderMix.side(value));
  }

  /// Returns a copy with the specified eccentricity.
  CircleBorderMix eccentricity(double value) {
    return merge(CircleBorderMix.eccentricity(value));
  }

  @override
  CircleBorder resolve(BuildContext context) {
    return CircleBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
      eccentricity: MixOps.resolve(context, $eccentricity) ?? 0.0,
    );
  }

  @override
  CircleBorderMix merge(CircleBorderMix? other) {
    if (other == null) return this;

    return CircleBorderMix.raw(
      side: $side.tryMerge(other.$side),
      eccentricity: $eccentricity.tryMerge(other.$eccentricity),
    );
  }

  @override
  List<Object?> get props => [$side, $eccentricity];
}

/// Mix-compatible representation of Flutter's [StarBorder] with customizable star properties.
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
  }) : this.raw(
         side: MixProp.maybe(side),
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

  const StarBorderMix.raw({
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

  /// Creates a star border with the specified number of points.
  factory StarBorderMix.points(double value) {
    return StarBorderMix(points: value);
  }

  /// Creates a star border with the specified inner radius ratio.
  factory StarBorderMix.innerRadiusRatio(double value) {
    return StarBorderMix(innerRadiusRatio: value);
  }

  /// Creates a star border with the specified point rounding.
  factory StarBorderMix.pointRounding(double value) {
    return StarBorderMix(pointRounding: value);
  }

  /// Creates a star border with the specified valley rounding.
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

  /// Returns a copy with the specified border side.
  StarBorderMix side(BorderSideMix value) {
    return merge(StarBorderMix.side(value));
  }

  @override
  StarBorder resolve(BuildContext context) {
    return StarBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
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
    if (other == null) return this;

    return StarBorderMix.raw(
      side: $side.tryMerge(other.$side),
      points: $points.tryMerge(other.$points),
      innerRadiusRatio: $innerRadiusRatio.tryMerge(other.$innerRadiusRatio),
      pointRounding: $pointRounding.tryMerge(other.$pointRounding),
      valleyRounding: $valleyRounding.tryMerge(other.$valleyRounding),
      rotation: $rotation.tryMerge(other.$rotation),
      squash: $squash.tryMerge(other.$squash),
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
  final MixProp<LinearBorderEdge>? $start;
  final MixProp<LinearBorderEdge>? $end;
  final MixProp<LinearBorderEdge>? $top;
  final MixProp<LinearBorderEdge>? $bottom;

  LinearBorderMix({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) : this.raw(
         side: MixProp.maybe(side),
         start: MixProp.maybe(start),
         end: MixProp.maybe(end),
         top: MixProp.maybe(top),
         bottom: MixProp.maybe(bottom),
       );
  const LinearBorderMix.raw({
    super.side,
    MixProp<LinearBorderEdge>? start,
    MixProp<LinearBorderEdge>? end,
    MixProp<LinearBorderEdge>? top,
    MixProp<LinearBorderEdge>? bottom,
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

  /// Returns a copy with the specified border side.
  LinearBorderMix side(BorderSideMix value) {
    return merge(LinearBorderMix.side(value));
  }

  @override
  LinearBorder resolve(BuildContext context) {
    return LinearBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
      start: MixOps.resolve(context, $start),
      end: MixOps.resolve(context, $end),
      top: MixOps.resolve(context, $top),
      bottom: MixOps.resolve(context, $bottom),
    );
  }

  @override
  LinearBorderMix merge(LinearBorderMix? other) {
    if (other == null) return this;

    return LinearBorderMix.raw(
      side: $side.tryMerge(other.$side),
      start: $start.tryMerge(other.$start),
      end: $end.tryMerge(other.$end),
      top: $top.tryMerge(other.$top),
      bottom: $bottom.tryMerge(other.$bottom),
    );
  }

  @override
  List<Object?> get props => [$side, $start, $end, $top, $bottom];
}

/// Mix-compatible representation of [LinearBorderEdge] with size and alignment properties.
final class LinearBorderEdgeMix extends Mix<LinearBorderEdge> {
  final Prop<double>? $size;
  final Prop<double>? $alignment;

  LinearBorderEdgeMix({double? size, double? alignment})
    : this.raw(size: Prop.maybe(size), alignment: Prop.maybe(alignment));
  LinearBorderEdgeMix.value(LinearBorderEdge edge)
    : this(size: edge.size, alignment: edge.alignment);
  const LinearBorderEdgeMix.raw({Prop<double>? size, Prop<double>? alignment})
    : $size = size,
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
    if (other == null) return this;

    return LinearBorderEdgeMix.raw(
      size: $size.tryMerge(other.$size),
      alignment: $alignment.tryMerge(other.$alignment),
    );
  }

  @override
  List<Object?> get props => [$size, $alignment];
}

/// Mix-compatible representation of Flutter's [StadiumBorder] with rounded stadium shape.
final class StadiumBorderMix extends OutlinedBorderMix<StadiumBorder> {
  StadiumBorderMix({BorderSideMix? side}) : this.raw(side: MixProp.maybe(side));

  const StadiumBorderMix.raw({super.side});

  StadiumBorderMix.value(StadiumBorder border)
    : this(side: BorderSideMix.maybeValue(border.side));

  /// Creates a stadium border with the specified border side.
  factory StadiumBorderMix.side(BorderSideMix value) {
    return StadiumBorderMix(side: value);
  }

  static StadiumBorderMix? maybeValue(StadiumBorder? border) {
    return border != null ? StadiumBorderMix.value(border) : null;
  }

  /// Returns a copy with the specified border side.
  StadiumBorderMix side(BorderSideMix value) {
    return merge(StadiumBorderMix.side(value));
  }

  @override
  StadiumBorder resolve(BuildContext context) {
    return StadiumBorder(
      side: MixOps.resolve(context, $side) ?? BorderSide.none,
    );
  }

  @override
  StadiumBorderMix merge(StadiumBorderMix? other) {
    if (other == null) return this;

    return StadiumBorderMix.raw(side: $side.tryMerge(other.$side));
  }

  @override
  List<Object?> get props => [$side];
}

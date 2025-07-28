// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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

  static RoundedRectangleBorderMix? maybeValue(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderMix.value(border) : null;
  }

  @override
  RoundedRectangleBorder resolve(BuildContext context) {
    return RoundedRectangleBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedRectangleBorderMix mergeShapeBorder(RoundedRectangleBorderMix other) {
    return RoundedRectangleBorderMix.raw(
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      side: MixHelpers.merge($side, other.$side),
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

  static BeveledRectangleBorderMix? maybeValue(BeveledRectangleBorder? border) {
    return border != null ? BeveledRectangleBorderMix.value(border) : null;
  }

  @override
  BeveledRectangleBorder resolve(BuildContext context) {
    return BeveledRectangleBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  BeveledRectangleBorderMix mergeShapeBorder(BeveledRectangleBorderMix other) {
    return BeveledRectangleBorderMix.raw(
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      side: MixHelpers.merge($side, other.$side),
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

  static ContinuousRectangleBorderMix? maybeValue(
    ContinuousRectangleBorder? border,
  ) {
    return border != null ? ContinuousRectangleBorderMix.value(border) : null;
  }

  @override
  ContinuousRectangleBorder resolve(BuildContext context) {
    return ContinuousRectangleBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  ContinuousRectangleBorderMix mergeShapeBorder(
    ContinuousRectangleBorderMix other,
  ) {
    return ContinuousRectangleBorderMix.raw(
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      side: MixHelpers.merge($side, other.$side),
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

  static CircleBorderMix? maybeValue(CircleBorder? border) {
    return border != null ? CircleBorderMix.value(border) : null;
  }

  @override
  CircleBorder resolve(BuildContext context) {
    return CircleBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      eccentricity: MixHelpers.resolve(context, $eccentricity) ?? 0.0,
    );
  }

  @override
  CircleBorderMix mergeShapeBorder(CircleBorderMix other) {
    return CircleBorderMix.raw(
      side: MixHelpers.merge($side, other.$side),
      eccentricity: MixHelpers.merge($eccentricity, other.$eccentricity),
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
    return mergeShapeBorder(StarBorderMix(points: value));
  }

  /// Returns a copy with the specified inner radius ratio.
  StarBorderMix innerRadiusRatio(double value) {
    return mergeShapeBorder(StarBorderMix(innerRadiusRatio: value));
  }

  /// Returns a copy with the specified point rounding.
  StarBorderMix pointRounding(double value) {
    return mergeShapeBorder(StarBorderMix(pointRounding: value));
  }

  /// Returns a copy with the specified valley rounding.
  StarBorderMix valleyRounding(double value) {
    return mergeShapeBorder(StarBorderMix(valleyRounding: value));
  }

  /// Returns a copy with the specified rotation.
  StarBorderMix rotation(double value) {
    return mergeShapeBorder(StarBorderMix(rotation: value));
  }

  /// Returns a copy with the specified squash factor.
  StarBorderMix squash(double value) {
    return mergeShapeBorder(StarBorderMix(squash: value));
  }

  /// Returns a copy with the specified border side.
  StarBorderMix side(BorderSideMix value) {
    return mergeShapeBorder(StarBorderMix(side: value));
  }

  @override
  StarBorder resolve(BuildContext context) {
    return StarBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      points: MixHelpers.resolve(context, $points) ?? 5,
      innerRadiusRatio: MixHelpers.resolve(context, $innerRadiusRatio) ?? 0.4,
      pointRounding: MixHelpers.resolve(context, $pointRounding) ?? 0,
      valleyRounding: MixHelpers.resolve(context, $valleyRounding) ?? 0,
      rotation: MixHelpers.resolve(context, $rotation) ?? 0,
      squash: MixHelpers.resolve(context, $squash) ?? 0,
    );
  }

  @override
  StarBorderMix mergeShapeBorder(StarBorderMix other) {
    return StarBorderMix.raw(
      side: MixHelpers.merge($side, other.$side),
      points: MixHelpers.merge($points, other.$points),
      innerRadiusRatio: MixHelpers.merge(
        $innerRadiusRatio,
        other.$innerRadiusRatio,
      ),
      pointRounding: MixHelpers.merge($pointRounding, other.$pointRounding),
      valleyRounding: MixHelpers.merge($valleyRounding, other.$valleyRounding),
      rotation: MixHelpers.merge($rotation, other.$rotation),
      squash: MixHelpers.merge($squash, other.$squash),
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
    return mergeShapeBorder(LinearBorderMix(start: value));
  }

  /// Returns a copy with the specified end edge.
  LinearBorderMix end(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix(end: value));
  }

  /// Returns a copy with the specified top edge.
  LinearBorderMix top(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix(top: value));
  }

  /// Returns a copy with the specified bottom edge.
  LinearBorderMix bottom(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix(bottom: value));
  }

  /// Returns a copy with the specified border side.
  LinearBorderMix side(BorderSideMix value) {
    return mergeShapeBorder(LinearBorderMix(side: value));
  }

  @override
  LinearBorder resolve(BuildContext context) {
    return LinearBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      start: MixHelpers.resolve(context, $start),
      end: MixHelpers.resolve(context, $end),
      top: MixHelpers.resolve(context, $top),
      bottom: MixHelpers.resolve(context, $bottom),
    );
  }

  @override
  LinearBorderMix mergeShapeBorder(LinearBorderMix other) {
    return LinearBorderMix.raw(
      side: MixHelpers.merge($side, other.$side),
      start: MixHelpers.merge($start, other.$start),
      end: MixHelpers.merge($end, other.$end),
      top: MixHelpers.merge($top, other.$top),
      bottom: MixHelpers.merge($bottom, other.$bottom),
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
    return merge(LinearBorderEdgeMix(size: value));
  }

  /// Returns a copy with the specified alignment.
  LinearBorderEdgeMix alignment(double value) {
    return merge(LinearBorderEdgeMix(alignment: value));
  }

  @override
  LinearBorderEdge resolve(BuildContext context) {
    return LinearBorderEdge(
      size: MixHelpers.resolve(context, $size) ?? 1.0,
      alignment: MixHelpers.resolve(context, $alignment) ?? 0.0,
    );
  }

  @override
  LinearBorderEdgeMix merge(LinearBorderEdgeMix? other) {
    if (other == null) return this;

    return LinearBorderEdgeMix.raw(
      size: MixHelpers.merge($size, other.$size),
      alignment: MixHelpers.merge($alignment, other.$alignment),
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
    return mergeShapeBorder(StadiumBorderMix(side: value));
  }

  @override
  StadiumBorder resolve(BuildContext context) {
    return StadiumBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
    );
  }

  @override
  StadiumBorderMix mergeShapeBorder(StadiumBorderMix other) {
    return StadiumBorderMix.raw(side: MixHelpers.merge($side, other.$side));
  }

  @override
  List<Object?> get props => [$side];
}

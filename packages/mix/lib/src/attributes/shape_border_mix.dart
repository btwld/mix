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
  final MixProp<BorderSide>? $side;

  const OutlinedBorderMix({MixProp<BorderSide>? side}) : $side = side;
}

final class RoundedRectangleBorderMix
    extends OutlinedBorderMix<RoundedRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  RoundedRectangleBorderMix.only({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );
  const RoundedRectangleBorderMix({
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  }) : $borderRadius = borderRadius,
       super(side: side);

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
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  RoundedRectangleBorderMix mergeShapeBorder(RoundedRectangleBorderMix other) {
    return RoundedRectangleBorderMix(
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      side: MixHelpers.merge($side, other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

final class BeveledRectangleBorderMix
    extends OutlinedBorderMix<BeveledRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  BeveledRectangleBorderMix.only({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const BeveledRectangleBorderMix({
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  }) : $borderRadius = borderRadius,
       super(side: side);

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
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  BeveledRectangleBorderMix mergeShapeBorder(BeveledRectangleBorderMix other) {
    return BeveledRectangleBorderMix(
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      side: MixHelpers.merge($side, other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

final class ContinuousRectangleBorderMix
    extends OutlinedBorderMix<ContinuousRectangleBorder> {
  final MixProp<BorderRadiusGeometry>? $borderRadius;

  ContinuousRectangleBorderMix.only({
    BorderRadiusGeometryMix? borderRadius,
    BorderSideMix? side,
  }) : this(
         borderRadius: MixProp.maybe(borderRadius),
         side: MixProp.maybe(side),
       );

  const ContinuousRectangleBorderMix({
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  }) : $borderRadius = borderRadius,
       super(side: side);

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
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      borderRadius:
          MixHelpers.resolve(context, $borderRadius) ?? BorderRadius.zero,
    );
  }

  @override
  ContinuousRectangleBorderMix mergeShapeBorder(
    ContinuousRectangleBorderMix other,
  ) {
    return ContinuousRectangleBorderMix(
      borderRadius: MixHelpers.merge($borderRadius, other.$borderRadius),
      side: MixHelpers.merge($side, other.$side),
    );
  }

  @override
  List<Object?> get props => [$borderRadius, $side];
}

final class CircleBorderMix extends OutlinedBorderMix<CircleBorder> {
  final Prop<double>? $eccentricity;

  CircleBorderMix.only({BorderSideMix? side, double? eccentricity})
    : this(side: MixProp.maybe(side), eccentricity: Prop.maybe(eccentricity));

  const CircleBorderMix({MixProp<BorderSide>? side, Prop<double>? eccentricity})
    : $eccentricity = eccentricity,
      super(side: side);

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
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
      eccentricity: MixHelpers.resolve(context, $eccentricity) ?? 0.0,
    );
  }

  @override
  CircleBorderMix mergeShapeBorder(CircleBorderMix other) {
    return CircleBorderMix(
      side: MixHelpers.merge($side, other.$side),
      eccentricity: MixHelpers.merge($eccentricity, other.$eccentricity),
    );
  }

  @override
  List<Object?> get props => [$side, $eccentricity];
}

final class StarBorderMix extends OutlinedBorderMix<StarBorder> {
  final Prop<double>? $points;
  final Prop<double>? $innerRadiusRatio;
  final Prop<double>? $pointRounding;
  final Prop<double>? $valleyRounding;
  final Prop<double>? $rotation;
  final Prop<double>? $squash;

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
    MixProp<BorderSide>? side,
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
       $squash = squash,
       super(side: side);

  factory StarBorderMix.points(double value) {
    return StarBorderMix.only(points: value);
  }

  factory StarBorderMix.innerRadiusRatio(double value) {
    return StarBorderMix.only(innerRadiusRatio: value);
  }

  factory StarBorderMix.pointRounding(double value) {
    return StarBorderMix.only(pointRounding: value);
  }

  factory StarBorderMix.valleyRounding(double value) {
    return StarBorderMix.only(valleyRounding: value);
  }

  factory StarBorderMix.rotation(double value) {
    return StarBorderMix.only(rotation: value);
  }

  factory StarBorderMix.squash(double value) {
    return StarBorderMix.only(squash: value);
  }

  factory StarBorderMix.side(BorderSideMix value) {
    return StarBorderMix.only(side: value);
  }

  static StarBorderMix? maybeValue(StarBorder? border) {
    return border != null ? StarBorderMix.value(border) : null;
  }

  /// Creates a new [StarBorderMix] with the provided points,
  /// merging it with the current instance.
  StarBorderMix points(double value) {
    return mergeShapeBorder(StarBorderMix.only(points: value));
  }

  /// Creates a new [StarBorderMix] with the provided innerRadiusRatio,
  /// merging it with the current instance.
  StarBorderMix innerRadiusRatio(double value) {
    return mergeShapeBorder(StarBorderMix.only(innerRadiusRatio: value));
  }

  /// Creates a new [StarBorderMix] with the provided pointRounding,
  /// merging it with the current instance.
  StarBorderMix pointRounding(double value) {
    return mergeShapeBorder(StarBorderMix.only(pointRounding: value));
  }

  /// Creates a new [StarBorderMix] with the provided valleyRounding,
  /// merging it with the current instance.
  StarBorderMix valleyRounding(double value) {
    return mergeShapeBorder(StarBorderMix.only(valleyRounding: value));
  }

  /// Creates a new [StarBorderMix] with the provided rotation,
  /// merging it with the current instance.
  StarBorderMix rotation(double value) {
    return mergeShapeBorder(StarBorderMix.only(rotation: value));
  }

  /// Creates a new [StarBorderMix] with the provided squash,
  /// merging it with the current instance.
  StarBorderMix squash(double value) {
    return mergeShapeBorder(StarBorderMix.only(squash: value));
  }

  /// Creates a new [StarBorderMix] with the provided side,
  /// merging it with the current instance.
  StarBorderMix side(BorderSideMix value) {
    return mergeShapeBorder(StarBorderMix.only(side: value));
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
    return StarBorderMix(
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

final class LinearBorderMix extends OutlinedBorderMix<LinearBorder> {
  final MixProp<LinearBorderEdge>? $start;
  final MixProp<LinearBorderEdge>? $end;
  final MixProp<LinearBorderEdge>? $top;
  final MixProp<LinearBorderEdge>? $bottom;

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
    MixProp<BorderSide>? side,
    MixProp<LinearBorderEdge>? start,
    MixProp<LinearBorderEdge>? end,
    MixProp<LinearBorderEdge>? top,
    MixProp<LinearBorderEdge>? bottom,
  }) : $start = start,
       $end = end,
       $top = top,
       $bottom = bottom,
       super(side: side);

  LinearBorderMix.value(LinearBorder border)
    : this.only(
        side: BorderSideMix.maybeValue(border.side),
        start: LinearBorderEdgeMix.maybeValue(border.start),
        end: LinearBorderEdgeMix.maybeValue(border.end),
        top: LinearBorderEdgeMix.maybeValue(border.top),
        bottom: LinearBorderEdgeMix.maybeValue(border.bottom),
      );

  factory LinearBorderMix.start(LinearBorderEdgeMix value) {
    return LinearBorderMix.only(start: value);
  }

  factory LinearBorderMix.end(LinearBorderEdgeMix value) {
    return LinearBorderMix.only(end: value);
  }

  factory LinearBorderMix.top(LinearBorderEdgeMix value) {
    return LinearBorderMix.only(top: value);
  }

  factory LinearBorderMix.bottom(LinearBorderEdgeMix value) {
    return LinearBorderMix.only(bottom: value);
  }

  factory LinearBorderMix.side(BorderSideMix value) {
    return LinearBorderMix.only(side: value);
  }

  static LinearBorderMix? maybeValue(LinearBorder? border) {
    return border != null ? LinearBorderMix.value(border) : null;
  }

  /// Creates a new [LinearBorderMix] with the provided start,
  /// merging it with the current instance.
  LinearBorderMix start(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix.only(start: value));
  }

  /// Creates a new [LinearBorderMix] with the provided end,
  /// merging it with the current instance.
  LinearBorderMix end(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix.only(end: value));
  }

  /// Creates a new [LinearBorderMix] with the provided top,
  /// merging it with the current instance.
  LinearBorderMix top(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix.only(top: value));
  }

  /// Creates a new [LinearBorderMix] with the provided bottom,
  /// merging it with the current instance.
  LinearBorderMix bottom(LinearBorderEdgeMix value) {
    return mergeShapeBorder(LinearBorderMix.only(bottom: value));
  }

  /// Creates a new [LinearBorderMix] with the provided side,
  /// merging it with the current instance.
  LinearBorderMix side(BorderSideMix value) {
    return mergeShapeBorder(LinearBorderMix.only(side: value));
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
    return LinearBorderMix(
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

final class LinearBorderEdgeMix extends Mix<LinearBorderEdge> {
  final Prop<double>? $size;
  final Prop<double>? $alignment;

  LinearBorderEdgeMix.only({double? size, double? alignment})
    : this(size: Prop.maybe(size), alignment: Prop.maybe(alignment));
  LinearBorderEdgeMix.value(LinearBorderEdge edge)
    : this.only(size: edge.size, alignment: edge.alignment);
  const LinearBorderEdgeMix({Prop<double>? size, Prop<double>? alignment})
    : $size = size,
      $alignment = alignment;

  factory LinearBorderEdgeMix.size(double value) {
    return LinearBorderEdgeMix.only(size: value);
  }

  factory LinearBorderEdgeMix.alignment(double value) {
    return LinearBorderEdgeMix.only(alignment: value);
  }

  static LinearBorderEdgeMix? maybeValue(LinearBorderEdge? edge) {
    return edge != null ? LinearBorderEdgeMix.value(edge) : null;
  }

  /// Creates a new [LinearBorderEdgeMix] with the provided size,
  /// merging it with the current instance.
  LinearBorderEdgeMix size(double value) {
    return merge(LinearBorderEdgeMix.only(size: value));
  }

  /// Creates a new [LinearBorderEdgeMix] with the provided alignment,
  /// merging it with the current instance.
  LinearBorderEdgeMix alignment(double value) {
    return merge(LinearBorderEdgeMix.only(alignment: value));
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

    return LinearBorderEdgeMix(
      size: MixHelpers.merge($size, other.$size),
      alignment: MixHelpers.merge($alignment, other.$alignment),
    );
  }

  @override
  List<Object?> get props => [$size, $alignment];
}

final class StadiumBorderMix extends OutlinedBorderMix<StadiumBorder> {
  StadiumBorderMix.only({BorderSideMix? side})
    : this(side: MixProp.maybe(side));

  const StadiumBorderMix({super.side});

  StadiumBorderMix.value(StadiumBorder border)
    : this.only(side: BorderSideMix.maybeValue(border.side));

  factory StadiumBorderMix.side(BorderSideMix value) {
    return StadiumBorderMix.only(side: value);
  }

  static StadiumBorderMix? maybeValue(StadiumBorder? border) {
    return border != null ? StadiumBorderMix.value(border) : null;
  }

  /// Creates a new [StadiumBorderMix] with the provided side,
  /// merging it with the current instance.
  StadiumBorderMix side(BorderSideMix value) {
    return mergeShapeBorder(StadiumBorderMix.only(side: value));
  }

  @override
  StadiumBorder resolve(BuildContext context) {
    return StadiumBorder(
      side: MixHelpers.resolve(context, $side) ?? BorderSide.none,
    );
  }

  @override
  StadiumBorderMix mergeShapeBorder(StadiumBorderMix other) {
    return StadiumBorderMix(side: MixHelpers.merge($side, other.$side));
  }

  @override
  List<Object?> get props => [$side];
}

import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'border_mix.dart';
import 'border_radius_mix.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'shape_border_mix.dart';

/// Utility class for configuring [RoundedRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [RoundedRectangleBorder].
/// Use the methods of this class to configure specific properties of a [RoundedRectangleBorder].
final class RoundedRectangleBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, RoundedRectangleBorder> {
  /// Utility for defining [RoundedRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => onlyProps(borderRadius: v),
  );

  /// Utility for defining [RoundedRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  RoundedRectangleBorderUtility(super.builder)
    : super(convertToMix: RoundedRectangleBorderMix.value);

  @protected
  T onlyProps({
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  }) {
    return builder(
      MixProp(
        RoundedRectangleBorderMix.raw(borderRadius: borderRadius, side: side),
      ),
    );
  }

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return onlyProps(
      borderRadius: MixProp.maybe(borderRadius),
      side: MixProp.maybe(side),
    );
  }

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return only(borderRadius: borderRadius, side: side);
  }

  T mix(RoundedRectangleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [BeveledRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [BeveledRectangleBorder].
/// Use the methods of this class to configure specific properties of a [BeveledRectangleBorder].
final class BeveledRectangleBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => onlyProps(borderRadius: v),
  );

  /// Utility for defining [BeveledRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  BeveledRectangleBorderUtility(super.builder)
    : super(convertToMix: BeveledRectangleBorderMix.value);

  @protected
  T onlyProps({
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  }) {
    return builder(
      MixProp(
        BeveledRectangleBorderMix.raw(borderRadius: borderRadius, side: side),
      ),
    );
  }

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return onlyProps(
      borderRadius: MixProp.maybe(borderRadius),
      side: MixProp.maybe(side),
    );
  }

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return only(borderRadius: borderRadius, side: side);
  }

  T mix(BeveledRectangleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [ContinuousRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [ContinuousRectangleBorder].
/// Use the methods of this class to configure specific properties of a [ContinuousRectangleBorder].
final class ContinuousRectangleBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, ContinuousRectangleBorder> {
  /// Utility for defining [ContinuousRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => onlyProps(borderRadius: v),
  );

  /// Utility for defining [ContinuousRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  ContinuousRectangleBorderUtility(super.builder)
    : super(convertToMix: ContinuousRectangleBorderMix.value);

  @protected
  T onlyProps({
    MixProp<BorderRadiusGeometry>? borderRadius,
    MixProp<BorderSide>? side,
  }) {
    return builder(
      MixProp(
        ContinuousRectangleBorderMix.raw(
          borderRadius: borderRadius,
          side: side,
        ),
      ),
    );
  }

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return onlyProps(
      borderRadius: MixProp.maybe(borderRadius),
      side: MixProp.maybe(side),
    );
  }

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return only(borderRadius: borderRadius, side: side);
  }

  T mix(ContinuousRectangleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
final class CircleBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, CircleBorder> {
  /// Utility for defining [CircleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  /// Utility for defining [CircleBorderMix.eccentricity]
  late final eccentricity = PropUtility<T, double>(
    (prop) => onlyProps(eccentricity: prop),
  );

  CircleBorderUtility(super.builder)
    : super(convertToMix: CircleBorderMix.value);

  @protected
  T onlyProps({MixProp<BorderSide>? side, Prop<double>? eccentricity}) {
    return builder(
      MixProp(CircleBorderMix.raw(side: side, eccentricity: eccentricity)),
    );
  }

  T only({BorderSideMix? side, double? eccentricity}) {
    return onlyProps(
      side: MixProp.maybe(side),
      eccentricity: Prop.maybe(eccentricity),
    );
  }

  T call({BorderSideMix? side, double? eccentricity}) {
    return only(side: side, eccentricity: eccentricity);
  }

  T mix(CircleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [StarBorder] properties.
///
/// This class provides methods to set individual properties of a [StarBorder].
/// Use the methods of this class to configure specific properties of a [StarBorder].
final class StarBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StarBorder> {
  /// Utility for defining [StarBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  /// Utility for defining [StarBorderMix.points]
  late final points = PropUtility<T, double>((prop) => onlyProps(points: prop));

  /// Utility for defining [StarBorderMix.innerRadiusRatio]
  late final innerRadiusRatio = PropUtility<T, double>(
    (prop) => onlyProps(innerRadiusRatio: prop),
  );

  /// Utility for defining [StarBorderMix.pointRounding]
  late final pointRounding = PropUtility<T, double>(
    (prop) => onlyProps(pointRounding: prop),
  );

  /// Utility for defining [StarBorderMix.valleyRounding]
  late final valleyRounding = PropUtility<T, double>(
    (prop) => onlyProps(valleyRounding: prop),
  );

  /// Utility for defining [StarBorderMix.rotation]
  late final rotation = PropUtility<T, double>(
    (prop) => onlyProps(rotation: prop),
  );

  /// Utility for defining [StarBorderMix.squash]
  late final squash = PropUtility<T, double>((prop) => onlyProps(squash: prop));

  StarBorderUtility(super.builder) : super(convertToMix: StarBorderMix.value);

  @protected
  T onlyProps({
    MixProp<BorderSide>? side,
    Prop<double>? points,
    Prop<double>? innerRadiusRatio,
    Prop<double>? pointRounding,
    Prop<double>? valleyRounding,
    Prop<double>? rotation,
    Prop<double>? squash,
  }) {
    return builder(
      MixProp(
        StarBorderMix.raw(
          side: side,
          points: points,
          innerRadiusRatio: innerRadiusRatio,
          pointRounding: pointRounding,
          valleyRounding: valleyRounding,
          rotation: rotation,
          squash: squash,
        ),
      ),
    );
  }

  T only({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return onlyProps(
      side: MixProp.maybe(side),
      points: Prop.maybe(points),
      innerRadiusRatio: Prop.maybe(innerRadiusRatio),
      pointRounding: Prop.maybe(pointRounding),
      valleyRounding: Prop.maybe(valleyRounding),
      rotation: Prop.maybe(rotation),
      squash: Prop.maybe(squash),
    );
  }

  T call({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return only(
      side: side,
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }

  T mix(StarBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [LinearBorder] properties.
///
/// This class provides methods to set individual properties of a [LinearBorder].
/// Use the methods of this class to configure specific properties of a [LinearBorder].
final class LinearBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, LinearBorder> {
  /// Utility for defining [LinearBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  /// Utility for defining [LinearBorderMix.start]
  late final start = LinearBorderEdgeUtility<T>((v) => onlyProps(start: v));

  /// Utility for defining [LinearBorderMix.end]
  late final end = LinearBorderEdgeUtility<T>((v) => onlyProps(end: v));

  /// Utility for defining [LinearBorderMix.top]
  late final top = LinearBorderEdgeUtility<T>((v) => onlyProps(top: v));

  /// Utility for defining [LinearBorderMix.bottom]
  late final bottom = LinearBorderEdgeUtility<T>((v) => onlyProps(bottom: v));

  LinearBorderUtility(super.builder)
    : super(convertToMix: LinearBorderMix.value);

  @protected
  T onlyProps({
    MixProp<BorderSide>? side,
    MixProp<LinearBorderEdge>? start,
    MixProp<LinearBorderEdge>? end,
    MixProp<LinearBorderEdge>? top,
    MixProp<LinearBorderEdge>? bottom,
  }) {
    return builder(
      MixProp(
        LinearBorderMix.raw(
          side: side,
          start: start,
          end: end,
          top: top,
          bottom: bottom,
        ),
      ),
    );
  }

  T only({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) {
    return onlyProps(
      side: MixProp.maybe(side),
      start: MixProp.maybe(start),
      end: MixProp.maybe(end),
      top: MixProp.maybe(top),
      bottom: MixProp.maybe(bottom),
    );
  }

  T call({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) {
    return only(side: side, start: start, end: end, top: top, bottom: bottom);
  }

  T mix(LinearBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
final class LinearBorderEdgeUtility<T extends Style<Object?>>
    extends MixPropUtility<T, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeMix.size]
  late final size = PropUtility<T, double>((prop) => onlyProps(size: prop));

  /// Utility for defining [LinearBorderEdgeMix.alignment]
  late final alignment = PropUtility<T, double>(
    (prop) => onlyProps(alignment: prop),
  );

  LinearBorderEdgeUtility(super.builder)
    : super(convertToMix: LinearBorderEdgeMix.value);

  @protected
  T onlyProps({Prop<double>? size, Prop<double>? alignment}) {
    return builder(
      MixProp(LinearBorderEdgeMix.raw(size: size, alignment: alignment)),
    );
  }

  T only({double? size, double? alignment}) {
    return onlyProps(size: Prop.maybe(size), alignment: Prop.maybe(alignment));
  }

  T call({double? size, double? alignment}) {
    return only(size: size, alignment: alignment);
  }

  T mix(LinearBorderEdgeMix value) => builder(MixProp(value));
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
final class StadiumBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StadiumBorder> {
  /// Utility for defining [StadiumBorderMix.side]
  late final side = BorderSideUtility<T>((v) => onlyProps(side: v));

  StadiumBorderUtility(super.builder)
    : super(convertToMix: StadiumBorderMix.value);

  @protected
  T onlyProps({MixProp<BorderSide>? side}) {
    return builder(MixProp(StadiumBorderMix.raw(side: side)));
  }

  T only({BorderSideMix? side}) {
    return onlyProps(side: MixProp.maybe(side));
  }

  T call({BorderSideMix? side}) {
    return only(side: side);
  }

  T mix(StadiumBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [ShapeBorder] properties.
///
/// This class provides methods to set individual properties of a [ShapeBorder].
/// Use the methods of this class to configure specific properties of a [ShapeBorder].
final class ShapeBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, ShapeBorder> {
  /// Utility for defining RoundedRectangleBorder
  late final roundedRectangle = RoundedRectangleBorderUtility<T>(builder);

  /// Utility for defining BeveledRectangleBorder
  late final beveled = BeveledRectangleBorderUtility<T>(builder);

  /// Utility for defining ContinuousRectangleBorder
  late final continuous = ContinuousRectangleBorderUtility<T>(builder);

  /// Utility for defining CircleBorder
  late final circle = CircleBorderUtility<T>(builder);

  /// Utility for defining StarBorder
  late final star = StarBorderUtility<T>(builder);

  /// Utility for defining LinearBorder
  late final linear = LinearBorderUtility<T>(builder);

  /// Utility for defining StadiumBorder
  late final stadium = StadiumBorderUtility<T>(builder);

  ShapeBorderUtility(super.builder) : super(convertToMix: ShapeBorderMix.value);
}

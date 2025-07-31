import 'package:flutter/widgets.dart';

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
    extends
        MixPropUtility<T, RoundedRectangleBorderMix, RoundedRectangleBorder> {
  /// Utility for defining [RoundedRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [RoundedRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  RoundedRectangleBorderUtility(super.builder);

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return builder(
      RoundedRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return only(borderRadius: borderRadius, side: side);
  }

  @override
  T as(RoundedRectangleBorder value) {
    return builder(RoundedRectangleBorderMix.value(value));
  }
}

/// Utility class for configuring [BeveledRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [BeveledRectangleBorder].
/// Use the methods of this class to configure specific properties of a [BeveledRectangleBorder].
final class BeveledRectangleBorderUtility<T extends Style<Object?>>
    extends
        MixPropUtility<T, BeveledRectangleBorderMix, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [BeveledRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  BeveledRectangleBorderUtility(super.builder);

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return builder(
      BeveledRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return only(borderRadius: borderRadius, side: side);
  }

  @override
  T as(BeveledRectangleBorder value) {
    return builder(BeveledRectangleBorderMix.value(value));
  }
}

/// Utility class for configuring [ContinuousRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [ContinuousRectangleBorder].
/// Use the methods of this class to configure specific properties of a [ContinuousRectangleBorder].
final class ContinuousRectangleBorderUtility<T extends Style<Object?>>
    extends
        MixPropUtility<
          T,
          ContinuousRectangleBorderMix,
          ContinuousRectangleBorder
        > {
  /// Utility for defining [ContinuousRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [ContinuousRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  ContinuousRectangleBorderUtility(super.builder);

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return builder(
      ContinuousRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return only(borderRadius: borderRadius, side: side);
  }

  @override
  T as(ContinuousRectangleBorder value) {
    return builder(ContinuousRectangleBorderMix.value(value));
  }
}

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
final class CircleBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, CircleBorderMix, CircleBorder> {
  /// Utility for defining [CircleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  /// Utility for defining [CircleBorderMix.eccentricity]
  late final eccentricity = MixUtility<T, double>(
    (prop) => only(eccentricity: prop),
  );

  CircleBorderUtility(super.builder);

  T only({BorderSideMix? side, double? eccentricity}) {
    return builder(CircleBorderMix(side: side, eccentricity: eccentricity));
  }

  T call({BorderSideMix? side, double? eccentricity}) {
    return only(side: side, eccentricity: eccentricity);
  }

  @override
  T as(CircleBorder value) {
    return builder(CircleBorderMix.value(value));
  }
}

/// Utility class for configuring [StarBorder] properties.
///
/// This class provides methods to set individual properties of a [StarBorder].
/// Use the methods of this class to configure specific properties of a [StarBorder].
final class StarBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StarBorderMix, StarBorder> {
  /// Utility for defining [StarBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  /// Utility for defining [StarBorderMix.points]
  late final points = MixUtility<T, double>((prop) => only(points: prop));

  /// Utility for defining [StarBorderMix.innerRadiusRatio]
  late final innerRadiusRatio = MixUtility<T, double>(
    (prop) => only(innerRadiusRatio: prop),
  );

  /// Utility for defining [StarBorderMix.pointRounding]
  late final pointRounding = MixUtility<T, double>(
    (prop) => only(pointRounding: prop),
  );

  /// Utility for defining [StarBorderMix.valleyRounding]
  late final valleyRounding = MixUtility<T, double>(
    (prop) => only(valleyRounding: prop),
  );

  /// Utility for defining [StarBorderMix.rotation]
  late final rotation = MixUtility<T, double>((prop) => only(rotation: prop));

  /// Utility for defining [StarBorderMix.squash]
  late final squash = MixUtility<T, double>((prop) => only(squash: prop));

  StarBorderUtility(super.builder);

  T only({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return builder(
      StarBorderMix(
        side: side,
        points: points,
        innerRadiusRatio: innerRadiusRatio,
        pointRounding: pointRounding,
        valleyRounding: valleyRounding,
        rotation: rotation,
        squash: squash,
      ),
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

  @override
  T as(StarBorder value) {
    return builder(StarBorderMix.value(value));
  }
}

/// Utility class for configuring [LinearBorder] properties.
///
/// This class provides methods to set individual properties of a [LinearBorder].
/// Use the methods of this class to configure specific properties of a [LinearBorder].
final class LinearBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, LinearBorderMix, LinearBorder> {
  /// Utility for defining [LinearBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  /// Utility for defining [LinearBorderMix.start]
  late final start = LinearBorderEdgeUtility<T>((v) => only(start: v));

  /// Utility for defining [LinearBorderMix.end]
  late final end = LinearBorderEdgeUtility<T>((v) => only(end: v));

  /// Utility for defining [LinearBorderMix.top]
  late final top = LinearBorderEdgeUtility<T>((v) => only(top: v));

  /// Utility for defining [LinearBorderMix.bottom]
  late final bottom = LinearBorderEdgeUtility<T>((v) => only(bottom: v));

  LinearBorderUtility(super.builder);

  T only({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) {
    return builder(
      LinearBorderMix(
        side: side,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
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

  @override
  T as(LinearBorder value) {
    return builder(LinearBorderMix.value(value));
  }
}

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
final class LinearBorderEdgeUtility<T extends Style<Object?>>
    extends MixPropUtility<T, LinearBorderEdgeMix, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeMix.size]
  late final size = MixUtility<T, double>((prop) => only(size: prop));

  /// Utility for defining [LinearBorderEdgeMix.alignment]
  late final alignment = MixUtility<T, double>((prop) => only(alignment: prop));

  LinearBorderEdgeUtility(super.builder);

  T only({double? size, double? alignment}) {
    return builder(LinearBorderEdgeMix(size: size, alignment: alignment));
  }

  T call({double? size, double? alignment}) {
    return only(size: size, alignment: alignment);
  }

  @override
  T as(LinearBorderEdge value) {
    return builder(LinearBorderEdgeMix.value(value));
  }
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
final class StadiumBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, StadiumBorderMix, StadiumBorder> {
  /// Utility for defining [StadiumBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  StadiumBorderUtility(super.builder);

  T only({BorderSideMix? side}) {
    return builder(StadiumBorderMix(side: side));
  }

  T call({BorderSideMix? side}) {
    return only(side: side);
  }

  @override
  T as(StadiumBorder value) {
    return builder(StadiumBorderMix.value(value));
  }
}

/// Utility class for configuring [ShapeBorder] properties.
///
/// This class provides methods to set individual properties of a [ShapeBorder].
/// Use the methods of this class to configure specific properties of a [ShapeBorder].
final class ShapeBorderUtility<T extends Style<Object?>>
    extends MixPropUtility<T, ShapeBorderMix<ShapeBorder>, ShapeBorder> {
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

  ShapeBorderUtility(super.builder);
  @override
  T as(ShapeBorder value) {
    return builder(ShapeBorderMix.value(value));
  }
}

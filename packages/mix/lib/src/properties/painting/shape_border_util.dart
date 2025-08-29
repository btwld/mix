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
    extends MixUtility<T, RoundedRectangleBorderMix> {
  /// Utility for defining [RoundedRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(borderRadius: v),
  );

  /// Utility for defining [RoundedRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(side: v));

  RoundedRectangleBorderUtility(super.utilityBuilder);

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return utilityBuilder(
      RoundedRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return utilityBuilder(
      RoundedRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T as(RoundedRectangleBorder value) {
    return utilityBuilder(RoundedRectangleBorderMix.value(value));
  }
}

/// Utility class for configuring [BeveledRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [BeveledRectangleBorder].
/// Use the methods of this class to configure specific properties of a [BeveledRectangleBorder].
final class BeveledRectangleBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, BeveledRectangleBorderMix> {
  /// Utility for defining [BeveledRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(borderRadius: v),
  );

  /// Utility for defining [BeveledRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(side: v));

  BeveledRectangleBorderUtility(super.utilityBuilder);

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return utilityBuilder(
      BeveledRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return utilityBuilder(
      BeveledRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T as(BeveledRectangleBorder value) {
    return utilityBuilder(BeveledRectangleBorderMix.value(value));
  }
}

/// Utility class for configuring [ContinuousRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [ContinuousRectangleBorder].
/// Use the methods of this class to configure specific properties of a [ContinuousRectangleBorder].
final class ContinuousRectangleBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, ContinuousRectangleBorderMix> {
  /// Utility for defining [ContinuousRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(borderRadius: v),
  );

  /// Utility for defining [ContinuousRectangleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(side: v));

  ContinuousRectangleBorderUtility(super.utilityBuilder);

  T call({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return utilityBuilder(
      ContinuousRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T only({BorderRadiusGeometryMix? borderRadius, BorderSideMix? side}) {
    return utilityBuilder(
      ContinuousRectangleBorderMix(borderRadius: borderRadius, side: side),
    );
  }

  T as(ContinuousRectangleBorder value) {
    return utilityBuilder(ContinuousRectangleBorderMix.value(value));
  }
}

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
final class CircleBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, CircleBorderMix> {
  /// Utility for defining [CircleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(side: v));

  late final only = call;

  CircleBorderUtility(super.utilityBuilder);

  /// Utility for defining [CircleBorderMix.eccentricity]
  T eccentricity(double v) => call(eccentricity: v);

  T call({BorderSideMix? side, double? eccentricity}) {
    return utilityBuilder(
      CircleBorderMix(side: side, eccentricity: eccentricity),
    );
  }

  T as(CircleBorder value) {
    return utilityBuilder(CircleBorderMix.value(value));
  }
}

/// Utility class for configuring [StarBorder] properties.
///
/// This class provides methods to set individual properties of a [StarBorder].
/// Use the methods of this class to configure specific properties of a [StarBorder].
final class StarBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, StarBorderMix> {
  /// Utility for defining [StarBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(side: v));

  late final only = call;

  StarBorderUtility(super.utilityBuilder);

  /// Utility for defining [StarBorderMix.points]
  T points(double v) => call(points: v);

  /// Utility for defining [StarBorderMix.innerRadiusRatio]
  T innerRadiusRatio(double v) => call(innerRadiusRatio: v);

  /// Utility for defining [StarBorderMix.pointRounding]
  T pointRounding(double v) => call(pointRounding: v);

  /// Utility for defining [StarBorderMix.valleyRounding]
  T valleyRounding(double v) => call(valleyRounding: v);

  /// Utility for defining [StarBorderMix.rotation]
  T rotation(double v) => call(rotation: v);

  /// Utility for defining [StarBorderMix.squash]
  T squash(double v) => call(squash: v);

  T call({
    BorderSideMix? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return utilityBuilder(
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

  T as(StarBorder value) {
    return utilityBuilder(StarBorderMix.value(value));
  }
}

/// Utility class for configuring [LinearBorder] properties.
///
/// This class provides methods to set individual properties of a [LinearBorder].
/// Use the methods of this class to configure specific properties of a [LinearBorder].
final class LinearBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, LinearBorderMix> {
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

  LinearBorderUtility(super.utilityBuilder);

  T only({
    BorderSideMix? side,
    LinearBorderEdgeMix? start,
    LinearBorderEdgeMix? end,
    LinearBorderEdgeMix? top,
    LinearBorderEdgeMix? bottom,
  }) {
    return utilityBuilder(
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

  T as(LinearBorder value) {
    return utilityBuilder(LinearBorderMix.value(value));
  }
}

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
final class LinearBorderEdgeUtility<T extends Style<Object?>>
    extends MixUtility<T, LinearBorderEdgeMix> {
  late final only = call;

  LinearBorderEdgeUtility(super.utilityBuilder);

  /// Utility for defining [LinearBorderEdgeMix.size]
  T size(double v) => call(size: v);

  /// Utility for defining [LinearBorderEdgeMix.alignment]
  T alignment(double v) => call(alignment: v);

  T call({double? size, double? alignment}) {
    return utilityBuilder(
      LinearBorderEdgeMix(size: size, alignment: alignment),
    );
  }

  T as(LinearBorderEdge value) {
    return utilityBuilder(LinearBorderEdgeMix.value(value));
  }
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
final class StadiumBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, StadiumBorderMix> {
  /// Utility for defining [StadiumBorderMix.side]
  late final side = BorderSideUtility<T>((v) => only(side: v));

  StadiumBorderUtility(super.utilityBuilder);

  T only({BorderSideMix? side}) {
    return utilityBuilder(StadiumBorderMix(side: side));
  }

  T call({BorderSideMix? side}) {
    return only(side: side);
  }

  T as(StadiumBorder value) {
    return utilityBuilder(StadiumBorderMix.value(value));
  }
}

/// Utility class for configuring [ShapeBorder] properties.
///
/// This class provides methods to set individual properties of a [ShapeBorder].
/// Use the methods of this class to configure specific properties of a [ShapeBorder].
final class ShapeBorderUtility<T extends Style<Object?>>
    extends MixUtility<T, ShapeBorderMix<ShapeBorder>> {
  /// Utility for defining RoundedRectangleBorder
  late final roundedRectangle = RoundedRectangleBorderUtility<T>(
    utilityBuilder,
  );

  /// Utility for defining BeveledRectangleBorder
  late final beveled = BeveledRectangleBorderUtility<T>(utilityBuilder);

  /// Utility for defining ContinuousRectangleBorder
  late final continuous = ContinuousRectangleBorderUtility<T>(utilityBuilder);

  /// Utility for defining CircleBorder
  late final circle = CircleBorderUtility<T>(utilityBuilder);

  /// Utility for defining StarBorder
  late final star = StarBorderUtility<T>(utilityBuilder);

  /// Utility for defining LinearBorder
  late final linear = LinearBorderUtility<T>(utilityBuilder);

  /// Utility for defining StadiumBorder
  late final stadium = StadiumBorderUtility<T>(utilityBuilder);

  ShapeBorderUtility(super.utilityBuilder);
  T as(ShapeBorder value) {
    return utilityBuilder(ShapeBorderMix.value(value));
  }
}

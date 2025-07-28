import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'shape_border_mix.dart';

/// Utility class for configuring [RoundedRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [RoundedRectangleBorder].
/// Use the methods of this class to configure specific properties of a [RoundedRectangleBorder].
final class RoundedRectangleBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, RoundedRectangleBorder> {
  /// Utility for defining [RoundedRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(RoundedRectangleBorderMix.raw(borderRadius: v)),
  );

  /// Utility for defining [RoundedRectangleBorderMix.side]
  late final side = BorderSideUtility<T>(
    (v) => call(RoundedRectangleBorderMix.raw(side: v)),
  );

  RoundedRectangleBorderUtility(super.builder)
    : super(convertToMix: RoundedRectangleBorderMix.value);

  @override
  T call(RoundedRectangleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [BeveledRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [BeveledRectangleBorder].
/// Use the methods of this class to configure specific properties of a [BeveledRectangleBorder].
final class BeveledRectangleBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(BeveledRectangleBorderMix.raw(borderRadius: v)),
  );

  /// Utility for defining [BeveledRectangleBorderMix.side]
  late final side = BorderSideUtility<T>(
    (v) => call(BeveledRectangleBorderMix.raw(side: v)),
  );

  BeveledRectangleBorderUtility(super.builder)
    : super(convertToMix: BeveledRectangleBorderMix.value);

  @override
  T call(BeveledRectangleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [ContinuousRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [ContinuousRectangleBorder].
/// Use the methods of this class to configure specific properties of a [ContinuousRectangleBorder].
final class ContinuousRectangleBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, ContinuousRectangleBorder> {
  /// Utility for defining [ContinuousRectangleBorderMix.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(ContinuousRectangleBorderMix.raw(borderRadius: v)),
  );

  /// Utility for defining [ContinuousRectangleBorderMix.side]
  late final side = BorderSideUtility<T>(
    (v) => call(ContinuousRectangleBorderMix.raw(side: v)),
  );

  ContinuousRectangleBorderUtility(super.builder)
    : super(convertToMix: ContinuousRectangleBorderMix.value);

  @override
  T call(ContinuousRectangleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
final class CircleBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, CircleBorder> {
  /// Utility for defining [CircleBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(CircleBorderMix.raw(side: v)));

  /// Utility for defining [CircleBorderMix.eccentricity]
  late final eccentricity = PropUtility<T, double>(
    (prop) => call(CircleBorderMix.raw(eccentricity: prop),)
  );

  CircleBorderUtility(super.builder)
    : super(convertToMix: CircleBorderMix.value);

  @override
  T call(CircleBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [StarBorder] properties.
///
/// This class provides methods to set individual properties of a [StarBorder].
/// Use the methods of this class to configure specific properties of a [StarBorder].
final class StarBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, StarBorder> {
  /// Utility for defining [StarBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(StarBorderMix.raw(side: v)));

  /// Utility for defining [StarBorderMix.points]
  late final points = PropUtility<T, double>(
    (prop) => call(StarBorderMix.raw(points: prop),)
  );

  /// Utility for defining [StarBorderMix.innerRadiusRatio]
  late final innerRadiusRatio = PropUtility<T, double>(
    (prop) => call(StarBorderMix.raw(innerRadiusRatio: prop),)
  );

  /// Utility for defining [StarBorderMix.pointRounding]
  late final pointRounding = PropUtility<T, double>(
    (prop) => call(StarBorderMix.raw(pointRounding: prop),)
  );

  /// Utility for defining [StarBorderMix.valleyRounding]
  late final valleyRounding = PropUtility<T, double>(
    (prop) => call(StarBorderMix.raw(valleyRounding: prop),)
  );

  /// Utility for defining [StarBorderMix.rotation]
  late final rotation = PropUtility<T, double>(
    (prop) => call(StarBorderMix.raw(rotation: prop),)
  );

  /// Utility for defining [StarBorderMix.squash]
  late final squash = PropUtility<T, double>(
    (prop) => call(StarBorderMix.raw(squash: prop),)
  );

  StarBorderUtility(super.builder) : super(convertToMix: StarBorderMix.value);

  @override
  T call(StarBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [LinearBorder] properties.
///
/// This class provides methods to set individual properties of a [LinearBorder].
/// Use the methods of this class to configure specific properties of a [LinearBorder].
final class LinearBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, LinearBorder> {
  /// Utility for defining [LinearBorderMix.side]
  late final side = BorderSideUtility<T>((v) => call(LinearBorderMix.raw(side: v)));

  /// Utility for defining [LinearBorderMix.start]
  late final start = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderMix.raw(start: v)),
  );

  /// Utility for defining [LinearBorderMix.end]
  late final end = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderMix.raw(end: v)),
  );

  /// Utility for defining [LinearBorderMix.top]
  late final top = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderMix.raw(top: v)),
  );

  /// Utility for defining [LinearBorderMix.bottom]
  late final bottom = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderMix.raw(bottom: v)),
  );

  LinearBorderUtility(super.builder)
    : super(convertToMix: LinearBorderMix.value);

  @override
  T call(LinearBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
final class LinearBorderEdgeUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeMix.size]
  late final size = PropUtility<T, double>(
    (prop) => call(LinearBorderEdgeMix.raw(size: prop),)
  );

  /// Utility for defining [LinearBorderEdgeMix.alignment]
  late final alignment = PropUtility<T, double>(
    (prop) => call(LinearBorderEdgeMix.raw(alignment: prop),)
  );

  LinearBorderEdgeUtility(super.builder)
    : super(convertToMix: LinearBorderEdgeMix.value);

  @override
  T call(LinearBorderEdgeMix value) => builder(MixProp(value));
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
final class StadiumBorderUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, StadiumBorder> {
  /// Utility for defining [StadiumBorderMix.side]
  late final side = BorderSideUtility<T>(
    (v) => call(StadiumBorderMix.raw(side: v)),
  );

  StadiumBorderUtility(super.builder)
    : super(convertToMix: StadiumBorderMix.value);

  @override
  T call(StadiumBorderMix value) => builder(MixProp(value));
}

/// Utility class for configuring [ShapeBorder] properties.
///
/// This class provides methods to set individual properties of a [ShapeBorder].
/// Use the methods of this class to configure specific properties of a [ShapeBorder].
final class ShapeBorderUtility<T extends StyleAttribute<Object?>>
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

  @override
  T call(ShapeBorderMix value) => builder(MixProp(value));
}

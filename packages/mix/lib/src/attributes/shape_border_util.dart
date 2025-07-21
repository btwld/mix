import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/prop.dart';
import '../core/utility.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'scalar_util.dart';
import 'shape_border_dto.dart';

/// Utility class for configuring [RoundedRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [RoundedRectangleBorder].
/// Use the methods of this class to configure specific properties of a [RoundedRectangleBorder].
final class RoundedRectangleBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, RoundedRectangleBorder> {
  /// Utility for defining [RoundedRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(RoundedRectangleBorderDto(borderRadius: v)),
  );

  /// Utility for defining [RoundedRectangleBorderDto.side]
  late final side = BorderSideUtility<T>(
    (v) => call(RoundedRectangleBorderDto(side: v)),
  );

  RoundedRectangleBorderUtility(super.builder)
    : super(valueToMix: RoundedRectangleBorderDto.value);

  @override
  T call(RoundedRectangleBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [BeveledRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [BeveledRectangleBorder].
/// Use the methods of this class to configure specific properties of a [BeveledRectangleBorder].
final class BeveledRectangleBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(BeveledRectangleBorderDto(borderRadius: v)),
  );

  /// Utility for defining [BeveledRectangleBorderDto.side]
  late final side = BorderSideUtility<T>(
    (v) => call(BeveledRectangleBorderDto(side: v)),
  );

  BeveledRectangleBorderUtility(super.builder)
    : super(valueToMix: BeveledRectangleBorderDto.value);

  @override
  T call(BeveledRectangleBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [ContinuousRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [ContinuousRectangleBorder].
/// Use the methods of this class to configure specific properties of a [ContinuousRectangleBorder].
final class ContinuousRectangleBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, ContinuousRectangleBorder> {
  /// Utility for defining [ContinuousRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility<T>(
    (v) => call(ContinuousRectangleBorderDto(borderRadius: v)),
  );

  /// Utility for defining [ContinuousRectangleBorderDto.side]
  late final side = BorderSideUtility<T>(
    (v) => call(ContinuousRectangleBorderDto(side: v)),
  );

  ContinuousRectangleBorderUtility(super.builder)
    : super(valueToMix: ContinuousRectangleBorderDto.value);

  @override
  T call(ContinuousRectangleBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
final class CircleBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, CircleBorder> {
  /// Utility for defining [CircleBorderDto.side]
  late final side = BorderSideUtility<T>((v) => call(CircleBorderDto(side: v)));

  /// Utility for defining [CircleBorderDto.eccentricity]
  late final eccentricity = DoubleUtility<T>(
    (prop) => call(CircleBorderDto(eccentricity: prop)),
  );

  CircleBorderUtility(super.builder) : super(valueToMix: CircleBorderDto.value);

  @override
  T call(CircleBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [StarBorder] properties.
///
/// This class provides methods to set individual properties of a [StarBorder].
/// Use the methods of this class to configure specific properties of a [StarBorder].
final class StarBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, StarBorder> {
  /// Utility for defining [StarBorderDto.side]
  late final side = BorderSideUtility<T>((v) => call(StarBorderDto(side: v)));

  /// Utility for defining [StarBorderDto.points]
  late final points = DoubleUtility<T>(
    (prop) => call(StarBorderDto(points: prop)),
  );

  /// Utility for defining [StarBorderDto.innerRadiusRatio]
  late final innerRadiusRatio = DoubleUtility<T>(
    (prop) => call(StarBorderDto(innerRadiusRatio: prop)),
  );

  /// Utility for defining [StarBorderDto.pointRounding]
  late final pointRounding = DoubleUtility<T>(
    (prop) => call(StarBorderDto(pointRounding: prop)),
  );

  /// Utility for defining [StarBorderDto.valleyRounding]
  late final valleyRounding = DoubleUtility<T>(
    (prop) => call(StarBorderDto(valleyRounding: prop)),
  );

  /// Utility for defining [StarBorderDto.rotation]
  late final rotation = DoubleUtility<T>(
    (prop) => call(StarBorderDto(rotation: prop)),
  );

  /// Utility for defining [StarBorderDto.squash]
  late final squash = DoubleUtility<T>(
    (prop) => call(StarBorderDto(squash: prop)),
  );

  StarBorderUtility(super.builder) : super(valueToMix: StarBorderDto.value);

  @override
  T call(StarBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [LinearBorder] properties.
///
/// This class provides methods to set individual properties of a [LinearBorder].
/// Use the methods of this class to configure specific properties of a [LinearBorder].
final class LinearBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, LinearBorder> {
  /// Utility for defining [LinearBorderDto.side]
  late final side = BorderSideUtility<T>((v) => call(LinearBorderDto(side: v)));

  /// Utility for defining [LinearBorderDto.start]
  late final start = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderDto(start: v)),
  );

  /// Utility for defining [LinearBorderDto.end]
  late final end = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderDto(end: v)),
  );

  /// Utility for defining [LinearBorderDto.top]
  late final top = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderDto(top: v)),
  );

  /// Utility for defining [LinearBorderDto.bottom]
  late final bottom = LinearBorderEdgeUtility<T>(
    (v) => call(LinearBorderDto(bottom: v)),
  );

  LinearBorderUtility(super.builder) : super(valueToMix: LinearBorderDto.value);

  @override
  T call(LinearBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
final class LinearBorderEdgeUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeDto.size]
  late final size = DoubleUtility<T>(
    (prop) => call(LinearBorderEdgeDto(size: prop)),
  );

  /// Utility for defining [LinearBorderEdgeDto.alignment]
  late final alignment = DoubleUtility<T>(
    (prop) => call(LinearBorderEdgeDto(alignment: prop)),
  );

  LinearBorderEdgeUtility(super.builder)
    : super(valueToMix: LinearBorderEdgeDto.value);

  @override
  T call(LinearBorderEdgeDto value) => builder(MixProp(value));
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
final class StadiumBorderUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, StadiumBorder> {
  /// Utility for defining [StadiumBorderDto.side]
  late final side = BorderSideUtility<T>(
    (v) => call(StadiumBorderDto(side: v)),
  );

  StadiumBorderUtility(super.builder)
    : super(valueToMix: StadiumBorderDto.value);

  @override
  T call(StadiumBorderDto value) => builder(MixProp(value));
}

/// Utility class for configuring [ShapeBorder] properties.
///
/// This class provides methods to set individual properties of a [ShapeBorder].
/// Use the methods of this class to configure specific properties of a [ShapeBorder].
final class ShapeBorderUtility<T extends SpecAttribute<Object?>>
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

  ShapeBorderUtility(super.builder) : super(valueToMix: ShapeBorderDto.value);

  @override
  T call(ShapeBorderDto value) => builder(MixProp(value));
}

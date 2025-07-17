import 'package:flutter/widgets.dart';

import '../../core/spec.dart';
import '../../core/utility.dart';
import 'border_dto.dart';
import 'border_radius_dto.dart';
import 'border_radius_util.dart';
import 'border_util.dart';
import 'shape_border_dto.dart';

/// Utility class for configuring [RoundedRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [RoundedRectangleBorder].
/// Use the methods of this class to configure specific properties of a [RoundedRectangleBorder].
class RoundedRectangleBorderUtility<T extends SpecMix>
    extends DtoUtility<T, RoundedRectangleBorderDto, RoundedRectangleBorder> {
  /// Utility for defining [RoundedRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [RoundedRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  RoundedRectangleBorderUtility(super.builder)
    : super(valueToDto: RoundedRectangleBorderDto.value);

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: BorderRadiusGeometryDto.maybeValue(borderRadius),
      side: BorderSideDto.maybeValue(side),
    );
  }

  /// Returns a new [RoundedRectangleBorderDto] with the specified properties.
  @override
  T only({BorderRadiusGeometryDto? borderRadius, BorderSideDto? side}) {
    return builder(
      RoundedRectangleBorderDto(borderRadius: borderRadius, side: side),
    );
  }
}

class BeveledRectangleBorderUtility<T extends SpecMix>
    extends DtoUtility<T, BeveledRectangleBorderDto, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [BeveledRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  BeveledRectangleBorderUtility(super.builder)
    : super(valueToDto: BeveledRectangleBorderDto.value);

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: BorderRadiusGeometryDto.maybeValue(borderRadius),
      side: BorderSideDto.maybeValue(side),
    );
  }

  /// Returns a new [BeveledRectangleBorderDto] with the specified properties.
  @override
  T only({BorderRadiusGeometryDto? borderRadius, BorderSideDto? side}) {
    return builder(
      BeveledRectangleBorderDto(borderRadius: borderRadius, side: side),
    );
  }
}

class ContinuousRectangleBorderUtility<T extends SpecMix>
    extends
        DtoUtility<T, ContinuousRectangleBorderDto, ContinuousRectangleBorder> {
  /// Utility for defining [ContinuousRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [ContinuousRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  ContinuousRectangleBorderUtility(super.builder)
    : super(valueToDto: ContinuousRectangleBorderDto.value);

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: BorderRadiusGeometryDto.maybeValue(borderRadius),
      side: BorderSideDto.maybeValue(side),
    );
  }

  /// Returns a new [ContinuousRectangleBorderDto] with the specified properties.
  @override
  T only({BorderRadiusGeometryDto? borderRadius, BorderSideDto? side}) {
    return builder(
      ContinuousRectangleBorderDto(borderRadius: borderRadius, side: side),
    );
  }
}

class CircleBorderUtility<T extends SpecMix>
    extends DtoUtility<T, CircleBorderDto, CircleBorder> {
  /// Utility for defining [CircleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [CircleBorderDto.eccentricity]
  late final eccentricity = DoubleUtility(
    (prop) => builder(CircleBorderDto.props(eccentricity: prop)),
  );

  CircleBorderUtility(super.builder) : super(valueToDto: CircleBorderDto.value);

  T call({BorderSide? side, double? eccentricity}) {
    return only(
      side: BorderSideDto.maybeValue(side),
      eccentricity: eccentricity,
    );
  }

  /// Returns a new [CircleBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side, double? eccentricity}) {
    return builder(CircleBorderDto(side: side, eccentricity: eccentricity));
  }
}

class StarBorderUtility<T extends SpecMix>
    extends DtoUtility<T, StarBorderDto, StarBorder> {
  /// Utility for defining [StarBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [StarBorderDto.points]
  late final points = DoubleUtility(
    (prop) => builder(StarBorderDto.props(points: prop)),
  );

  /// Utility for defining [StarBorderDto.innerRadiusRatio]
  late final innerRadiusRatio = DoubleUtility(
    (prop) => builder(StarBorderDto.props(innerRadiusRatio: prop)),
  );

  /// Utility for defining [StarBorderDto.pointRounding]
  late final pointRounding = DoubleUtility(
    (prop) => builder(StarBorderDto.props(pointRounding: prop)),
  );

  /// Utility for defining [StarBorderDto.valleyRounding]
  late final valleyRounding = DoubleUtility(
    (prop) => builder(StarBorderDto.props(valleyRounding: prop)),
  );

  /// Utility for defining [StarBorderDto.rotation]
  late final rotation = DoubleUtility(
    (prop) => builder(StarBorderDto.props(rotation: prop)),
  );

  /// Utility for defining [StarBorderDto.squash]
  late final squash = DoubleUtility(
    (prop) => builder(StarBorderDto.props(squash: prop)),
  );

  StarBorderUtility(super.builder) : super(valueToDto: StarBorderDto.value);

  T call({
    BorderSide? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return only(
      side: BorderSideDto.maybeValue(side),
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }

  /// Returns a new [StarBorderDto] with the specified properties.
  @override
  T only({
    BorderSideDto? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return builder(
      StarBorderDto(
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
}

class LinearBorderUtility<T extends SpecMix>
    extends DtoUtility<T, LinearBorderDto, LinearBorder> {
  /// Utility for defining [LinearBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [LinearBorderDto.start]
  late final start = LinearBorderEdgeUtility((v) => only(start: v));

  /// Utility for defining [LinearBorderDto.end]
  late final end = LinearBorderEdgeUtility((v) => only(end: v));

  /// Utility for defining [LinearBorderDto.top]
  late final top = LinearBorderEdgeUtility((v) => only(top: v));

  /// Utility for defining [LinearBorderDto.bottom]
  late final bottom = LinearBorderEdgeUtility((v) => only(bottom: v));

  LinearBorderUtility(super.builder) : super(valueToDto: LinearBorderDto.value);

  T call({
    BorderSide? side,
    LinearBorderEdge? start,
    LinearBorderEdge? end,
    LinearBorderEdge? top,
    LinearBorderEdge? bottom,
  }) {
    return only(
      side: BorderSideDto.maybeValue(side),
      start: LinearBorderEdgeDto.maybeValue(start),
      end: LinearBorderEdgeDto.maybeValue(end),
      top: LinearBorderEdgeDto.maybeValue(top),
      bottom: LinearBorderEdgeDto.maybeValue(bottom),
    );
  }

  /// Returns a new [LinearBorderDto] with the specified properties.
  @override
  T only({
    BorderSideDto? side,
    LinearBorderEdgeDto? start,
    LinearBorderEdgeDto? end,
    LinearBorderEdgeDto? top,
    LinearBorderEdgeDto? bottom,
  }) {
    return builder(
      LinearBorderDto(
        side: side,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
    );
  }
}

class LinearBorderEdgeUtility<T extends SpecMix>
    extends DtoUtility<T, LinearBorderEdgeDto, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeDto.size]
  late final size = DoubleUtility(
    (prop) => builder(LinearBorderEdgeDto.props(size: prop)),
  );

  /// Utility for defining [LinearBorderEdgeDto.alignment]
  late final alignment = DoubleUtility(
    (prop) => builder(LinearBorderEdgeDto.props(alignment: prop)),
  );

  LinearBorderEdgeUtility(super.builder)
    : super(valueToDto: LinearBorderEdgeDto.value);

  T call({double? size, double? alignment}) {
    return only(size: size, alignment: alignment);
  }

  /// Returns a new [LinearBorderEdgeDto] with the specified properties.
  @override
  T only({double? size, double? alignment}) {
    return builder(LinearBorderEdgeDto(size: size, alignment: alignment));
  }
}

class StadiumBorderUtility<T extends SpecMix>
    extends DtoUtility<T, StadiumBorderDto, StadiumBorder> {
  /// Utility for defining [StadiumBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  StadiumBorderUtility(super.builder)
    : super(valueToDto: StadiumBorderDto.value);

  T call({BorderSide? side}) {
    return only(side: BorderSideDto.maybeValue(side));
  }

  /// Returns a new [StadiumBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side}) {
    return builder(StadiumBorderDto(side: side));
  }
}

class ShapeBorderUtility<T extends SpecMix>
    extends DtoUtility<T, ShapeBorderDto, ShapeBorder> {
  /// Utility for defining RoundedRectangleBorder
  late final roundedRectangle = RoundedRectangleBorderUtility(builder);

  /// Utility for defining BeveledRectangleBorder
  late final beveled = BeveledRectangleBorderUtility(builder);

  /// Utility for defining ContinuousRectangleBorder
  late final continuous = ContinuousRectangleBorderUtility(builder);

  /// Utility for defining CircleBorder
  late final circle = CircleBorderUtility(builder);

  /// Utility for defining StarBorder
  late final star = StarBorderUtility(builder);

  /// Utility for defining LinearBorder
  late final linear = LinearBorderUtility(builder);

  /// Utility for defining StadiumBorder
  late final stadium = StadiumBorderUtility(builder);

  ShapeBorderUtility(super.builder) : super(valueToDto: ShapeBorderDto.value);

  T call(ShapeBorder shape) {
    return builder(ShapeBorderDto.value(shape));
  }

  @override
  T only() {
    throw UnsupportedError(
      'ShapeBorderUtility.only is not supported. Use the specific shape utilities instead.',
    );
  }
}

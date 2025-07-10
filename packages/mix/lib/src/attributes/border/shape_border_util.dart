import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
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
class RoundedRectangleBorderUtility<T extends StyleElement>
    extends DtoUtility<T, RoundedRectangleBorderDto, RoundedRectangleBorder> {
  /// Utility for defining [RoundedRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [RoundedRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  RoundedRectangleBorderUtility(super.builder)
    : super(
        valueToDto: (v) => RoundedRectangleBorderDto(
          borderRadius: v.borderRadius != BorderRadius.zero
              ? _borderRadiusToDto(v.borderRadius)
              : null,
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
        ),
      );

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: borderRadius != null
          ? _borderRadiusToDto(borderRadius)
          : null,
      side: side != null ? _borderSideToDto(side) : null,
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

class BeveledRectangleBorderUtility<T extends StyleElement>
    extends DtoUtility<T, BeveledRectangleBorderDto, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [BeveledRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  BeveledRectangleBorderUtility(super.builder)
    : super(
        valueToDto: (v) => BeveledRectangleBorderDto(
          borderRadius: v.borderRadius != BorderRadius.zero
              ? _borderRadiusToDto(v.borderRadius)
              : null,
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
        ),
      );

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: borderRadius != null
          ? _borderRadiusToDto(borderRadius)
          : null,
      side: side != null ? _borderSideToDto(side) : null,
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

class ContinuousRectangleBorderUtility<T extends StyleElement>
    extends
        DtoUtility<T, ContinuousRectangleBorderDto, ContinuousRectangleBorder> {
  /// Utility for defining [ContinuousRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [ContinuousRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  ContinuousRectangleBorderUtility(super.builder)
    : super(
        valueToDto: (v) => ContinuousRectangleBorderDto(
          borderRadius: v.borderRadius != BorderRadius.zero
              ? _borderRadiusToDto(v.borderRadius)
              : null,
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
        ),
      );

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: borderRadius != null
          ? _borderRadiusToDto(borderRadius)
          : null,
      side: side != null ? _borderSideToDto(side) : null,
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

class CircleBorderUtility<T extends StyleElement>
    extends DtoUtility<T, CircleBorderDto, CircleBorder> {
  /// Utility for defining [CircleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [CircleBorderDto.eccentricity]
  late final eccentricity = DoubleUtility((v) => only(eccentricity: v));

  CircleBorderUtility(super.builder)
    : super(
        valueToDto: (v) => CircleBorderDto(
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
          eccentricity: v.eccentricity != 0.0 ? v.eccentricity : null,
        ),
      );

  T call({BorderSide? side, double? eccentricity}) {
    return only(
      side: side != null ? _borderSideToDto(side) : null,
      eccentricity: eccentricity,
    );
  }

  /// Returns a new [CircleBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side, double? eccentricity}) {
    return builder(CircleBorderDto(side: side, eccentricity: eccentricity));
  }
}

class StarBorderUtility<T extends StyleElement>
    extends DtoUtility<T, StarBorderDto, StarBorder> {
  /// Utility for defining [StarBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [StarBorderDto.points]
  late final points = DoubleUtility((v) => only(points: v));

  /// Utility for defining [StarBorderDto.innerRadiusRatio]
  late final innerRadiusRatio = DoubleUtility((v) => only(innerRadiusRatio: v));

  /// Utility for defining [StarBorderDto.pointRounding]
  late final pointRounding = DoubleUtility((v) => only(pointRounding: v));

  /// Utility for defining [StarBorderDto.valleyRounding]
  late final valleyRounding = DoubleUtility((v) => only(valleyRounding: v));

  /// Utility for defining [StarBorderDto.rotation]
  late final rotation = DoubleUtility((v) => only(rotation: v));

  /// Utility for defining [StarBorderDto.squash]
  late final squash = DoubleUtility((v) => only(squash: v));

  StarBorderUtility(super.builder)
    : super(
        valueToDto: (v) => StarBorderDto(
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
          points: v.points != 5 ? v.points : null,
          innerRadiusRatio: v.innerRadiusRatio != 0.4
              ? v.innerRadiusRatio
              : null,
          pointRounding: v.pointRounding != 0 ? v.pointRounding : null,
          valleyRounding: v.valleyRounding != 0 ? v.valleyRounding : null,
          rotation: v.rotation != 0 ? v.rotation : null,
          squash: v.squash != 0 ? v.squash : null,
        ),
      );

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
      side: side != null ? _borderSideToDto(side) : null,
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

class LinearBorderUtility<T extends StyleElement>
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

  LinearBorderUtility(super.builder)
    : super(
        valueToDto: (v) => LinearBorderDto(
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
          start: v.start != null ? _linearBorderEdgeToDto(v.start!) : null,
          end: v.end != null ? _linearBorderEdgeToDto(v.end!) : null,
          top: v.top != null ? _linearBorderEdgeToDto(v.top!) : null,
          bottom: v.bottom != null ? _linearBorderEdgeToDto(v.bottom!) : null,
        ),
      );

  T call({
    BorderSide? side,
    LinearBorderEdge? start,
    LinearBorderEdge? end,
    LinearBorderEdge? top,
    LinearBorderEdge? bottom,
  }) {
    return only(
      side: side != null ? _borderSideToDto(side) : null,
      start: start != null ? _linearBorderEdgeToDto(start) : null,
      end: end != null ? _linearBorderEdgeToDto(end) : null,
      top: top != null ? _linearBorderEdgeToDto(top) : null,
      bottom: bottom != null ? _linearBorderEdgeToDto(bottom) : null,
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

class LinearBorderEdgeUtility<T extends StyleElement>
    extends DtoUtility<T, LinearBorderEdgeDto, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeDto.size]
  late final size = DoubleUtility((v) => only(size: v));

  /// Utility for defining [LinearBorderEdgeDto.alignment]
  late final alignment = DoubleUtility((v) => only(alignment: v));

  LinearBorderEdgeUtility(super.builder)
    : super(
        valueToDto: (v) => LinearBorderEdgeDto(
          size: v.size != 1.0 ? v.size : null,
          alignment: v.alignment != 0.0 ? v.alignment : null,
        ),
      );

  T call({double? size, double? alignment}) {
    return only(size: size, alignment: alignment);
  }

  /// Returns a new [LinearBorderEdgeDto] with the specified properties.
  @override
  T only({double? size, double? alignment}) {
    return builder(LinearBorderEdgeDto(size: size, alignment: alignment));
  }
}

class StadiumBorderUtility<T extends StyleElement>
    extends DtoUtility<T, StadiumBorderDto, StadiumBorder> {
  /// Utility for defining [StadiumBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  StadiumBorderUtility(super.builder)
    : super(
        valueToDto: (v) => StadiumBorderDto(
          side: v.side != BorderSide.none ? _borderSideToDto(v.side) : null,
        ),
      );

  T call({BorderSide? side}) {
    return only(side: side != null ? _borderSideToDto(side) : null);
  }

  /// Returns a new [StadiumBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side}) {
    return builder(StadiumBorderDto(side: side));
  }
}

class ShapeBorderUtility<T extends StyleElement>
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

  ShapeBorderUtility(super.builder)
    : super(valueToDto: (v) => _shapeBorderToDto(v));

  T call(ShapeBorder shape) {
    return builder(_shapeBorderToDto(shape));
  }

  @override
  T only() {
    throw UnsupportedError(
      'ShapeBorderUtility.only is not supported. Use the specific shape utilities instead.',
    );
  }
}

// Helper functions
BorderRadiusGeometryDto? _borderRadiusToDto(BorderRadiusGeometry borderRadius) {
  if (borderRadius == BorderRadius.zero) return null;

  if (borderRadius is BorderRadius) {
    return BorderRadiusDto(
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
  } else if (borderRadius is BorderRadiusDirectional) {
    return BorderRadiusDirectionalDto(
      topStart: borderRadius.topStart,
      topEnd: borderRadius.topEnd,
      bottomStart: borderRadius.bottomStart,
      bottomEnd: borderRadius.bottomEnd,
    );
  }

  throw ArgumentError(
    'Unsupported BorderRadiusGeometry type: ${borderRadius.runtimeType}',
  );
}

BorderSideDto? _borderSideToDto(BorderSide side) {
  if (side == BorderSide.none) return null;

  const defaultSide = BorderSide();

  return BorderSideDto(
    color: side.color != defaultSide.color ? side.color : null,
    strokeAlign: side.strokeAlign != defaultSide.strokeAlign
        ? side.strokeAlign
        : null,
    style: side.style != defaultSide.style ? side.style : null,
    width: side.width != defaultSide.width ? side.width : null,
  );
}

LinearBorderEdgeDto _linearBorderEdgeToDto(LinearBorderEdge edge) {
  return LinearBorderEdgeDto(
    size: edge.size != 1.0 ? edge.size : null,
    alignment: edge.alignment != 0.0 ? edge.alignment : null,
  );
}

ShapeBorderDto _shapeBorderToDto(ShapeBorder border) {
  return switch (border) {
    RoundedRectangleBorder b => RoundedRectangleBorderDto(
      borderRadius: _borderRadiusToDto(b.borderRadius),
      side: _borderSideToDto(b.side),
    ),
    BeveledRectangleBorder b => BeveledRectangleBorderDto(
      borderRadius: _borderRadiusToDto(b.borderRadius),
      side: _borderSideToDto(b.side),
    ),
    ContinuousRectangleBorder b => ContinuousRectangleBorderDto(
      borderRadius: _borderRadiusToDto(b.borderRadius),
      side: _borderSideToDto(b.side),
    ),
    CircleBorder b => CircleBorderDto(
      side: _borderSideToDto(b.side),
      eccentricity: b.eccentricity != 0.0 ? b.eccentricity : null,
    ),
    StarBorder b => StarBorderDto(
      side: _borderSideToDto(b.side),
      points: b.points != 5 ? b.points : null,
      innerRadiusRatio: b.innerRadiusRatio != 0.4 ? b.innerRadiusRatio : null,
      pointRounding: b.pointRounding != 0 ? b.pointRounding : null,
      valleyRounding: b.valleyRounding != 0 ? b.valleyRounding : null,
      rotation: b.rotation != 0 ? b.rotation : null,
      squash: b.squash != 0 ? b.squash : null,
    ),
    LinearBorder b => LinearBorderDto(
      side: _borderSideToDto(b.side),
      start: b.start != null ? _linearBorderEdgeToDto(b.start!) : null,
      end: b.end != null ? _linearBorderEdgeToDto(b.end!) : null,
      top: b.top != null ? _linearBorderEdgeToDto(b.top!) : null,
      bottom: b.bottom != null ? _linearBorderEdgeToDto(b.bottom!) : null,
    ),
    StadiumBorder b => StadiumBorderDto(side: _borderSideToDto(b.side)),
    _ => throw ArgumentError(
      'Unsupported ShapeBorder type: ${border.runtimeType}',
    ),
  };
}

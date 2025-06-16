// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shape_border_dto.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides DTO functionality for [RoundedRectangleBorderDto].
mixin _$RoundedRectangleBorderDto on Mixable<RoundedRectangleBorder> {
  /// Resolves to [RoundedRectangleBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final roundedRectangleBorder = RoundedRectangleBorderDto(...).resolve(mix);
  /// ```
  @override
  RoundedRectangleBorder resolve(MixData mix) {
    return RoundedRectangleBorder(
      borderRadius: _$this.borderRadius?.resolve(mix) ?? BorderRadius.zero,
      side: _$this.side?.resolve(mix) ?? BorderSide.none,
    );
  }

  /// Merges the properties of this [RoundedRectangleBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [RoundedRectangleBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  RoundedRectangleBorderDto merge(RoundedRectangleBorderDto? other) {
    if (other == null) return _$this;

    return RoundedRectangleBorderDto(
      borderRadius:
          _$this.borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      side: _$this.side?.merge(other.side) ?? other.side,
    );
  }

  /// The list of properties that constitute the state of this [RoundedRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RoundedRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [_$this.borderRadius, _$this.side];

  /// Returns this instance as a [RoundedRectangleBorderDto].
  RoundedRectangleBorderDto get _$this => this as RoundedRectangleBorderDto;
}

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
    : super(valueToDto: (v) => v.toDto());

  /// Returns a new [RoundedRectangleBorderDto] with the specified properties.
  @override
  T only({BorderRadiusGeometryDto? borderRadius, BorderSideDto? side}) {
    return builder(
      RoundedRectangleBorderDto(borderRadius: borderRadius, side: side),
    );
  }

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(borderRadius: borderRadius?.toDto(), side: side?.toDto());
  }
}

/// Extension methods to convert [RoundedRectangleBorder] to [RoundedRectangleBorderDto].
extension RoundedRectangleBorderMixExt on RoundedRectangleBorder {
  /// Converts this [RoundedRectangleBorder] to a [RoundedRectangleBorderDto].
  RoundedRectangleBorderDto toDto() {
    return RoundedRectangleBorderDto(
      borderRadius: borderRadius.toDto(),
      side: side.toDto(),
    );
  }
}

/// Extension methods to convert List<[RoundedRectangleBorder]> to List<[RoundedRectangleBorderDto]>.
extension ListRoundedRectangleBorderMixExt on List<RoundedRectangleBorder> {
  /// Converts this List<[RoundedRectangleBorder]> to a List<[RoundedRectangleBorderDto]>.
  List<RoundedRectangleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [BeveledRectangleBorderDto].
mixin _$BeveledRectangleBorderDto on Mixable<BeveledRectangleBorder> {
  /// Resolves to [BeveledRectangleBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final beveledRectangleBorder = BeveledRectangleBorderDto(...).resolve(mix);
  /// ```
  @override
  BeveledRectangleBorder resolve(MixData mix) {
    return BeveledRectangleBorder(
      borderRadius: _$this.borderRadius?.resolve(mix) ?? BorderRadius.zero,
      side: _$this.side?.resolve(mix) ?? BorderSide.none,
    );
  }

  /// Merges the properties of this [BeveledRectangleBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BeveledRectangleBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BeveledRectangleBorderDto merge(BeveledRectangleBorderDto? other) {
    if (other == null) return _$this;

    return BeveledRectangleBorderDto(
      borderRadius:
          _$this.borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      side: _$this.side?.merge(other.side) ?? other.side,
    );
  }

  /// The list of properties that constitute the state of this [BeveledRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BeveledRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [_$this.borderRadius, _$this.side];

  /// Returns this instance as a [BeveledRectangleBorderDto].
  BeveledRectangleBorderDto get _$this => this as BeveledRectangleBorderDto;
}

/// Utility class for configuring [BeveledRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [BeveledRectangleBorder].
/// Use the methods of this class to configure specific properties of a [BeveledRectangleBorder].
class BeveledRectangleBorderUtility<T extends StyleElement>
    extends DtoUtility<T, BeveledRectangleBorderDto, BeveledRectangleBorder> {
  /// Utility for defining [BeveledRectangleBorderDto.borderRadius]
  late final borderRadius = BorderRadiusGeometryUtility(
    (v) => only(borderRadius: v),
  );

  /// Utility for defining [BeveledRectangleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  BeveledRectangleBorderUtility(super.builder)
    : super(valueToDto: (v) => v.toDto());

  /// Returns a new [BeveledRectangleBorderDto] with the specified properties.
  @override
  T only({BorderRadiusGeometryDto? borderRadius, BorderSideDto? side}) {
    return builder(
      BeveledRectangleBorderDto(borderRadius: borderRadius, side: side),
    );
  }

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(borderRadius: borderRadius?.toDto(), side: side?.toDto());
  }
}

/// Extension methods to convert [BeveledRectangleBorder] to [BeveledRectangleBorderDto].
extension BeveledRectangleBorderMixExt on BeveledRectangleBorder {
  /// Converts this [BeveledRectangleBorder] to a [BeveledRectangleBorderDto].
  BeveledRectangleBorderDto toDto() {
    return BeveledRectangleBorderDto(
      borderRadius: borderRadius.toDto(),
      side: side.toDto(),
    );
  }
}

/// Extension methods to convert List<[BeveledRectangleBorder]> to List<[BeveledRectangleBorderDto]>.
extension ListBeveledRectangleBorderMixExt on List<BeveledRectangleBorder> {
  /// Converts this List<[BeveledRectangleBorder]> to a List<[BeveledRectangleBorderDto]>.
  List<BeveledRectangleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [ContinuousRectangleBorderDto].
mixin _$ContinuousRectangleBorderDto on Mixable<ContinuousRectangleBorder> {
  /// Resolves to [ContinuousRectangleBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final continuousRectangleBorder = ContinuousRectangleBorderDto(...).resolve(mix);
  /// ```
  @override
  ContinuousRectangleBorder resolve(MixData mix) {
    return ContinuousRectangleBorder(
      borderRadius: _$this.borderRadius?.resolve(mix) ?? BorderRadius.zero,
      side: _$this.side?.resolve(mix) ?? BorderSide.none,
    );
  }

  /// Merges the properties of this [ContinuousRectangleBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ContinuousRectangleBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ContinuousRectangleBorderDto merge(ContinuousRectangleBorderDto? other) {
    if (other == null) return _$this;

    return ContinuousRectangleBorderDto(
      borderRadius:
          _$this.borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      side: _$this.side?.merge(other.side) ?? other.side,
    );
  }

  /// The list of properties that constitute the state of this [ContinuousRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ContinuousRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [_$this.borderRadius, _$this.side];

  /// Returns this instance as a [ContinuousRectangleBorderDto].
  ContinuousRectangleBorderDto get _$this =>
      this as ContinuousRectangleBorderDto;
}

/// Utility class for configuring [ContinuousRectangleBorder] properties.
///
/// This class provides methods to set individual properties of a [ContinuousRectangleBorder].
/// Use the methods of this class to configure specific properties of a [ContinuousRectangleBorder].
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
    : super(valueToDto: (v) => v.toDto());

  /// Returns a new [ContinuousRectangleBorderDto] with the specified properties.
  @override
  T only({BorderRadiusGeometryDto? borderRadius, BorderSideDto? side}) {
    return builder(
      ContinuousRectangleBorderDto(borderRadius: borderRadius, side: side),
    );
  }

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(borderRadius: borderRadius?.toDto(), side: side?.toDto());
  }
}

/// Extension methods to convert [ContinuousRectangleBorder] to [ContinuousRectangleBorderDto].
extension ContinuousRectangleBorderMixExt on ContinuousRectangleBorder {
  /// Converts this [ContinuousRectangleBorder] to a [ContinuousRectangleBorderDto].
  ContinuousRectangleBorderDto toDto() {
    return ContinuousRectangleBorderDto(
      borderRadius: borderRadius.toDto(),
      side: side.toDto(),
    );
  }
}

/// Extension methods to convert List<[ContinuousRectangleBorder]> to List<[ContinuousRectangleBorderDto]>.
extension ListContinuousRectangleBorderMixExt
    on List<ContinuousRectangleBorder> {
  /// Converts this List<[ContinuousRectangleBorder]> to a List<[ContinuousRectangleBorderDto]>.
  List<ContinuousRectangleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [CircleBorderDto].
mixin _$CircleBorderDto on Mixable<CircleBorder> {
  /// Resolves to [CircleBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final circleBorder = CircleBorderDto(...).resolve(mix);
  /// ```
  @override
  CircleBorder resolve(MixData mix) {
    return CircleBorder(
      side: _$this.side?.resolve(mix) ?? BorderSide.none,
      eccentricity: _$this.eccentricity ?? 0.0,
    );
  }

  /// Merges the properties of this [CircleBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [CircleBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  CircleBorderDto merge(CircleBorderDto? other) {
    if (other == null) return _$this;

    return CircleBorderDto(
      side: _$this.side?.merge(other.side) ?? other.side,
      eccentricity: other.eccentricity ?? _$this.eccentricity,
    );
  }

  /// The list of properties that constitute the state of this [CircleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CircleBorderDto] instances for equality.
  @override
  List<Object?> get props => [_$this.side, _$this.eccentricity];

  /// Returns this instance as a [CircleBorderDto].
  CircleBorderDto get _$this => this as CircleBorderDto;
}

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
class CircleBorderUtility<T extends StyleElement>
    extends DtoUtility<T, CircleBorderDto, CircleBorder> {
  /// Utility for defining [CircleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [CircleBorderDto.eccentricity]
  late final eccentricity = DoubleUtility((v) => only(eccentricity: v));

  CircleBorderUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [CircleBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side, double? eccentricity}) {
    return builder(CircleBorderDto(side: side, eccentricity: eccentricity));
  }

  T call({BorderSide? side, double? eccentricity}) {
    return only(side: side?.toDto(), eccentricity: eccentricity);
  }
}

/// Extension methods to convert [CircleBorder] to [CircleBorderDto].
extension CircleBorderMixExt on CircleBorder {
  /// Converts this [CircleBorder] to a [CircleBorderDto].
  CircleBorderDto toDto() {
    return CircleBorderDto(side: side.toDto(), eccentricity: eccentricity);
  }
}

/// Extension methods to convert List<[CircleBorder]> to List<[CircleBorderDto]>.
extension ListCircleBorderMixExt on List<CircleBorder> {
  /// Converts this List<[CircleBorder]> to a List<[CircleBorderDto]>.
  List<CircleBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [StarBorderDto].
mixin _$StarBorderDto on Mixable<StarBorder> {
  /// Resolves to [StarBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final starBorder = StarBorderDto(...).resolve(mix);
  /// ```
  @override
  StarBorder resolve(MixData mix) {
    return StarBorder(
      side: _$this.side?.resolve(mix) ?? BorderSide.none,
      points: _$this.points ?? 5,
      innerRadiusRatio: _$this.innerRadiusRatio ?? 0.4,
      pointRounding: _$this.pointRounding ?? 0,
      valleyRounding: _$this.valleyRounding ?? 0,
      rotation: _$this.rotation ?? 0,
      squash: _$this.squash ?? 0,
    );
  }

  /// Merges the properties of this [StarBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StarBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StarBorderDto merge(StarBorderDto? other) {
    if (other == null) return _$this;

    return StarBorderDto(
      side: _$this.side?.merge(other.side) ?? other.side,
      points: other.points ?? _$this.points,
      innerRadiusRatio: other.innerRadiusRatio ?? _$this.innerRadiusRatio,
      pointRounding: other.pointRounding ?? _$this.pointRounding,
      valleyRounding: other.valleyRounding ?? _$this.valleyRounding,
      rotation: other.rotation ?? _$this.rotation,
      squash: other.squash ?? _$this.squash,
    );
  }

  /// The list of properties that constitute the state of this [StarBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StarBorderDto] instances for equality.
  @override
  List<Object?> get props => [
    _$this.side,
    _$this.points,
    _$this.innerRadiusRatio,
    _$this.pointRounding,
    _$this.valleyRounding,
    _$this.rotation,
    _$this.squash,
  ];

  /// Returns this instance as a [StarBorderDto].
  StarBorderDto get _$this => this as StarBorderDto;
}

/// Utility class for configuring [StarBorder] properties.
///
/// This class provides methods to set individual properties of a [StarBorder].
/// Use the methods of this class to configure specific properties of a [StarBorder].
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

  StarBorderUtility(super.builder) : super(valueToDto: (v) => v.toDto());

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
      side: side?.toDto(),
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }
}

/// Extension methods to convert [StarBorder] to [StarBorderDto].
extension StarBorderMixExt on StarBorder {
  /// Converts this [StarBorder] to a [StarBorderDto].
  StarBorderDto toDto() {
    return StarBorderDto(
      side: side.toDto(),
      points: points,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
      rotation: rotation,
      squash: squash,
    );
  }
}

/// Extension methods to convert List<[StarBorder]> to List<[StarBorderDto]>.
extension ListStarBorderMixExt on List<StarBorder> {
  /// Converts this List<[StarBorder]> to a List<[StarBorderDto]>.
  List<StarBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [LinearBorderDto].
mixin _$LinearBorderDto on Mixable<LinearBorder> {
  /// Resolves to [LinearBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final linearBorder = LinearBorderDto(...).resolve(mix);
  /// ```
  @override
  LinearBorder resolve(MixData mix) {
    return LinearBorder(
      side: _$this.side?.resolve(mix) ?? BorderSide.none,
      start: _$this.start?.resolve(mix),
      end: _$this.end?.resolve(mix),
      top: _$this.top?.resolve(mix),
      bottom: _$this.bottom?.resolve(mix),
    );
  }

  /// Merges the properties of this [LinearBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [LinearBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  LinearBorderDto merge(LinearBorderDto? other) {
    if (other == null) return _$this;

    return LinearBorderDto(
      side: _$this.side?.merge(other.side) ?? other.side,
      start: _$this.start?.merge(other.start) ?? other.start,
      end: _$this.end?.merge(other.end) ?? other.end,
      top: _$this.top?.merge(other.top) ?? other.top,
      bottom: _$this.bottom?.merge(other.bottom) ?? other.bottom,
    );
  }

  /// The list of properties that constitute the state of this [LinearBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LinearBorderDto] instances for equality.
  @override
  List<Object?> get props => [
    _$this.side,
    _$this.start,
    _$this.end,
    _$this.top,
    _$this.bottom,
  ];

  /// Returns this instance as a [LinearBorderDto].
  LinearBorderDto get _$this => this as LinearBorderDto;
}

/// Utility class for configuring [LinearBorder] properties.
///
/// This class provides methods to set individual properties of a [LinearBorder].
/// Use the methods of this class to configure specific properties of a [LinearBorder].
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

  LinearBorderUtility(super.builder) : super(valueToDto: (v) => v.toDto());

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

  T call({
    BorderSide? side,
    LinearBorderEdge? start,
    LinearBorderEdge? end,
    LinearBorderEdge? top,
    LinearBorderEdge? bottom,
  }) {
    return only(
      side: side?.toDto(),
      start: start?.toDto(),
      end: end?.toDto(),
      top: top?.toDto(),
      bottom: bottom?.toDto(),
    );
  }
}

/// Extension methods to convert [LinearBorder] to [LinearBorderDto].
extension LinearBorderMixExt on LinearBorder {
  /// Converts this [LinearBorder] to a [LinearBorderDto].
  LinearBorderDto toDto() {
    return LinearBorderDto(
      side: side.toDto(),
      start: start?.toDto(),
      end: end?.toDto(),
      top: top?.toDto(),
      bottom: bottom?.toDto(),
    );
  }
}

/// Extension methods to convert List<[LinearBorder]> to List<[LinearBorderDto]>.
extension ListLinearBorderMixExt on List<LinearBorder> {
  /// Converts this List<[LinearBorder]> to a List<[LinearBorderDto]>.
  List<LinearBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [LinearBorderEdgeDto].
mixin _$LinearBorderEdgeDto on Mixable<LinearBorderEdge> {
  /// Resolves to [LinearBorderEdge] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final linearBorderEdge = LinearBorderEdgeDto(...).resolve(mix);
  /// ```
  @override
  LinearBorderEdge resolve(MixData mix) {
    return LinearBorderEdge(
      size: _$this.size ?? 1.0,
      alignment: _$this.alignment ?? 0.0,
    );
  }

  /// Merges the properties of this [LinearBorderEdgeDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [LinearBorderEdgeDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  LinearBorderEdgeDto merge(LinearBorderEdgeDto? other) {
    if (other == null) return _$this;

    return LinearBorderEdgeDto(
      size: other.size ?? _$this.size,
      alignment: other.alignment ?? _$this.alignment,
    );
  }

  /// The list of properties that constitute the state of this [LinearBorderEdgeDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LinearBorderEdgeDto] instances for equality.
  @override
  List<Object?> get props => [_$this.size, _$this.alignment];

  /// Returns this instance as a [LinearBorderEdgeDto].
  LinearBorderEdgeDto get _$this => this as LinearBorderEdgeDto;
}

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
class LinearBorderEdgeUtility<T extends StyleElement>
    extends DtoUtility<T, LinearBorderEdgeDto, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeDto.size]
  late final size = DoubleUtility((v) => only(size: v));

  /// Utility for defining [LinearBorderEdgeDto.alignment]
  late final alignment = DoubleUtility((v) => only(alignment: v));

  LinearBorderEdgeUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [LinearBorderEdgeDto] with the specified properties.
  @override
  T only({double? size, double? alignment}) {
    return builder(LinearBorderEdgeDto(size: size, alignment: alignment));
  }

  T call({double? size, double? alignment}) {
    return only(size: size, alignment: alignment);
  }
}

/// Extension methods to convert [LinearBorderEdge] to [LinearBorderEdgeDto].
extension LinearBorderEdgeMixExt on LinearBorderEdge {
  /// Converts this [LinearBorderEdge] to a [LinearBorderEdgeDto].
  LinearBorderEdgeDto toDto() {
    return LinearBorderEdgeDto(size: size, alignment: alignment);
  }
}

/// Extension methods to convert List<[LinearBorderEdge]> to List<[LinearBorderEdgeDto]>.
extension ListLinearBorderEdgeMixExt on List<LinearBorderEdge> {
  /// Converts this List<[LinearBorderEdge]> to a List<[LinearBorderEdgeDto]>.
  List<LinearBorderEdgeDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// A mixin that provides DTO functionality for [StadiumBorderDto].
mixin _$StadiumBorderDto on Mixable<StadiumBorder> {
  /// Resolves to [StadiumBorder] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final stadiumBorder = StadiumBorderDto(...).resolve(mix);
  /// ```
  @override
  StadiumBorder resolve(MixData mix) {
    return StadiumBorder(side: _$this.side?.resolve(mix) ?? BorderSide.none);
  }

  /// Merges the properties of this [StadiumBorderDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StadiumBorderDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StadiumBorderDto merge(StadiumBorderDto? other) {
    if (other == null) return _$this;

    return StadiumBorderDto(side: _$this.side?.merge(other.side) ?? other.side);
  }

  /// The list of properties that constitute the state of this [StadiumBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StadiumBorderDto] instances for equality.
  @override
  List<Object?> get props => [_$this.side];

  /// Returns this instance as a [StadiumBorderDto].
  StadiumBorderDto get _$this => this as StadiumBorderDto;
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
class StadiumBorderUtility<T extends StyleElement>
    extends DtoUtility<T, StadiumBorderDto, StadiumBorder> {
  /// Utility for defining [StadiumBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  StadiumBorderUtility(super.builder) : super(valueToDto: (v) => v.toDto());

  /// Returns a new [StadiumBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side}) {
    return builder(StadiumBorderDto(side: side));
  }

  T call({BorderSide? side}) {
    return only(side: side?.toDto());
  }
}

/// Extension methods to convert [StadiumBorder] to [StadiumBorderDto].
extension StadiumBorderMixExt on StadiumBorder {
  /// Converts this [StadiumBorder] to a [StadiumBorderDto].
  StadiumBorderDto toDto() {
    return StadiumBorderDto(side: side.toDto());
  }
}

/// Extension methods to convert List<[StadiumBorder]> to List<[StadiumBorderDto]>.
extension ListStadiumBorderMixExt on List<StadiumBorder> {
  /// Converts this List<[StadiumBorder]> to a List<[StadiumBorderDto]>.
  List<StadiumBorderDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

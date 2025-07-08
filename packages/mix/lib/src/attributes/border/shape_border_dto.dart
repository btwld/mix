// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

@immutable
sealed class ShapeBorderDto<T extends ShapeBorder> extends Mix<T> {
  const ShapeBorderDto();

  static ShapeBorderDto? tryToMerge(ShapeBorderDto? a, ShapeBorderDto? b) {
    if (b == null) return a;
    if (a == null) return b;

    if (b is! OutlinedBorderDto || a is! OutlinedBorderDto) {
      // Not merge anything besides OutlinedBorderDto
      return b;
    }

    return OutlinedBorderDto.tryToMerge(a, b);
  }

  static ({
    BorderSideDto? side,
    BorderRadiusGeometryDto? borderRadius,
    BoxShape? boxShape,
  })
  extract(ShapeBorderDto? dto) {
    return dto is OutlinedBorderDto
        ? (
            side: dto.side,
            borderRadius: dto.borderRadiusGetter,
            boxShape: dto._toBoxShape(),
          )
        : (side: null, borderRadius: null, boxShape: null);
  }

  @override
  ShapeBorderDto<T> merge(covariant ShapeBorderDto<T>? other);
}

@immutable
abstract class OutlinedBorderDto<T extends OutlinedBorder>
    extends ShapeBorderDto<T> {
  final BorderSideDto? side;

  const OutlinedBorderDto({this.side});

  static OutlinedBorderDto? tryToMerge(
    OutlinedBorderDto? a,
    OutlinedBorderDto? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<
    A extends OutlinedBorderDto,
    B extends OutlinedBorderDto
  >(A a, B b) {
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    final adaptedA = b.adapt(a) as B;

    return adaptedA.merge(b) as B;
  }

  BoxShape? _toBoxShape() {
    if (this is CircleBorderDto) {
      return BoxShape.circle;
    } else if (this is RoundedRectangleBorderDto) {
      return BoxShape.rectangle;
    }

    return null;
  }

  @protected
  BorderRadiusGeometryDto? get borderRadiusGetter;

  OutlinedBorderDto<T> adapt(OutlinedBorderDto other);

  @override
  OutlinedBorderDto<T> merge(covariant OutlinedBorderDto<T>? other);
}

final class RoundedRectangleBorderDto
    extends OutlinedBorderDto<RoundedRectangleBorder> {
  final BorderRadiusGeometryDto? borderRadius;

  const RoundedRectangleBorderDto({this.borderRadius, super.side});

  // Factory from RoundedRectangleBorder
  factory RoundedRectangleBorderDto.from(RoundedRectangleBorder border) {
    return RoundedRectangleBorderDto(
      borderRadius: BorderRadiusGeometryDto.from(border.borderRadius),
      side: BorderSideDto.from(border.side),
    );
  }

  // Nullable factory from RoundedRectangleBorder
  static RoundedRectangleBorderDto? maybeFrom(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderDto.from(border) : null;
  }

  @override
  RoundedRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is RoundedRectangleBorderDto) return other;

    return RoundedRectangleBorderDto(
      borderRadius: other.borderRadiusGetter,
      side: other.side,
    );
  }

  /// Resolves to [RoundedRectangleBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final roundedRectangleBorder = RoundedRectangleBorderDto(...).resolve(mix);
  /// ```
  @override
  RoundedRectangleBorder resolve(MixContext mix) {
    return RoundedRectangleBorder(
      side: side?.resolve(mix) ?? BorderSide.none,
      borderRadius: borderRadius?.resolve(mix) ?? BorderRadius.zero,
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
    if (other == null) return this;

    return RoundedRectangleBorderDto(
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      side: side?.merge(other.side) ?? other.side,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => borderRadius;

  /// The list of properties that constitute the state of this [RoundedRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RoundedRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [borderRadius, side];
}

final class BeveledRectangleBorderDto
    extends OutlinedBorderDto<BeveledRectangleBorder> {
  final BorderRadiusGeometryDto? borderRadius;

  const BeveledRectangleBorderDto({this.borderRadius, super.side});

  // Factory from BeveledRectangleBorder
  factory BeveledRectangleBorderDto.from(BeveledRectangleBorder border) {
    return BeveledRectangleBorderDto(
      borderRadius: BorderRadiusGeometryDto.from(border.borderRadius),
      side: BorderSideDto.from(border.side),
    );
  }

  // Nullable factory from BeveledRectangleBorder
  static BeveledRectangleBorderDto? maybeFrom(BeveledRectangleBorder? border) {
    return border != null ? BeveledRectangleBorderDto.from(border) : null;
  }

  @override
  BeveledRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is BeveledRectangleBorderDto) return other;

    return BeveledRectangleBorderDto(
      borderRadius: other.borderRadiusGetter,
      side: other.side,
    );
  }

  /// Resolves to [BeveledRectangleBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final beveledRectangleBorder = BeveledRectangleBorderDto(...).resolve(mix);
  /// ```
  @override
  BeveledRectangleBorder resolve(MixContext mix) {
    return BeveledRectangleBorder(
      side: side?.resolve(mix) ?? BorderSide.none,
      borderRadius: borderRadius?.resolve(mix) ?? BorderRadius.zero,
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
    if (other == null) return this;

    return BeveledRectangleBorderDto(
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      side: side?.merge(other.side) ?? other.side,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => borderRadius;

  /// The list of properties that constitute the state of this [BeveledRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BeveledRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [borderRadius, side];
}

final class ContinuousRectangleBorderDto
    extends OutlinedBorderDto<ContinuousRectangleBorder> {
  final BorderRadiusGeometryDto? borderRadius;

  const ContinuousRectangleBorderDto({this.borderRadius, super.side});

  // Factory from ContinuousRectangleBorder
  factory ContinuousRectangleBorderDto.from(ContinuousRectangleBorder border) {
    return ContinuousRectangleBorderDto(
      borderRadius: BorderRadiusGeometryDto.from(border.borderRadius),
      side: BorderSideDto.from(border.side),
    );
  }

  // Nullable factory from ContinuousRectangleBorder
  static ContinuousRectangleBorderDto? maybeFrom(
    ContinuousRectangleBorder? border,
  ) {
    return border != null ? ContinuousRectangleBorderDto.from(border) : null;
  }

  @override
  ContinuousRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is ContinuousRectangleBorderDto) {
      return other;
    }

    return ContinuousRectangleBorderDto(
      borderRadius: other.borderRadiusGetter,
      side: other.side,
    );
  }

  /// Resolves to [ContinuousRectangleBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final continuousRectangleBorder = ContinuousRectangleBorderDto(...).resolve(mix);
  /// ```
  @override
  ContinuousRectangleBorder resolve(MixContext mix) {
    return ContinuousRectangleBorder(
      side: side?.resolve(mix) ?? BorderSide.none,
      borderRadius: borderRadius?.resolve(mix) ?? BorderRadius.zero,
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
    if (other == null) return this;

    return ContinuousRectangleBorderDto(
      borderRadius:
          borderRadius?.merge(other.borderRadius) ?? other.borderRadius,
      side: side?.merge(other.side) ?? other.side,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => borderRadius;

  /// The list of properties that constitute the state of this [ContinuousRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ContinuousRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [borderRadius, side];
}

final class CircleBorderDto extends OutlinedBorderDto<CircleBorder> {
  final MixProperty<double> eccentricity;

  // Main constructor accepts either BorderSide or BorderSideDto for compatibility
  factory CircleBorderDto({Object? side, double? eccentricity}) {
    BorderSideDto? sideDto;
    if (side is BorderSide) {
      sideDto = BorderSideDto.from(side);
    } else if (side is BorderSideDto) {
      sideDto = side;
    }

    return CircleBorderDto.raw(
      side: sideDto,
      eccentricity: MixProperty.prop(eccentricity),
    );
  }

  // Factory that accepts MixableProperty instances
  const CircleBorderDto.raw({required super.side, required this.eccentricity});

  // Factory from CircleBorder
  factory CircleBorderDto.from(CircleBorder border) {
    return CircleBorderDto(
      side: border.side,
      eccentricity: border.eccentricity,
    );
  }

  // Nullable factory from CircleBorder
  static CircleBorderDto? maybeFrom(CircleBorder? border) {
    return border != null ? CircleBorderDto.from(border) : null;
  }

  @override
  CircleBorderDto adapt(OutlinedBorderDto other) {
    if (other is CircleBorderDto) {
      return other;
    }

    return CircleBorderDto.raw(
      side: other.side,
      eccentricity: const MixProperty(null),
    );
  }

  /// Resolves to [CircleBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final circleBorder = CircleBorderDto(...).resolve(mix);
  /// ```
  @override
  CircleBorder resolve(MixContext mix) {
    return CircleBorder(
      side: side?.resolve(mix) ?? BorderSide.none,
      eccentricity: eccentricity.resolve(mix) ?? 0.0,
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
    if (other == null) return this;

    return CircleBorderDto.raw(
      side: side?.merge(other.side) ?? other.side,
      eccentricity: eccentricity.merge(other.eccentricity),
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;

  /// The list of properties that constitute the state of this [CircleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CircleBorderDto] instances for equality.
  @override
  List<Object?> get props => [side, eccentricity];
}

final class StarBorderDto extends OutlinedBorderDto<StarBorder> {
  final MixProperty<double> points;
  final MixProperty<double> innerRadiusRatio;
  final MixProperty<double> pointRounding;
  final MixProperty<double> valleyRounding;
  final MixProperty<double> rotation;
  final MixProperty<double> squash;

  // Main constructor accepts real values
  factory StarBorderDto({
    BorderSide? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return StarBorderDto.raw(
      side: side != null ? BorderSideDto.from(side) : null,
      points: MixProperty.prop(points),
      innerRadiusRatio: MixProperty.prop(innerRadiusRatio),
      pointRounding: MixProperty.prop(pointRounding),
      valleyRounding: MixProperty.prop(valleyRounding),
      rotation: MixProperty.prop(rotation),
      squash: MixProperty.prop(squash),
    );
  }

  // Factory that accepts MixableProperty instances
  const StarBorderDto.raw({
    required super.side,
    required this.points,
    required this.innerRadiusRatio,
    required this.pointRounding,
    required this.valleyRounding,
    required this.rotation,
    required this.squash,
  });

  // Factory from StarBorder
  factory StarBorderDto.from(StarBorder border) {
    return StarBorderDto(
      side: border.side,
      points: border.points,
      innerRadiusRatio: border.innerRadiusRatio,
      pointRounding: border.pointRounding,
      valleyRounding: border.valleyRounding,
      rotation: border.rotation,
      squash: border.squash,
    );
  }

  // Nullable factory from StarBorder
  static StarBorderDto? maybeFrom(StarBorder? border) {
    return border != null ? StarBorderDto.from(border) : null;
  }

  @override
  StarBorderDto adapt(OutlinedBorderDto other) {
    return StarBorderDto.raw(
      side: other.side,
      points: const MixProperty(null),
      innerRadiusRatio: const MixProperty(null),
      pointRounding: const MixProperty(null),
      valleyRounding: const MixProperty(null),
      rotation: const MixProperty(null),
      squash: const MixProperty(null),
    );
  }

  /// Resolves to [StarBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final starBorder = StarBorderDto(...).resolve(mix);
  /// ```
  @override
  StarBorder resolve(MixContext mix) {
    return StarBorder(
      side: side?.resolve(mix) ?? BorderSide.none,
      points: points.resolve(mix) ?? 5,
      innerRadiusRatio: innerRadiusRatio.resolve(mix) ?? 0.4,
      pointRounding: pointRounding.resolve(mix) ?? 0,
      valleyRounding: valleyRounding.resolve(mix) ?? 0,
      rotation: rotation.resolve(mix) ?? 0,
      squash: squash.resolve(mix) ?? 0,
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
    if (other == null) return this;

    return StarBorderDto.raw(
      side: side?.merge(other.side) ?? other.side,
      points: points.merge(other.points),
      innerRadiusRatio: innerRadiusRatio.merge(other.innerRadiusRatio),
      pointRounding: pointRounding.merge(other.pointRounding),
      valleyRounding: valleyRounding.merge(other.valleyRounding),
      rotation: rotation.merge(other.rotation),
      squash: squash.merge(other.squash),
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;

  /// The list of properties that constitute the state of this [StarBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StarBorderDto] instances for equality.
  @override
  List<Object?> get props => [
    side,
    points,
    innerRadiusRatio,
    pointRounding,
    valleyRounding,
    rotation,
    squash,
  ];
}

final class LinearBorderDto extends OutlinedBorderDto<LinearBorder> {
  final LinearBorderEdgeDto? start;
  final LinearBorderEdgeDto? end;
  final LinearBorderEdgeDto? top;
  final LinearBorderEdgeDto? bottom;

  const LinearBorderDto({
    super.side,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  // Factory from LinearBorder
  factory LinearBorderDto.from(LinearBorder border) {
    return LinearBorderDto(
      side: BorderSideDto.from(border.side),
      start: LinearBorderEdgeDto.maybeFrom(border.start),
      end: LinearBorderEdgeDto.maybeFrom(border.end),
      top: LinearBorderEdgeDto.maybeFrom(border.top),
      bottom: LinearBorderEdgeDto.maybeFrom(border.bottom),
    );
  }

  // Nullable factory from LinearBorder
  static LinearBorderDto? maybeFrom(LinearBorder? border) {
    return border != null ? LinearBorderDto.from(border) : null;
  }

  @override
  LinearBorderDto adapt(OutlinedBorderDto other) {
    if (other is LinearBorderDto) {
      return other;
    }

    return LinearBorderDto(side: other.side);
  }

  /// Resolves to [LinearBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final linearBorder = LinearBorderDto(...).resolve(mix);
  /// ```
  @override
  LinearBorder resolve(MixContext mix) {
    return LinearBorder(
      side: side?.resolve(mix) ?? BorderSide.none,
      start: start?.resolve(mix),
      end: end?.resolve(mix),
      top: top?.resolve(mix),
      bottom: bottom?.resolve(mix),
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
    if (other == null) return this;

    return LinearBorderDto(
      side: side?.merge(other.side) ?? other.side,
      start: start?.merge(other.start) ?? other.start,
      end: end?.merge(other.end) ?? other.end,
      top: top?.merge(other.top) ?? other.top,
      bottom: bottom?.merge(other.bottom) ?? other.bottom,
    );
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;

  /// The list of properties that constitute the state of this [LinearBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LinearBorderDto] instances for equality.
  @override
  List<Object?> get props => [side, start, end, top, bottom];
}

final class LinearBorderEdgeDto extends Mix<LinearBorderEdge> {
  final MixProperty<double> size;
  final MixProperty<double> alignment;

  // Main constructor accepts real values
  factory LinearBorderEdgeDto({double? size, double? alignment}) {
    return LinearBorderEdgeDto.raw(
      size: MixProperty.prop(size),
      alignment: MixProperty.prop(alignment),
    );
  }

  // Factory that accepts MixableProperty instances
  const LinearBorderEdgeDto.raw({required this.size, required this.alignment});

  // Factory from LinearBorderEdge
  factory LinearBorderEdgeDto.from(LinearBorderEdge edge) {
    return LinearBorderEdgeDto(size: edge.size, alignment: edge.alignment);
  }

  // Nullable factory from LinearBorderEdge
  static LinearBorderEdgeDto? maybeFrom(LinearBorderEdge? edge) {
    return edge != null ? LinearBorderEdgeDto.from(edge) : null;
  }

  /// Resolves to [LinearBorderEdge] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final linearBorderEdge = LinearBorderEdgeDto(...).resolve(mix);
  /// ```
  @override
  LinearBorderEdge resolve(MixContext mix) {
    return LinearBorderEdge(
      size: size.resolve(mix) ?? 1.0,
      alignment: alignment.resolve(mix) ?? 0.0,
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
    if (other == null) return this;

    return LinearBorderEdgeDto.raw(
      size: size.merge(other.size),
      alignment: alignment.merge(other.alignment),
    );
  }

  /// The list of properties that constitute the state of this [LinearBorderEdgeDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LinearBorderEdgeDto] instances for equality.
  @override
  List<Object?> get props => [size, alignment];
}

final class StadiumBorderDto extends OutlinedBorderDto<StadiumBorder> {
  const StadiumBorderDto({super.side});

  // Factory from StadiumBorder
  factory StadiumBorderDto.from(StadiumBorder border) {
    return StadiumBorderDto(side: BorderSideDto.from(border.side));
  }

  // Nullable factory from StadiumBorder
  static StadiumBorderDto? maybeFrom(StadiumBorder? border) {
    return border != null ? StadiumBorderDto.from(border) : null;
  }

  @override
  StadiumBorderDto adapt(OutlinedBorderDto other) {
    if (other is StadiumBorderDto) {
      return other;
    }

    return StadiumBorderDto(side: other.side);
  }

  /// Resolves to [StadiumBorder] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final stadiumBorder = StadiumBorderDto(...).resolve(mix);
  /// ```
  @override
  StadiumBorder resolve(MixContext mix) {
    return StadiumBorder(side: side?.resolve(mix) ?? BorderSide.none);
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
    if (other == null) return this;

    return StadiumBorderDto(side: side?.merge(other.side) ?? other.side);
  }

  @override
  BorderRadiusGeometryDto? get borderRadiusGetter => null;

  /// The list of properties that constitute the state of this [StadiumBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StadiumBorderDto] instances for equality.
  @override
  List<Object?> get props => [side];
}

abstract class MixOutlinedBorder<T extends OutlinedBorderDto>
    extends OutlinedBorder {
  const MixOutlinedBorder({super.side = BorderSide.none});
  T toDto();
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
    : super(valueToDto: (v) => RoundedRectangleBorderDto.from(v));

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: borderRadius != null
          ? BorderRadiusGeometryDto.from(borderRadius)
          : null,
      side: side != null ? BorderSideDto.from(side) : null,
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
    : super(valueToDto: (v) => BeveledRectangleBorderDto.from(v));

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: borderRadius != null
          ? BorderRadiusGeometryDto.from(borderRadius)
          : null,
      side: side != null ? BorderSideDto.from(side) : null,
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
    : super(valueToDto: (v) => ContinuousRectangleBorderDto.from(v));

  T call({BorderRadiusGeometry? borderRadius, BorderSide? side}) {
    return only(
      borderRadius: borderRadius != null
          ? BorderRadiusGeometryDto.from(borderRadius)
          : null,
      side: side != null ? BorderSideDto.from(side) : null,
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

/// Utility class for configuring [CircleBorder] properties.
///
/// This class provides methods to set individual properties of a [CircleBorder].
/// Use the methods of this class to configure specific properties of a [CircleBorder].
class CircleBorderUtility<T extends StyleElement>
    extends DtoUtility<T, CircleBorderDto, CircleBorder> {
  /// Utility for defining [CircleBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  /// Utility for defining [CircleBorderDto.eccentricity]
  late final eccentricity = DoubleUtility(
    (v) => only(eccentricity: Mix.value(v)),
  );

  CircleBorderUtility(super.builder)
    : super(valueToDto: (v) => CircleBorderDto.from(v));

  T call({BorderSide? side, double? eccentricity}) {
    return builder(CircleBorderDto(side: side, eccentricity: eccentricity));
  }

  /// Returns a new [CircleBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side, Mix<double>? eccentricity}) {
    return builder(
      CircleBorderDto.raw(side: side, eccentricity: MixProperty(eccentricity)),
    );
  }
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
  late final points = DoubleUtility((v) => only(points: Mix.value(v)));

  /// Utility for defining [StarBorderDto.innerRadiusRatio]
  late final innerRadiusRatio = DoubleUtility(
    (v) => only(innerRadiusRatio: Mix.value(v)),
  );

  /// Utility for defining [StarBorderDto.pointRounding]
  late final pointRounding = DoubleUtility(
    (v) => only(pointRounding: Mix.value(v)),
  );

  /// Utility for defining [StarBorderDto.valleyRounding]
  late final valleyRounding = DoubleUtility(
    (v) => only(valleyRounding: Mix.value(v)),
  );

  /// Utility for defining [StarBorderDto.rotation]
  late final rotation = DoubleUtility((v) => only(rotation: Mix.value(v)));

  /// Utility for defining [StarBorderDto.squash]
  late final squash = DoubleUtility((v) => only(squash: Mix.value(v)));

  StarBorderUtility(super.builder)
    : super(valueToDto: (v) => StarBorderDto.from(v));

  T call({
    BorderSide? side,
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

  /// Returns a new [StarBorderDto] with the specified properties.
  @override
  T only({
    BorderSideDto? side,
    Mix<double>? points,
    Mix<double>? innerRadiusRatio,
    Mix<double>? pointRounding,
    Mix<double>? valleyRounding,
    Mix<double>? rotation,
    Mix<double>? squash,
  }) {
    return builder(
      StarBorderDto.raw(
        side: side,
        points: MixProperty(points),
        innerRadiusRatio: MixProperty(innerRadiusRatio),
        pointRounding: MixProperty(pointRounding),
        valleyRounding: MixProperty(valleyRounding),
        rotation: MixProperty(rotation),
        squash: MixProperty(squash),
      ),
    );
  }
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

  LinearBorderUtility(super.builder)
    : super(valueToDto: (v) => LinearBorderDto.from(v));

  T call({
    BorderSide? side,
    LinearBorderEdge? start,
    LinearBorderEdge? end,
    LinearBorderEdge? top,
    LinearBorderEdge? bottom,
  }) {
    return only(
      side: side != null ? BorderSideDto.from(side) : null,
      start: start != null ? LinearBorderEdgeDto.from(start) : null,
      end: end != null ? LinearBorderEdgeDto.from(end) : null,
      top: top != null ? LinearBorderEdgeDto.from(top) : null,
      bottom: bottom != null ? LinearBorderEdgeDto.from(bottom) : null,
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

/// Utility class for configuring [LinearBorderEdge] properties.
///
/// This class provides methods to set individual properties of a [LinearBorderEdge].
/// Use the methods of this class to configure specific properties of a [LinearBorderEdge].
class LinearBorderEdgeUtility<T extends StyleElement>
    extends DtoUtility<T, LinearBorderEdgeDto, LinearBorderEdge> {
  /// Utility for defining [LinearBorderEdgeDto.size]
  late final size = DoubleUtility((v) => only(size: Mix.value(v)));

  /// Utility for defining [LinearBorderEdgeDto.alignment]
  late final alignment = DoubleUtility((v) => only(alignment: Mix.value(v)));

  LinearBorderEdgeUtility(super.builder)
    : super(valueToDto: (v) => LinearBorderEdgeDto.from(v));

  T call({double? size, double? alignment}) {
    return builder(LinearBorderEdgeDto(size: size, alignment: alignment));
  }

  /// Returns a new [LinearBorderEdgeDto] with the specified properties.
  @override
  T only({Mix<double>? size, Mix<double>? alignment}) {
    return builder(
      LinearBorderEdgeDto.raw(
        size: MixProperty(size),
        alignment: MixProperty(alignment),
      ),
    );
  }
}

/// Utility class for configuring [StadiumBorder] properties.
///
/// This class provides methods to set individual properties of a [StadiumBorder].
/// Use the methods of this class to configure specific properties of a [StadiumBorder].
class StadiumBorderUtility<T extends StyleElement>
    extends DtoUtility<T, StadiumBorderDto, StadiumBorder> {
  /// Utility for defining [StadiumBorderDto.side]
  late final side = BorderSideUtility((v) => only(side: v));

  StadiumBorderUtility(super.builder)
    : super(valueToDto: (v) => StadiumBorderDto.from(v));

  T call({BorderSide? side}) {
    return only(side: side != null ? BorderSideDto.from(side) : null);
  }

  /// Returns a new [StadiumBorderDto] with the specified properties.
  @override
  T only({BorderSideDto? side}) {
    return builder(StadiumBorderDto(side: side));
  }
}

class ShapeBorderUtility<T extends StyleElement>
    extends MixUtility<T, ShapeBorderDto> {
  late final beveledRectangle = BeveledRectangleBorderUtility(builder);

  late final circle = CircleBorderUtility(builder);

  late final continuousRectangle = ContinuousRectangleBorderUtility(builder);

  late final linear = LinearBorderUtility(builder);

  late final roundedRectangle = RoundedRectangleBorderUtility(builder);

  late final stadium = StadiumBorderUtility(builder);

  late final star = StarBorderUtility(builder);

  late final shapeBuilder = builder;

  ShapeBorderUtility(super.builder);
}

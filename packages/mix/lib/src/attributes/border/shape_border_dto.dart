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
  final Prop<double> eccentricity;

  // Main constructor accepts Mix values
  factory CircleBorderDto({BorderSideDto? side, Mix<double>? eccentricity}) {
    return CircleBorderDto._(side: side, eccentricity: Prop(eccentricity));
  }

  // Private constructor that accepts MixProp instances
  const CircleBorderDto._({required super.side, required this.eccentricity});

  @override
  CircleBorderDto adapt(OutlinedBorderDto other) {
    if (other is CircleBorderDto) {
      return other;
    }

    return CircleBorderDto._(
      side: other.side,
      eccentricity: const Prop.empty(),
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

    return CircleBorderDto._(
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
  final Prop<double> points;
  final Prop<double> innerRadiusRatio;
  final Prop<double> pointRounding;
  final Prop<double> valleyRounding;
  final Prop<double> rotation;
  final Prop<double> squash;

  // Main constructor accepts Mix values
  factory StarBorderDto({
    BorderSideDto? side,
    Mix<double>? points,
    Mix<double>? innerRadiusRatio,
    Mix<double>? pointRounding,
    Mix<double>? valleyRounding,
    Mix<double>? rotation,
    Mix<double>? squash,
  }) {
    return StarBorderDto._(
      side: side,
      points: Prop(points),
      innerRadiusRatio: Prop(innerRadiusRatio),
      pointRounding: Prop(pointRounding),
      valleyRounding: Prop(valleyRounding),
      rotation: Prop(rotation),
      squash: Prop(squash),
    );
  }

  // Private constructor that accepts MixProp instances
  const StarBorderDto._({
    required super.side,
    required this.points,
    required this.innerRadiusRatio,
    required this.pointRounding,
    required this.valleyRounding,
    required this.rotation,
    required this.squash,
  });

  @override
  StarBorderDto adapt(OutlinedBorderDto other) {
    return StarBorderDto._(
      side: other.side,
      points: const Prop.empty(),
      innerRadiusRatio: const Prop.empty(),
      pointRounding: const Prop.empty(),
      valleyRounding: const Prop.empty(),
      rotation: const Prop.empty(),
      squash: const Prop.empty(),
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

    return StarBorderDto._(
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
  final Prop<double> size;
  final Prop<double> alignment;

  // Main constructor accepts Mix values
  factory LinearBorderEdgeDto({Mix<double>? size, Mix<double>? alignment}) {
    return LinearBorderEdgeDto._(size: Prop(size), alignment: Prop(alignment));
  }

  // Private constructor that accepts MixProp instances
  const LinearBorderEdgeDto._({required this.size, required this.alignment});

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

    return LinearBorderEdgeDto._(
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

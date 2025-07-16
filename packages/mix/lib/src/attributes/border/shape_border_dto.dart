// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

@immutable
sealed class ShapeBorderDto<T extends ShapeBorder> extends Mix<T> {
  const ShapeBorderDto();

  /// Constructor that accepts a [ShapeBorder] value and converts it to the appropriate DTO.
  ///
  /// This is useful for converting existing [ShapeBorder] instances to [ShapeBorderDto].
  ///
  /// ```dart
  /// const border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = ShapeBorderDto.value(border);
  /// ```
  static ShapeBorderDto value(ShapeBorder border) {
    return switch (border) {
      RoundedRectangleBorder b => RoundedRectangleBorderDto.value(b),
      BeveledRectangleBorder b => BeveledRectangleBorderDto.value(b),
      ContinuousRectangleBorder b => ContinuousRectangleBorderDto.value(b),
      CircleBorder b => CircleBorderDto.value(b),
      StarBorder b => StarBorderDto.value(b),
      LinearBorder b => LinearBorderDto.value(b),
      StadiumBorder b => StadiumBorderDto.value(b),
      _ => throw ArgumentError(
        'Unsupported ShapeBorder type: ${border.runtimeType}',
      ),
    };
  }

  /// Constructor that accepts a nullable [ShapeBorder] value and converts it to the appropriate DTO.
  ///
  /// Returns null if the input is null, otherwise uses [ShapeBorderDto.value].
  ///
  /// ```dart
  /// const ShapeBorder? border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = ShapeBorderDto.maybeValue(border); // Returns ShapeBorderDto or null
  /// ```
  static ShapeBorderDto? maybeValue(ShapeBorder? border) {
    return border != null ? ShapeBorderDto.value(border) : null;
  }

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
    MixProp<BorderSide, BorderSideDto>? side,
    MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>? borderRadius,
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
  final MixProp<BorderSide, BorderSideDto>? side;

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
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter;

  OutlinedBorderDto<T> adapt(OutlinedBorderDto other);

  @override
  OutlinedBorderDto<T> merge(covariant OutlinedBorderDto<T>? other);
}

final class RoundedRectangleBorderDto
    extends OutlinedBorderDto<RoundedRectangleBorder> {
  final MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>? borderRadius;

  factory RoundedRectangleBorderDto({
    BorderRadiusGeometryDto? borderRadius,
    BorderSideDto? side,
  }) {
    return RoundedRectangleBorderDto.props(
      borderRadius: MixProp.maybeValue(borderRadius),
      side: MixProp.maybeValue(side),
    );
  }

  const RoundedRectangleBorderDto.props({this.borderRadius, super.side});

  /// Constructor that accepts a [RoundedRectangleBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [RoundedRectangleBorder] instances to [RoundedRectangleBorderDto].
  ///
  /// ```dart
  /// const border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = RoundedRectangleBorderDto.value(border);
  /// ```
  factory RoundedRectangleBorderDto.value(RoundedRectangleBorder border) {
    return RoundedRectangleBorderDto(
      borderRadius: border.borderRadius != BorderRadius.zero
          ? BorderRadiusDto.value(border.borderRadius as BorderRadius)
          : null,
      side: BorderSideDto.maybeValue(border.side),
    );
  }

  /// Constructor that accepts a nullable [RoundedRectangleBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [RoundedRectangleBorderDto.value].
  ///
  /// ```dart
  /// const RoundedRectangleBorder? border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = RoundedRectangleBorderDto.maybeValue(border); // Returns RoundedRectangleBorderDto or null
  /// ```
  static RoundedRectangleBorderDto? maybeValue(RoundedRectangleBorder? border) {
    return border != null ? RoundedRectangleBorderDto.value(border) : null;
  }

  @override
  RoundedRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is RoundedRectangleBorderDto) return other;

    return RoundedRectangleBorderDto.props(
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
  RoundedRectangleBorder resolve(MixContext context) {
    return RoundedRectangleBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
      borderRadius: resolveMixProp(context, borderRadius) ?? BorderRadius.zero,
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

    return RoundedRectangleBorderDto.props(
      borderRadius: mergeMixProp(borderRadius, other.borderRadius),
      side: mergeMixProp(side, other.side),
    );
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => borderRadius;

  /// The list of properties that constitute the state of this [RoundedRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [RoundedRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [borderRadius, side];
}

final class BeveledRectangleBorderDto
    extends OutlinedBorderDto<BeveledRectangleBorder> {
  final MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>? borderRadius;

  factory BeveledRectangleBorderDto({
    BorderRadiusGeometryDto? borderRadius,
    BorderSideDto? side,
  }) {
    return BeveledRectangleBorderDto.props(
      borderRadius: MixProp.maybeValue(borderRadius),
      side: MixProp.maybeValue(side),
    );
  }

  const BeveledRectangleBorderDto.props({this.borderRadius, super.side});

  /// Constructor that accepts a [BeveledRectangleBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [BeveledRectangleBorder] instances to [BeveledRectangleBorderDto].
  ///
  /// ```dart
  /// const border = BeveledRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = BeveledRectangleBorderDto.value(border);
  /// ```
  factory BeveledRectangleBorderDto.value(BeveledRectangleBorder border) {
    return BeveledRectangleBorderDto(
      borderRadius: border.borderRadius != BorderRadius.zero
          ? BorderRadiusDto.value(border.borderRadius as BorderRadius)
          : null,
      side: BorderSideDto.maybeValue(border.side),
    );
  }

  /// Constructor that accepts a nullable [BeveledRectangleBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BeveledRectangleBorderDto.value].
  ///
  /// ```dart
  /// const BeveledRectangleBorder? border = BeveledRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = BeveledRectangleBorderDto.maybeValue(border); // Returns BeveledRectangleBorderDto or null
  /// ```
  static BeveledRectangleBorderDto? maybeValue(BeveledRectangleBorder? border) {
    return border != null ? BeveledRectangleBorderDto.value(border) : null;
  }

  @override
  BeveledRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is BeveledRectangleBorderDto) return other;

    return BeveledRectangleBorderDto.props(
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
  BeveledRectangleBorder resolve(MixContext context) {
    return BeveledRectangleBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
      borderRadius: resolveMixProp(context, borderRadius) ?? BorderRadius.zero,
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

    return BeveledRectangleBorderDto.props(
      borderRadius: mergeMixProp(borderRadius, other.borderRadius),
      side: mergeMixProp(side, other.side),
    );
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => borderRadius;

  /// The list of properties that constitute the state of this [BeveledRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BeveledRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [borderRadius, side];
}

final class ContinuousRectangleBorderDto
    extends OutlinedBorderDto<ContinuousRectangleBorder> {
  final MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>? borderRadius;

  factory ContinuousRectangleBorderDto({
    BorderRadiusGeometryDto? borderRadius,
    BorderSideDto? side,
  }) {
    return ContinuousRectangleBorderDto.props(
      borderRadius: MixProp.maybeValue(borderRadius),
      side: MixProp.maybeValue(side),
    );
  }

  const ContinuousRectangleBorderDto.props({this.borderRadius, super.side});

  /// Constructor that accepts a [ContinuousRectangleBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [ContinuousRectangleBorder] instances to [ContinuousRectangleBorderDto].
  ///
  /// ```dart
  /// const border = ContinuousRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = ContinuousRectangleBorderDto.value(border);
  /// ```
  factory ContinuousRectangleBorderDto.value(ContinuousRectangleBorder border) {
    return ContinuousRectangleBorderDto(
      borderRadius: border.borderRadius != BorderRadius.zero
          ? BorderRadiusDto.value(border.borderRadius as BorderRadius)
          : null,
      side: BorderSideDto.maybeValue(border.side),
    );
  }

  /// Constructor that accepts a nullable [ContinuousRectangleBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ContinuousRectangleBorderDto.value].
  ///
  /// ```dart
  /// const ContinuousRectangleBorder? border = ContinuousRectangleBorder(borderRadius: BorderRadius.circular(8));
  /// final dto = ContinuousRectangleBorderDto.maybeValue(border); // Returns ContinuousRectangleBorderDto or null
  /// ```
  static ContinuousRectangleBorderDto? maybeValue(
    ContinuousRectangleBorder? border,
  ) {
    return border != null ? ContinuousRectangleBorderDto.value(border) : null;
  }

  @override
  ContinuousRectangleBorderDto adapt(OutlinedBorderDto other) {
    if (other is ContinuousRectangleBorderDto) {
      return other;
    }

    return ContinuousRectangleBorderDto.props(
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
  ContinuousRectangleBorder resolve(MixContext context) {
    return ContinuousRectangleBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
      borderRadius: resolveMixProp(context, borderRadius) ?? BorderRadius.zero,
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

    return ContinuousRectangleBorderDto.props(
      borderRadius: mergeMixProp(borderRadius, other.borderRadius),
      side: mergeMixProp(side, other.side),
    );
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => borderRadius;

  /// The list of properties that constitute the state of this [ContinuousRectangleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ContinuousRectangleBorderDto] instances for equality.
  @override
  List<Object?> get props => [borderRadius, side];
}

final class CircleBorderDto extends OutlinedBorderDto<CircleBorder> {
  final Prop<double>? eccentricity;

  // Main constructor accepts raw values
  factory CircleBorderDto({BorderSideDto? side, double? eccentricity}) {
    return CircleBorderDto.props(
      side: side != null ? MixProp.fromValue(side) : null,
      eccentricity: Prop.maybeValue(eccentricity),
    );
  }

  // Private constructor that accepts MixProp instances
  const CircleBorderDto.props({super.side, this.eccentricity});

  /// Constructor that accepts a [CircleBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [CircleBorder] instances to [CircleBorderDto].
  ///
  /// ```dart
  /// const border = CircleBorder(side: BorderSide(color: Colors.red));
  /// final dto = CircleBorderDto.value(border);
  /// ```
  factory CircleBorderDto.value(CircleBorder border) {
    return CircleBorderDto(
      side: BorderSideDto.maybeValue(border.side),
      eccentricity: border.eccentricity,
    );
  }

  /// Constructor that accepts a nullable [CircleBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [CircleBorderDto.value].
  ///
  /// ```dart
  /// const CircleBorder? border = CircleBorder(side: BorderSide(color: Colors.red));
  /// final dto = CircleBorderDto.maybeValue(border); // Returns CircleBorderDto or null
  /// ```
  static CircleBorderDto? maybeValue(CircleBorder? border) {
    return border != null ? CircleBorderDto.value(border) : null;
  }

  @override
  CircleBorderDto adapt(OutlinedBorderDto other) {
    if (other is CircleBorderDto) {
      return other;
    }

    return CircleBorderDto.props(side: other.side, eccentricity: null);
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
  CircleBorder resolve(MixContext context) {
    return CircleBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
      eccentricity: resolveProp(context, eccentricity) ?? 0.0,
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

    return CircleBorderDto.props(
      side: mergeMixProp(side, other.side),
      eccentricity: mergeProp(eccentricity, other.eccentricity),
    );
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => null;

  /// The list of properties that constitute the state of this [CircleBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [CircleBorderDto] instances for equality.
  @override
  List<Object?> get props => [side, eccentricity];
}

final class StarBorderDto extends OutlinedBorderDto<StarBorder> {
  final Prop<double>? points;
  final Prop<double>? innerRadiusRatio;
  final Prop<double>? pointRounding;
  final Prop<double>? valleyRounding;
  final Prop<double>? rotation;
  final Prop<double>? squash;

  // Main constructor accepts raw values
  factory StarBorderDto({
    BorderSideDto? side,
    double? points,
    double? innerRadiusRatio,
    double? pointRounding,
    double? valleyRounding,
    double? rotation,
    double? squash,
  }) {
    return StarBorderDto.props(
      side: side != null ? MixProp.fromValue(side) : null,
      points: Prop.maybeValue(points),
      innerRadiusRatio: Prop.maybeValue(innerRadiusRatio),
      pointRounding: Prop.maybeValue(pointRounding),
      valleyRounding: Prop.maybeValue(valleyRounding),
      rotation: Prop.maybeValue(rotation),
      squash: Prop.maybeValue(squash),
    );
  }

  /// Constructor that accepts a [StarBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [StarBorder] instances to [StarBorderDto].
  ///
  /// ```dart
  /// const border = StarBorder(points: 6);
  /// final dto = StarBorderDto.value(border);
  /// ```
  factory StarBorderDto.value(StarBorder border) {
    return StarBorderDto(
      side: BorderSideDto.maybeValue(border.side),
      points: border.points,
      innerRadiusRatio: border.innerRadiusRatio,
      pointRounding: border.pointRounding,
      valleyRounding: border.valleyRounding,
      rotation: border.rotation,
      squash: border.squash,
    );
  }

  // Private constructor that accepts MixProp instances
  const StarBorderDto.props({
    super.side,
    this.points,
    this.innerRadiusRatio,
    this.pointRounding,
    this.valleyRounding,
    this.rotation,
    this.squash,
  });

  /// Constructor that accepts a nullable [StarBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StarBorderDto.value].
  ///
  /// ```dart
  /// const StarBorder? border = StarBorder(points: 6);
  /// final dto = StarBorderDto.maybeValue(border); // Returns StarBorderDto or null
  /// ```
  static StarBorderDto? maybeValue(StarBorder? border) {
    return border != null ? StarBorderDto.value(border) : null;
  }

  @override
  StarBorderDto adapt(OutlinedBorderDto other) {
    return StarBorderDto.props(
      side: other.side,
      points: null,
      innerRadiusRatio: null,
      pointRounding: null,
      valleyRounding: null,
      rotation: null,
      squash: null,
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
  StarBorder resolve(MixContext context) {
    return StarBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
      points: resolveProp(context, points) ?? 5,
      innerRadiusRatio: resolveProp(context, innerRadiusRatio) ?? 0.4,
      pointRounding: resolveProp(context, pointRounding) ?? 0,
      valleyRounding: resolveProp(context, valleyRounding) ?? 0,
      rotation: resolveProp(context, rotation) ?? 0,
      squash: resolveProp(context, squash) ?? 0,
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

    return StarBorderDto.props(
      side: mergeMixProp(side, other.side),
      points: mergeProp(points, other.points),
      innerRadiusRatio: mergeProp(innerRadiusRatio, other.innerRadiusRatio),
      pointRounding: mergeProp(pointRounding, other.pointRounding),
      valleyRounding: mergeProp(valleyRounding, other.valleyRounding),
      rotation: mergeProp(rotation, other.rotation),
      squash: mergeProp(squash, other.squash),
    );
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => null;

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
  final MixProp<LinearBorderEdge, LinearBorderEdgeDto>? start;
  final MixProp<LinearBorderEdge, LinearBorderEdgeDto>? end;
  final MixProp<LinearBorderEdge, LinearBorderEdgeDto>? top;
  final MixProp<LinearBorderEdge, LinearBorderEdgeDto>? bottom;

  factory LinearBorderDto({
    BorderSideDto? side,
    LinearBorderEdgeDto? start,
    LinearBorderEdgeDto? end,
    LinearBorderEdgeDto? top,
    LinearBorderEdgeDto? bottom,
  }) {
    return LinearBorderDto.props(
      side: MixProp.maybeValue(side),
      start: MixProp.maybeValue(start),
      end: MixProp.maybeValue(end),
      top: MixProp.maybeValue(top),
      bottom: MixProp.maybeValue(bottom),
    );
  }

  const LinearBorderDto.props({
    super.side,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  /// Constructor that accepts a [LinearBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [LinearBorder] instances to [LinearBorderDto].
  ///
  /// ```dart
  /// const border = LinearBorder(side: BorderSide(color: Colors.blue));
  /// final dto = LinearBorderDto.value(border);
  /// ```
  factory LinearBorderDto.value(LinearBorder border) {
    return LinearBorderDto(
      side: BorderSideDto.maybeValue(border.side),
      start: LinearBorderEdgeDto.maybeValue(border.start),
      end: LinearBorderEdgeDto.maybeValue(border.end),
      top: LinearBorderEdgeDto.maybeValue(border.top),
      bottom: LinearBorderEdgeDto.maybeValue(border.bottom),
    );
  }

  /// Constructor that accepts a nullable [LinearBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [LinearBorderDto.value].
  ///
  /// ```dart
  /// const LinearBorder? border = LinearBorder(side: BorderSide(color: Colors.blue));
  /// final dto = LinearBorderDto.maybeValue(border); // Returns LinearBorderDto or null
  /// ```
  static LinearBorderDto? maybeValue(LinearBorder? border) {
    return border != null ? LinearBorderDto.value(border) : null;
  }

  @override
  LinearBorderDto adapt(OutlinedBorderDto other) {
    if (other is LinearBorderDto) {
      return other;
    }

    return LinearBorderDto.props(side: other.side);
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
  LinearBorder resolve(MixContext context) {
    return LinearBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
      start: resolveMixProp(context, start),
      end: resolveMixProp(context, end),
      top: resolveMixProp(context, top),
      bottom: resolveMixProp(context, bottom),
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

    return LinearBorderDto.props(
      side: mergeMixProp(side, other.side),
      start: mergeMixProp(start, other.start),
      end: mergeMixProp(end, other.end),
      top: mergeMixProp(top, other.top),
      bottom: mergeMixProp(bottom, other.bottom),
    );
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => null;

  /// The list of properties that constitute the state of this [LinearBorderDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [LinearBorderDto] instances for equality.
  @override
  List<Object?> get props => [side, start, end, top, bottom];
}

final class LinearBorderEdgeDto extends Mix<LinearBorderEdge> {
  final Prop<double>? size;
  final Prop<double>? alignment;

  // Main constructor accepts raw values
  factory LinearBorderEdgeDto({double? size, double? alignment}) {
    return LinearBorderEdgeDto.props(
      size: Prop.maybeValue(size),
      alignment: Prop.maybeValue(alignment),
    );
  }

  /// Constructor that accepts a [LinearBorderEdge] value and extracts its properties.
  ///
  /// This is useful for converting existing [LinearBorderEdge] instances to [LinearBorderEdgeDto].
  ///
  /// ```dart
  /// const edge = LinearBorderEdge(size: 2.0, alignment: 0.5);
  /// final dto = LinearBorderEdgeDto.value(edge);
  /// ```
  factory LinearBorderEdgeDto.value(LinearBorderEdge edge) {
    return LinearBorderEdgeDto(size: edge.size, alignment: edge.alignment);
  }

  // Private constructor that accepts MixProp instances
  const LinearBorderEdgeDto.props({this.size, this.alignment});

  /// Constructor that accepts a nullable [LinearBorderEdge] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [LinearBorderEdgeDto.value].
  ///
  /// ```dart
  /// const LinearBorderEdge? edge = LinearBorderEdge(size: 2.0, alignment: 0.5);
  /// final dto = LinearBorderEdgeDto.maybeValue(edge); // Returns LinearBorderEdgeDto or null
  /// ```
  static LinearBorderEdgeDto? maybeValue(LinearBorderEdge? edge) {
    return edge != null ? LinearBorderEdgeDto.value(edge) : null;
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
  LinearBorderEdge resolve(MixContext context) {
    return LinearBorderEdge(
      size: resolveProp(context, size) ?? 1.0,
      alignment: resolveProp(context, alignment) ?? 0.0,
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

    return LinearBorderEdgeDto.props(
      size: mergeProp(size, other.size),
      alignment: mergeProp(alignment, other.alignment),
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
  factory StadiumBorderDto({BorderSideDto? side}) {
    return StadiumBorderDto.props(side: MixProp.maybeValue(side));
  }

  const StadiumBorderDto.props({super.side});

  /// Constructor that accepts a [StadiumBorder] value and extracts its properties.
  ///
  /// This is useful for converting existing [StadiumBorder] instances to [StadiumBorderDto].
  ///
  /// ```dart
  /// const border = StadiumBorder(side: BorderSide(color: Colors.green));
  /// final dto = StadiumBorderDto.value(border);
  /// ```
  factory StadiumBorderDto.value(StadiumBorder border) {
    return StadiumBorderDto(side: BorderSideDto.maybeValue(border.side));
  }

  /// Constructor that accepts a nullable [StadiumBorder] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StadiumBorderDto.value].
  ///
  /// ```dart
  /// const StadiumBorder? border = StadiumBorder(side: BorderSide(color: Colors.green));
  /// final dto = StadiumBorderDto.maybeValue(border); // Returns StadiumBorderDto or null
  /// ```
  static StadiumBorderDto? maybeValue(StadiumBorder? border) {
    return border != null ? StadiumBorderDto.value(border) : null;
  }

  @override
  StadiumBorderDto adapt(OutlinedBorderDto other) {
    if (other is StadiumBorderDto) {
      return other;
    }

    return StadiumBorderDto.props(side: other.side);
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
  StadiumBorder resolve(MixContext context) {
    return StadiumBorder(
      side: resolveMixProp(context, side) ?? BorderSide.none,
    );
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

    return StadiumBorderDto.props(side: mergeMixProp(side, other.side));
  }

  @override
  MixProp<BorderRadiusGeometry, BorderRadiusGeometryDto>?
  get borderRadiusGetter => null;

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

import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/prop.dart';
import '../../core/utility.dart';
import '../scalars/scalar_util.dart';
import 'border_radius_dto.dart';

/// Utility class for creating and manipulating attributes with [BorderRadiusGeometry]
///
/// Extends the [BorderRadiusUtility] class to provide additional utility methods for creating and manipulating [BorderRadiusGeometry] attributes.
/// adds a [directional] property that returns a [BorderRadiusDirectionalUtility] instance.
final class BorderRadiusGeometryUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderRadiusGeometry> {
  /// Returns a directional utility for creating and manipulating attributes with [BorderRadiusDirectional]
  late final directional = BorderRadiusDirectionalUtility<T>(builder);

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  late final all = _bordeRadius.all;

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = _bordeRadius.bottomLeft;

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = _bordeRadius.bottomRight;

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = _bordeRadius.topLeft;

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight corner.
  late final topRight = _bordeRadius.topRight;

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = _bordeRadius.top;

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = _bordeRadius.bottom;

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = _bordeRadius.left;

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = _bordeRadius.right;

  /// Sets a circular [Radius] for all corners.
  late final circular = _bordeRadius.circular;

  /// Sets an elliptical [Radius] for all corners.
  late final elliptical = _bordeRadius.elliptical;

  /// Sets a zero [Radius] for all corn
  late final zero = _bordeRadius.zero;

  late final _bordeRadius = BorderRadiusUtility<T>(builder);

  BorderRadiusGeometryUtility(super.builder)
    : super(valueToMix: BorderRadiusGeometryDto.value);

  @override
  T call(BorderRadiusGeometryDto value) => builder(MixProp(value));
}

/// Utility class for creating and manipulating attributes with [BorderRadius]
///
/// Allows setting of radius for a border. This class provides a convenient way to configure and apply border radius to [T]
/// Accepts a builder function that returns [T] and takes a [BorderRadiusDto] as a parameter.
final class BorderRadiusUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderRadius> {
  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(bottomLeft: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(bottomRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(topLeft: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight corner.
  late final topRight = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(topRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  late final all = RadiusUtility<T>(
    (radius) => call(
      BorderRadiusDto(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
    ),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(topLeft: radius, topRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(bottomLeft: radius, bottomRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(topLeft: radius, bottomLeft: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = RadiusUtility<T>(
    (radius) => call(BorderRadiusDto(topRight: radius, bottomRight: radius)),
  );

  /// Sets a circular [Radius] for all corners.
  late final circular = all.circular;

  /// Sets an elliptical [Radius] for all corners.
  late final elliptical = all.elliptical;

  /// Sets a zero [Radius] for all corners.
  late final zero = all.zero;
  BorderRadiusUtility(super.builder) : super(valueToMix: BorderRadiusDto.value);

  @override
  T call(BorderRadiusDto value) => builder(MixProp(value));
}

final class BorderRadiusDirectionalUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderRadiusDirectional> {
  const BorderRadiusDirectionalUtility(super.builder)
    : super(valueToMix: BorderRadiusDirectionalDto.value);

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  RadiusUtility<T> get all {
    return RadiusUtility(
      (radius) => call(
        BorderRadiusDirectionalDto(
          topStart: radius,
          topEnd: radius,
          bottomStart: radius,
          bottomEnd: radius,
        ),
      ),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart and topEnd corner.
  RadiusUtility<T> get top {
    return RadiusUtility(
      (radius) =>
          call(BorderRadiusDirectionalDto(topStart: radius, topEnd: radius)),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomStart and bottomEnd corner.
  RadiusUtility<T> get bottom {
    return RadiusUtility(
      (radius) => call(
        BorderRadiusDirectionalDto(bottomStart: radius, bottomEnd: radius),
      ),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart and bottomStart corner.
  RadiusUtility<T> get start {
    return RadiusUtility(
      (radius) => call(
        BorderRadiusDirectionalDto(topStart: radius, bottomStart: radius),
      ),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topEnd and bottomEnd corner.
  RadiusUtility<T> get end {
    return RadiusUtility(
      (radius) =>
          call(BorderRadiusDirectionalDto(topEnd: radius, bottomEnd: radius)),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart corner.
  RadiusUtility<T> get topStart {
    return RadiusUtility(
      (radius) => call(BorderRadiusDirectionalDto(topStart: radius)),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topEnd corner.
  RadiusUtility<T> get topEnd {
    return RadiusUtility(
      (radius) => call(BorderRadiusDirectionalDto(topEnd: radius)),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomStart corner.
  RadiusUtility<T> get bottomStart {
    return RadiusUtility(
      (radius) => call(BorderRadiusDirectionalDto(bottomStart: radius)),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomEnd corner.
  RadiusUtility<T> get bottomEnd {
    return RadiusUtility(
      (radius) => call(BorderRadiusDirectionalDto(bottomEnd: radius)),
    );
  }

  T circular(double radius) {
    return all.circular(radius);
  }

  T elliptical(double x, double y) {
    return all.elliptical(x, y);
  }

  T zero() {
    return all.zero();
  }

  @override
  T call(BorderRadiusDirectionalDto value) => builder(MixProp(value));
}

import 'package:flutter/widgets.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'border_radius_mix.dart';
import 'scalar_util.dart';

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
    : super(convertToMix: BorderRadiusGeometryMix.value);

  @override
  T call(BorderRadiusGeometryMix value) => builder(MixProp(value));
}

/// Utility class for creating and manipulating attributes with [BorderRadius]
///
/// Allows setting of radius for a border. This class provides a convenient way to configure and apply border radius to [T]
/// Accepts a builder function that returns [T] and takes a [BorderRadiusMix] as a parameter.
final class BorderRadiusUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderRadius> {
  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(bottomLeft: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(bottomRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(topLeft: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight corner.
  late final topRight = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(topRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  late final all = RadiusUtility<T>(
    (radius) => call(
      BorderRadiusMix(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
    ),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(topLeft: radius, topRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(bottomLeft: radius, bottomRight: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(topLeft: radius, bottomLeft: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = RadiusUtility<T>(
    (radius) => call(BorderRadiusMix(topRight: radius, bottomRight: radius)),
  );

  /// Sets a circular [Radius] for all corners.
  late final circular = all.circular;

  /// Sets an elliptical [Radius] for all corners.
  late final elliptical = all.elliptical;

  /// Sets a zero [Radius] for all corners.
  late final zero = all.zero;

  BorderRadiusUtility(super.builder)
    : super(convertToMix: BorderRadiusMix.value);

  @override
  T call(BorderRadiusMix value) => builder(MixProp(value));
}

final class BorderRadiusDirectionalUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BorderRadiusDirectional> {
  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart and topEnd corner.
  late final top = RadiusUtility(
    (radius) =>
        call(BorderRadiusDirectionalMix(topStart: radius, topEnd: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomStart and bottomEnd corner.
  late final bottom = RadiusUtility(
    (radius) => call(
      BorderRadiusDirectionalMix(bottomStart: radius, bottomEnd: radius),
    ),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart and bottomStart corner.
  late final start = RadiusUtility(
    (radius) =>
        call(BorderRadiusDirectionalMix(topStart: radius, bottomStart: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topEnd and bottomEnd corner.
  late final end = RadiusUtility(
    (radius) =>
        call(BorderRadiusDirectionalMix(topEnd: radius, bottomEnd: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart corner.
  late final topStart = RadiusUtility(
    (radius) => call(BorderRadiusDirectionalMix(topStart: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topEnd corner.
  late final topEnd = RadiusUtility(
    (radius) => call(BorderRadiusDirectionalMix(topEnd: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomStart corner.
  late final bottomStart = RadiusUtility(
    (radius) => call(BorderRadiusDirectionalMix(bottomStart: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomEnd corner.
  late final bottomEnd = RadiusUtility(
    (radius) => call(BorderRadiusDirectionalMix(bottomEnd: radius)),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  late final all = RadiusUtility(
    (radius) => call(
      BorderRadiusDirectionalMix(
        topStart: radius,
        topEnd: radius,
        bottomStart: radius,
        bottomEnd: radius,
      ),
    ),
  );

  BorderRadiusDirectionalUtility(super.builder)
    : super(convertToMix: BorderRadiusDirectionalMix.value);

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
  T call(BorderRadiusDirectionalMix value) => builder(MixProp(value));
}

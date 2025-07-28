import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../layout/scalar_util.dart';
import 'border_radius_mix.dart';

/// Utility class for creating and manipulating attributes with [BorderRadiusGeometry]
///
/// Extends the [BorderRadiusUtility] class to provide additional utility methods for creating and manipulating [BorderRadiusGeometry] attributes.
/// adds a [directional] property that returns a [BorderRadiusDirectionalUtility] instance.
final class BorderRadiusGeometryUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BorderRadiusGeometry> {
  /// Returns a directional utility for creating and manipulating attributes with [BorderRadiusDirectional]
  late final borderRadiusDirectional = BorderRadiusDirectionalUtility<T>(
    builder,
  );

  late final borderRadius = BorderRadiusUtility<T>(builder);

  BorderRadiusGeometryUtility(super.builder)
    : super(convertToMix: BorderRadiusGeometryMix.value);

  @override
  T call(BorderRadiusGeometryMix value) => builder(MixProp(value));
}

/// Utility class for creating and manipulating attributes with [BorderRadius]
///
/// Allows setting of radius for a border. This class provides a convenient way to configure and apply border radius to [T]
/// Accepts a builder function that returns [T] and takes a [BorderRadiusMix] as a parameter.
final class BorderRadiusUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BorderRadius> {
  /// Returns a [PropUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(bottomLeft: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(bottomRight: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(topLeft: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topRight corner.
  late final topRight = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(topRight: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for all corners.
  late final all = PropUtility<T, Radius>(
    (radius) => call(
      BorderRadiusMix.raw(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
    ),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(topLeft: radius, topRight: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(bottomLeft: radius, bottomRight: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(topLeft: radius, bottomLeft: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusMix.raw(topRight: radius, bottomRight: radius)),
  );

  BorderRadiusUtility(super.builder)
    : super(convertToMix: BorderRadiusMix.value);

  /// Sets a circular [Radius] for all corners.
  T circular(double radius) => all.circular(radius);

  /// Sets an elliptical [Radius] for all corners.
  T elliptical(double x, double y) => all.elliptical(x, y);

  /// Sets a zero [Radius] for all corners.
  T zero() => all.zero();

  @override
  T call(BorderRadiusMix value) => builder(MixProp(value));
}

final class BorderRadiusDirectionalUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BorderRadiusDirectional> {
  /// Returns a [PropUtility] to manipulate [Radius] for topStart and topEnd corner.
  late final top = PropUtility<T, Radius>(
    (radius) =>
        call(BorderRadiusDirectionalMix.raw(topStart: radius, topEnd: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomStart and bottomEnd corner.
  late final bottom = PropUtility<T, Radius>(
    (radius) => call(
      BorderRadiusDirectionalMix.raw(bottomStart: radius, bottomEnd: radius),
    ),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topStart and bottomStart corner.
  late final start = PropUtility<T, Radius>(
    (radius) =>
        call(BorderRadiusDirectionalMix.raw(topStart: radius, bottomStart: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topEnd and bottomEnd corner.
  late final end = PropUtility<T, Radius>(
    (radius) =>
        call(BorderRadiusDirectionalMix.raw(topEnd: radius, bottomEnd: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topStart corner.
  late final topStart = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusDirectionalMix.raw(topStart: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topEnd corner.
  late final topEnd = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusDirectionalMix.raw(topEnd: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomStart corner.
  late final bottomStart = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusDirectionalMix.raw(bottomStart: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomEnd corner.
  late final bottomEnd = PropUtility<T, Radius>(
    (radius) => call(BorderRadiusDirectionalMix.raw(bottomEnd: radius)),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for all corners.
  late final all = PropUtility<T, Radius>(
    (radius) => call(
      BorderRadiusDirectionalMix.raw(
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


import 'package:flutter/widgets.dart';

import '../../core/mix_element.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../layout/scalar_util.dart';
import 'border_radius_mix.dart';

/// Mixin that provides convenient border radius methods
mixin BorderRadiusMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  T borderRadius(BorderRadiusGeometryMix value);
}

/// Utility class for creating and manipulating attributes with [BorderRadiusGeometry]
///
/// Extends the [BorderRadiusUtility] class to provide additional utility methods for creating and manipulating [BorderRadiusGeometry] attributes.
/// adds a [directional] property that returns a [BorderRadiusDirectionalUtility] instance.
final class BorderRadiusGeometryUtility<T extends Style<Object?>>
    extends MixUtility<T, BorderRadiusGeometryMix> {
  /// Returns a directional utility for creating and manipulating attributes with [BorderRadiusDirectional]
  late final borderRadiusDirectional = BorderRadiusDirectionalUtility<T>(
    utilityBuilder,
  );

  /// Returns a utility for creating and manipulating attributes with [BorderRadius]
  late final borderRadius = BorderRadiusUtility<T>(utilityBuilder);

  BorderRadiusGeometryUtility(super.utilityBuilder);
  @Deprecated('Use borderRadius.circular instead')
  T call(double value) => utilityBuilder(BorderRadiusMix.circular(value));

  T as(BorderRadiusGeometry value) {
    return utilityBuilder(BorderRadiusGeometryMix.value(value));
  }
}

/// Utility class for creating and manipulating attributes with [BorderRadius]
///
/// Allows setting of radius for a border. This class provides a convenient way to configure and apply border radius to [T]
/// Accepts a builder function that returns [T] and takes a [BorderRadiusMix] as a parameter.
final class BorderRadiusUtility<T extends Style<Object?>>
    extends MixUtility<T, BorderRadiusMix> {
  /// Returns a [MixUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = MixUtility<T, Radius>(
    (radius) => only(bottomLeft: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = MixUtility<T, Radius>(
    (radius) => only(bottomRight: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = MixUtility<T, Radius>((radius) => only(topLeft: radius));

  /// Returns a [MixUtility] to manipulate [Radius] for topRight corner.
  late final topRight = MixUtility<T, Radius>(
    (radius) => only(topRight: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for all corners.
  late final all = MixUtility<T, Radius>(
    (radius) => only(
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = MixUtility<T, Radius>(
    (radius) => only(topLeft: radius, topRight: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = MixUtility<T, Radius>(
    (radius) => only(bottomLeft: radius, bottomRight: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = MixUtility<T, Radius>(
    (radius) => only(topLeft: radius, bottomLeft: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = MixUtility<T, Radius>(
    (radius) => only(topRight: radius, bottomRight: radius),
  );

  BorderRadiusUtility(super.utilityBuilder);

  /// Sets a circular [Radius] for all corners.
  T circular(double radius) => all.circular(radius);

  /// Sets an elliptical [Radius] for all corners.
  T elliptical(double x, double y) => all.elliptical(x, y);

  /// Sets a zero [Radius] for all corners.
  T zero() => all.zero();

  @Deprecated('Use borderRadius.circular instead')
  T call(double value) => utilityBuilder(BorderRadiusMix.circular(value));

  T only({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return utilityBuilder(
      BorderRadiusMix(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      ),
    );
  }

  T as(BorderRadius value) {
    return utilityBuilder(BorderRadiusMix.value(value));
  }
}

final class BorderRadiusDirectionalUtility<T extends Style<Object?>>
    extends MixUtility<T, BorderRadiusDirectionalMix> {
  /// Returns a [MixUtility] to manipulate [Radius] for topStart and topEnd corner.
  late final top = MixUtility<T, Radius>(
    (radius) => only(topStart: radius, topEnd: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for bottomStart and bottomEnd corner.
  late final bottom = MixUtility<T, Radius>(
    (radius) => only(bottomStart: radius, bottomEnd: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topStart and bottomStart corner.
  late final start = MixUtility<T, Radius>(
    (radius) => only(topStart: radius, bottomStart: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topEnd and bottomEnd corner.
  late final end = MixUtility<T, Radius>(
    (radius) => only(topEnd: radius, bottomEnd: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topStart corner.
  late final topStart = MixUtility<T, Radius>(
    (radius) => only(topStart: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for topEnd corner.
  late final topEnd = MixUtility<T, Radius>((radius) => only(topEnd: radius));

  /// Returns a [MixUtility] to manipulate [Radius] for bottomStart corner.
  late final bottomStart = MixUtility<T, Radius>(
    (radius) => only(bottomStart: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for bottomEnd corner.
  late final bottomEnd = MixUtility<T, Radius>(
    (radius) => only(bottomEnd: radius),
  );

  /// Returns a [MixUtility] to manipulate [Radius] for all corners.
  late final all = MixUtility<T, Radius>(
    (radius) => only(
      topStart: radius,
      topEnd: radius,
      bottomStart: radius,
      bottomEnd: radius,
    ),
  );

  BorderRadiusDirectionalUtility(super.utilityBuilder);

  /// Sets a circular [Radius] for all corners.
  T circular(double radius) => all.circular(radius);

  /// Sets an elliptical [Radius] for all corners.
  T elliptical(double x, double y) => all.elliptical(x, y);

  /// Sets a zero [Radius] for all corners.
  T zero() => all.zero();

  T only({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    return utilityBuilder(
      BorderRadiusDirectionalMix(
        topStart: topStart,
        topEnd: topEnd,
        bottomStart: bottomStart,
        bottomEnd: bottomEnd,
      ),
    );
  }

  @Deprecated('Use borderRadiusDirectional.circular instead')
  T call(double value) =>
      utilityBuilder(BorderRadiusDirectionalMix.circular(value));

  T as(BorderRadiusDirectional value) {
    return utilityBuilder(BorderRadiusDirectionalMix.value(value));
  }
}

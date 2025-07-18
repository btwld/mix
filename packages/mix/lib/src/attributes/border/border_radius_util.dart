import 'package:flutter/widgets.dart';

import '../../core/attribute.dart';
import '../../core/utility.dart';
import '../scalars/scalar_util.dart';
import 'border_radius_dto.dart';

/// Utility class for creating and manipulating attributes with [BorderRadiusGeometry]
///
/// Extends the [BorderRadiusUtility] class to provide additional utility methods for creating and manipulating [BorderRadiusGeometry] attributes.
/// adds a [directional] property that returns a [BorderRadiusDirectionalUtility] instance.
final class BorderRadiusGeometryUtility<T extends Attribute>
    extends DtoUtility<T, BorderRadiusGeometryDto, BorderRadiusGeometry> {
  /// Returns a directional utility for creating and manipulating attributes with [BorderRadiusDirectional]
  late final directional = BorderRadiusDirectionalUtility(builder);

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

  late final _bordeRadius = BorderRadiusUtility(builder);

  BorderRadiusGeometryUtility(super.builder)
    : super(
        valueToDto: (v) {
          return switch (v) {
            BorderRadius() => BorderRadiusDto(
              topLeft: v.topLeft,
              topRight: v.topRight,
              bottomLeft: v.bottomLeft,
              bottomRight: v.bottomRight,
            ),
            BorderRadiusDirectional() => BorderRadiusDirectionalDto(
              topStart: v.topStart,
              topEnd: v.topEnd,
              bottomStart: v.bottomStart,
              bottomEnd: v.bottomEnd,
            ),
            _ => throw ArgumentError(
              'Unsupported BorderRadiusGeometry type: ${v.runtimeType}',
            ),
          };
        },
      );

  T call(double p1, [double? p2, double? p3, double? p4]) {
    return _bordeRadius(p1, p2, p3, p4);
  }

  // Only specific corners
  @override
  T only({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return _bordeRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}

/// Utility class for creating and manipulating attributes with [BorderRadius]
///
/// Allows setting of radius for a border. This class provides a convenient way to configure and apply border radius to [T]
/// Accepts a builder function that returns [T] and takes a [BorderRadiusDto] as a parameter.
final class BorderRadiusUtility<T extends Attribute>
    extends DtoUtility<T, BorderRadiusDto, BorderRadius> {
  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = RadiusUtility((radius) => only(bottomLeft: radius));

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = RadiusUtility((radius) => only(bottomRight: radius));

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = RadiusUtility((radius) => only(topLeft: radius));

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight corner.
  late final topRight = RadiusUtility((radius) => only(topRight: radius));

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  late final all = RadiusUtility(
    (radius) => only(
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = RadiusUtility(
    (radius) => only(topLeft: radius, topRight: radius),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = RadiusUtility(
    (radius) => only(bottomLeft: radius, bottomRight: radius),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = RadiusUtility(
    (radius) => only(topLeft: radius, bottomLeft: radius),
  );

  /// Returns a [RadiusUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = RadiusUtility(
    (radius) => only(topRight: radius, bottomRight: radius),
  );

  /// Sets a circular [Radius] for all corners.
  late final circular = all.circular;

  /// Sets an elliptical [Radius] for all corners.
  late final elliptical = all.elliptical;

  /// Sets a zero [Radius] for all corners.
  late final zero = all.zero;
  BorderRadiusUtility(super.builder)
    : super(
        valueToDto: (v) => BorderRadiusDto(
          topLeft: v.topLeft,
          topRight: v.topRight,
          bottomLeft: v.bottomLeft,
          bottomRight: v.bottomRight,
        ),
      );

  T call(double p1, [double? p2, double? p3, double? p4]) {
    double topLeft = p1;
    double topRight = p1;
    double bottomLeft = p1;
    double bottomRight = p1;

    if (p2 != null) {
      bottomRight = p2;
      bottomLeft = p2;
    }

    if (p3 != null) {
      topLeft = p1;
      topRight = p2!;
      bottomLeft = p2;
      bottomRight = p3;
    }

    if (p4 != null) {
      topLeft = p1;
      topRight = p2!;
      bottomLeft = p3!;
      bottomRight = p4;
    }

    return only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  // Only specific corners
  @override
  T only({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) {
    return builder(
      BorderRadiusDto(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      ),
    );
  }
}

final class BorderRadiusDirectionalUtility<T extends Attribute>
    extends DtoUtility<T, BorderRadiusDirectionalDto, BorderRadiusDirectional> {
  BorderRadiusDirectionalUtility(super.builder)
    : super(
        valueToDto: (v) => BorderRadiusDirectionalDto(
          topStart: v.topStart,
          topEnd: v.topEnd,
          bottomStart: v.bottomStart,
          bottomEnd: v.bottomEnd,
        ),
      );

  /// Returns a [RadiusUtility] to manipulate [Radius] for all corners.
  RadiusUtility<T> get all {
    return RadiusUtility(
      (radius) => only(
        topStart: radius,
        topEnd: radius,
        bottomStart: radius,
        bottomEnd: radius,
      ),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart and topEnd corner.
  RadiusUtility<T> get top {
    return RadiusUtility((radius) => only(topStart: radius, topEnd: radius));
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomStart and bottomEnd corner.
  RadiusUtility<T> get bottom {
    return RadiusUtility(
      (radius) => only(bottomStart: radius, bottomEnd: radius),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart and bottomStart corner.
  RadiusUtility<T> get start {
    return RadiusUtility(
      (radius) => only(topStart: radius, bottomStart: radius),
    );
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topEnd and bottomEnd corner.
  RadiusUtility<T> get end {
    return RadiusUtility((radius) => only(topEnd: radius, bottomEnd: radius));
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topStart corner.
  RadiusUtility<T> get topStart {
    return RadiusUtility((radius) => only(topStart: radius));
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for topEnd corner.
  RadiusUtility<T> get topEnd {
    return RadiusUtility((radius) => only(topEnd: radius));
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomStart corner.
  RadiusUtility<T> get bottomStart {
    return RadiusUtility((radius) => only(bottomStart: radius));
  }

  /// Returns a [RadiusUtility] to manipulate [Radius] for bottomEnd corner.
  RadiusUtility<T> get bottomEnd {
    return RadiusUtility((radius) => only(bottomEnd: radius));
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

  T call(double p1, [double? p2, double? p3, double? p4]) {
    double topStart = p1;
    double topEnd = p1;
    double bottomStart = p1;
    double bottomEnd = p1;

    if (p2 != null) {
      bottomEnd = p2;
      bottomStart = p2;
    }

    if (p3 != null) {
      topStart = p1;
      topEnd = p2!;
      bottomStart = p2;
      bottomEnd = p3;
    }

    if (p4 != null) {
      topStart = p1;
      topEnd = p2!;
      bottomStart = p3!;
      bottomEnd = p4;
    }

    return builder(
      BorderRadiusDirectionalDto(
        topStart: Radius.circular(topStart),
        topEnd: Radius.circular(topEnd),
        bottomStart: Radius.circular(bottomStart),
        bottomEnd: Radius.circular(bottomEnd),
      ),
    );
  }

  /// Creates a [BorderRadiusGeometryDto] with the specified radius values for each corner.
  ///
  /// The [topStart] parameter represents the radius of the top-left corner.
  /// The [topEnd] parameter represents the radius of the top-right corner.
  /// The [bottomStart] parameter represents the radius of the bottom-left corner.
  /// The [bottomEnd] parameter represents the radius of the bottom-right corner.
  ///
  /// Returns the created [T] object.
  @override
  T only({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    return builder(
      BorderRadiusDirectionalDto(
        topStart: topStart,
        topEnd: topEnd,
        bottomStart: bottomStart,
        bottomEnd: bottomEnd,
      ),
    );
  }
}

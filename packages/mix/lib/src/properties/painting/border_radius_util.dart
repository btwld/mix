import 'package:flutter/widgets.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../layout/scalar_util.dart';
import 'border_radius_mix.dart';

/// Mixin that provides convenient border radius methods
mixin BorderRadiusMixin<T extends Style<Object?>> {
  /// Must be implemented by the class using this mixin
  T borderRadius(BorderRadiusGeometryMix value);

  /// Sets border radius with Radius objects for complete control
  ///
  /// Priority order (lowest to highest):
  /// 1. all - applies to all corners
  /// 2. horizontal - applies to left and right sides
  /// 3. vertical - applies to top and bottom sides
  /// 4. top/bottom - applies to both corners of that edge
  /// 5. left/right OR start/end - applies to both corners of that side
  /// 6. topLeft/topRight/bottomLeft/bottomRight OR topStart/topEnd/bottomStart/bottomEnd
  ///
  /// Cannot mix physical (left/right) with logical (start/end) properties
  T corners({
    Radius? all,
    Radius? horizontal,
    Radius? vertical,
    Radius? top,
    Radius? bottom,
    Radius? left,
    Radius? right,
    Radius? start,
    Radius? end,
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    // Check for mixing logical and physical properties
    final hasPhysicalSides = left != null || right != null;
    final hasLogicalSides = start != null || end != null;
    final hasPhysicalCorners =
        topLeft != null ||
        topRight != null ||
        bottomLeft != null ||
        bottomRight != null;
    final hasLogicalCorners =
        topStart != null ||
        topEnd != null ||
        bottomStart != null ||
        bottomEnd != null;

    if ((hasPhysicalSides && hasLogicalSides) ||
        (hasPhysicalCorners && hasLogicalCorners)) {
      throw ArgumentError(
        'Cannot mix physical (left/right/topLeft/etc) and logical '
        '(start/end/topStart/etc) properties. Use one or the other.',
      );
    }

    // Determine if we're using logical properties
    final useLogical = hasLogicalSides || hasLogicalCorners;

    // Start with all as base
    Radius? tl = all;
    Radius? tr = all;
    Radius? bl = all;
    Radius? br = all;

    // Apply horizontal/vertical
    if (horizontal != null) {
      tl = horizontal;
      tr = horizontal;
      bl = horizontal;
      br = horizontal;
    }
    if (vertical != null) {
      tl = vertical;
      tr = vertical;
      bl = vertical;
      br = vertical;
    }

    // Apply edge-specific values
    if (top != null) {
      tl = top;
      tr = top;
    }
    if (bottom != null) {
      bl = bottom;
      br = bottom;
    }

    if (useLogical) {
      // Apply logical side values (treating start as left, end as right)
      if (start != null) {
        tl = start;
        bl = start;
      }
      if (end != null) {
        tr = end;
        br = end;
      }

      // Apply logical corner values
      if (topStart != null) tl = topStart;
      if (topEnd != null) tr = topEnd;
      if (bottomStart != null) bl = bottomStart;
      if (bottomEnd != null) br = bottomEnd;
    } else {
      // Apply physical side values
      if (left != null) {
        tl = left;
        bl = left;
      }
      if (right != null) {
        tr = right;
        br = right;
      }

      // Apply physical corner values
      if (topLeft != null) tl = topLeft;
      if (topRight != null) tr = topRight;
      if (bottomLeft != null) bl = bottomLeft;
      if (bottomRight != null) br = bottomRight;
    }

    return borderRadius(
      BorderRadiusGeometryMix.only(
        topLeft: tl,
        topRight: tr,
        bottomLeft: bl,
        bottomRight: br,
      ),
    );
  }

  /// Sets circular border radius with simple double values
  ///
  /// Converts doubles to Radius.circular and delegates to corners()
  T rounded({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? start,
    double? end,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    double? topStart,
    double? topEnd,
    double? bottomStart,
    double? bottomEnd,
  }) {
    return corners(
      all: _maybeCircular(all),
      horizontal: _maybeCircular(horizontal),
      vertical: _maybeCircular(vertical),
      top: _maybeCircular(top),
      bottom: _maybeCircular(bottom),
      left: _maybeCircular(left),
      right: _maybeCircular(right),
      start: _maybeCircular(start),
      end: _maybeCircular(end),
      topLeft: _maybeCircular(topLeft),
      topRight: _maybeCircular(topRight),
      bottomLeft: _maybeCircular(bottomLeft),
      bottomRight: _maybeCircular(bottomRight),
      topStart: _maybeCircular(topStart),
      topEnd: _maybeCircular(topEnd),
      bottomStart: _maybeCircular(bottomStart),
      bottomEnd: _maybeCircular(bottomEnd),
    );
  }
}

Radius? _maybeCircular(double? value) {
  return value != null ? Radius.circular(value) : null;
}

/// Utility class for creating and manipulating attributes with [BorderRadiusGeometry]
///
/// Extends the [BorderRadiusUtility] class to provide additional utility methods for creating and manipulating [BorderRadiusGeometry] attributes.
/// adds a [directional] property that returns a [BorderRadiusDirectionalUtility] instance.
final class BorderRadiusGeometryUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BorderRadiusGeometry> {
  /// Returns a directional utility for creating and manipulating attributes with [BorderRadiusDirectional]
  late final borderRadiusDirectional = BorderRadiusDirectionalUtility<T>(
    builder,
  );

  late final borderRadius = BorderRadiusUtility<T>(builder);

  BorderRadiusGeometryUtility(super.builder)
    : super(convertToMix: BorderRadiusGeometryMix.value);

  T call(double value) => builder(MixProp(BorderRadiusMix.circular(value)));
}

/// Utility class for creating and manipulating attributes with [BorderRadius]
///
/// Allows setting of radius for a border. This class provides a convenient way to configure and apply border radius to [T]
/// Accepts a builder function that returns [T] and takes a [BorderRadiusMix] as a parameter.
final class BorderRadiusUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BorderRadius> {
  /// Returns a [PropUtility] to manipulate [Radius] for bottomLeft corner.
  late final bottomLeft = PropUtility<T, Radius>(
    (radius) => onlyProps(bottomLeft: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomRight corner.
  late final bottomRight = PropUtility<T, Radius>(
    (radius) => onlyProps(bottomRight: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topLeft corner.
  late final topLeft = PropUtility<T, Radius>(
    (radius) => onlyProps(topLeft: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topRight corner.
  late final topRight = PropUtility<T, Radius>(
    (radius) => onlyProps(topRight: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for all corners.
  late final all = PropUtility<T, Radius>(
    (radius) => onlyProps(
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    ),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topLeft and topRight corner.
  late final top = PropUtility<T, Radius>(
    (radius) => onlyProps(topLeft: radius, topRight: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomLeft and bottomRight corner.
  late final bottom = PropUtility<T, Radius>(
    (radius) => onlyProps(bottomLeft: radius, bottomRight: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topLeft and bottomLeft corner.
  late final left = PropUtility<T, Radius>(
    (radius) => onlyProps(topLeft: radius, bottomLeft: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topRight and bottomRight corner.
  late final right = PropUtility<T, Radius>(
    (radius) => onlyProps(topRight: radius, bottomRight: radius),
  );

  BorderRadiusUtility(super.builder)
    : super(convertToMix: BorderRadiusMix.value);

  /// Sets a circular [Radius] for all corners.
  T circular(double radius) => all.circular(radius);

  /// Sets an elliptical [Radius] for all corners.
  T elliptical(double x, double y) => all.elliptical(x, y);

  /// Sets a zero [Radius] for all corners.
  T zero() => all.zero();

  @protected
  T onlyProps({
    Prop<Radius>? topLeft,
    Prop<Radius>? topRight,
    Prop<Radius>? bottomLeft,
    Prop<Radius>? bottomRight,
  }) {
    return builder(
      MixProp(
        BorderRadiusMix.raw(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }

  T call(double value) => builder(MixProp(BorderRadiusMix.circular(value)));
}

final class BorderRadiusDirectionalUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BorderRadiusDirectional> {
  /// Returns a [PropUtility] to manipulate [Radius] for topStart and topEnd corner.
  late final top = PropUtility<T, Radius>(
    (radius) => onlyProps(topStart: radius, topEnd: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomStart and bottomEnd corner.
  late final bottom = PropUtility<T, Radius>(
    (radius) => onlyProps(bottomStart: radius, bottomEnd: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topStart and bottomStart corner.
  late final start = PropUtility<T, Radius>(
    (radius) => onlyProps(topStart: radius, bottomStart: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topEnd and bottomEnd corner.
  late final end = PropUtility<T, Radius>(
    (radius) => onlyProps(topEnd: radius, bottomEnd: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topStart corner.
  late final topStart = PropUtility<T, Radius>(
    (radius) => onlyProps(topStart: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for topEnd corner.
  late final topEnd = PropUtility<T, Radius>(
    (radius) => onlyProps(topEnd: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomStart corner.
  late final bottomStart = PropUtility<T, Radius>(
    (radius) => onlyProps(bottomStart: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for bottomEnd corner.
  late final bottomEnd = PropUtility<T, Radius>(
    (radius) => onlyProps(bottomEnd: radius),
  );

  /// Returns a [PropUtility] to manipulate [Radius] for all corners.
  late final all = PropUtility<T, Radius>(
    (radius) => onlyProps(
      topStart: radius,
      topEnd: radius,
      bottomStart: radius,
      bottomEnd: radius,
    ),
  );

  BorderRadiusDirectionalUtility(super.builder)
    : super(convertToMix: BorderRadiusDirectionalMix.value);

  /// Sets a circular [Radius] for all corners.
  T circular(double radius) => all.circular(radius);

  /// Sets an elliptical [Radius] for all corners.
  T elliptical(double x, double y) => all.elliptical(x, y);

  /// Sets a zero [Radius] for all corners.
  T zero() => all.zero();

  @protected
  T onlyProps({
    Prop<Radius>? topStart,
    Prop<Radius>? topEnd,
    Prop<Radius>? bottomStart,
    Prop<Radius>? bottomEnd,
  }) {
    return builder(
      MixProp(
        BorderRadiusDirectionalMix.raw(
          topStart: topStart,
          topEnd: topEnd,
          bottomStart: bottomStart,
          bottomEnd: bottomEnd,
        ),
      ),
    );
  }

  T call(double value) =>
      builder(MixProp(BorderRadiusDirectionalMix.circular(value)));
}

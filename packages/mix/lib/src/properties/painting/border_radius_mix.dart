import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for Mix-compatible border radius styling with token support.
///
/// Supports both [BorderRadius] and [BorderRadiusDirectional] with automatic
/// type conversion and merging between different radius types.
@immutable
sealed class BorderRadiusGeometryMix<T extends BorderRadiusGeometry>
    extends Mix<T> {
  const BorderRadiusGeometryMix();

  factory BorderRadiusGeometryMix.value(BorderRadiusGeometry value) {
    return switch (value) {
      BorderRadius() =>
        BorderRadiusMix.value(value) as BorderRadiusGeometryMix<T>,
      BorderRadiusDirectional() =>
        BorderRadiusDirectionalMix.value(value) as BorderRadiusGeometryMix<T>,
      _ => throw ArgumentError(
        'Unsupported BorderRadiusGeometry type: ${value.runtimeType}',
      ),
    };
  }

  static BorderRadiusGeometryMix only({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) {
    if (topLeft != null ||
        topRight != null ||
        bottomLeft != null ||
        bottomRight != null) {
      return BorderRadiusMix(
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      );
    } else if (topStart != null ||
        topEnd != null ||
        bottomStart != null ||
        bottomEnd != null) {
      return BorderRadiusDirectionalMix(
        topStart: topStart,
        topEnd: topEnd,
        bottomStart: bottomStart,
        bottomEnd: bottomEnd,
      );
    }

    return BorderRadiusMix(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  static BorderRadiusMix all(Radius radius) {
    return BorderRadiusMix.all(radius);
  }

  /// Creates a border radius with the same circular radius for all corners.
  static BorderRadiusMix circular(double radius) {
    return BorderRadiusMix.all(Radius.circular(radius));
  }

  /// Creates a border radius with the same elliptical radius for all corners.
  static BorderRadiusMix elliptical(double xRadius, double yRadius) {
    return BorderRadiusMix.all(Radius.elliptical(xRadius, yRadius));
  }

  static BorderRadiusGeometryMix<T>? maybeValue<T extends BorderRadiusGeometry>(
    T? value,
  ) {
    if (value == null) return null;

    return BorderRadiusGeometryMix.value(value);
  }

  /// Creates a border radius with only the top-left corner rounded.
  static BorderRadiusMix topLeft(Radius radius) {
    return BorderRadiusMix(topLeft: radius);
  }

  static BorderRadiusMix top(Radius radius) {
    return BorderRadiusMix(topLeft: radius, topRight: radius);
  }

  static BorderRadiusMix left(Radius radius) {
    return BorderRadiusMix(topLeft: radius, bottomLeft: radius);
  }

  static BorderRadiusMix right(Radius radius) {
    return BorderRadiusMix(topRight: radius, bottomRight: radius);
  }

  //bottom
  static BorderRadiusMix bottom(Radius radius) {
    return BorderRadiusMix(bottomLeft: radius, bottomRight: radius);
  }

  /// Creates a border radius with only the top-right corner rounded.
  static BorderRadiusMix topRight(Radius radius) {
    return BorderRadiusMix(topRight: radius);
  }

  /// Creates a border radius with only the bottom-left corner rounded.
  static BorderRadiusMix bottomLeft(Radius radius) {
    return BorderRadiusMix(bottomLeft: radius);
  }

  /// Creates a border radius with only the bottom-right corner rounded.
  static BorderRadiusMix bottomRight(Radius radius) {
    return BorderRadiusMix(bottomRight: radius);
  }

  /// Creates a directional border radius with only the top-start corner rounded.
  static BorderRadiusDirectionalMix topStart(Radius radius) {
    return BorderRadiusDirectionalMix(topStart: radius);
  }

  /// Creates a directional border radius with only the top-end corner rounded.
  static BorderRadiusDirectionalMix topEnd(Radius radius) {
    return BorderRadiusDirectionalMix(topEnd: radius);
  }

  /// Creates a directional border radius with only the bottom-start corner rounded.
  static BorderRadiusDirectionalMix bottomStart(Radius radius) {
    return BorderRadiusDirectionalMix(bottomStart: radius);
  }

  /// Creates a directional border radius with only the bottom-end corner rounded.
  static BorderRadiusDirectionalMix bottomEnd(Radius radius) {
    return BorderRadiusDirectionalMix(bottomEnd: radius);
  }

  /// Merges two border radius geometries with automatic type conversion.
  ///
  /// Returns the type of [b] if not null, otherwise [a]. Handles conversion
  /// between [BorderRadiusMix] and [BorderRadiusDirectionalMix] automatically.
  static BorderRadiusGeometryMix? tryToMerge(
    BorderRadiusGeometryMix? a,
    BorderRadiusGeometryMix? b,
  ) {
    if (b == null) return a;
    if (a == null) return b;

    return a.runtimeType == b.runtimeType ? a.merge(b) : _exhaustiveMerge(a, b);
  }

  static B _exhaustiveMerge<
    A extends BorderRadiusGeometryMix,
    B extends BorderRadiusGeometryMix
  >(A a, B b) {
    return switch ((a, b)) {
      (BorderRadiusMix a, BorderRadiusMix b) => a.merge(b) as B,
      (BorderRadiusDirectionalMix a, BorderRadiusDirectionalMix b) =>
        a.merge(b) as B,
      (BorderRadiusMix a, BorderRadiusDirectionalMix b) =>
        BorderRadiusDirectionalMix.create(
              topStart: a.$topLeft,
              topEnd: a.$topRight,
              bottomStart: a.$bottomLeft,
              bottomEnd: a.$bottomRight,
            ).merge(b)
            as B,
      (BorderRadiusDirectionalMix a, BorderRadiusMix b) =>
        BorderRadiusMix.create(
              topLeft: a.$topStart,
              topRight: a.$topEnd,
              bottomLeft: a.$bottomStart,
              bottomRight: a.$bottomEnd,
            ).merge(b)
            as B,
    };
  }

  @override
  /// Merges this [BorderRadiusGeometryMix] instance with another of the same type.
  ///
  /// Returns a new instance where each property is merged using the [MixOps.merge] logic.
  /// If [other] is null, returns this instance.
  /// The resulting type will match this instance's type parameter [T].
  BorderRadiusGeometryMix<T> merge(covariant BorderRadiusGeometryMix<T>? other);
}

/// Mix-compatible representation of Flutter's [BorderRadius] with individual corner control.
///
/// Allows independent styling of topLeft, topRight, bottomLeft, and bottomRight
/// corners with token support and merging capabilities.
final class BorderRadiusMix extends BorderRadiusGeometryMix<BorderRadius> {
  final Prop<Radius>? $topLeft;
  final Prop<Radius>? $topRight;
  final Prop<Radius>? $bottomLeft;
  final Prop<Radius>? $bottomRight;

  BorderRadiusMix({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) : this.create(
         topLeft: Prop.maybe(topLeft),
         topRight: Prop.maybe(topRight),
         bottomLeft: Prop.maybe(bottomLeft),
         bottomRight: Prop.maybe(bottomRight),
       );

  /// Creates a [BorderRadiusMix] from an existing [BorderRadius].
  ///
  /// ```dart
  /// const borderRadius = BorderRadius.circular(12.0);
  /// final dto = BorderRadiusMix.value(borderRadius);
  /// ```
  BorderRadiusMix.value(BorderRadius borderRadius)
    : this(
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );

  const BorderRadiusMix.create({
    Prop<Radius>? topLeft,
    Prop<Radius>? topRight,
    Prop<Radius>? bottomLeft,
    Prop<Radius>? bottomRight,
  }) : $topLeft = topLeft,
       $topRight = topRight,
       $bottomLeft = bottomLeft,
       $bottomRight = bottomRight;

  BorderRadiusMix.all(Radius radius)
    : this(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );

  /// Creates a [BorderRadiusMix] with all corners having the same circular radius.
  factory BorderRadiusMix.circular(double radius) {
    return BorderRadiusMix.all(Radius.circular(radius));
  }

  /// Creates a border radius with the specified top-left corner.
  factory BorderRadiusMix.topLeft(Radius radius) {
    return BorderRadiusMix(topLeft: radius);
  }

  /// Creates a border radius with the specified top-right corner.
  factory BorderRadiusMix.topRight(Radius radius) {
    return BorderRadiusMix(topRight: radius);
  }

  /// Creates a border radius with the specified bottom-left corner.
  factory BorderRadiusMix.bottomLeft(Radius radius) {
    return BorderRadiusMix(bottomLeft: radius);
  }

  /// Creates a border radius with the specified bottom-right corner.
  factory BorderRadiusMix.bottomRight(Radius radius) {
    return BorderRadiusMix(bottomRight: radius);
  }

  /// Creates a border radius with the specified elliptical radius for all corners.
  factory BorderRadiusMix.elliptical(double xRadius, double yRadius) {
    return BorderRadiusMix.all(Radius.elliptical(xRadius, yRadius));
  }

  /// Creates a [BorderRadiusMix] from a nullable [BorderRadius].
  ///
  /// Returns null if the input is null.
  ///
  /// ```dart
  /// const BorderRadius? borderRadius = BorderRadius.circular(12.0);
  /// final dto = BorderRadiusMix.maybeValue(borderRadius); // Returns BorderRadiusMix or null
  /// ```
  static BorderRadiusMix? maybeValue(BorderRadius? borderRadius) {
    return borderRadius != null ? BorderRadiusMix.value(borderRadius) : null;
  }

  /// Returns a copy with the specified top-left corner radius.
  BorderRadiusMix topLeft(Radius radius) {
    return merge(BorderRadiusMix.topLeft(radius));
  }

  /// Returns a copy with the specified top-right corner radius.
  BorderRadiusMix topRight(Radius radius) {
    return merge(BorderRadiusMix.topRight(radius));
  }

  /// Returns a copy with the specified bottom-left corner radius.
  BorderRadiusMix bottomLeft(Radius radius) {
    return merge(BorderRadiusMix.bottomLeft(radius));
  }

  /// Returns a copy with the specified bottom-right corner radius.
  BorderRadiusMix bottomRight(Radius radius) {
    return merge(BorderRadiusMix.bottomRight(radius));
  }

  @override
  BorderRadius resolve(BuildContext context) {
    return BorderRadius.only(
      topLeft: MixOps.resolve(context, $topLeft) ?? Radius.zero,
      topRight: MixOps.resolve(context, $topRight) ?? Radius.zero,
      bottomLeft: MixOps.resolve(context, $bottomLeft) ?? Radius.zero,
      bottomRight: MixOps.resolve(context, $bottomRight) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusMix merge(BorderRadiusMix? other) {
    if (other == null) return this;

    return BorderRadiusMix.create(
      topLeft: $topLeft.tryMerge(other.$topLeft),
      topRight: $topRight.tryMerge(other.$topRight),
      bottomLeft: $bottomLeft.tryMerge(other.$bottomLeft),
      bottomRight: $bottomRight.tryMerge(other.$bottomRight),
    );
  }

  @override
  List<Object?> get props => [$topLeft, $topRight, $bottomLeft, $bottomRight];
}

/// Mix-compatible representation of Flutter's [BorderRadiusDirectional] with RTL support.
///
/// Allows independent styling of topStart, topEnd, bottomStart, and bottomEnd
/// corners with proper right-to-left layout handling and token support.
final class BorderRadiusDirectionalMix
    extends BorderRadiusGeometryMix<BorderRadiusDirectional> {
  final Prop<Radius>? $topStart;
  final Prop<Radius>? $topEnd;
  final Prop<Radius>? $bottomStart;
  final Prop<Radius>? $bottomEnd;

  BorderRadiusDirectionalMix({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) : this.create(
         topStart: Prop.maybe(topStart),
         topEnd: Prop.maybe(topEnd),
         bottomStart: Prop.maybe(bottomStart),
         bottomEnd: Prop.maybe(bottomEnd),
       );

  /// Creates a [BorderRadiusDirectionalMix] from an existing [BorderRadiusDirectional].
  ///
  /// ```dart
  /// const borderRadius = BorderRadiusDirectional.circular(12.0);
  /// final dto = BorderRadiusDirectionalMix.value(borderRadius);
  /// ```
  BorderRadiusDirectionalMix.value(BorderRadiusDirectional borderRadius)
    : this(
        topStart: borderRadius.topStart,
        topEnd: borderRadius.topEnd,
        bottomStart: borderRadius.bottomStart,
        bottomEnd: borderRadius.bottomEnd,
      );

  const BorderRadiusDirectionalMix.create({
    Prop<Radius>? topStart,
    Prop<Radius>? topEnd,
    Prop<Radius>? bottomStart,
    Prop<Radius>? bottomEnd,
  }) : $topStart = topStart,
       $topEnd = topEnd,
       $bottomStart = bottomStart,
       $bottomEnd = bottomEnd;

  /// Creates a border radius with all corners having the same circular radius.
  factory BorderRadiusDirectionalMix.circular(double radius) {
    return BorderRadiusDirectionalMix.all(Radius.circular(radius));
  }

  /// Creates a border radius with the specified top-start corner.
  factory BorderRadiusDirectionalMix.topStart(Radius radius) {
    return BorderRadiusDirectionalMix(topStart: radius);
  }

  /// Creates a border radius with the specified top-end corner.
  factory BorderRadiusDirectionalMix.topEnd(Radius radius) {
    return BorderRadiusDirectionalMix(topEnd: radius);
  }

  /// Creates a border radius with the specified bottom-start corner.
  factory BorderRadiusDirectionalMix.bottomStart(Radius radius) {
    return BorderRadiusDirectionalMix(bottomStart: radius);
  }

  /// Creates a border radius with the specified bottom-end corner.
  factory BorderRadiusDirectionalMix.bottomEnd(Radius radius) {
    return BorderRadiusDirectionalMix(bottomEnd: radius);
  }

  /// Creates a border radius with the specified elliptical radius for all corners.
  factory BorderRadiusDirectionalMix.elliptical(
    double xRadius,
    double yRadius,
  ) {
    return BorderRadiusDirectionalMix.all(Radius.elliptical(xRadius, yRadius));
  }

  BorderRadiusDirectionalMix.all(Radius radius)
    : this(
        topStart: radius,
        topEnd: radius,
        bottomStart: radius,
        bottomEnd: radius,
      );

  /// Creates a [BorderRadiusDirectionalMix] from a nullable [BorderRadiusDirectional].
  ///
  /// Returns null if the input is null.
  ///
  /// ```dart
  /// const BorderRadiusDirectional? borderRadius = BorderRadiusDirectional.circular(12.0);
  /// final dto = BorderRadiusDirectionalMix.maybeValue(borderRadius); // Returns BorderRadiusDirectionalMix or null
  /// ```
  static BorderRadiusDirectionalMix? maybeValue(
    BorderRadiusDirectional? borderRadius,
  ) {
    return borderRadius != null
        ? BorderRadiusDirectionalMix.value(borderRadius)
        : null;
  }

  /// Returns a copy with the specified top-start corner radius.
  BorderRadiusDirectionalMix topStart(Radius radius) {
    return merge(BorderRadiusDirectionalMix.topStart(radius));
  }

  /// Returns a copy with the specified top-end corner radius.
  BorderRadiusDirectionalMix topEnd(Radius radius) {
    return merge(BorderRadiusDirectionalMix.topEnd(radius));
  }

  /// Returns a copy with the specified bottom-start corner radius.
  BorderRadiusDirectionalMix bottomStart(Radius radius) {
    return merge(BorderRadiusDirectionalMix.bottomStart(radius));
  }

  /// Returns a copy with the specified bottom-end corner radius.
  BorderRadiusDirectionalMix bottomEnd(Radius radius) {
    return merge(BorderRadiusDirectionalMix.bottomEnd(radius));
  }

  @override
  BorderRadiusDirectional resolve(BuildContext context) {
    return BorderRadiusDirectional.only(
      topStart: MixOps.resolve(context, $topStart) ?? Radius.zero,
      topEnd: MixOps.resolve(context, $topEnd) ?? Radius.zero,
      bottomStart: MixOps.resolve(context, $bottomStart) ?? Radius.zero,
      bottomEnd: MixOps.resolve(context, $bottomEnd) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDirectionalMix merge(BorderRadiusDirectionalMix? other) {
    if (other == null) return this;

    return BorderRadiusDirectionalMix.create(
      topStart: $topStart.tryMerge(other.$topStart),
      topEnd: $topEnd.tryMerge(other.$topEnd),
      bottomStart: $bottomStart.tryMerge(other.$bottomStart),
      bottomEnd: $bottomEnd.tryMerge(other.$bottomEnd),
    );
  }

  @override
  List<Object?> get props => [$topStart, $topEnd, $bottomStart, $bottomEnd];
}

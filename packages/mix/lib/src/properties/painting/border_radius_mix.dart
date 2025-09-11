import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for Mix border radius types.
///
/// Supports automatic type conversion and merging.
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

  /// Creates circular radius for all corners.
  static BorderRadiusMix circular(double radius) {
    return BorderRadiusMix.all(Radius.circular(radius));
  }

  /// Creates elliptical radius for all corners.
  static BorderRadiusMix elliptical(double xRadius, double yRadius) {
    return BorderRadiusMix.all(Radius.elliptical(xRadius, yRadius));
  }

  static BorderRadiusGeometryMix<T>? maybeValue<T extends BorderRadiusGeometry>(
    T? value,
  ) {
    if (value == null) return null;

    return BorderRadiusGeometryMix.value(value);
  }

  /// Creates with top-left corner only.
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

  /// Creates with top-right corner only.
  static BorderRadiusMix topRight(Radius radius) {
    return BorderRadiusMix(topRight: radius);
  }

  /// Creates with bottom-left corner only.
  static BorderRadiusMix bottomLeft(Radius radius) {
    return BorderRadiusMix(bottomLeft: radius);
  }

  /// Creates with bottom-right corner only.
  static BorderRadiusMix bottomRight(Radius radius) {
    return BorderRadiusMix(bottomRight: radius);
  }

  /// Creates with top-start corner only.
  static BorderRadiusDirectionalMix topStart(Radius radius) {
    return BorderRadiusDirectionalMix(topStart: radius);
  }

  /// Creates with top-end corner only.
  static BorderRadiusDirectionalMix topEnd(Radius radius) {
    return BorderRadiusDirectionalMix(topEnd: radius);
  }

  /// Creates with bottom-start corner only.
  static BorderRadiusDirectionalMix bottomStart(Radius radius) {
    return BorderRadiusDirectionalMix(bottomStart: radius);
  }

  /// Creates with bottom-end corner only.
  static BorderRadiusDirectionalMix bottomEnd(Radius radius) {
    return BorderRadiusDirectionalMix(bottomEnd: radius);
  }

  /// Merges with automatic type conversion.
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

  /// Merges with another instance.
  @override
  BorderRadiusGeometryMix<T> merge(covariant BorderRadiusGeometryMix<T>? other);
}

/// Mix representation of [BorderRadius].
///
/// Supports individual corner control with tokens.
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

  /// Creates from [BorderRadius].
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

  /// Creates with circular radius.
  factory BorderRadiusMix.circular(double radius) {
    // Use a simple value-based creation. Token-aware radius should be passed as
    // a Radius token to BorderRadiusMix.all(...) at call sites.
    return BorderRadiusMix.all(Radius.circular(radius));
  }

  /// Creates with top-left corner.
  factory BorderRadiusMix.topLeft(Radius radius) {
    return BorderRadiusMix(topLeft: radius);
  }

  /// Creates with top-right corner.
  factory BorderRadiusMix.topRight(Radius radius) {
    return BorderRadiusMix(topRight: radius);
  }

  /// Creates with bottom-left corner.
  factory BorderRadiusMix.bottomLeft(Radius radius) {
    return BorderRadiusMix(bottomLeft: radius);
  }

  /// Creates with bottom-right corner.
  factory BorderRadiusMix.bottomRight(Radius radius) {
    return BorderRadiusMix(bottomRight: radius);
  }

  /// Creates with elliptical radius.
  factory BorderRadiusMix.elliptical(double xRadius, double yRadius) {
    return BorderRadiusMix.all(Radius.elliptical(xRadius, yRadius));
  }

  /// Creates from nullable [BorderRadius].
  static BorderRadiusMix? maybeValue(BorderRadius? borderRadius) {
    return borderRadius != null ? BorderRadiusMix.value(borderRadius) : null;
  }

  /// Copy with top-left radius.
  BorderRadiusMix topLeft(Radius radius) {
    return merge(BorderRadiusMix.topLeft(radius));
  }

  /// Copy with top-right radius.
  BorderRadiusMix topRight(Radius radius) {
    return merge(BorderRadiusMix.topRight(radius));
  }

  /// Copy with bottom-left radius.
  BorderRadiusMix bottomLeft(Radius radius) {
    return merge(BorderRadiusMix.bottomLeft(radius));
  }

  /// Copy with bottom-right radius.
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
    return BorderRadiusMix.create(
      topLeft: MixOps.merge($topLeft, other?.$topLeft),
      topRight: MixOps.merge($topRight, other?.$topRight),
      bottomLeft: MixOps.merge($bottomLeft, other?.$bottomLeft),
      bottomRight: MixOps.merge($bottomRight, other?.$bottomRight),
    );
  }

  @override
  List<Object?> get props => [$topLeft, $topRight, $bottomLeft, $bottomRight];
}

/// Mix representation of [BorderRadiusDirectional].
///
/// Supports RTL layout handling and tokens.
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

  /// Creates from [BorderRadiusDirectional].
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

  /// Creates with elliptical radius.
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

  /// Creates from nullable [BorderRadiusDirectional].
  static BorderRadiusDirectionalMix? maybeValue(
    BorderRadiusDirectional? borderRadius,
  ) {
    return borderRadius != null
        ? BorderRadiusDirectionalMix.value(borderRadius)
        : null;
  }

  /// Copy with top-start radius.
  BorderRadiusDirectionalMix topStart(Radius radius) {
    return merge(BorderRadiusDirectionalMix.topStart(radius));
  }

  /// Copy with top-end radius.
  BorderRadiusDirectionalMix topEnd(Radius radius) {
    return merge(BorderRadiusDirectionalMix.topEnd(radius));
  }

  /// Copy with bottom-start radius.
  BorderRadiusDirectionalMix bottomStart(Radius radius) {
    return merge(BorderRadiusDirectionalMix.bottomStart(radius));
  }

  /// Copy with bottom-end radius.
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
    return BorderRadiusDirectionalMix.create(
      topStart: MixOps.merge($topStart, other?.$topStart),
      topEnd: MixOps.merge($topEnd, other?.$topEnd),
      bottomStart: MixOps.merge($bottomStart, other?.$bottomStart),
      bottomEnd: MixOps.merge($bottomEnd, other?.$bottomEnd),
    );
  }

  @override
  List<Object?> get props => [$topStart, $topEnd, $bottomStart, $bottomEnd];
}

// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Represents a [Mix] Data transfer object of [BorderRadiusGeometry]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [BorderRadiusGeometry]
///
/// This Mix implements `BorderRadius` and `BorderRadiusDirectional` Flutter classes to allow for
/// better merging support, and cleaner API for the utilities
///
/// See also:
/// - [BorderRadiusGeometry], which is the Flutter counterpart of this class.
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

  static BorderRadiusGeometryMix<T>? maybeValue<T extends BorderRadiusGeometry>(
    T? value,
  ) {
    if (value == null) return null;

    return BorderRadiusGeometryMix.value(value);
  }

  /// Will try to merge two border radius geometries, the type will resolve to type of
  /// `b` if its not null and `a` otherwise.
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
    if (a.runtimeType == b.runtimeType) return a.merge(b) as B;

    return switch (b) {
      (BorderRadiusMix g) => a._asBorderRadius().merge(g) as B,
      (BorderRadiusDirectionalMix g) =>
        a._asBorderRadiusDirectional().merge(g) as B,
    };
  }

  @protected
  BorderRadiusMix _asBorderRadius() {
    if (this is BorderRadiusMix) return this as BorderRadiusMix;

    // For BorderRadiusDirectionalMix converting to BorderRadiusMix
    // topStart -> topLeft, topEnd -> topRight, bottomStart -> bottomLeft, bottomEnd -> bottomRight
    final directional = this as BorderRadiusDirectionalMix;

    return BorderRadiusMix(
      topLeft: directional.topStart,
      topRight: directional.topEnd,
      bottomLeft: directional.bottomStart,
      bottomRight: directional.bottomEnd,
    );
  }

  @protected
  BorderRadiusDirectionalMix _asBorderRadiusDirectional() {
    if (this is BorderRadiusDirectionalMix) {
      return this as BorderRadiusDirectionalMix;
    }

    // For BorderRadiusMix converting to BorderRadiusDirectionalMix
    // topLeft -> topStart, topRight -> topEnd, bottomLeft -> bottomStart, bottomRight -> bottomEnd
    return BorderRadiusDirectionalMix(
      topStart: topLeft,
      topEnd: topRight,
      bottomStart: bottomLeft,
      bottomEnd: bottomRight,
    );
  }

  /// Common getters for accessing radius properties
  /// These return null for types that don't support these properties
  Prop<Radius>? get topLeft => null;
  Prop<Radius>? get topRight => null;
  Prop<Radius>? get bottomLeft => null;

  Prop<Radius>? get bottomRight => null;

  @override
  /// Merges this [BorderRadiusGeometryMix] instance with another of the same type.
  ///
  /// Returns a new instance where each property is merged using the [MixHelpers.merge] logic.
  /// If [other] is null, returns this instance.
  /// The resulting type will match this instance's type parameter [T].
  BorderRadiusGeometryMix<T> merge(covariant BorderRadiusGeometryMix<T>? other);
}

final class BorderRadiusMix extends BorderRadiusGeometryMix<BorderRadius> {
  @override
  final Prop<Radius>? topLeft;

  @override
  final Prop<Radius>? topRight;

  @override
  final Prop<Radius>? bottomLeft;

  @override
  final Prop<Radius>? bottomRight;

  BorderRadiusMix.only({
    Radius? topLeft,
    Radius? topRight,
    Radius? bottomLeft,
    Radius? bottomRight,
  }) : this(
         topLeft: Prop.maybe(topLeft),
         topRight: Prop.maybe(topRight),
         bottomLeft: Prop.maybe(bottomLeft),
         bottomRight: Prop.maybe(bottomRight),
       );

  /// Constructor that accepts a [BorderRadius] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderRadius] instances to [BorderRadiusMix].
  ///
  /// ```dart
  /// const borderRadius = BorderRadius.circular(12.0);
  /// final dto = BorderRadiusMix.value(borderRadius);
  /// ```
  BorderRadiusMix.value(BorderRadius borderRadius)
    : this.only(
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );

  const BorderRadiusMix({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  BorderRadiusMix.all(Radius radius)
    : this.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );

  /// Constructor that accepts a nullable [BorderRadius] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderRadiusMix.value].
  ///
  /// ```dart
  /// const BorderRadius? borderRadius = BorderRadius.circular(12.0);
  /// final dto = BorderRadiusMix.maybeValue(borderRadius); // Returns BorderRadiusMix or null
  /// ```
  static BorderRadiusMix? maybeValue(BorderRadius? borderRadius) {
    return borderRadius != null ? BorderRadiusMix.value(borderRadius) : null;
  }

  @override
  BorderRadius resolve(BuildContext context) {
    return BorderRadius.only(
      topLeft: MixHelpers.resolve(context, topLeft) ?? Radius.zero,
      topRight: MixHelpers.resolve(context, topRight) ?? Radius.zero,
      bottomLeft: MixHelpers.resolve(context, bottomLeft) ?? Radius.zero,
      bottomRight: MixHelpers.resolve(context, bottomRight) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusMix merge(BorderRadiusMix? other) {
    if (other == null) return this;

    return BorderRadiusMix(
      topLeft: MixHelpers.merge(topLeft, other.topLeft),
      topRight: MixHelpers.merge(topRight, other.topRight),
      bottomLeft: MixHelpers.merge(bottomLeft, other.bottomLeft),
      bottomRight: MixHelpers.merge(bottomRight, other.bottomRight),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderRadiusMix &&
        other.topLeft == topLeft &&
        other.topRight == topRight &&
        other.bottomLeft == bottomLeft &&
        other.bottomRight == bottomRight;
  }

  @override
  int get hashCode {
    return Object.hash(topLeft, topRight, bottomLeft, bottomRight);
  }
}

final class BorderRadiusDirectionalMix
    extends BorderRadiusGeometryMix<BorderRadiusDirectional> {
  final Prop<Radius>? topStart;
  final Prop<Radius>? topEnd;
  final Prop<Radius>? bottomStart;
  final Prop<Radius>? bottomEnd;

  BorderRadiusDirectionalMix.only({
    Radius? topStart,
    Radius? topEnd,
    Radius? bottomStart,
    Radius? bottomEnd,
  }) : this(
         topStart: Prop.maybe(topStart),
         topEnd: Prop.maybe(topEnd),
         bottomStart: Prop.maybe(bottomStart),
         bottomEnd: Prop.maybe(bottomEnd),
       );

  /// Constructor that accepts a [BorderRadiusDirectional] value and extracts its properties.
  ///
  /// This is useful for converting existing [BorderRadiusDirectional] instances to [BorderRadiusDirectionalMix].
  ///
  /// ```dart
  /// const borderRadius = BorderRadiusDirectional.circular(12.0);
  /// final dto = BorderRadiusDirectionalMix.value(borderRadius);
  /// ```
  BorderRadiusDirectionalMix.value(BorderRadiusDirectional borderRadius)
    : this.only(
        topStart: borderRadius.topStart,
        topEnd: borderRadius.topEnd,
        bottomStart: borderRadius.bottomStart,
        bottomEnd: borderRadius.bottomEnd,
      );

  const BorderRadiusDirectionalMix({
    this.topStart,
    this.topEnd,
    this.bottomStart,
    this.bottomEnd,
  });

  /// Constructor that accepts a nullable [BorderRadiusDirectional] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BorderRadiusDirectionalMix.value].
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

  @override
  BorderRadiusDirectional resolve(BuildContext context) {
    return BorderRadiusDirectional.only(
      topStart: MixHelpers.resolve(context, topStart) ?? Radius.zero,
      topEnd: MixHelpers.resolve(context, topEnd) ?? Radius.zero,
      bottomStart: MixHelpers.resolve(context, bottomStart) ?? Radius.zero,
      bottomEnd: MixHelpers.resolve(context, bottomEnd) ?? Radius.zero,
    );
  }

  @override
  BorderRadiusDirectionalMix merge(BorderRadiusDirectionalMix? other) {
    if (other == null) return this;

    return BorderRadiusDirectionalMix(
      topStart: MixHelpers.merge(topStart, other.topStart),
      topEnd: MixHelpers.merge(topEnd, other.topEnd),
      bottomStart: MixHelpers.merge(bottomStart, other.bottomStart),
      bottomEnd: MixHelpers.merge(bottomEnd, other.bottomEnd),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BorderRadiusDirectionalMix &&
        other.topStart == topStart &&
        other.topEnd == topEnd &&
        other.bottomStart == bottomStart &&
        other.bottomEnd == bottomEnd;
  }

  @override
  int get hashCode {
    return Object.hash(topStart, topEnd, bottomStart, bottomEnd);
  }

  /// These getters return null for BorderRadiusDirectional as they don't apply
  /// to directional border radius (which uses topStart/topEnd instead of topLeft/topRight)
  @override
  Prop<Radius>? get topLeft => null;
  @override
  Prop<Radius>? get topRight => null;
  @override
  Prop<Radius>? get bottomLeft => null;
  @override
  Prop<Radius>? get bottomRight => null;
}

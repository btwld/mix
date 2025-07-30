import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'color_util.dart';
import 'shadow_mix.dart';

/// Utility class for configuring [Shadow] properties.
///
/// This class provides methods to set individual properties of a [Shadow].
/// Use the methods of this class to configure specific properties of a [Shadow].
///
class ShadowUtility<T extends Style<Object?>>
    extends MixPropUtility<T, Shadow> {
  /// Utility for defining [ShadowMix.blurRadius].
  late final blurRadius = PropUtility<T, double>(
    (prop) => onlyProps(blurRadius: prop),
  );

  /// Utility for defining [ShadowMix.color].
  late final color = ColorUtility<T>((prop) => onlyProps(color: prop));

  /// Utility for defining [ShadowMix.offset].
  late final offset = PropUtility<T, Offset>((prop) => onlyProps(offset: prop));

  ShadowUtility(super.builder) : super(convertToMix: ShadowMix.value);

  @protected
  T onlyProps({
    Prop<double>? blurRadius,
    Prop<Color>? color,
    Prop<Offset>? offset,
  }) {
    return builder(
      MixProp(
        ShadowMix.raw(blurRadius: blurRadius, color: color, offset: offset),
      ),
    );
  }

  T only({double? blurRadius, Color? color, Offset? offset}) {
    return onlyProps(
      blurRadius: Prop.maybe(blurRadius),
      color: Prop.maybe(color),
      offset: Prop.maybe(offset),
    );
  }

  T call({double? blurRadius, Color? color, Offset? offset}) {
    return only(blurRadius: blurRadius, color: color, offset: offset);
  }
}

/// Utility class for configuring [BoxShadow] properties.
///
/// This class provides methods to set individual properties of a [BoxShadow].
/// Use the methods of this class to configure specific properties of a [BoxShadow].
class BoxShadowUtility<T extends Style<Object?>>
    extends MixPropUtility<T, BoxShadow> {
  late final color = ColorUtility<T>((prop) => onlyProps(color: prop));

  /// Utility for defining [BoxShadowMix.offset].
  late final offset = PropUtility<T, Offset>((prop) => onlyProps(offset: prop));

  /// Utility for defining [BoxShadowMix.blurRadius].
  late final blurRadius = PropUtility<T, double>(
    (prop) => onlyProps(blurRadius: prop),
  );

  /// Utility for defining [BoxShadowMix.spreadRadius].
  late final spreadRadius = PropUtility<T, double>(
    (prop) => onlyProps(spreadRadius: prop),
  );

  BoxShadowUtility(super.builder) : super(convertToMix: BoxShadowMix.value);

  @protected
  T onlyProps({
    Prop<Color>? color,
    Prop<Offset>? offset,
    Prop<double>? blurRadius,
    Prop<double>? spreadRadius,
  }) {
    return builder(
      MixProp(
        BoxShadowMix.raw(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
      ),
    );
  }

  T only({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return onlyProps(
      color: Prop.maybe(color),
      offset: Prop.maybe(offset),
      blurRadius: Prop.maybe(blurRadius),
      spreadRadius: Prop.maybe(spreadRadius),
    );
  }

  T call({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return only(
      color: color,
      offset: offset,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }

  /// Returns a new [T] with the specified [BoxShadowMix] properties.
  T mix(BoxShadowMix value) => builder(MixProp(value));
}

/// A utility class for building [Style] instances from elevation values that produces [MixProp<BoxShadow>] lists.
///
/// This class extends [MixUtility] and provides methods to create [Style] instances
/// based on predefined elevation values, which are mapped to corresponding lists of
/// [MixProp<BoxShadow>] objects that can be directly used in DTOs.
final class ElevationMixPropUtility<T extends Style<Object?>>
    extends MixUtility<T, List<MixProp<BoxShadow>>> {
  /// Creates an [T] instance with an elevation of 1.
  late final e1 = one;

  /// Creates an [T] instance with an elevation of 2.
  late final e2 = two;

  /// Creates an [T] instance with an elevation of 3.
  late final e3 = three;

  /// Creates an [T] instance with an elevation of 4.
  late final e4 = four;

  /// Creates an [T] instance with an elevation of 6.
  late final e6 = six;

  /// Creates an [T] instance with an elevation of 8.
  late final e8 = eight;

  /// Creates an [T] instance with an elevation of 9.
  late final e9 = nine;

  /// Creates an [T] instance with an elevation of 12.
  late final e12 = twelve;

  /// Creates an [T] instance with an elevation of 16
  late final e16 = sixteen;

  /// Creates an [T] instance with an elevation of 24.
  late final e24 = twentyFour;

  ElevationMixPropUtility(super.builder);

  /// Creates an [T] instance with an elevation of 1.
  T get one => call(1);

  /// Creates an [T] instance with an elevation of 2.
  T get two => call(2);

  /// Creates an [T] instance with an elevation of 3.
  T get three => call(3);

  /// Creates an [T] instance with an elevation of 4.
  T get four => call(4);

  /// Creates an [T] instance with an elevation of 6.
  T get six => call(6);

  /// Creates an [T] instance with an elevation of 8.
  T get eight => call(8);

  /// Creates an [T] instance with an elevation of 9.
  T get nine => call(9);

  /// Creates an [T] instance with an elevation of 12.
  T get twelve => call(12);

  /// Creates an [T] instance with an elevation of 16.
  T get sixteen => call(16);

  /// Creates an [T] instance with an elevation of 24.
  T get twentyFour => call(24);

  /// Creates an [Style] instance from an elevation value.
  ///
  /// Retrieves the corresponding list of [BoxShadow] objects from the [kElevationToShadow]
  /// map, maps each [BoxShadow] to a [MixProp<BoxShadow>], and passes the resulting list to
  /// the [builder] function to create the [Style] instance.
  ///
  /// Throws an [AssertionError] if the provided [value] is not a valid elevation value.
  T call(int value) {
    if (!kElevationToShadow.containsKey(value)) {
      throw FlutterError.fromParts([
        ErrorSummary('Invalid elevation value provided.'),
        ErrorDescription(
          'The elevation value $value is not a valid predefined elevation.',
        ),
        ErrorHint(
          'Please use one of the predefined elevation values: ${kElevationToShadow.keys.join(", ")}.',
        ),
      ]);
    }

    final boxShadows = kElevationToShadow[value]!.map(
      (e) => MixProp(
        BoxShadowMix.raw(
          color: Prop(e.color),
          offset: Prop(e.offset),
          blurRadius: Prop(e.blurRadius),
          spreadRadius: Prop(e.spreadRadius),
        ),
      ),
    );

    return builder(boxShadows.toList());
  }
}

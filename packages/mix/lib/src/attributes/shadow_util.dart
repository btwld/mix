import 'package:flutter/material.dart';

import '../core/prop.dart';
import '../core/style.dart';
import '../core/utility.dart';
import 'color_util.dart';
import 'scalar_util.dart';
import 'shadow_mix.dart';

/// Utility class for configuring [Shadow] properties.
///
/// This class provides methods to set individual properties of a [Shadow].
/// Use the methods of this class to configure specific properties of a [Shadow].
class ShadowUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, Shadow> {
  /// Utility for defining [ShadowMix.blurRadius].
  late final blurRadius = DoubleUtility<T>(
    (prop) => call(ShadowMix(blurRadius: prop)),
  );

  /// Utility for defining [ShadowMix.color].
  late final color = ColorUtility<T>((prop) => call(ShadowMix(color: prop)));

  /// Utility for defining [ShadowMix.offset].
  late final offset = OffsetUtility<T>((prop) => call(ShadowMix(offset: prop)));

  ShadowUtility(super.builder) : super(convertToMix: ShadowMix.value);

  /// Returns a new [T] with the specified [ShadowMix] properties.
  @override
  T call(ShadowMix value) => builder(MixProp(value));
}

/// Utility class for configuring [BoxShadow] properties.
///
/// This class provides methods to set individual properties of a [BoxShadow].
/// Use the methods of this class to configure specific properties of a [BoxShadow].
class BoxShadowUtility<T extends StyleAttribute<Object?>>
    extends MixPropUtility<T, BoxShadow> {
  late final color = ColorUtility<T>((prop) => call(BoxShadowMix(color: prop)));

  /// Utility for defining [BoxShadowMix.offset].
  late final offset = OffsetUtility<T>(
    (prop) => call(BoxShadowMix(offset: prop)),
  );

  /// Utility for defining [BoxShadowMix.blurRadius].
  late final blurRadius = DoubleUtility<T>(
    (prop) => call(BoxShadowMix(blurRadius: prop)),
  );

  /// Utility for defining [BoxShadowMix.spreadRadius].
  late final spreadRadius = DoubleUtility<T>(
    (prop) => call(BoxShadowMix(spreadRadius: prop)),
  );

  BoxShadowUtility(super.builder) : super(convertToMix: BoxShadowMix.value);

  /// Returns a new [T] with the specified [BoxShadowMix] properties.
  @override
  T call(BoxShadowMix value) => builder(MixProp(value));
}

/// A utility class for building [StyleAttribute] instances from elevation values that produces [MixProp<BoxShadow>] lists.
///
/// This class extends [MixUtility] and provides methods to create [StyleAttribute] instances
/// based on predefined elevation values, which are mapped to corresponding lists of
/// [MixProp<BoxShadow>] objects that can be directly used in DTOs.
final class ElevationMixPropUtility<T extends StyleAttribute<Object?>>
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

  /// Creates an [StyleAttribute] instance from an elevation value.
  ///
  /// Retrieves the corresponding list of [BoxShadow] objects from the [kElevationToShadow]
  /// map, maps each [BoxShadow] to a [MixProp<BoxShadow>], and passes the resulting list to
  /// the [builder] function to create the [StyleAttribute] instance.
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
        BoxShadowMix(
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

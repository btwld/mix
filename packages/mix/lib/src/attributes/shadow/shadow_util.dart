import 'package:flutter/material.dart';

import '../../core/element.dart';
import '../../core/utility.dart';
import 'shadow_dto.dart';

/// A utility class for building [StyleElement] instances from a list of [ShadowDto] objects.
///
/// This class extends [MixUtility] and provides a convenient way to create [StyleElement]
/// instances by transforming a list of [BoxShadow] objects into a list of [ShadowDto] objects.
final class ShadowListUtility<T extends StyleElement>
    extends MixUtility<T, List<ShadowDto>> {
  const ShadowListUtility(super.builder);

  /// Creates an [StyleElement] instance from a list of [BoxShadow] objects.
  ///
  /// This method maps each [BoxShadow] object to a [ShadowDto] object and passes the
  /// resulting list to the [builder] function to create the [StyleElement] instance.
  T call(List<Shadow> shadows) {
    return builder(shadows.map((e) => e.toDto()).toList());
  }
}

/// A utility class for building [StyleElement] instances from a list of [BoxShadowDto] objects.
///
/// This class extends [MixUtility] and provides a convenient way to create [StyleElement]
/// instances by transforming a list of [BoxShadow] objects into a list of [BoxShadowDto] objects.
final class BoxShadowListUtility<T extends StyleElement>
    extends MixUtility<T, List<BoxShadowDto>> {
  late final add = BoxShadowUtility((v) => builder([v]));

  BoxShadowListUtility(super.builder);

  /// Creates an [StyleElement] instance from a list of [BoxShadow] objects.
  ///
  /// This method maps each [BoxShadow] object to a [BoxShadowDto] object and passes the
  /// resulting list to the [builder] function to create the [StyleElement] instance.
  T call(List<BoxShadow> shadows) {
    return builder(shadows.map((e) => e.toDto()).toList());
  }
}

/// A utility class for building [StyleElement] instances from elevation values.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// based on predefined elevation values, which are mapped to corresponding lists of
/// [BoxShadowDto] objects using the [kElevationToShadow] map.
final class ElevationUtility<T extends StyleElement>
    extends MixUtility<T, List<BoxShadowDto>> {
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

  ElevationUtility(super.builder);

  /// Creates an [StyleElement] instance from an elevation value.
  ///
  /// Retrieves the corresponding list of [BoxShadow] objects from the [kElevationToShadow]
  /// map, maps each [BoxShadow] to a [BoxShadowDto], and passes the resulting list to
  /// the [builder] function to create the [StyleElement] instance.
  ///
  /// Throws an [AssertionError] if the provided [value] is not a valid elevation value.
  T call(int value) {
    if (!kElevationToShadow.containsKey(value)) {
      throw FlutterError.fromParts(
        [
          ErrorSummary('Invalid elevation value provided.'),
          ErrorDescription(
            'The elevation value $value is not a valid predefined elevation.',
          ),
          ErrorHint(
            'Please use one of the predefined elevation values: ${kElevationToShadow.keys.join(", ")}.',
          ),
        ],
      );
    }

    final boxShadows = kElevationToShadow[value]!.map((e) => e.toDto());

    return builder(boxShadows.toList());
  }

  /// Creates an [T] instance with no elevation.
  T none() => call(0);

  /// Creates an [T] instance with an elevation of 1.
  T one() => call(1);

  /// Creates an [T] instance with an elevation of 2.
  T two() => call(2);

  /// Creates an [T] instance with an elevation of 3.
  T three() => call(3);

  /// Creates an [T] instance with an elevation of 4.
  T four() => call(4);

  /// Creates an [T] instance with an elevation of 6.
  T six() => call(6);

  /// Creates an [T] instance with an elevation of 8.
  T eight() => call(8);

  /// Creates an [T] instance with an elevation of 9.
  T nine() => call(9);

  /// Creates an [T] instance with an elevation of 12.
  T twelve() => call(12);

  /// Creates an [T] instance with an elevation of 16.
  T sixteen() => call(16);

  /// Creates an [T] instance with an elevation of 24.
  T twentyFour() => call(24);
}

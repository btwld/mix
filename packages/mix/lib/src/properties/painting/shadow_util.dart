import 'package:flutter/material.dart';

import '../../core/style.dart';
import '../../core/utility.dart';
import 'color_util.dart';
import 'shadow_mix.dart';

/// Utility class for configuring [Shadow] properties.
///
/// This class provides methods to set individual properties of a [Shadow].
/// Use the methods of this class to configure specific properties of a [Shadow].
///
final class ShadowUtility<T extends Style<Object?>>
    extends MixUtility<T, ShadowMix> {
  /// Utility for defining [ShadowMix.color].
  late final color = ColorUtility(
    (prop) => utilityBuilder(ShadowMix.create(color: prop)),
  );

  /// Utility for defining [ShadowMix.offset].
  late final offset = MixUtility<T, Offset>((prop) => call(offset: prop));

  ShadowUtility(super.utilityBuilder);

  /// Utility for defining [ShadowMix.blurRadius].
  T blurRadius(double v) => call(blurRadius: v);

  T call({double? blurRadius, Color? color, Offset? offset}) {
    return utilityBuilder(
      ShadowMix(blurRadius: blurRadius, color: color, offset: offset),
    );
  }

  T as(Shadow value) {
    return utilityBuilder(ShadowMix.value(value));
  }
}

/// Utility class for configuring [BoxShadow] properties.
///
/// This class provides methods to set individual properties of a [BoxShadow].
/// Use the methods of this class to configure specific properties of a [BoxShadow].
final class BoxShadowUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxShadowMix> {
  /// Utility for defining [BoxShadowMix.color].
  late final color = ColorUtility(
    (prop) => utilityBuilder(BoxShadowMix.create(color: prop)),
  );

  /// Utility for defining [BoxShadowMix.offset].
  late final offset = MixUtility<T, Offset>((prop) => call(offset: prop));

  BoxShadowUtility(super.utilityBuilder);

  /// Utility for defining [BoxShadowMix.blurRadius].
  T blurRadius(double v) => call(blurRadius: v);

  /// Utility for defining [BoxShadowMix.spreadRadius].
  T spreadRadius(double v) => call(spreadRadius: v);

  T call({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    var boxShadow = BoxShadowMix();

    boxShadow = boxShadow.merge(
      BoxShadowMix(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    );

    return utilityBuilder(boxShadow);
  }

  T as(BoxShadow value) {
    return utilityBuilder(BoxShadowMix.value(value));
  }
}

/// A utility class for building [Style] instances from elevation values that produces
/// a Mix value representing a list of [BoxShadow]s.
///
/// This class extends [MixUtility] and provides methods to create [Style] instances
/// based on predefined elevation values, which are mapped to corresponding lists of
/// [BoxShadowMix] and wrapped into a [BoxShadowListMix].
final class ElevationPropUtility<T extends Style<Object?>>
    extends MixUtility<T, BoxShadowListMix> {
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

  ElevationPropUtility(super.utilityBuilder);

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

  /// Creates a Mix value from an elevation value.
  ///
  /// Retrieves the corresponding list of [BoxShadow] objects from the [kElevationToShadow]
  /// map, maps each [BoxShadow] to a [BoxShadowMix], wraps them in a [BoxShadowListMix],
  /// and passes it to the [utilityBuilder].
  ///
  /// Throws a [FlutterError] if the provided [value] is not a valid elevation value.
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

    final items = kElevationToShadow[value]!
        .map<BoxShadowMix>((e) => BoxShadowMix.value(e))
        .toList();

    return utilityBuilder(BoxShadowListMix(items));
  }
}

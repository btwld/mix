import 'package:flutter/material.dart';

import '../../core/mix_element.dart';
import '../../core/utility.dart';
import '../color/color_util.dart';
import '../scalars/scalar_util.dart';
import 'shadow_dto.dart';

/// Utility class for configuring [Shadow] properties.
///
/// This class provides methods to set individual properties of a [Shadow].
/// Use the methods of this class to configure specific properties of a [Shadow].
class ShadowUtility<T extends StyleElement>
    extends DtoUtility<T, ShadowDto, Shadow> {
  /// Utility for defining [ShadowDto.blurRadius]
  late final blurRadius = DoubleUtility((v) => only(blurRadius: v));

  /// Utility for defining [ShadowDto.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [ShadowDto.offset]
  late final offset = OffsetUtility((v) => only(offset: v));

  ShadowUtility(super.builder)
    : super(
        valueToDto: (v) => ShadowDto(
          blurRadius: v.blurRadius,
          color: v.color,
          offset: v.offset,
        ),
      );

  T call({double? blurRadius, Color? color, Offset? offset}) {
    return builder(
      ShadowDto(blurRadius: blurRadius, color: color, offset: offset),
    );
  }

  /// Returns a new [ShadowDto] with the specified properties.
  @override
  T only({double? blurRadius, Color? color, Offset? offset}) {
    return builder(
      ShadowDto(blurRadius: blurRadius, color: color, offset: offset),
    );
  }
}

/// Utility class for configuring [BoxShadow] properties.
///
/// This class provides methods to set individual properties of a [BoxShadow].
/// Use the methods of this class to configure specific properties of a [BoxShadow].
class BoxShadowUtility<T extends StyleElement>
    extends DtoUtility<T, BoxShadowDto, BoxShadow> {
  /// Utility for defining [BoxShadowDto.color]
  late final color = ColorUtility((v) => only(color: v));

  /// Utility for defining [BoxShadowDto.offset]
  late final offset = OffsetUtility((v) => only(offset: v));

  /// Utility for defining [BoxShadowDto.blurRadius]
  late final blurRadius = DoubleUtility((v) => only(blurRadius: v));

  /// Utility for defining [BoxShadowDto.spreadRadius]
  late final spreadRadius = DoubleUtility((v) => only(spreadRadius: v));

  BoxShadowUtility(super.builder)
    : super(
        valueToDto: (v) => BoxShadowDto(
          color: v.color,
          offset: v.offset,
          blurRadius: v.blurRadius,
          spreadRadius: v.spreadRadius,
        ),
      );

  T call({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return builder(
      BoxShadowDto(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    );
  }

  /// Returns a new [BoxShadowDto] with the specified properties.
  @override
  T only({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return builder(
      BoxShadowDto(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    );
  }
}

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
    return builder(
      shadows
          .map(
            (e) => ShadowDto(
              blurRadius: e.blurRadius,
              color: e.color,
              offset: e.offset,
            ),
          )
          .toList(),
    );
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
    return builder(
      shadows
          .map(
            (e) => BoxShadowDto(
              color: e.color,
              offset: e.offset,
              blurRadius: e.blurRadius,
              spreadRadius: e.spreadRadius,
            ),
          )
          .toList(),
    );
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
      (e) => BoxShadowDto(
        color: e.color,
        offset: e.offset,
        blurRadius: e.blurRadius,
        spreadRadius: e.spreadRadius,
      ),
    );

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

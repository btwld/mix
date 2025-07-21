import 'package:flutter/material.dart';

import '../../core/attribute.dart';
import '../../core/prop.dart';
import '../../core/utility.dart';
import '../color/color_util.dart';
import '../scalars/scalar_util.dart';
import 'shadow_dto.dart';

/// Utility class for configuring [Shadow] properties.
///
/// This class provides methods to set individual properties of a [Shadow].
/// Use the methods of this class to configure specific properties of a [Shadow].
class ShadowUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, Shadow> {
  /// Utility for defining [ShadowDto.blurRadius].
  late final blurRadius = DoubleUtility<T>(
    (prop) => call(ShadowDto(blurRadius: prop)),
  );

  /// Utility for defining [ShadowDto.color].
  late final color = ColorUtility<T>((prop) => call(ShadowDto(color: prop)));

  /// Utility for defining [ShadowDto.offset].
  late final offset = OffsetUtility<T>((prop) => call(ShadowDto(offset: prop)));

  ShadowUtility(super.builder) : super(valueToMix: ShadowDto.value);

  /// Returns a new [T] with the specified [ShadowDto] properties.
  @override
  T call(ShadowDto value) => builder(MixProp(value));
}

/// Utility class for configuring [BoxShadow] properties.
///
/// This class provides methods to set individual properties of a [BoxShadow].
/// Use the methods of this class to configure specific properties of a [BoxShadow].
class BoxShadowUtility<T extends SpecAttribute<Object?>>
    extends MixPropUtility<T, BoxShadow> {
  late final color = ColorUtility<T>((prop) => call(BoxShadowDto(color: prop)));

  /// Utility for defining [BoxShadowDto.offset].
  late final offset = OffsetUtility<T>(
    (prop) => call(BoxShadowDto(offset: prop)),
  );

  /// Utility for defining [BoxShadowDto.blurRadius].
  late final blurRadius = DoubleUtility<T>(
    (prop) => call(BoxShadowDto(blurRadius: prop)),
  );

  /// Utility for defining [BoxShadowDto.spreadRadius].
  late final spreadRadius = DoubleUtility<T>(
    (prop) => call(BoxShadowDto(spreadRadius: prop)),
  );

  BoxShadowUtility(super.builder) : super(valueToMix: BoxShadowDto.value);

  /// Returns a new [T] with the specified [BoxShadowDto] properties.
  @override
  T call(BoxShadowDto value) => builder(MixProp(value));
}

/// A utility class for building [StyleElement] instances from a list of [MixProp<BoxShadow>] objects.
///
/// This class extends [MixUtility] and provides a way to create [StyleElement]
/// instances by transforming a list of [BoxShadow] objects into a list of [MixProp<BoxShadow>] objects
/// that can be directly used in DTOs.
final class BoxShadowMixPropListUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, List<MixProp<BoxShadow>>> {
  const BoxShadowMixPropListUtility(super.builder);

  /// Creates an [StyleElement] instance from a list of [BoxShadow] objects.
  ///
  /// This method maps each [BoxShadow] object to a [MixProp<BoxShadow>] object and passes the
  /// resulting list to the [builder] function to create the [StyleElement] instance.
  T call(List<BoxShadow> shadows) {
    return builder(
      shadows.map((shadow) => MixProp(BoxShadowDto.value(shadow))).toList(),
    );
  }
}

/// A utility class for building [StyleElement] instances from elevation values that produces [MixProp<BoxShadow>] lists.
///
/// This class extends [MixUtility] and provides methods to create [StyleElement] instances
/// based on predefined elevation values, which are mapped to corresponding lists of
/// [MixProp<BoxShadow>] objects that can be directly used in DTOs.
final class ElevationMixPropUtility<T extends SpecAttribute<Object?>>
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

  /// Creates an [StyleElement] instance from an elevation value.
  ///
  /// Retrieves the corresponding list of [BoxShadow] objects from the [kElevationToShadow]
  /// map, maps each [BoxShadow] to a [MixProp<BoxShadow>], and passes the resulting list to
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
      (e) => MixProp(
        BoxShadowDto(
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

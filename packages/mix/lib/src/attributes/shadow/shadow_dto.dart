// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

sealed class BaseShadowDto<T extends Shadow> extends Mix<T> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? color;
  final Prop<Offset>? offset;
  final Prop<double>? blurRadius;

  const BaseShadowDto({
    required this.blurRadius,
    required this.color,
    required this.offset,
  });
}

/// Represents a [Mix] Data transfer object of [Shadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [Shadow]
class ShadowDto extends BaseShadowDto<Shadow> with HasDefaultValue<Shadow> {
  ShadowDto.only({double? blurRadius, Color? color, Offset? offset})
    : this(
        blurRadius: Prop.maybe(blurRadius),
        color: Prop.maybe(color),
        offset: Prop.maybe(offset),
      );

  const ShadowDto({super.blurRadius, super.color, super.offset});

  /// Constructor that accepts a [Shadow] value and extracts its properties.
  ///
  /// This is useful for converting existing [Shadow] instances to [ShadowDto].
  ///
  /// ```dart
  /// const shadow = Shadow(color: Colors.black, blurRadius: 5.0);
  /// final dto = ShadowDto.value(shadow);
  /// ```
  ShadowDto.value(Shadow shadow)
    : this.only(
        blurRadius: shadow.blurRadius,
        color: shadow.color,
        offset: shadow.offset,
      );

  /// Constructor that accepts a nullable [Shadow] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ShadowDto.value].
  ///
  /// ```dart
  /// const Shadow? shadow = Shadow(color: Colors.black, blurRadius: 5.0);
  /// final dto = ShadowDto.maybeValue(shadow); // Returns ShadowDto or null
  /// ```
  static ShadowDto? maybeValue(Shadow? shadow) {
    return shadow != null ? ShadowDto.value(shadow) : null;
  }

  /// Resolves to [Shadow] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final shadow = ShadowDto(...).resolve(mix);
  /// ```
  @override
  Shadow resolve(BuildContext context) {
    return Shadow(
      color: MixHelpers.resolve(context, color) ?? defaultValue.color,
      offset: MixHelpers.resolve(context, offset) ?? defaultValue.offset,
      blurRadius:
          MixHelpers.resolve(context, blurRadius) ?? defaultValue.blurRadius,
    );
  }

  /// Merges the properties of this [ShadowDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ShadowDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ShadowDto merge(ShadowDto? other) {
    if (other == null) return this;

    return ShadowDto(
      blurRadius: MixHelpers.merge(blurRadius, other.blurRadius),
      color: MixHelpers.merge(color, other.color),
      offset: MixHelpers.merge(offset, other.offset),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShadowDto &&
        other.blurRadius == blurRadius &&
        other.color == color &&
        other.offset == offset;
  }

  @override
  Shadow get defaultValue => const Shadow();

  @override
  int get hashCode {
    return blurRadius.hashCode ^ color.hashCode ^ offset.hashCode;
  }
}

/// Represents a [Mix] Data transfer object of [BoxShadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxShadow]
class BoxShadowDto extends BaseShadowDto<BoxShadow>
    with HasDefaultValue<BoxShadow> {
  final Prop<double>? spreadRadius;

  BoxShadowDto.only({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) : this(
         color: Prop.maybe(color),
         offset: Prop.maybe(offset),
         blurRadius: Prop.maybe(blurRadius),
         spreadRadius: Prop.maybe(spreadRadius),
       );

  const BoxShadowDto({
    super.color,
    super.offset,
    super.blurRadius,
    this.spreadRadius,
  });

  /// Constructor that accepts a [BoxShadow] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxShadow] instances to [BoxShadowDto].
  ///
  /// ```dart
  /// const boxShadow = BoxShadow(color: Colors.grey, blurRadius: 10.0);
  /// final dto = BoxShadowDto.value(boxShadow);
  /// ```
  BoxShadowDto.value(BoxShadow boxShadow)
    : this.only(
        color: boxShadow.color,
        offset: boxShadow.offset,
        blurRadius: boxShadow.blurRadius,
        spreadRadius: boxShadow.spreadRadius,
      );

  /// Constructor that accepts a nullable [BoxShadow] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxShadowDto.value].
  ///
  /// ```dart
  /// const BoxShadow? boxShadow = BoxShadow(color: Colors.grey, blurRadius: 10.0);
  /// final dto = BoxShadowDto.maybeValue(boxShadow); // Returns BoxShadowDto or null
  /// ```
  static BoxShadowDto? maybeValue(BoxShadow? boxShadow) {
    return boxShadow != null ? BoxShadowDto.value(boxShadow) : null;
  }

  static List<BoxShadowDto> fromElevation(ElevationShadow value) {
    return kElevationToShadow[value.elevation]!
        .map(BoxShadowDto.value)
        .toList();
  }

  /// Resolves to [BoxShadow] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxShadow = BoxShadowDto(...).resolve(mix);
  /// ```
  @override
  BoxShadow resolve(BuildContext context) {
    return BoxShadow(
      color: MixHelpers.resolve(context, color) ?? defaultValue.color,
      offset: MixHelpers.resolve(context, offset) ?? defaultValue.offset,
      blurRadius:
          MixHelpers.resolve(context, blurRadius) ?? defaultValue.blurRadius,
      spreadRadius:
          MixHelpers.resolve(context, spreadRadius) ??
          defaultValue.spreadRadius,
    );
  }

  /// Merges the properties of this [BoxShadowDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxShadowDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxShadowDto merge(BoxShadowDto? other) {
    if (other == null) return this;

    return BoxShadowDto(
      color: MixHelpers.merge(color, other.color),
      offset: MixHelpers.merge(offset, other.offset),
      blurRadius: MixHelpers.merge(blurRadius, other.blurRadius),
      spreadRadius: MixHelpers.merge(spreadRadius, other.spreadRadius),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxShadowDto &&
        other.color == color &&
        other.offset == offset &&
        other.blurRadius == blurRadius &&
        other.spreadRadius == spreadRadius;
  }

  @override
  BoxShadow get defaultValue => const BoxShadow();

  @override
  int get hashCode {
    return color.hashCode ^
        offset.hashCode ^
        blurRadius.hashCode ^
        spreadRadius.hashCode;
  }
}

// ElevationBoxShadowDto is a convenience class for creating BoxShadowDto from elevation values.
enum ElevationShadow {
  one(1),
  two(2),
  three(3),
  four(4),
  six(6),
  eight(8),
  nine(9),
  twelve(12),
  sixteen(16),
  twentyFour(24);

  final int elevation;

  const ElevationShadow(this.elevation);
}

// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/material.dart';

import '../core/helpers.dart';
import '../core/mix_element.dart';
import '../core/prop.dart';

sealed class BaseShadowMix<T extends Shadow> extends Mix<T> {
  // Properties use MixableProperty for cleaner merging
  final Prop<Color>? $color;
  final Prop<Offset>? $offset;
  final Prop<double>? $blurRadius;

  const BaseShadowMix({
    Prop<double>? blurRadius,
    Prop<Color>? color,
    Prop<Offset>? offset,
  }) : $blurRadius = blurRadius,
       $color = color,
       $offset = offset;
}

/// Represents a [Mix] Data transfer object of [Shadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [Shadow]
class ShadowMix extends BaseShadowMix<Shadow> with DefaultValue<Shadow> {
  ShadowMix.only({double? blurRadius, Color? color, Offset? offset})
    : this(
        blurRadius: Prop.maybe(blurRadius),
        color: Prop.maybe(color),
        offset: Prop.maybe(offset),
      );

  const ShadowMix({super.blurRadius, super.color, super.offset});

  /// Constructor that accepts a [Shadow] value and extracts its properties.
  ///
  /// This is useful for converting existing [Shadow] instances to [ShadowMix].
  ///
  /// ```dart
  /// const shadow = Shadow(color: Colors.black, blurRadius: 5.0);
  /// final dto = ShadowMix.value(shadow);
  /// ```
  ShadowMix.value(Shadow shadow)
    : this.only(
        blurRadius: shadow.blurRadius,
        color: shadow.color,
        offset: shadow.offset,
      );

  factory ShadowMix.color(Color value) {
    return ShadowMix.only(color: value);
  }

  factory ShadowMix.offset(Offset value) {
    return ShadowMix.only(offset: value);
  }

  factory ShadowMix.blurRadius(double value) {
    return ShadowMix.only(blurRadius: value);
  }

  /// Constructor that accepts a nullable [Shadow] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [ShadowMix.value].
  ///
  /// ```dart
  /// const Shadow? shadow = Shadow(color: Colors.black, blurRadius: 5.0);
  /// final dto = ShadowMix.maybeValue(shadow); // Returns ShadowMix or null
  /// ```
  static ShadowMix? maybeValue(Shadow? shadow) {
    return shadow != null ? ShadowMix.value(shadow) : null;
  }

  /// Creates a new [ShadowMix] with the provided color,
  /// merging it with the current instance.
  ShadowMix color(Color value) {
    return merge(ShadowMix.only(color: value));
  }

  /// Creates a new [ShadowMix] with the provided offset,
  /// merging it with the current instance.
  ShadowMix offset(Offset value) {
    return merge(ShadowMix.only(offset: value));
  }

  /// Creates a new [ShadowMix] with the provided blurRadius,
  /// merging it with the current instance.
  ShadowMix blurRadius(double value) {
    return merge(ShadowMix.only(blurRadius: value));
  }

  /// Resolves to [Shadow] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final shadow = ShadowMix(...).resolve(mix);
  /// ```
  @override
  Shadow resolve(BuildContext context) {
    return Shadow(
      color: MixHelpers.resolve(context, $color) ?? defaultValue.color,
      offset: MixHelpers.resolve(context, $offset) ?? defaultValue.offset,
      blurRadius:
          MixHelpers.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
    );
  }

  /// Merges the properties of this [ShadowMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ShadowMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ShadowMix merge(ShadowMix? other) {
    if (other == null) return this;

    return ShadowMix(
      blurRadius: MixHelpers.merge($blurRadius, other.$blurRadius),
      color: MixHelpers.merge($color, other.$color),
      offset: MixHelpers.merge($offset, other.$offset),
    );
  }

  @override
  List<Object?> get props => [$blurRadius, $color, $offset];

  @override
  Shadow get defaultValue => const Shadow();
}

/// Represents a [Mix] Data transfer object of [BoxShadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxShadow]
class BoxShadowMix extends BaseShadowMix<BoxShadow>
    with DefaultValue<BoxShadow> {
  final Prop<double>? $spreadRadius;

  BoxShadowMix.only({
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

  const BoxShadowMix({
    super.color,
    super.offset,
    super.blurRadius,
    Prop<double>? spreadRadius,
  }) : $spreadRadius = spreadRadius;

  /// Constructor that accepts a [BoxShadow] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxShadow] instances to [BoxShadowMix].
  ///
  /// ```dart
  /// const boxShadow = BoxShadow(color: Colors.grey, blurRadius: 10.0);
  /// final dto = BoxShadowMix.value(boxShadow);
  /// ```
  BoxShadowMix.value(BoxShadow boxShadow)
    : this.only(
        color: boxShadow.color,
        offset: boxShadow.offset,
        blurRadius: boxShadow.blurRadius,
        spreadRadius: boxShadow.spreadRadius,
      );

  factory BoxShadowMix.color(Color value) {
    return BoxShadowMix.only(color: value);
  }

  factory BoxShadowMix.offset(Offset value) {
    return BoxShadowMix.only(offset: value);
  }

  factory BoxShadowMix.blurRadius(double value) {
    return BoxShadowMix.only(blurRadius: value);
  }

  factory BoxShadowMix.spreadRadius(double value) {
    return BoxShadowMix.only(spreadRadius: value);
  }

  /// Constructor that accepts a nullable [BoxShadow] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxShadowMix.value].
  ///
  /// ```dart
  /// const BoxShadow? boxShadow = BoxShadow(color: Colors.grey, blurRadius: 10.0);
  /// final dto = BoxShadowMix.maybeValue(boxShadow); // Returns BoxShadowMix or null
  /// ```
  static BoxShadowMix? maybeValue(BoxShadow? boxShadow) {
    return boxShadow != null ? BoxShadowMix.value(boxShadow) : null;
  }

  static List<BoxShadowMix> fromElevation(ElevationShadow value) {
    return kElevationToShadow[value.elevation]!
        .map(BoxShadowMix.value)
        .toList();
  }

  /// Creates a new [BoxShadowMix] with the provided color,
  /// merging it with the current instance.
  BoxShadowMix color(Color value) {
    return merge(BoxShadowMix.only(color: value));
  }

  /// Creates a new [BoxShadowMix] with the provided offset,
  /// merging it with the current instance.
  BoxShadowMix offset(Offset value) {
    return merge(BoxShadowMix.only(offset: value));
  }

  /// Creates a new [BoxShadowMix] with the provided blurRadius,
  /// merging it with the current instance.
  BoxShadowMix blurRadius(double value) {
    return merge(BoxShadowMix.only(blurRadius: value));
  }

  /// Creates a new [BoxShadowMix] with the provided spreadRadius,
  /// merging it with the current instance.
  BoxShadowMix spreadRadius(double value) {
    return merge(BoxShadowMix.only(spreadRadius: value));
  }

  /// Resolves to [BoxShadow] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxShadow = BoxShadowMix(...).resolve(mix);
  /// ```
  @override
  BoxShadow resolve(BuildContext context) {
    return BoxShadow(
      color: MixHelpers.resolve(context, $color) ?? defaultValue.color,
      offset: MixHelpers.resolve(context, $offset) ?? defaultValue.offset,
      blurRadius:
          MixHelpers.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
      spreadRadius:
          MixHelpers.resolve(context, $spreadRadius) ??
          defaultValue.spreadRadius,
    );
  }

  /// Merges the properties of this [BoxShadowMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxShadowMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxShadowMix merge(BoxShadowMix? other) {
    if (other == null) return this;

    return BoxShadowMix(
      color: MixHelpers.merge($color, other.$color),
      offset: MixHelpers.merge($offset, other.$offset),
      blurRadius: MixHelpers.merge($blurRadius, other.$blurRadius),
      spreadRadius: MixHelpers.merge($spreadRadius, other.$spreadRadius),
    );
  }

  @override
  List<Object?> get props => [$color, $offset, $blurRadius, $spreadRadius];

  @override
  BoxShadow get defaultValue => const BoxShadow();
}

// ElevationBoxShadowMix is a convenience class for creating BoxShadowMix from elevation values.
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

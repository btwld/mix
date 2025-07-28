// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for shadow styling with common shadow properties.
///
/// Provides color, offset, and blur radius properties that are shared between
/// [ShadowMix] and [BoxShadowMix] implementations.
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

/// Mix-compatible representation of Flutter's [Shadow] with token support.
///
/// Provides shadow styling with color, offset, and blur radius properties
/// that support resolvable tokens and merging capabilities.
class ShadowMix extends BaseShadowMix<Shadow> with DefaultValue<Shadow> {
  ShadowMix({double? blurRadius, Color? color, Offset? offset})
    : this.raw(
        blurRadius: Prop.maybe(blurRadius),
        color: Prop.maybe(color),
        offset: Prop.maybe(offset),
      );

  const ShadowMix.raw({super.blurRadius, super.color, super.offset});

  /// Creates a [ShadowMix] from an existing [Shadow].
  ShadowMix.value(Shadow shadow)
    : this(
        blurRadius: shadow.blurRadius,
        color: shadow.color,
        offset: shadow.offset,
      );

  /// Creates a shadow with the specified color.
  factory ShadowMix.color(Color value) {
    return ShadowMix(color: value);
  }

  /// Creates a shadow with the specified offset.
  factory ShadowMix.offset(Offset value) {
    return ShadowMix(offset: value);
  }

  /// Creates a shadow with the specified blur radius.
  factory ShadowMix.blurRadius(double value) {
    return ShadowMix(blurRadius: value);
  }

  /// Creates a [ShadowMix] from a nullable [Shadow].
  ///
  /// Returns null if the input is null.
  static ShadowMix? maybeValue(Shadow? shadow) {
    return shadow != null ? ShadowMix.value(shadow) : null;
  }

  /// Returns a copy with the specified color.
  ShadowMix color(Color value) {
    return merge(ShadowMix(color: value));
  }

  /// Returns a copy with the specified offset.
  ShadowMix offset(Offset value) {
    return merge(ShadowMix(offset: value));
  }

  /// Returns a copy with the specified blur radius.
  ShadowMix blurRadius(double value) {
    return merge(ShadowMix(blurRadius: value));
  }

  /// Resolves to [Shadow] using the provided [BuildContext].
  @override
  Shadow resolve(BuildContext context) {
    return Shadow(
      color: MixHelpers.resolve(context, $color) ?? defaultValue.color,
      offset: MixHelpers.resolve(context, $offset) ?? defaultValue.offset,
      blurRadius:
          MixHelpers.resolve(context, $blurRadius) ?? defaultValue.blurRadius,
    );
  }

  /// Merges this shadow with another, with other taking precedence.
  @override
  ShadowMix merge(ShadowMix? other) {
    if (other == null) return this;

    return ShadowMix.raw(
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

/// Mix-compatible representation of Flutter's [BoxShadow] with additional spread radius.
///
/// Extends shadow styling with spread radius for box shadow effects, supporting
/// resolvable tokens and merging capabilities.
class BoxShadowMix extends BaseShadowMix<BoxShadow>
    with DefaultValue<BoxShadow> {
  final Prop<double>? $spreadRadius;

  BoxShadowMix({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) : this.raw(
         color: Prop.maybe(color),
         offset: Prop.maybe(offset),
         blurRadius: Prop.maybe(blurRadius),
         spreadRadius: Prop.maybe(spreadRadius),
       );

  const BoxShadowMix.raw({
    super.color,
    super.offset,
    super.blurRadius,
    Prop<double>? spreadRadius,
  }) : $spreadRadius = spreadRadius;

  /// Creates a [BoxShadowMix] from an existing [BoxShadow].
  BoxShadowMix.value(BoxShadow boxShadow)
    : this(
        color: boxShadow.color,
        offset: boxShadow.offset,
        blurRadius: boxShadow.blurRadius,
        spreadRadius: boxShadow.spreadRadius,
      );

  /// Creates a box shadow with the specified color.
  factory BoxShadowMix.color(Color value) {
    return BoxShadowMix(color: value);
  }

  /// Creates a box shadow with the specified offset.
  factory BoxShadowMix.offset(Offset value) {
    return BoxShadowMix(offset: value);
  }

  /// Creates a box shadow with the specified blur radius.
  factory BoxShadowMix.blurRadius(double value) {
    return BoxShadowMix(blurRadius: value);
  }

  /// Creates a box shadow with the specified spread radius.
  factory BoxShadowMix.spreadRadius(double value) {
    return BoxShadowMix(spreadRadius: value);
  }

  /// Creates a [BoxShadowMix] from a nullable [BoxShadow].
  ///
  /// Returns null if the input is null.
  static BoxShadowMix? maybeValue(BoxShadow? boxShadow) {
    return boxShadow != null ? BoxShadowMix.value(boxShadow) : null;
  }

  /// Creates a list of box shadows from Material Design elevation levels.
  static List<BoxShadowMix> fromElevation(ElevationShadow value) {
    return kElevationToShadow[value.elevation]!
        .map(BoxShadowMix.value)
        .toList();
  }

  /// Returns a copy with the specified color.
  BoxShadowMix color(Color value) {
    return merge(BoxShadowMix(color: value));
  }

  /// Returns a copy with the specified offset.
  BoxShadowMix offset(Offset value) {
    return merge(BoxShadowMix(offset: value));
  }

  /// Returns a copy with the specified blur radius.
  BoxShadowMix blurRadius(double value) {
    return merge(BoxShadowMix(blurRadius: value));
  }

  /// Returns a copy with the specified spread radius.
  BoxShadowMix spreadRadius(double value) {
    return merge(BoxShadowMix(spreadRadius: value));
  }

  /// Resolves to [BoxShadow] using the provided [BuildContext].
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

  /// Merges this box shadow with another, with other taking precedence.
  @override
  BoxShadowMix merge(BoxShadowMix? other) {
    if (other == null) return this;

    return BoxShadowMix.raw(
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

/// Material Design elevation levels for generating appropriate box shadows.
///
/// Provides predefined elevation values that correspond to Material Design shadow specifications.
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

  /// The elevation value in logical pixels.
  final int elevation;

  const ElevationShadow(this.elevation);
}

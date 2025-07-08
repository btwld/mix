// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

sealed class BaseShadowDto<T extends Shadow> extends Mixable<T> {
  // Properties use MixableProperty for cleaner merging
  final MixableProperty<Color> color;
  final MixableProperty<Offset> offset;
  final MixableProperty<double> blurRadius;

  const BaseShadowDto({
    required this.blurRadius,
    required this.color,
    required this.offset,
  });
}

/// Represents a [Mixable] Data transfer object of [Shadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [Shadow]
class ShadowDto extends BaseShadowDto<Shadow> with HasDefaultValue<Shadow> {
  // Main constructor accepts real values
  factory ShadowDto({double? blurRadius, Color? color, Offset? offset}) {
    return ShadowDto.raw(
      blurRadius: MixableProperty.prop(blurRadius),
      color: MixableProperty.prop(color),
      offset: MixableProperty.prop(offset),
    );
  }

  // Factory that accepts MixableProperty instances
  const ShadowDto.raw({
    required super.blurRadius,
    required super.color,
    required super.offset,
  });

  // Factory from Shadow
  factory ShadowDto.from(Shadow shadow) {
    return ShadowDto(
      blurRadius: shadow.blurRadius,
      color: shadow.color,
      offset: shadow.offset,
    );
  }

  /// Creates a ShadowDto from a nullable Shadow value
  /// Returns null if the value is null, otherwise uses ShadowDto.from
  static ShadowDto? maybeFrom(Shadow? value) {
    return value != null ? ShadowDto.from(value) : null;
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
  Shadow resolve(MixContext mix) {
    return Shadow(
      color: color.resolve(mix) ?? defaultValue.color,
      offset: offset.resolve(mix) ?? defaultValue.offset,
      blurRadius: blurRadius.resolve(mix) ?? defaultValue.blurRadius,
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

    return ShadowDto.raw(
      blurRadius: blurRadius.merge(other.blurRadius),
      color: color.merge(other.color),
      offset: offset.merge(other.offset),
    );
  }

  @override
  Shadow get defaultValue => const Shadow();

  /// The list of properties that constitute the state of this [ShadowDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ShadowDto] instances for equality.
  @override
  List<Object?> get props => [blurRadius, color, offset];
}

/// Represents a [Mixable] Data transfer object of [BoxShadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxShadow]
class BoxShadowDto extends BaseShadowDto<BoxShadow>
    with HasDefaultValue<BoxShadow> {
  final MixableProperty<double> spreadRadius;

  // Main constructor accepts real values
  factory BoxShadowDto({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return BoxShadowDto.raw(
      color: MixableProperty.prop(color),
      offset: MixableProperty.prop(offset),
      blurRadius: MixableProperty.prop(blurRadius),
      spreadRadius: MixableProperty.prop(spreadRadius),
    );
  }

  // Factory that accepts MixableProperty instances
  const BoxShadowDto.raw({
    required super.color,
    required super.offset,
    required super.blurRadius,
    required this.spreadRadius,
  });

  // Factory from BoxShadow
  factory BoxShadowDto.from(BoxShadow shadow) {
    return BoxShadowDto(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: shadow.spreadRadius,
    );
  }

  /// Creates a BoxShadowDto from a nullable BoxShadow value
  /// Returns null if the value is null, otherwise uses BoxShadowDto.from
  static BoxShadowDto? maybeFrom(BoxShadow? value) {
    return value != null ? BoxShadowDto.from(value) : null;
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
  BoxShadow resolve(MixContext mix) {
    return BoxShadow(
      color: color.resolve(mix) ?? defaultValue.color,
      offset: offset.resolve(mix) ?? defaultValue.offset,
      blurRadius: blurRadius.resolve(mix) ?? defaultValue.blurRadius,
      spreadRadius: spreadRadius.resolve(mix) ?? defaultValue.spreadRadius,
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

    return BoxShadowDto.raw(
      color: color.merge(other.color),
      offset: offset.merge(other.offset),
      blurRadius: blurRadius.merge(other.blurRadius),
      spreadRadius: spreadRadius.merge(other.spreadRadius),
    );
  }

  @override
  BoxShadow get defaultValue => const BoxShadow();

  /// The list of properties that constitute the state of this [BoxShadowDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxShadowDto] instances for equality.
  @override
  List<Object?> get props => [color, offset, blurRadius, spreadRadius];
}


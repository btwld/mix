// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

sealed class BaseShadowDto<T extends Shadow> extends Mix<T> {
  // Properties use MixableProperty for cleaner merging
  final MixValue<Color> color;
  final MixValue<Offset> offset;
  final MixValue<double> blurRadius;

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
  // Main constructor accepts Mix<T>? values
  factory ShadowDto({
    Mix<double>? blurRadius,
    Mix<Color>? color,
    Mix<Offset>? offset,
  }) {
    return ShadowDto._(
      blurRadius: MixValue(blurRadius),
      color: MixValue(color),
      offset: MixValue(offset),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const ShadowDto._({
    required super.blurRadius,
    required super.color,
    required super.offset,
  });

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

    return ShadowDto._(
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

/// Represents a [Mix] Data transfer object of [BoxShadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxShadow]
class BoxShadowDto extends BaseShadowDto<BoxShadow>
    with HasDefaultValue<BoxShadow> {
  final MixValue<double> spreadRadius;

  // Main constructor accepts Mix<T>? values
  factory BoxShadowDto({
    Mix<Color>? color,
    Mix<Offset>? offset,
    Mix<double>? blurRadius,
    Mix<double>? spreadRadius,
  }) {
    return BoxShadowDto._(
      color: MixValue(color),
      offset: MixValue(offset),
      blurRadius: MixValue(blurRadius),
      spreadRadius: MixValue(spreadRadius),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BoxShadowDto._({
    required super.color,
    required super.offset,
    required super.blurRadius,
    required this.spreadRadius,
  });

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

    return BoxShadowDto._(
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

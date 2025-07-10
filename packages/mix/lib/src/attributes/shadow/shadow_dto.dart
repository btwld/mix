// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

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
  // Main constructor accepts Mix<T>? values
  factory ShadowDto({double? blurRadius, Color? color, Offset? offset}) {
    return ShadowDto._(
      blurRadius: Prop.maybeValue(blurRadius),
      color: Prop.maybeValue(color),
      offset: Prop.maybeValue(offset),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const ShadowDto._({super.blurRadius, super.color, super.offset});

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
      color: resolveValue(mix, color) ?? defaultValue.color,
      offset: resolveValue(mix, offset) ?? defaultValue.offset,
      blurRadius: resolveValue(mix, blurRadius) ?? defaultValue.blurRadius,
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
      blurRadius: mergeValue(blurRadius, other.blurRadius),
      color: mergeValue(color, other.color),
      offset: mergeValue(offset, other.offset),
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
  final Prop<double>? spreadRadius;

  // Main constructor accepts Mix<T>? values
  factory BoxShadowDto({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    return BoxShadowDto._(
      color: Prop.maybeValue(color),
      offset: Prop.maybeValue(offset),
      blurRadius: Prop.maybeValue(blurRadius),
      spreadRadius: Prop.maybeValue(spreadRadius),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BoxShadowDto._({
    super.color,
    super.offset,
    super.blurRadius,
    this.spreadRadius,
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
      color: resolveValue(mix, color) ?? defaultValue.color,
      offset: resolveValue(mix, offset) ?? defaultValue.offset,
      blurRadius: resolveValue(mix, blurRadius) ?? defaultValue.blurRadius,
      spreadRadius:
          resolveValue(mix, spreadRadius) ?? defaultValue.spreadRadius,
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
      color: mergeValue(color, other.color),
      offset: mergeValue(offset, other.offset),
      blurRadius: mergeValue(blurRadius, other.blurRadius),
      spreadRadius: mergeValue(spreadRadius, other.spreadRadius),
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

// ignore_for_file: prefer_relative_imports, avoid-importing-entrypoint-exports

import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

sealed class ShadowDtoImpl<T extends Shadow> extends Mixable<T> {
  final Mixable<Color>? color;
  final Offset? offset;
  final double? blurRadius;

  const ShadowDtoImpl({this.blurRadius, this.color, this.offset});
}

/// Represents a [Mixable] Data transfer object of [Shadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a [Shadow]
class ShadowDto extends ShadowDtoImpl<Shadow>
    with HasDefaultValue<Shadow> {
  const ShadowDto({super.blurRadius, super.color, super.offset});

  @override
  Shadow get defaultValue => const Shadow();

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
      blurRadius: blurRadius ?? defaultValue.blurRadius,
      color: color?.resolve(mix) ?? defaultValue.color,
      offset: offset ?? defaultValue.offset,
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
      blurRadius: other.blurRadius ?? blurRadius,
      color: other.color ?? color,
      offset: other.offset ?? offset,
    );
  }

  /// The list of properties that constitute the state of this [ShadowDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ShadowDto] instances for equality.
  @override
  List<Object?> get props => [
        blurRadius,
        color,
        offset,
      ];
}

/// Represents a [Mixable] Data transfer object of [BoxShadow]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxShadow]
class BoxShadowDto extends ShadowDtoImpl<BoxShadow>
    with HasDefaultValue<BoxShadow> {
  final double? spreadRadius;

  const BoxShadowDto({
    super.color,
    super.offset,
    super.blurRadius,
    this.spreadRadius,
  });

  @override
  BoxShadow get defaultValue => const BoxShadow();

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
      color: color?.resolve(mix) ?? defaultValue.color,
      offset: offset ?? defaultValue.offset,
      blurRadius: blurRadius ?? defaultValue.blurRadius,
      spreadRadius: spreadRadius ?? defaultValue.spreadRadius,
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
      color: other.color ?? color,
      offset: other.offset ?? offset,
      blurRadius: other.blurRadius ?? blurRadius,
      spreadRadius: other.spreadRadius ?? spreadRadius,
    );
  }

  /// The list of properties that constitute the state of this [BoxShadowDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxShadowDto] instances for equality.
  @override
  List<Object?> get props => [
        color,
        offset,
        blurRadius,
        spreadRadius,
      ];
}

/// Extension methods to convert [Shadow] to [ShadowDto].
extension ShadowMixExt on Shadow {
  /// Converts this [Shadow] to a [ShadowDto].
  ShadowDto toDto() {
    return ShadowDto(
      blurRadius: blurRadius,
      color: Mixable.value(color),
      offset: offset,
    );
  }
}

/// Extension methods to convert List<[Shadow]> to List<[ShadowDto]>.
extension ListShadowMixExt on List<Shadow> {
  /// Converts this List<[Shadow]> to a List<[ShadowDto]>.
  List<ShadowDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

/// Extension methods to convert [BoxShadow] to [BoxShadowDto].
extension BoxShadowMixExt on BoxShadow {
  /// Converts this [BoxShadow] to a [BoxShadowDto].
  BoxShadowDto toDto() {
    return BoxShadowDto(
      color: Mixable.value(color),
      offset: offset,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );
  }
}

/// Extension methods to convert List<[BoxShadow]> to List<[BoxShadowDto]>.
extension ListBoxShadowMixExt on List<BoxShadow> {
  /// Converts this List<[BoxShadow]> to a List<[BoxShadowDto]>.
  List<BoxShadowDto> toDto() {
    return map((e) => e.toDto()).toList();
  }
}

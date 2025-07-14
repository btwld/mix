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
    return ShadowDto.props(
      blurRadius: Prop.maybeValue(blurRadius),
      color: Prop.maybeValue(color),
      offset: Prop.maybeValue(offset),
    );
  }

  /// Constructor that accepts a [Shadow] value and extracts its properties.
  ///
  /// This is useful for converting existing [Shadow] instances to [ShadowDto].
  ///
  /// ```dart
  /// const shadow = Shadow(color: Colors.black, blurRadius: 5.0);
  /// final dto = ShadowDto.value(shadow);
  /// ```
  factory ShadowDto.value(Shadow shadow) {
    return ShadowDto.props(
      blurRadius: Prop.value(shadow.blurRadius),
      color: Prop.value(shadow.color),
      offset: Prop.value(shadow.offset),
    );
  }

  /// Constructor that accepts Prop values directly
  const ShadowDto.props({super.blurRadius, super.color, super.offset});

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
  Shadow resolve(MixContext context) {
    return Shadow(
      color: resolveProp(context, color) ?? defaultValue.color,
      offset: resolveProp(context, offset) ?? defaultValue.offset,
      blurRadius: resolveProp(context, blurRadius) ?? defaultValue.blurRadius,
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

    return ShadowDto.props(
      blurRadius: mergeProp(blurRadius, other.blurRadius),
      color: mergeProp(color, other.color),
      offset: mergeProp(offset, other.offset),
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
    return BoxShadowDto.props(
      color: Prop.maybeValue(color),
      offset: Prop.maybeValue(offset),
      blurRadius: Prop.maybeValue(blurRadius),
      spreadRadius: Prop.maybeValue(spreadRadius),
    );
  }

  /// Constructor that accepts a [BoxShadow] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxShadow] instances to [BoxShadowDto].
  ///
  /// ```dart
  /// const boxShadow = BoxShadow(color: Colors.grey, blurRadius: 10.0);
  /// final dto = BoxShadowDto.value(boxShadow);
  /// ```
  factory BoxShadowDto.value(BoxShadow boxShadow) {
    return BoxShadowDto.props(
      color: Prop.value(boxShadow.color),
      offset: Prop.value(boxShadow.offset),
      blurRadius: Prop.value(boxShadow.blurRadius),
      spreadRadius: Prop.value(boxShadow.spreadRadius),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BoxShadowDto.props({
    super.color,
    super.offset,
    super.blurRadius,
    this.spreadRadius,
  });

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

  /// Resolves to [BoxShadow] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxShadow = BoxShadowDto(...).resolve(mix);
  /// ```
  @override
  BoxShadow resolve(MixContext context) {
    return BoxShadow(
      color: resolveProp(context, color) ?? defaultValue.color,
      offset: resolveProp(context, offset) ?? defaultValue.offset,
      blurRadius: resolveProp(context, blurRadius) ?? defaultValue.blurRadius,
      spreadRadius: resolveProp(context, spreadRadius) ?? defaultValue.spreadRadius,
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

    return BoxShadowDto.props(
      color: mergeProp(color, other.color),
      offset: mergeProp(offset, other.offset),
      blurRadius: mergeProp(blurRadius, other.blurRadius),
      spreadRadius: mergeProp(spreadRadius, other.spreadRadius),
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

// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/rendering.dart';
import 'package:mix/mix.dart';

sealed class ConstraintsDto<T extends Constraints> extends Mix<T> {
  const ConstraintsDto();
}

/// Represents a Data transfer object of [BoxConstraints]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxConstraints]
final class BoxConstraintsDto extends ConstraintsDto<BoxConstraints>
    with HasDefaultValue<BoxConstraints> {
  // Properties use MixableProperty for cleaner merging
  final Prop<double>? minWidth;
  final Prop<double>? maxWidth;
  final Prop<double>? minHeight;
  final Prop<double>? maxHeight;

  // Main constructor accepts raw values
  factory BoxConstraintsDto({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return BoxConstraintsDto.props(
      minWidth: Prop.maybeValue(minWidth),
      maxWidth: Prop.maybeValue(maxWidth),
      minHeight: Prop.maybeValue(minHeight),
      maxHeight: Prop.maybeValue(maxHeight),
    );
  }

  /// Constructor that accepts a [BoxConstraints] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxConstraints] instances to [BoxConstraintsDto].
  ///
  /// ```dart
  /// const constraints = BoxConstraints(maxWidth: 300, maxHeight: 200);
  /// final dto = BoxConstraintsDto.value(constraints);
  /// ```
  factory BoxConstraintsDto.value(BoxConstraints constraints) {
    return BoxConstraintsDto(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BoxConstraintsDto.props({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  /// Constructor that accepts a nullable [BoxConstraints] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxConstraintsDto.value].
  ///
  /// ```dart
  /// const BoxConstraints? constraints = BoxConstraints(maxWidth: 300, maxHeight: 200);
  /// final dto = BoxConstraintsDto.maybeValue(constraints); // Returns BoxConstraintsDto or null
  /// ```
  static BoxConstraintsDto? maybeValue(BoxConstraints? constraints) {
    return constraints != null ? BoxConstraintsDto.value(constraints) : null;
  }

  /// Resolves to [BoxConstraints] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final constraints = BoxConstraintsDto(...).resolve(mix);
  /// ```
  @override
  BoxConstraints resolve(MixContext context) {
    return BoxConstraints(
      minWidth: resolveProp(context, minWidth) ?? defaultValue.minWidth,
      maxWidth: resolveProp(context, maxWidth) ?? defaultValue.maxWidth,
      minHeight: resolveProp(context, minHeight) ?? defaultValue.minHeight,
      maxHeight: resolveProp(context, maxHeight) ?? defaultValue.maxHeight,
    );
  }

  /// Merges the properties of this [BoxConstraintsDto] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxConstraintsDto] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxConstraintsDto merge(BoxConstraintsDto? other) {
    if (other == null) return this;

    return BoxConstraintsDto.props(
      minWidth: mergeProp(minWidth, other.minWidth),
      maxWidth: mergeProp(maxWidth, other.maxWidth),
      minHeight: mergeProp(minHeight, other.minHeight),
      maxHeight: mergeProp(maxHeight, other.maxHeight),
    );
  }

  @override
  BoxConstraints get defaultValue => const BoxConstraints();

  /// The list of properties that constitute the state of this [BoxConstraintsDto].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxConstraintsDto] instances for equality.
  @override
  List<Object?> get props => [minWidth, maxWidth, minHeight, maxHeight];
}

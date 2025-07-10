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
    return BoxConstraintsDto._(
      minWidth: Prop.maybeValue(minWidth),
      maxWidth: Prop.maybeValue(maxWidth),
      minHeight: Prop.maybeValue(minHeight),
      maxHeight: Prop.maybeValue(maxHeight),
    );
  }

  // Private constructor that accepts MixableProperty instances
  const BoxConstraintsDto._({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  /// Resolves to [BoxConstraints] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final constraints = BoxConstraintsDto(...).resolve(mix);
  /// ```
  @override
  BoxConstraints resolve(MixContext mix) {
    return BoxConstraints(
      minWidth: resolveProp(mix, minWidth) ?? defaultValue.minWidth,
      maxWidth: resolveProp(mix, maxWidth) ?? defaultValue.maxWidth,
      minHeight: resolveProp(mix, minHeight) ?? defaultValue.minHeight,
      maxHeight: resolveProp(mix, maxHeight) ?? defaultValue.maxHeight,
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

    return BoxConstraintsDto._(
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

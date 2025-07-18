// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../../internal/compare_mixin.dart';

sealed class ConstraintsDto<T extends Constraints> extends Mix<T>
    with EqualityMixin {
  const ConstraintsDto();

  @override
  T resolve(BuildContext context);

  @override
  ConstraintsDto<T> merge(covariant ConstraintsDto<T>? other);
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
  BoxConstraints resolve(BuildContext context) {
    return BoxConstraints(
      minWidth: MixHelpers.resolve(context, minWidth) ?? defaultValue.minWidth,
      maxWidth: MixHelpers.resolve(context, maxWidth) ?? defaultValue.maxWidth,
      minHeight:
          MixHelpers.resolve(context, minHeight) ?? defaultValue.minHeight,
      maxHeight:
          MixHelpers.resolve(context, maxHeight) ?? defaultValue.maxHeight,
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
      minWidth: MixHelpers.merge(minWidth, other.minWidth),
      maxWidth: MixHelpers.merge(maxWidth, other.maxWidth),
      minHeight: MixHelpers.merge(minHeight, other.minHeight),
      maxHeight: MixHelpers.merge(maxHeight, other.maxHeight),
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

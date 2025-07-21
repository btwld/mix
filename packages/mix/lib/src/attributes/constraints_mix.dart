// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

sealed class ConstraintsMix<T extends Constraints> extends Mix<T> {
  const ConstraintsMix();

  @override
  T resolve(BuildContext context);

  @override
  ConstraintsMix<T> merge(covariant ConstraintsMix<T>? other);
}

/// Represents a Data transfer object of [BoxConstraints]
///
/// This is used to allow for resolvable value tokens, and also the correct
/// merge and combining behavior. It allows to be merged, and resolved to a `[BoxConstraints]
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with MixDefaultValue<BoxConstraints> {
  // Properties use MixableProperty for cleaner merging
  final Prop<double>? minWidth;
  final Prop<double>? maxWidth;
  final Prop<double>? minHeight;
  final Prop<double>? maxHeight;

  BoxConstraintsMix.only({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) : this(
         minWidth: Prop.maybe(minWidth),
         maxWidth: Prop.maybe(maxWidth),
         minHeight: Prop.maybe(minHeight),
         maxHeight: Prop.maybe(maxHeight),
       );

  const BoxConstraintsMix({
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
  });

  BoxConstraintsMix.minWidth(double minWidth) : this.only(minWidth: minWidth);

  BoxConstraintsMix.maxWidth(double maxWidth) : this.only(maxWidth: maxWidth);

  BoxConstraintsMix.minHeight(double minHeight)
    : this.only(minHeight: minHeight);

  BoxConstraintsMix.maxHeight(double maxHeight)
    : this.only(maxHeight: maxHeight);

  /// Constructor that accepts a [BoxConstraints] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxConstraints] instances to [BoxConstraintsMix].
  ///
  /// ```dart
  /// const constraints = BoxConstraints(maxWidth: 300, maxHeight: 200);
  /// final dto = BoxConstraintsMix.value(constraints);
  /// ```
  BoxConstraintsMix.value(BoxConstraints constraints)
    : this.only(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
        minHeight: constraints.minHeight,
        maxHeight: constraints.maxHeight,
      );

  /// Constructor that accepts a nullable [BoxConstraints] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxConstraintsMix.value].
  ///
  /// ```dart
  /// const BoxConstraints? constraints = BoxConstraints(maxWidth: 300, maxHeight: 200);
  /// final dto = BoxConstraintsMix.maybeValue(constraints); // Returns BoxConstraintsMix or null
  /// ```
  static BoxConstraintsMix? maybeValue(BoxConstraints? constraints) {
    return constraints != null ? BoxConstraintsMix.value(constraints) : null;
  }

  /// Resolves to [BoxConstraints] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final constraints = BoxConstraintsMix(...).resolve(mix);
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

  /// Merges the properties of this [BoxConstraintsMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxConstraintsMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxConstraintsMix merge(BoxConstraintsMix? other) {
    if (other == null) return this;

    return BoxConstraintsMix(
      minWidth: MixHelpers.merge(minWidth, other.minWidth),
      maxWidth: MixHelpers.merge(maxWidth, other.maxWidth),
      minHeight: MixHelpers.merge(minHeight, other.minHeight),
      maxHeight: MixHelpers.merge(maxHeight, other.maxHeight),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BoxConstraintsMix &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.minHeight == minHeight &&
        other.maxHeight == maxHeight;
  }

  @override
  BoxConstraints get defaultValue => const BoxConstraints();

  @override
  int get hashCode {
    return minWidth.hashCode ^
        maxWidth.hashCode ^
        minHeight.hashCode ^
        maxHeight.hashCode;
  }
}

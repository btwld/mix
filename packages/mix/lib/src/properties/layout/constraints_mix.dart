// ignore_for_file: prefer_relative_imports,avoid-importing-entrypoint-exports
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Base class for Mix-compatible constraint styling that wraps Flutter's [Constraints] types.
///
/// Provides common functionality for different constraint types with factory methods
/// for common sizing operations like width, height, and size constraints.
sealed class ConstraintsMix<T extends Constraints> extends Mix<T> {
  const ConstraintsMix();

  /// Creates box constraints with the specified minimum width.
  static BoxConstraintsMix minWidth(double value) {
    return BoxConstraintsMix.only(minWidth: value);
  }

  /// Creates box constraints with the specified maximum width.
  static BoxConstraintsMix maxWidth(double value) {
    return BoxConstraintsMix.only(maxWidth: value);
  }

  /// Creates box constraints with the specified minimum height.
  static BoxConstraintsMix minHeight(double value) {
    return BoxConstraintsMix.only(minHeight: value);
  }

  /// Creates box constraints with the specified maximum height.
  static BoxConstraintsMix maxHeight(double value) {
    return BoxConstraintsMix.only(maxHeight: value);
  }

  /// Creates box constraints with fixed width (min and max width equal).
  static BoxConstraintsMix width(double value) {
    return BoxConstraintsMix.width(value);
  }

  /// Creates box constraints with fixed height (min and max height equal).
  static BoxConstraintsMix height(double value) {
    return BoxConstraintsMix.height(value);
  }

  /// Creates box constraints with fixed size (both width and height constrained).
  static BoxConstraintsMix size(Size value) {
    return BoxConstraintsMix.size(value);
  }

  @override
  T resolve(BuildContext context);

  @override
  ConstraintsMix<T> merge(covariant ConstraintsMix<T>? other);
}

/// Mix-compatible representation of Flutter's [BoxConstraints] with token support.
///
/// Allows setting minimum and maximum width and height constraints with
/// merging capabilities and resolvable values.
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with DefaultValue<BoxConstraints> {
  final Prop<double>? $minWidth;
  final Prop<double>? $maxWidth;
  final Prop<double>? $minHeight;
  final Prop<double>? $maxHeight;

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
    Prop<double>? minWidth,
    Prop<double>? maxWidth,
    Prop<double>? minHeight,
    Prop<double>? maxHeight,
  }) : $minWidth = minWidth,
       $maxWidth = maxWidth,
       $minHeight = minHeight,
       $maxHeight = maxHeight;

  /// Creates constraints with fixed height (min and max height equal).
  BoxConstraintsMix.height(double height)
    : this.only(minHeight: height, maxHeight: height);

  /// Creates constraints with fixed width (min and max width equal).
  BoxConstraintsMix.width(double width)
    : this.only(minWidth: width, maxWidth: width);

  /// Creates constraints with fixed size (both width and height constrained).
  BoxConstraintsMix.size(Size size)
    : this.only(
        minWidth: size.width,
        maxWidth: size.width,
        minHeight: size.height,
        maxHeight: size.height,
      );

  /// Creates constraints with only minimum width specified.
  BoxConstraintsMix.minWidth(double minWidth) : this.only(minWidth: minWidth);

  /// Creates constraints with only maximum width specified.
  BoxConstraintsMix.maxWidth(double maxWidth) : this.only(maxWidth: maxWidth);

  /// Creates constraints with only minimum height specified.
  BoxConstraintsMix.minHeight(double minHeight)
    : this.only(minHeight: minHeight);

  /// Creates constraints with only maximum height specified.
  BoxConstraintsMix.maxHeight(double maxHeight)
    : this.only(maxHeight: maxHeight);

  /// Creates a [BoxConstraintsMix] from an existing [BoxConstraints].
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

  /// Creates a [BoxConstraintsMix] from a nullable [BoxConstraints].
  ///
  /// Returns null if the input is null.
  ///
  /// ```dart
  /// const BoxConstraints? constraints = BoxConstraints(maxWidth: 300, maxHeight: 200);
  /// final dto = BoxConstraintsMix.maybeValue(constraints); // Returns BoxConstraintsMix or null
  /// ```
  static BoxConstraintsMix? maybeValue(BoxConstraints? constraints) {
    return constraints != null ? BoxConstraintsMix.value(constraints) : null;
  }

  /// Returns a copy with fixed height (min and max height equal).
  BoxConstraintsMix height(double height) {
    return BoxConstraintsMix.only(minHeight: height, maxHeight: height);
  }

  /// Returns a copy with fixed width (min and max width equal).
  BoxConstraintsMix width(double width) {
    return BoxConstraintsMix.only(minWidth: width, maxWidth: width);
  }

  /// Returns a copy with the specified minimum width.
  BoxConstraintsMix minWidth(double value) {
    return merge(BoxConstraintsMix.only(minWidth: value));
  }

  /// Returns a copy with the specified maximum width.
  BoxConstraintsMix maxWidth(double value) {
    return merge(BoxConstraintsMix.only(maxWidth: value));
  }

  /// Returns a copy with the specified minimum height.
  BoxConstraintsMix minHeight(double value) {
    return merge(BoxConstraintsMix.only(minHeight: value));
  }

  /// Returns a copy with the specified maximum height.
  BoxConstraintsMix maxHeight(double value) {
    return merge(BoxConstraintsMix.only(maxHeight: value));
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
      minWidth: MixHelpers.resolve(context, $minWidth) ?? defaultValue.minWidth,
      maxWidth: MixHelpers.resolve(context, $maxWidth) ?? defaultValue.maxWidth,
      minHeight:
          MixHelpers.resolve(context, $minHeight) ?? defaultValue.minHeight,
      maxHeight:
          MixHelpers.resolve(context, $maxHeight) ?? defaultValue.maxHeight,
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
      minWidth: MixHelpers.merge($minWidth, other.$minWidth),
      maxWidth: MixHelpers.merge($maxWidth, other.$maxWidth),
      minHeight: MixHelpers.merge($minHeight, other.$minHeight),
      maxHeight: MixHelpers.merge($maxHeight, other.$maxHeight),
    );
  }

  @override
  List<Object?> get props => [$minWidth, $maxWidth, $minHeight, $maxHeight];

  @override
  BoxConstraints get defaultValue => const BoxConstraints();
}

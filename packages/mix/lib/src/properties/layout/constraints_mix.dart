import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';

/// Base class for Mix constraint types.
/// 
/// Provides factory methods for common sizing operations.
sealed class ConstraintsMix<T extends Constraints> extends Mix<T> {
  const ConstraintsMix.create();

  /// Creates constraints with minimum width.
  static BoxConstraintsMix minWidth(double value) {
    return BoxConstraintsMix(minWidth: value);
  }

  /// Creates constraints with maximum width.
  static BoxConstraintsMix maxWidth(double value) {
    return BoxConstraintsMix(maxWidth: value);
  }

  /// Creates constraints with minimum height.
  static BoxConstraintsMix minHeight(double value) {
    return BoxConstraintsMix(minHeight: value);
  }

  /// Creates constraints with maximum height.
  static BoxConstraintsMix maxHeight(double value) {
    return BoxConstraintsMix(maxHeight: value);
  }

  /// Creates constraints with fixed width.
  static BoxConstraintsMix width(double value) {
    return BoxConstraintsMix.width(value);
  }

  /// Creates constraints with fixed height.
  static BoxConstraintsMix height(double value) {
    return BoxConstraintsMix.height(value);
  }

  /// Creates constraints with fixed size.
  static BoxConstraintsMix size(Size value) {
    return BoxConstraintsMix.size(value);
  }

  @override
  T resolve(BuildContext context);

  @override
  ConstraintsMix<T> merge(covariant ConstraintsMix<T>? other);
}

/// Mix representation of [BoxConstraints].
/// 
/// Supports tokens and merging for constraint values.
final class BoxConstraintsMix extends ConstraintsMix<BoxConstraints>
    with DefaultValue<BoxConstraints> {
  final Prop<double>? $minWidth;
  final Prop<double>? $maxWidth;
  final Prop<double>? $minHeight;
  final Prop<double>? $maxHeight;

  BoxConstraintsMix({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) : this.create(
         minWidth: Prop.maybe(minWidth),
         maxWidth: Prop.maybe(maxWidth),
         minHeight: Prop.maybe(minHeight),
         maxHeight: Prop.maybe(maxHeight),
       );

  const BoxConstraintsMix.create({
    Prop<double>? minWidth,
    Prop<double>? maxWidth,
    Prop<double>? minHeight,
    Prop<double>? maxHeight,
  }) : $minWidth = minWidth,
       $maxWidth = maxWidth,
       $minHeight = minHeight,
       $maxHeight = maxHeight,
       super.create();

  /// Fixed height constraint.
  factory BoxConstraintsMix.height(double value) {
    return BoxConstraintsMix(minHeight: value, maxHeight: value);
  }

  /// Fixed width constraint.
  factory BoxConstraintsMix.width(double value) {
    return BoxConstraintsMix(minWidth: value, maxWidth: value);
  }

  /// Fixed size constraint.
  factory BoxConstraintsMix.size(Size value) {
    return BoxConstraintsMix(
      minWidth: value.width,
      maxWidth: value.width,
      minHeight: value.height,
      maxHeight: value.height,
    );
  }

  /// Minimum width constraint.
  factory BoxConstraintsMix.minWidth(double value) {
    return BoxConstraintsMix(minWidth: value);
  }

  /// Maximum width constraint.
  factory BoxConstraintsMix.maxWidth(double value) {
    return BoxConstraintsMix(maxWidth: value);
  }

  /// Minimum height constraint.
  factory BoxConstraintsMix.minHeight(double value) {
    return BoxConstraintsMix(minHeight: value);
  }

  /// Maximum height constraint.
  factory BoxConstraintsMix.maxHeight(double value) {
    return BoxConstraintsMix(maxHeight: value);
  }

  /// Creates from existing [BoxConstraints].
  BoxConstraintsMix.value(BoxConstraints constraints)
    : this(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
        minHeight: constraints.minHeight,
        maxHeight: constraints.maxHeight,
      );

  /// Creates from nullable [BoxConstraints].
  static BoxConstraintsMix? maybeValue(BoxConstraints? constraints) {
    return constraints != null ? BoxConstraintsMix.value(constraints) : null;
  }

  /// Copy with fixed height.
  BoxConstraintsMix height(double height) {
    return merge(BoxConstraintsMix.height(height));
  }

  /// Copy with fixed width.
  BoxConstraintsMix width(double width) {
    return merge(BoxConstraintsMix.width(width));
  }

  /// Copy with minimum width.
  BoxConstraintsMix minWidth(double value) {
    return merge(BoxConstraintsMix.minWidth(value));
  }

  /// Copy with maximum width.
  BoxConstraintsMix maxWidth(double value) {
    return merge(BoxConstraintsMix.maxWidth(value));
  }

  /// Copy with minimum height.
  BoxConstraintsMix minHeight(double value) {
    return merge(BoxConstraintsMix.minHeight(value));
  }

  /// Copy with maximum height.
  BoxConstraintsMix maxHeight(double value) {
    return merge(BoxConstraintsMix.maxHeight(value));
  }

  /// Resolves to [BoxConstraints] using context.
  @override
  BoxConstraints resolve(BuildContext context) {
    return BoxConstraints(
      minWidth: MixOps.resolve(context, $minWidth) ?? defaultValue.minWidth,
      maxWidth: MixOps.resolve(context, $maxWidth) ?? defaultValue.maxWidth,
      minHeight: MixOps.resolve(context, $minHeight) ?? defaultValue.minHeight,
      maxHeight: MixOps.resolve(context, $maxHeight) ?? defaultValue.maxHeight,
    );
  }

  /// Merges with another [BoxConstraintsMix].
  @override
  BoxConstraintsMix merge(BoxConstraintsMix? other) {
    if (other == null) return this;

    return BoxConstraintsMix.create(
      minWidth: MixOps.merge($minWidth, other.$minWidth),
      maxWidth: MixOps.merge($maxWidth, other.$maxWidth),
      minHeight: MixOps.merge($minHeight, other.$minHeight),
      maxHeight: MixOps.merge($maxHeight, other.$maxHeight),
    );
  }

  @override
  List<Object?> get props => [$minWidth, $maxWidth, $minHeight, $maxHeight];

  @override
  BoxConstraints get defaultValue => const BoxConstraints();
}

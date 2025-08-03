import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/style.dart';

/// Decorator that forces its child to be exactly as tall as its intrinsic height.
///
/// Wraps the child in an [IntrinsicHeight] widget.
final class IntrinsicHeightWidgetDecorator
    extends WidgetDecorator<IntrinsicHeightWidgetDecorator> {
  const IntrinsicHeightWidgetDecorator();

  @override
  IntrinsicHeightWidgetDecorator copyWith() {
    return const IntrinsicHeightWidgetDecorator();
  }

  @override
  IntrinsicHeightWidgetDecorator lerp(
    IntrinsicHeightWidgetDecorator? other,
    double t,
  ) {
    if (other == null) return this;

    return const IntrinsicHeightWidgetDecorator();
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicHeight(child: child);
  }
}

/// Decorator that forces its child to be exactly as wide as its intrinsic width.
///
/// Wraps the child in an [IntrinsicWidth] widget.
final class IntrinsicWidthWidgetDecorator
    extends WidgetDecorator<IntrinsicWidthWidgetDecorator> {
  const IntrinsicWidthWidgetDecorator();

  @override
  IntrinsicWidthWidgetDecorator copyWith() {
    return const IntrinsicWidthWidgetDecorator();
  }

  @override
  IntrinsicWidthWidgetDecorator lerp(
    IntrinsicWidthWidgetDecorator? other,
    double t,
  ) {
    if (other == null) return this;

    return const IntrinsicWidthWidgetDecorator();
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicWidth(child: child);
  }
}

/// Represents the attributes of a [IntrinsicHeightWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicHeightWidgetDecorator].
///
/// Use this class to configure the attributes of a [IntrinsicHeightWidgetDecorator] and pass it to
/// the [IntrinsicHeightWidgetDecorator] constructor.
class IntrinsicHeightWidgetDecoratorMix
    extends WidgetDecoratorMix<IntrinsicHeightWidgetDecorator> {
  const IntrinsicHeightWidgetDecoratorMix();

  /// Resolves to [IntrinsicHeightWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicHeightDecorator = IntrinsicHeightWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  IntrinsicHeightWidgetDecorator resolve(BuildContext context) {
    return const IntrinsicHeightWidgetDecorator();
  }

  /// Merges the properties of this [IntrinsicHeightWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicHeightWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicHeightWidgetDecoratorMix merge(
    IntrinsicHeightWidgetDecoratorMix? other,
  ) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightWidgetDecoratorMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightWidgetDecoratorMix] instances for equality.
  @override
  List<Object?> get props => [];
}

/// Represents the attributes of a [IntrinsicWidthWidgetDecorator].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicWidthWidgetDecorator].
///
/// Use this class to configure the attributes of a [IntrinsicWidthWidgetDecorator] and pass it to
/// the [IntrinsicWidthWidgetDecorator] constructor.
class IntrinsicWidthWidgetDecoratorMix
    extends WidgetDecoratorMix<IntrinsicWidthWidgetDecorator> {
  const IntrinsicWidthWidgetDecoratorMix();

  /// Resolves to [IntrinsicWidthWidgetDecorator] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicWidthDecorator = IntrinsicWidthWidgetDecoratorMix(...).resolve(mix);
  /// ```
  @override
  IntrinsicWidthWidgetDecorator resolve(BuildContext context) {
    return const IntrinsicWidthWidgetDecorator();
  }

  /// Merges the properties of this [IntrinsicWidthWidgetDecoratorMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicWidthWidgetDecoratorMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicWidthWidgetDecoratorMix merge(
    IntrinsicWidthWidgetDecoratorMix? other,
  ) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthWidgetDecoratorMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthWidgetDecoratorMix] instances for equality.
  @override
  List<Object?> get props => [];
}

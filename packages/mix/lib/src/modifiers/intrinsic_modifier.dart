import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/style.dart';

/// Modifier that forces its child to be exactly as tall as its intrinsic height.
///
/// Wraps the child in an [IntrinsicHeight] widget.
final class IntrinsicHeightWidgetModifier
    extends Modifier<IntrinsicHeightWidgetModifier> {
  const IntrinsicHeightWidgetModifier();

  @override
  IntrinsicHeightWidgetModifier copyWith() {
    return const IntrinsicHeightWidgetModifier();
  }

  @override
  IntrinsicHeightWidgetModifier lerp(
    IntrinsicHeightWidgetModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return const IntrinsicHeightWidgetModifier();
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicHeight(child: child);
  }
}

/// Modifier that forces its child to be exactly as wide as its intrinsic width.
///
/// Wraps the child in an [IntrinsicWidth] widget.
final class IntrinsicWidthWidgetModifier
    extends Modifier<IntrinsicWidthWidgetModifier> {
  const IntrinsicWidthWidgetModifier();

  @override
  IntrinsicWidthWidgetModifier copyWith() {
    return const IntrinsicWidthWidgetModifier();
  }

  @override
  IntrinsicWidthWidgetModifier lerp(
    IntrinsicWidthWidgetModifier? other,
    double t,
  ) {
    if (other == null) return this;

    return const IntrinsicWidthWidgetModifier();
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicWidth(child: child);
  }
}

/// Represents the attributes of a [IntrinsicHeightWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicHeightWidgetModifier].
///
/// Use this class to configure the attributes of a [IntrinsicHeightWidgetModifier] and pass it to
/// the [IntrinsicHeightWidgetModifier] constructor.
class IntrinsicHeightWidgetModifierMix
    extends WidgetModifierMix<IntrinsicHeightWidgetModifier> {
  const IntrinsicHeightWidgetModifierMix();

  /// Resolves to [IntrinsicHeightWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicHeightWidgetModifier = IntrinsicHeightWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  IntrinsicHeightWidgetModifier resolve(BuildContext context) {
    return const IntrinsicHeightWidgetModifier();
  }

  /// Merges the properties of this [IntrinsicHeightWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicHeightWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicHeightWidgetModifierMix merge(
    IntrinsicHeightWidgetModifierMix? other,
  ) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightWidgetModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightWidgetModifierMix] instances for equality.
  @override
  List<Object?> get props => [];
}

/// Represents the attributes of a [IntrinsicWidthWidgetModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicWidthWidgetModifier].
///
/// Use this class to configure the attributes of a [IntrinsicWidthWidgetModifier] and pass it to
/// the [IntrinsicWidthWidgetModifier] constructor.
class IntrinsicWidthWidgetModifierMix
    extends WidgetModifierMix<IntrinsicWidthWidgetModifier> {
  const IntrinsicWidthWidgetModifierMix();

  /// Resolves to [IntrinsicWidthWidgetModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicWidthWidgetModifier = IntrinsicWidthWidgetModifierMix(...).resolve(mix);
  /// ```
  @override
  IntrinsicWidthWidgetModifier resolve(BuildContext context) {
    return const IntrinsicWidthWidgetModifier();
  }

  /// Merges the properties of this [IntrinsicWidthWidgetModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicWidthWidgetModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicWidthWidgetModifierMix merge(
    IntrinsicWidthWidgetModifierMix? other,
  ) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthWidgetModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthWidgetModifierMix] instances for equality.
  @override
  List<Object?> get props => [];
}

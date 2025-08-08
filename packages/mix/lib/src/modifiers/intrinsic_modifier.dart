import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/style.dart';

/// Modifier that forces its child to be exactly as tall as its intrinsic height.
///
/// Wraps the child in an [IntrinsicHeight] widget.
final class IntrinsicHeightModifier extends Modifier<IntrinsicHeightModifier> {
  const IntrinsicHeightModifier();

  @override
  IntrinsicHeightModifier copyWith() {
    return const IntrinsicHeightModifier();
  }

  @override
  IntrinsicHeightModifier lerp(IntrinsicHeightModifier? other, double t) {
    if (other == null) return this;

    return const IntrinsicHeightModifier();
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
final class IntrinsicWidthModifier extends Modifier<IntrinsicWidthModifier> {
  const IntrinsicWidthModifier();

  @override
  IntrinsicWidthModifier copyWith() {
    return const IntrinsicWidthModifier();
  }

  @override
  IntrinsicWidthModifier lerp(IntrinsicWidthModifier? other, double t) {
    if (other == null) return this;

    return const IntrinsicWidthModifier();
  }

  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicWidth(child: child);
  }
}

/// Represents the attributes of a [IntrinsicHeightModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicHeightModifier].
///
/// Use this class to configure the attributes of a [IntrinsicHeightModifier] and pass it to
/// the [IntrinsicHeightModifier] constructor.
class IntrinsicHeightModifierMix extends ModifierMix<IntrinsicHeightModifier> {
  const IntrinsicHeightModifierMix();

  /// Resolves to [IntrinsicHeightModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicHeightModifier = IntrinsicHeightModifierMix(...).resolve(mix);
  /// ```
  @override
  IntrinsicHeightModifier resolve(BuildContext context) {
    return const IntrinsicHeightModifier();
  }

  /// Merges the properties of this [IntrinsicHeightModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicHeightModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicHeightModifierMix merge(IntrinsicHeightModifierMix? other) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightModifierMix] instances for equality.
  @override
  List<Object?> get props => [];
}

/// Represents the attributes of a [IntrinsicWidthModifier].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicWidthModifier].
///
/// Use this class to configure the attributes of a [IntrinsicWidthModifier] and pass it to
/// the [IntrinsicWidthModifier] constructor.
class IntrinsicWidthModifierMix extends ModifierMix<IntrinsicWidthModifier> {
  const IntrinsicWidthModifierMix();

  /// Resolves to [IntrinsicWidthModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicWidthModifier = IntrinsicWidthModifierMix(...).resolve(mix);
  /// ```
  @override
  IntrinsicWidthModifier resolve(BuildContext context) {
    return const IntrinsicWidthModifier();
  }

  /// Merges the properties of this [IntrinsicWidthModifierMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicWidthModifierMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicWidthModifierMix merge(IntrinsicWidthModifierMix? other) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthModifierMix].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthModifierMix] instances for equality.
  @override
  List<Object?> get props => [];
}

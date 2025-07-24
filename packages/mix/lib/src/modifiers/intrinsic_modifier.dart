// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/widgets.dart';

import '../core/modifier.dart';
import '../core/style.dart';

final class IntrinsicHeightModifier extends Modifier<IntrinsicHeightModifier> {
  const IntrinsicHeightModifier();

  /// Creates a copy of this [IntrinsicHeightModifier] but with the given fields
  /// replaced with the new values.
  @override
  IntrinsicHeightModifier copyWith() {
    return const IntrinsicHeightModifier();
  }

  /// Linearly interpolates between this [IntrinsicHeightModifier] and another [IntrinsicHeightModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IntrinsicHeightModifier] is returned. When [t] is 1.0, the [other] [IntrinsicHeightModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IntrinsicHeightModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [IntrinsicHeightModifier] instance.
  ///
  /// The interpolation is performed on each property of the [IntrinsicHeightModifier] using the appropriate
  /// interpolation method:

  /// This method is typically used in animations to smoothly transition between
  /// different [IntrinsicHeightModifier] configurations.
  @override
  IntrinsicHeightModifier lerp(IntrinsicHeightModifier? other, double t) {
    if (other == null) return this;

    return const IntrinsicHeightModifier();
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightModifier] instances for equality.
  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicHeight(child: child);
  }
}

final class IntrinsicWidthModifier extends Modifier<IntrinsicWidthModifier> {
  const IntrinsicWidthModifier();

  /// Creates a copy of this [IntrinsicWidthModifier] but with the given fields
  /// replaced with the new values.
  @override
  IntrinsicWidthModifier copyWith() {
    return const IntrinsicWidthModifier();
  }

  /// Linearly interpolates between this [IntrinsicWidthModifier] and another [IntrinsicWidthModifier] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IntrinsicWidthModifier] is returned. When [t] is 1.0, the [other] [IntrinsicWidthModifier] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IntrinsicWidthModifier] is returned.
  ///
  /// If [other] is null, this method returns the current [IntrinsicWidthModifier] instance.
  ///
  /// The interpolation is performed on each property of the [IntrinsicWidthModifier] using the appropriate
  /// interpolation method:

  /// This method is typically used in animations to smoothly transition between
  /// different [IntrinsicWidthModifier] configurations.
  @override
  IntrinsicWidthModifier lerp(IntrinsicWidthModifier? other, double t) {
    if (other == null) return this;

    return const IntrinsicWidthModifier();
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthModifier].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthModifier] instances for equality.
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
class IntrinsicHeightModifierAttribute
    extends ModifierAttribute<IntrinsicHeightModifier> {
  const IntrinsicHeightModifierAttribute();

  /// Resolves to [IntrinsicHeightModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicHeightModifierSpec = IntrinsicHeightModifierAttribute(...).resolve(mix);
  /// ```
  @override
  IntrinsicHeightModifier resolve(BuildContext context) {
    // ignore: prefer_const_constructors
    return IntrinsicHeightModifier();
  }

  /// Merges the properties of this [IntrinsicHeightModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicHeightModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicHeightModifierAttribute merge(
    IntrinsicHeightModifierAttribute? other,
  ) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightModifierAttribute] instances for equality.
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
class IntrinsicWidthModifierAttribute
    extends ModifierAttribute<IntrinsicWidthModifier> {
  const IntrinsicWidthModifierAttribute();

  /// Resolves to [IntrinsicWidthModifier] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicWidthModifierSpec = IntrinsicWidthModifierAttribute(...).resolve(mix);
  /// ```
  @override
  IntrinsicWidthModifier resolve(BuildContext context) {
    // ignore: prefer_const_constructors
    return IntrinsicWidthModifier();
  }

  /// Merges the properties of this [IntrinsicWidthModifierAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicWidthModifierAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicWidthModifierAttribute merge(
    IntrinsicWidthModifierAttribute? other,
  ) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthModifierAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthModifierAttribute] instances for equality.
  @override
  List<Object?> get props => [];
}

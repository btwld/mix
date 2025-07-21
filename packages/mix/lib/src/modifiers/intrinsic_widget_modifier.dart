// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/widgets.dart';

import '../core/attribute.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

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

final class IntrinsicWidthModifierSpec
    extends Modifier<IntrinsicWidthModifierSpec> {
  const IntrinsicWidthModifierSpec();

  /// Creates a copy of this [IntrinsicWidthModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  IntrinsicWidthModifierSpec copyWith() {
    return const IntrinsicWidthModifierSpec();
  }

  /// Linearly interpolates between this [IntrinsicWidthModifierSpec] and another [IntrinsicWidthModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IntrinsicWidthModifierSpec] is returned. When [t] is 1.0, the [other] [IntrinsicWidthModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IntrinsicWidthModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [IntrinsicWidthModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [IntrinsicWidthModifierSpec] using the appropriate
  /// interpolation method:

  /// This method is typically used in animations to smoothly transition between
  /// different [IntrinsicWidthModifierSpec] configurations.
  @override
  IntrinsicWidthModifierSpec lerp(IntrinsicWidthModifierSpec? other, double t) {
    if (other == null) return this;

    return const IntrinsicWidthModifierSpec();
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthModifierSpec] instances for equality.
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

/// A tween that interpolates between two [IntrinsicHeightModifier] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IntrinsicHeightModifier] specifications.
class IntrinsicHeightModifierSpecTween extends Tween<IntrinsicHeightModifier?> {
  IntrinsicHeightModifierSpecTween({super.begin, super.end});

  @override
  IntrinsicHeightModifier lerp(double t) {
    if (begin == null && end == null) {
      return const IntrinsicHeightModifier();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

/// Represents the attributes of a [IntrinsicWidthModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicWidthModifierSpec].
///
/// Use this class to configure the attributes of a [IntrinsicWidthModifierSpec] and pass it to
/// the [IntrinsicWidthModifierSpec] constructor.
class IntrinsicWidthModifierAttribute
    extends ModifierAttribute<IntrinsicWidthModifierSpec> {
  const IntrinsicWidthModifierAttribute();

  /// Resolves to [IntrinsicWidthModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicWidthModifierSpec = IntrinsicWidthModifierAttribute(...).resolve(mix);
  /// ```
  @override
  IntrinsicWidthModifierSpec resolve(BuildContext context) {
    // ignore: prefer_const_constructors
    return IntrinsicWidthModifierSpec();
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

/// A tween that interpolates between two [IntrinsicWidthModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IntrinsicWidthModifierSpec] specifications.
class IntrinsicWidthModifierSpecTween
    extends Tween<IntrinsicWidthModifierSpec?> {
  IntrinsicWidthModifierSpecTween({super.begin, super.end});

  @override
  IntrinsicWidthModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const IntrinsicWidthModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

final class IntrinsicHeightModifierUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, IntrinsicHeightModifierAttribute> {
  const IntrinsicHeightModifierUtility(super.builder);
  T call() => builder(const IntrinsicHeightModifierAttribute());
}

final class IntrinsicWidthModifierUtility<T extends SpecAttribute<Object?>>
    extends MixUtility<T, IntrinsicWidthModifierAttribute> {
  const IntrinsicWidthModifierUtility(super.builder);
  T call() => builder(const IntrinsicWidthModifierAttribute());
}

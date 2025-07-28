
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
class IntrinsicHeightModifierAttribute
    extends ModifierAttribute<IntrinsicHeightModifier> {
  const IntrinsicHeightModifierAttribute();

  /// Resolves to [IntrinsicHeightModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
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

  /// Resolves to [IntrinsicWidthModifier] using the provided [BuildContext].
  ///
  /// If a property is null in the [BuildContext], it falls back to the
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

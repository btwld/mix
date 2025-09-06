// ignore_for_file: prefer-named-boolean-parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../core/factory/mix_context.dart';
import '../core/mix_element.dart';
import '../core/modifier.dart';
import '../core/utility.dart';

final class IntrinsicHeightModifierSpec
    extends WidgetModifierSpec<IntrinsicHeightModifierSpec>
    with Diagnosticable {
  const IntrinsicHeightModifierSpec();

  /// Creates a copy of this [IntrinsicHeightModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  IntrinsicHeightModifierSpec copyWith() {
    return const IntrinsicHeightModifierSpec();
  }

  /// Linearly interpolates between this [IntrinsicHeightModifierSpec] and another [IntrinsicHeightModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [IntrinsicHeightModifierSpec] is returned. When [t] is 1.0, the [other] [IntrinsicHeightModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [IntrinsicHeightModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [IntrinsicHeightModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [IntrinsicHeightModifierSpec] using the appropriate
  /// interpolation method:

  /// This method is typically used in animations to smoothly transition between
  /// different [IntrinsicHeightModifierSpec] configurations.
  @override
  IntrinsicHeightModifierSpec lerp(
    IntrinsicHeightModifierSpec? other,
    double t,
  ) {
    if (other == null) return this;

    return const IntrinsicHeightModifierSpec();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightModifierSpec] instances for equality.
  @override
  List<Object?> get props => [];

  @override
  Widget build(Widget child) {
    return IntrinsicHeight(child: child);
  }
}

final class IntrinsicWidthModifierSpec
    extends WidgetModifierSpec<IntrinsicWidthModifierSpec>
    with Diagnosticable {
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
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

/// Represents the attributes of a [IntrinsicHeightModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [IntrinsicHeightModifierSpec].
///
/// Use this class to configure the attributes of a [IntrinsicHeightModifierSpec] and pass it to
/// the [IntrinsicHeightModifierSpec] constructor.
class IntrinsicHeightModifierSpecAttribute
    extends WidgetModifierSpecAttribute<IntrinsicHeightModifierSpec> {
  const IntrinsicHeightModifierSpecAttribute();

  /// Resolves to [IntrinsicHeightModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicHeightModifierSpec = IntrinsicHeightModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  IntrinsicHeightModifierSpec resolve(MixContext context) {
    // ignore: prefer_const_constructors
    return IntrinsicHeightModifierSpec();
  }

  /// Merges the properties of this [IntrinsicHeightModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicHeightModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicHeightModifierSpecAttribute merge(
    IntrinsicHeightModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return other;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [IntrinsicHeightModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicHeightModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [];
}

/// A tween that interpolates between two [IntrinsicHeightModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [IntrinsicHeightModifierSpec] specifications.
class IntrinsicHeightModifierSpecTween
    extends Tween<IntrinsicHeightModifierSpec?> {
  IntrinsicHeightModifierSpecTween({super.begin, super.end});

  @override
  IntrinsicHeightModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const IntrinsicHeightModifierSpec();
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
class IntrinsicWidthModifierSpecAttribute
    extends WidgetModifierSpecAttribute<IntrinsicWidthModifierSpec> {
  const IntrinsicWidthModifierSpecAttribute();

  /// Resolves to [IntrinsicWidthModifierSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final intrinsicWidthModifierSpec = IntrinsicWidthModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  IntrinsicWidthModifierSpec resolve(MixContext context) {
    // ignore: prefer_const_constructors
    return IntrinsicWidthModifierSpec();
  }

  /// Merges the properties of this [IntrinsicWidthModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [IntrinsicWidthModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  IntrinsicWidthModifierSpecAttribute merge(
    IntrinsicWidthModifierSpecAttribute? other,
  ) {
    if (other == null) return this;

    return other;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [IntrinsicWidthModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [IntrinsicWidthModifierSpecAttribute] instances for equality.
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

final class IntrinsicHeightModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, IntrinsicHeightModifierSpecAttribute> {
  const IntrinsicHeightModifierSpecUtility(super.builder);
  T call() => builder(const IntrinsicHeightModifierSpecAttribute());
}

final class IntrinsicWidthModifierSpecUtility<T extends StyleElement>
    extends MixUtility<T, IntrinsicWidthModifierSpecAttribute> {
  const IntrinsicWidthModifierSpecUtility(super.builder);
  T call() => builder(const IntrinsicWidthModifierSpecAttribute());
}

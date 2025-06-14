// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [ResetModifierSpec].
mixin _$ResetModifierSpec on WidgetModifierSpec<ResetModifierSpec> {
  /// Creates a copy of this [ResetModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  ResetModifierSpec copyWith() {
    return const ResetModifierSpec();
  }

  /// Linearly interpolates between this [ResetModifierSpec] and another [ResetModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ResetModifierSpec] is returned. When [t] is 1.0, the [other] [ResetModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ResetModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ResetModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ResetModifierSpec] using the appropriate
  /// interpolation method:

  /// This method is typically used in animations to smoothly transition between
  /// different [ResetModifierSpec] configurations.
  @override
  ResetModifierSpec lerp(ResetModifierSpec? other, double t) {
    if (other == null) return _$this;

    return const ResetModifierSpec();
  }

  /// The list of properties that constitute the state of this [ResetModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ResetModifierSpec] instances for equality.
  @override
  List<Object?> get props => [];

  ResetModifierSpec get _$this => this as ResetModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {}
}

/// Represents the attributes of a [ResetModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ResetModifierSpec].
///
/// Use this class to configure the attributes of a [ResetModifierSpec] and pass it to
/// the [ResetModifierSpec] constructor.
class ResetModifierSpecAttribute
    extends WidgetModifierSpecAttribute<ResetModifierSpec> with Diagnosticable {
  const ResetModifierSpecAttribute();

  /// Resolves to [ResetModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final resetModifierSpec = ResetModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ResetModifierSpec resolve(MixData mix) {
    // ignore: prefer_const_constructors
    return ResetModifierSpec();
  }

  /// Merges the properties of this [ResetModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ResetModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ResetModifierSpecAttribute merge(ResetModifierSpecAttribute? other) {
    if (other == null) return this;

    return other;
  }

  /// The list of properties that constitute the state of this [ResetModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ResetModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}

/// A tween that interpolates between two [ResetModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ResetModifierSpec] specifications.
class ResetModifierSpecTween extends Tween<ResetModifierSpec?> {
  ResetModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  ResetModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ResetModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

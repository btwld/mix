// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexible_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [FlexibleModifierSpec].
mixin _$FlexibleModifierSpec on WidgetModifierSpec<FlexibleModifierSpec> {
  /// Creates a copy of this [FlexibleModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  FlexibleModifierSpec copyWith({
    int? flex,
    FlexFit? fit,
  }) {
    return FlexibleModifierSpec(
      flex: flex ?? _$this.flex,
      fit: fit ?? _$this.fit,
    );
  }

  /// Linearly interpolates between this [FlexibleModifierSpec] and another [FlexibleModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FlexibleModifierSpec] is returned. When [t] is 1.0, the [other] [FlexibleModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FlexibleModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FlexibleModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FlexibleModifierSpec] using the appropriate
  /// interpolation method:
  /// For [flex] and [fit], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [FlexibleModifierSpec] is used. Otherwise, the value
  /// from the [other] [FlexibleModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [FlexibleModifierSpec] configurations.
  @override
  FlexibleModifierSpec lerp(FlexibleModifierSpec? other, double t) {
    if (other == null) return _$this;

    return FlexibleModifierSpec(
      flex: t < 0.5 ? _$this.flex : other.flex,
      fit: t < 0.5 ? _$this.fit : other.fit,
    );
  }

  /// The list of properties that constitute the state of this [FlexibleModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.flex,
        _$this.fit,
      ];

  FlexibleModifierSpec get _$this => this as FlexibleModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('flex', _$this.flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', _$this.fit, defaultValue: null));
  }
}

/// Represents the attributes of a [FlexibleModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexibleModifierSpec].
///
/// Use this class to configure the attributes of a [FlexibleModifierSpec] and pass it to
/// the [FlexibleModifierSpec] constructor.
class FlexibleModifierSpecAttribute
    extends WidgetModifierSpecAttribute<FlexibleModifierSpec>
    with Diagnosticable {
  final int? flex;
  final FlexFit? fit;

  const FlexibleModifierSpecAttribute({
    this.flex,
    this.fit,
  });

  /// Resolves to [FlexibleModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final flexibleModifierSpec = FlexibleModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FlexibleModifierSpec resolve(MixData mix) {
    return FlexibleModifierSpec(
      flex: flex,
      fit: fit,
    );
  }

  /// Merges the properties of this [FlexibleModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexibleModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexibleModifierSpecAttribute merge(FlexibleModifierSpecAttribute? other) {
    if (other == null) return this;

    return FlexibleModifierSpecAttribute(
      flex: other.flex ?? flex,
      fit: other.fit ?? fit,
    );
  }

  /// The list of properties that constitute the state of this [FlexibleModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexibleModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        flex,
        fit,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('flex', flex, defaultValue: null));
    properties.add(DiagnosticsProperty('fit', fit, defaultValue: null));
  }
}

/// A tween that interpolates between two [FlexibleModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [FlexibleModifierSpec] specifications.
class FlexibleModifierSpecTween extends Tween<FlexibleModifierSpec?> {
  FlexibleModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  FlexibleModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const FlexibleModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

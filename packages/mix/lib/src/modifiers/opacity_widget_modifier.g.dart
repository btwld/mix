// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opacity_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [OpacityModifierSpec].
mixin _$OpacityModifierSpec on WidgetModifierSpec<OpacityModifierSpec> {
  /// Creates a copy of this [OpacityModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  OpacityModifierSpec copyWith({
    double? opacity,
  }) {
    return OpacityModifierSpec(
      opacity ?? _$this.opacity,
    );
  }

  /// Linearly interpolates between this [OpacityModifierSpec] and another [OpacityModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [OpacityModifierSpec] is returned. When [t] is 1.0, the [other] [OpacityModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [OpacityModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [OpacityModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [OpacityModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [opacity].

  /// This method is typically used in animations to smoothly transition between
  /// different [OpacityModifierSpec] configurations.
  @override
  OpacityModifierSpec lerp(OpacityModifierSpec? other, double t) {
    if (other == null) return _$this;

    return OpacityModifierSpec(
      MixHelpers.lerpDouble(_$this.opacity, other.opacity, t)!,
    );
  }

  /// The list of properties that constitute the state of this [OpacityModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.opacity,
      ];

  OpacityModifierSpec get _$this => this as OpacityModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('opacity', _$this.opacity, defaultValue: null));
  }
}

/// Represents the attributes of a [OpacityModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [OpacityModifierSpec].
///
/// Use this class to configure the attributes of a [OpacityModifierSpec] and pass it to
/// the [OpacityModifierSpec] constructor.
class OpacityModifierSpecAttribute
    extends WidgetModifierSpecAttribute<OpacityModifierSpec>
    with Diagnosticable {
  final double? opacity;

  const OpacityModifierSpecAttribute({
    this.opacity,
  });

  /// Resolves to [OpacityModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final opacityModifierSpec = OpacityModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  OpacityModifierSpec resolve(MixData mix) {
    return OpacityModifierSpec(
      opacity,
    );
  }

  /// Merges the properties of this [OpacityModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [OpacityModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  OpacityModifierSpecAttribute merge(OpacityModifierSpecAttribute? other) {
    if (other == null) return this;

    return OpacityModifierSpecAttribute(
      opacity: other.opacity ?? opacity,
    );
  }

  /// The list of properties that constitute the state of this [OpacityModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [OpacityModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        opacity,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('opacity', opacity, defaultValue: null));
  }
}

/// A tween that interpolates between two [OpacityModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [OpacityModifierSpec] specifications.
class OpacityModifierSpecTween extends Tween<OpacityModifierSpec?> {
  OpacityModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  OpacityModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const OpacityModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

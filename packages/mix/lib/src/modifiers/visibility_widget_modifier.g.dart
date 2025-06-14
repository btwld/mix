// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visibility_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [VisibilityModifierSpec].
mixin _$VisibilityModifierSpec on WidgetModifierSpec<VisibilityModifierSpec> {
  /// Creates a copy of this [VisibilityModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  VisibilityModifierSpec copyWith({
    bool? visible,
  }) {
    return VisibilityModifierSpec(
      visible ?? _$this.visible,
    );
  }

  /// Linearly interpolates between this [VisibilityModifierSpec] and another [VisibilityModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [VisibilityModifierSpec] is returned. When [t] is 1.0, the [other] [VisibilityModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [VisibilityModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [VisibilityModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [VisibilityModifierSpec] using the appropriate
  /// interpolation method:
  /// For [visible], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [VisibilityModifierSpec] is used. Otherwise, the value
  /// from the [other] [VisibilityModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [VisibilityModifierSpec] configurations.
  @override
  VisibilityModifierSpec lerp(VisibilityModifierSpec? other, double t) {
    if (other == null) return _$this;

    return VisibilityModifierSpec(
      t < 0.5 ? _$this.visible : other.visible,
    );
  }

  /// The list of properties that constitute the state of this [VisibilityModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [VisibilityModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.visible,
      ];

  VisibilityModifierSpec get _$this => this as VisibilityModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
        DiagnosticsProperty('visible', _$this.visible, defaultValue: null));
  }
}

/// Represents the attributes of a [VisibilityModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [VisibilityModifierSpec].
///
/// Use this class to configure the attributes of a [VisibilityModifierSpec] and pass it to
/// the [VisibilityModifierSpec] constructor.
class VisibilityModifierSpecAttribute
    extends WidgetModifierSpecAttribute<VisibilityModifierSpec>
    with Diagnosticable {
  final bool? visible;

  const VisibilityModifierSpecAttribute({
    this.visible,
  });

  /// Resolves to [VisibilityModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final visibilityModifierSpec = VisibilityModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  VisibilityModifierSpec resolve(MixData mix) {
    return VisibilityModifierSpec(
      visible,
    );
  }

  /// Merges the properties of this [VisibilityModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [VisibilityModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  VisibilityModifierSpecAttribute merge(
      VisibilityModifierSpecAttribute? other) {
    if (other == null) return this;

    return VisibilityModifierSpecAttribute(
      visible: other.visible ?? visible,
    );
  }

  /// The list of properties that constitute the state of this [VisibilityModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [VisibilityModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        visible,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('visible', visible, defaultValue: null));
  }
}

/// A tween that interpolates between two [VisibilityModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [VisibilityModifierSpec] specifications.
class VisibilityModifierSpecTween extends Tween<VisibilityModifierSpec?> {
  VisibilityModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  VisibilityModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const VisibilityModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect_ratio_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [AspectRatioModifierSpec].
mixin _$AspectRatioModifierSpec on WidgetModifierSpec<AspectRatioModifierSpec> {
  /// Creates a copy of this [AspectRatioModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  AspectRatioModifierSpec copyWith({
    double? aspectRatio,
  }) {
    return AspectRatioModifierSpec(
      aspectRatio ?? _$this.aspectRatio,
    );
  }

  /// Linearly interpolates between this [AspectRatioModifierSpec] and another [AspectRatioModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [AspectRatioModifierSpec] is returned. When [t] is 1.0, the [other] [AspectRatioModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [AspectRatioModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [AspectRatioModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [AspectRatioModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [aspectRatio].

  /// This method is typically used in animations to smoothly transition between
  /// different [AspectRatioModifierSpec] configurations.
  @override
  AspectRatioModifierSpec lerp(AspectRatioModifierSpec? other, double t) {
    if (other == null) return _$this;

    return AspectRatioModifierSpec(
      MixHelpers.lerpDouble(_$this.aspectRatio, other.aspectRatio, t)!,
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.aspectRatio,
      ];

  AspectRatioModifierSpec get _$this => this as AspectRatioModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('aspectRatio', _$this.aspectRatio,
        defaultValue: null));
  }
}

/// Represents the attributes of a [AspectRatioModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [AspectRatioModifierSpec].
///
/// Use this class to configure the attributes of a [AspectRatioModifierSpec] and pass it to
/// the [AspectRatioModifierSpec] constructor.
class AspectRatioModifierSpecAttribute
    extends WidgetModifierSpecAttribute<AspectRatioModifierSpec>
    with Diagnosticable {
  final double? aspectRatio;

  const AspectRatioModifierSpecAttribute({
    this.aspectRatio,
  });

  /// Resolves to [AspectRatioModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final aspectRatioModifierSpec = AspectRatioModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  AspectRatioModifierSpec resolve(MixData mix) {
    return AspectRatioModifierSpec(
      aspectRatio,
    );
  }

  /// Merges the properties of this [AspectRatioModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [AspectRatioModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  AspectRatioModifierSpecAttribute merge(
      AspectRatioModifierSpecAttribute? other) {
    if (other == null) return this;

    return AspectRatioModifierSpecAttribute(
      aspectRatio: other.aspectRatio ?? aspectRatio,
    );
  }

  /// The list of properties that constitute the state of this [AspectRatioModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [AspectRatioModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        aspectRatio,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty('aspectRatio', aspectRatio, defaultValue: null));
  }
}

/// A tween that interpolates between two [AspectRatioModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [AspectRatioModifierSpec] specifications.
class AspectRatioModifierSpecTween extends Tween<AspectRatioModifierSpec?> {
  AspectRatioModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  AspectRatioModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const AspectRatioModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

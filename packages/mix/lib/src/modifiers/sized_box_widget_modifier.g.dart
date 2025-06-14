// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sized_box_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [SizedBoxModifierSpec].
mixin _$SizedBoxModifierSpec on WidgetModifierSpec<SizedBoxModifierSpec> {
  /// Creates a copy of this [SizedBoxModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  SizedBoxModifierSpec copyWith({
    double? width,
    double? height,
  }) {
    return SizedBoxModifierSpec(
      width: width ?? _$this.width,
      height: height ?? _$this.height,
    );
  }

  /// Linearly interpolates between this [SizedBoxModifierSpec] and another [SizedBoxModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [SizedBoxModifierSpec] is returned. When [t] is 1.0, the [other] [SizedBoxModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [SizedBoxModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [SizedBoxModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [SizedBoxModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [width] and [height].

  /// This method is typically used in animations to smoothly transition between
  /// different [SizedBoxModifierSpec] configurations.
  @override
  SizedBoxModifierSpec lerp(SizedBoxModifierSpec? other, double t) {
    if (other == null) return _$this;

    return SizedBoxModifierSpec(
      width: MixHelpers.lerpDouble(_$this.width, other.width, t),
      height: MixHelpers.lerpDouble(_$this.height, other.height, t),
    );
  }

  /// The list of properties that constitute the state of this [SizedBoxModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SizedBoxModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.width,
        _$this.height,
      ];

  SizedBoxModifierSpec get _$this => this as SizedBoxModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
        .add(DiagnosticsProperty('width', _$this.width, defaultValue: null));
    properties
        .add(DiagnosticsProperty('height', _$this.height, defaultValue: null));
  }
}

/// Represents the attributes of a [SizedBoxModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [SizedBoxModifierSpec].
///
/// Use this class to configure the attributes of a [SizedBoxModifierSpec] and pass it to
/// the [SizedBoxModifierSpec] constructor.
class SizedBoxModifierSpecAttribute
    extends WidgetModifierSpecAttribute<SizedBoxModifierSpec>
    with Diagnosticable {
  final double? width;
  final double? height;

  const SizedBoxModifierSpecAttribute({
    this.width,
    this.height,
  });

  /// Resolves to [SizedBoxModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final sizedBoxModifierSpec = SizedBoxModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  SizedBoxModifierSpec resolve(MixData mix) {
    return SizedBoxModifierSpec(
      width: width,
      height: height,
    );
  }

  /// Merges the properties of this [SizedBoxModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [SizedBoxModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  SizedBoxModifierSpecAttribute merge(SizedBoxModifierSpecAttribute? other) {
    if (other == null) return this;

    return SizedBoxModifierSpecAttribute(
      width: other.width ?? width,
      height: other.height ?? height,
    );
  }

  /// The list of properties that constitute the state of this [SizedBoxModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [SizedBoxModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        width,
        height,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
  }
}

/// A tween that interpolates between two [SizedBoxModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [SizedBoxModifierSpec] specifications.
class SizedBoxModifierSpecTween extends Tween<SizedBoxModifierSpec?> {
  SizedBoxModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  SizedBoxModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const SizedBoxModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

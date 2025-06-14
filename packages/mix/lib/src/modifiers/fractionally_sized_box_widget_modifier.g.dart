// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fractionally_sized_box_widget_modifier.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [FractionallySizedBoxModifierSpec].
mixin _$FractionallySizedBoxModifierSpec
    on WidgetModifierSpec<FractionallySizedBoxModifierSpec> {
  /// Creates a copy of this [FractionallySizedBoxModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  FractionallySizedBoxModifierSpec copyWith({
    double? widthFactor,
    double? heightFactor,
    AlignmentGeometry? alignment,
  }) {
    return FractionallySizedBoxModifierSpec(
      widthFactor: widthFactor ?? _$this.widthFactor,
      heightFactor: heightFactor ?? _$this.heightFactor,
      alignment: alignment ?? _$this.alignment,
    );
  }

  /// Linearly interpolates between this [FractionallySizedBoxModifierSpec] and another [FractionallySizedBoxModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [FractionallySizedBoxModifierSpec] is returned. When [t] is 1.0, the [other] [FractionallySizedBoxModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [FractionallySizedBoxModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [FractionallySizedBoxModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [FractionallySizedBoxModifierSpec] using the appropriate
  /// interpolation method:
  /// - [MixHelpers.lerpDouble] for [widthFactor] and [heightFactor].
  /// - [AlignmentGeometry.lerp] for [alignment].

  /// This method is typically used in animations to smoothly transition between
  /// different [FractionallySizedBoxModifierSpec] configurations.
  @override
  FractionallySizedBoxModifierSpec lerp(
      FractionallySizedBoxModifierSpec? other, double t) {
    if (other == null) return _$this;

    return FractionallySizedBoxModifierSpec(
      widthFactor:
          MixHelpers.lerpDouble(_$this.widthFactor, other.widthFactor, t),
      heightFactor:
          MixHelpers.lerpDouble(_$this.heightFactor, other.heightFactor, t),
      alignment: AlignmentGeometry.lerp(_$this.alignment, other.alignment, t),
    );
  }

  /// The list of properties that constitute the state of this [FractionallySizedBoxModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FractionallySizedBoxModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.widthFactor,
        _$this.heightFactor,
        _$this.alignment,
      ];

  FractionallySizedBoxModifierSpec get _$this =>
      this as FractionallySizedBoxModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('widthFactor', _$this.widthFactor,
        defaultValue: null));
    properties.add(DiagnosticsProperty('heightFactor', _$this.heightFactor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty('alignment', _$this.alignment, defaultValue: null));
  }
}

/// Represents the attributes of a [FractionallySizedBoxModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FractionallySizedBoxModifierSpec].
///
/// Use this class to configure the attributes of a [FractionallySizedBoxModifierSpec] and pass it to
/// the [FractionallySizedBoxModifierSpec] constructor.
class FractionallySizedBoxModifierSpecAttribute
    extends WidgetModifierSpecAttribute<FractionallySizedBoxModifierSpec>
    with Diagnosticable {
  final double? widthFactor;
  final double? heightFactor;
  final AlignmentGeometry? alignment;

  const FractionallySizedBoxModifierSpecAttribute({
    this.widthFactor,
    this.heightFactor,
    this.alignment,
  });

  /// Resolves to [FractionallySizedBoxModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final fractionallySizedBoxModifierSpec = FractionallySizedBoxModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  FractionallySizedBoxModifierSpec resolve(MixData mix) {
    return FractionallySizedBoxModifierSpec(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
    );
  }

  /// Merges the properties of this [FractionallySizedBoxModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FractionallySizedBoxModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FractionallySizedBoxModifierSpecAttribute merge(
      FractionallySizedBoxModifierSpecAttribute? other) {
    if (other == null) return this;

    return FractionallySizedBoxModifierSpecAttribute(
      widthFactor: other.widthFactor ?? widthFactor,
      heightFactor: other.heightFactor ?? heightFactor,
      alignment: other.alignment ?? alignment,
    );
  }

  /// The list of properties that constitute the state of this [FractionallySizedBoxModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FractionallySizedBoxModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        widthFactor,
        heightFactor,
        alignment,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty('widthFactor', widthFactor, defaultValue: null));
    properties.add(
        DiagnosticsProperty('heightFactor', heightFactor, defaultValue: null));
    properties
        .add(DiagnosticsProperty('alignment', alignment, defaultValue: null));
  }
}

/// A tween that interpolates between two [FractionallySizedBoxModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [FractionallySizedBoxModifierSpec] specifications.
class FractionallySizedBoxModifierSpecTween
    extends Tween<FractionallySizedBoxModifierSpec?> {
  FractionallySizedBoxModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  FractionallySizedBoxModifierSpec lerp(double t) {
    if (begin == null && end == null) {
      return const FractionallySizedBoxModifierSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

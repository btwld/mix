// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transform_widget_modifier.dart';

// **************************************************************************
// MixableSpecGenerator
// **************************************************************************

// ignore_for_file: deprecated_member_use_from_same_package

mixin _$TransformModifierSpec on WidgetModifierSpec<TransformModifierSpec> {
  static TransformModifierSpec from(MixData mix) {
    return mix.attributeOf<TransformModifierSpecAttribute>()?.resolve(mix) ??
        const TransformModifierSpec();
  }

  /// {@template transform_modifier_spec_of}
  /// Retrieves the [TransformModifierSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [TransformModifierSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [TransformModifierSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final transformModifierSpec = TransformModifierSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TransformModifierSpec of(BuildContext context) {
    return _$TransformModifierSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [TransformModifierSpec] but with the given fields
  /// replaced with the new values.
  @override
  TransformModifierSpec copyWith({
    Matrix4? transform,
    Alignment? alignment,
  }) {
    return TransformModifierSpec(
      transform: transform ?? _$this.transform,
      alignment: alignment ?? _$this.alignment,
    );
  }

  /// Linearly interpolates between this [TransformModifierSpec] and another [TransformModifierSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [TransformModifierSpec] is returned. When [t] is 1.0, the [other] [TransformModifierSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [TransformModifierSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [TransformModifierSpec] instance.
  ///
  /// The interpolation is performed on each property of the [TransformModifierSpec] using the appropriate
  /// interpolation method:
  ///
  /// - [MixHelpers.lerpMatrix4] for [transform].
  /// - [Alignment.lerp] for [alignment].

  /// For , the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TransformModifierSpec] is used. Otherwise, the value
  /// from the [other] [TransformModifierSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TransformModifierSpec] configurations.
  @override
  TransformModifierSpec lerp(TransformModifierSpec? other, double t) {
    if (other == null) return _$this;

    return TransformModifierSpec(
      transform: MixHelpers.lerpMatrix4(_$this.transform, other.transform, t),
      alignment: Alignment.lerp(_$this.alignment, other.alignment, t),
    );
  }

  /// The list of properties that constitute the state of this [TransformModifierSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TransformModifierSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.transform,
        _$this.alignment,
      ];

  TransformModifierSpec get _$this => this as TransformModifierSpec;

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty('transform', _$this.transform));
    properties.add(DiagnosticsProperty('alignment', _$this.alignment));
  }
}

/// Represents the attributes of a [TransformModifierSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TransformModifierSpec].
///
/// Use this class to configure the attributes of a [TransformModifierSpec] and pass it to
/// the [TransformModifierSpec] constructor.
final class TransformModifierSpecAttribute
    extends WidgetModifierSpecAttribute<TransformModifierSpec>
    with Diagnosticable {
  final Matrix4? transform;
  final Alignment? alignment;

  const TransformModifierSpecAttribute({
    this.transform,
    this.alignment,
  });

  /// Resolves to [TransformModifierSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final transformModifierSpec = TransformModifierSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TransformModifierSpec resolve(MixData mix) {
    return TransformModifierSpec(
      transform: transform,
      alignment: alignment,
    );
  }

  /// Merges the properties of this [TransformModifierSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TransformModifierSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TransformModifierSpecAttribute merge(TransformModifierSpecAttribute? other) {
    if (other == null) return this;

    return TransformModifierSpecAttribute(
      transform: other.transform ?? transform,
      alignment: other.alignment ?? alignment,
    );
  }

  /// The list of properties that constitute the state of this [TransformModifierSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TransformModifierSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        transform,
        alignment,
      ];

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('transform', transform));
    properties.add(DiagnosticsProperty('alignment', alignment));
  }
}

/// A tween that interpolates between two [TransformModifierSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [TransformModifierSpec] specifications.
class TransformModifierSpecTween extends Tween<TransformModifierSpec?> {
  TransformModifierSpecTween({
    super.begin,
    super.end,
  });

  @override
  TransformModifierSpec lerp(double t) {
    if (begin == null && end == null) return const TransformModifierSpec();
    if (begin == null) return end!;

    return begin!.lerp(end!, t);
  }
}

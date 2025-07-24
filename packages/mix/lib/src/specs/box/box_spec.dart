import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

final class BoxSpec extends Spec<BoxSpec> with Diagnosticable {
  /// Aligns the child within the box.
  final AlignmentGeometry? alignment;

  /// Adds empty space inside the box.
  final EdgeInsetsGeometry? padding;

  /// Adds empty space around the box.
  final EdgeInsetsGeometry? margin;

  /// Applies additional constraints to the child.
  final BoxConstraints? constraints;

  /// Paints a decoration behind the child.
  final Decoration? decoration;

  /// Paints a decoration in front of the child.
  final Decoration? foregroundDecoration;

  /// Applies a transformation matrix before painting the box.
  final Matrix4? transform;

  /// Aligns the origin of the coordinate system for the [transform].
  final AlignmentGeometry? transformAlignment;

  /// Defines the clip behavior for the box
  /// when [BoxConstraints] has a negative minimum extent.
  final Clip? clipBehavior;

  const BoxSpec({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
  });

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('margin', margin, defaultValue: null));
    properties.add(
      DiagnosticsProperty('constraints', constraints, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('decoration', decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'foregroundDecoration',
        foregroundDecoration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('transform', transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'transformAlignment',
        transformAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
  }

  /// Creates a copy of this [BoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  /// Linearly interpolates between this [BoxSpec] and another [BoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [BoxSpec] is returned. When [t] is 1.0, the [other] [BoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [BoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [BoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [BoxSpec] using the appropriate
  /// interpolation method:
  /// - [AlignmentGeometry.lerp] for [alignment] and [transformAlignment].
  /// - [EdgeInsetsGeometry.lerp] for [padding] and [margin].
  /// - [BoxConstraints.lerp] for [constraints].
  /// - [Decoration.lerp] for [decoration] and [foregroundDecoration].
  /// - [MixHelpers.lerpMatrix4] for [transform].
  /// - [MixHelpers.lerpDouble] for [width] and [height].
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [BoxSpec] is used. Otherwise, the value
  /// from the [other] [BoxSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [BoxSpec] configurations.
  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    if (other == null) return this;

    return BoxSpec(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      constraints: BoxConstraints.lerp(constraints, other.constraints, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
      foregroundDecoration: Decoration.lerp(
        foregroundDecoration,
        other.foregroundDecoration,
        t,
      ),
      transform: MixHelpers.lerpMatrix4(transform, other.transform, t),
      transformAlignment: AlignmentGeometry.lerp(
        transformAlignment,
        other.transformAlignment,
        t,
      ),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [BoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxSpec] instances for equality.
  @override
  List<Object?> get props => [
    alignment,
    padding,
    margin,
    constraints,
    decoration,
    foregroundDecoration,
    transform,
    transformAlignment,
    clipBehavior,
  ];
}

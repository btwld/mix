import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';

/// A property bag for Container widget configuration.
///
/// This Spec provides resolved container styling values that can be applied
/// to Container widgets. It encapsulates common container properties like
/// decoration, padding, alignment, and constraints.
class ContainerSpec extends Spec<ContainerSpec> with Diagnosticable {
  /// Aligns the child within the container.
  final AlignmentGeometry? alignment;

  /// Adds empty space inside the container.
  final EdgeInsetsGeometry? padding;

  /// Adds empty space around the container.
  final EdgeInsetsGeometry? margin;

  /// Applies additional constraints to the child.
  final BoxConstraints? constraints;

  /// Paints a decoration behind the child.
  final Decoration? decoration;

  /// Paints a decoration in front of the child.
  final Decoration? foregroundDecoration;

  /// Applies a transformation matrix before painting the container.
  final Matrix4? transform;

  /// Aligns the origin of the coordinate system for the [transform].
  final AlignmentGeometry? transformAlignment;

  /// Defines the clip behavior for the container when content overflows.
  final Clip? clipBehavior;

  const ContainerSpec({
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


  @override
  ContainerSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) {
    return ContainerSpec(
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

  @override
  ContainerSpec lerp(ContainerSpec? other, double t) {
    return ContainerSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      margin: MixOps.lerp(margin, other?.margin, t),
      constraints: MixOps.lerp(constraints, other?.constraints, t),
      decoration: MixOps.lerp(decoration, other?.decoration, t),
      foregroundDecoration: MixOps.lerp(
        foregroundDecoration,
        other?.foregroundDecoration,
        t,
      ),
      transform: MixOps.lerp(transform, other?.transform, t),
      transformAlignment: MixOps.lerp(
        transformAlignment,
        other?.transformAlignment,
        t,
      ),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('margin', margin))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('decoration', decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', foregroundDecoration))
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('transformAlignment', transformAlignment))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }

  /// The list of properties that constitute the state of this [ContainerSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ContainerSpec] instances for equality.
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

/// Creates a [Container] widget from a [ContainerSpec].
Container createContainerSpecWidget({
  required ContainerSpec spec,
  Widget? child,
}) {
  return Container(
    alignment: spec.alignment,
    padding: spec.padding,
    decoration: spec.decoration,
    foregroundDecoration: spec.foregroundDecoration,
    constraints: spec.constraints,
    margin: spec.margin,
    transform: spec.transform,
    transformAlignment: spec.transformAlignment,
    clipBehavior: spec.clipBehavior ?? Clip.none,
    child: child,
  );
}

/// Extension to convert [ContainerSpec] directly to a [Container] widget.
extension ContainerSpecX on ContainerSpec {
  /// Call operator to build a Container widget.
  Container call({Widget? child}) {
    return createContainerSpecWidget(spec: this, child: child);
  }
}

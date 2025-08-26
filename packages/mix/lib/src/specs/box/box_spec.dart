import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'box_widget.dart';

/// Specification for box styling and layout properties.
///
/// Provides comprehensive box styling including alignment, padding, margin, constraints,
/// decoration, transformation, and clipping behavior. Used as the resolved form
/// of [BoxStyle] styling attributes.
class BoxSpec extends Spec<BoxSpec> with Diagnosticable {
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

  /// Defines the clip behavior for the box when content overflows.
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

  /// Linearly interpolates between this and [other] BoxSpec.
  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    return BoxSpec(
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


/// Extension to convert [BoxSpec] directly to a [Container] widget.
extension BoxSpecX on BoxSpec {
  /// Call operator to build a Container widget.
  Container call({Widget? child}) {
    return createBoxSpecWidget(spec: this, child: child);
  }
}

/// Legacy alias for BoxSpec to maintain backward compatibility.
///
/// @deprecated Use BoxSpec directly instead.
typedef ContainerSpec = BoxSpec;

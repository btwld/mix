import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/constraints_mixin.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/layout/spacing_mixin.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/gradient_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/transform_mixin.dart';
import '../painting/decoration_mixin.dart';
import 'container_spec.dart';

/// Mix class for configuring [ContainerSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for container layouts with support for
/// proper Mix framework integration.
final class ContainerMix extends Mix<ContainerSpec>
    with
        DecorationMixin<ContainerMix>,
        SpacingMixin<ContainerMix>,
        ConstraintsMixin<ContainerMix>,
        TransformMixin<ContainerMix>,
        BorderRadiusMixin<ContainerMix>,
        Diagnosticable {
  final Prop<Decoration>? $decoration;
  final Prop<Decoration>? $foregroundDecoration;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<EdgeInsetsGeometry>? $margin;
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  /// Main constructor with user-friendly Mix types
  ContainerMix({
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) : this.create(
         decoration: Prop.maybeMix(decoration),
         foregroundDecoration: Prop.maybeMix(foregroundDecoration),
         padding: Prop.maybeMix(padding),
         margin: Prop.maybeMix(margin),
         alignment: Prop.maybe(alignment),
         constraints: Prop.maybeMix(constraints),
         transform: Prop.maybe(transform),
         transformAlignment: Prop.maybe(transformAlignment),
         clipBehavior: Prop.maybe(clipBehavior),
       );

  /// Create constructor with Prop`<T>` types for internal use
  const ContainerMix.create({
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<AlignmentGeometry>? alignment,
    Prop<BoxConstraints>? constraints,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
  }) : $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $padding = padding,
       $margin = margin,
       $alignment = alignment,
       $constraints = constraints,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  /// Constructor that accepts a [ContainerSpec] value and extracts its properties.
  ContainerMix.value(ContainerSpec spec)
    : this(
        decoration: DecorationMix.maybeValue(spec.decoration),
        foregroundDecoration: DecorationMix.maybeValue(
          spec.foregroundDecoration,
        ),
        padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
        margin: EdgeInsetsGeometryMix.maybeValue(spec.margin),
        alignment: spec.alignment,
        constraints: BoxConstraintsMix.maybeValue(spec.constraints),
        transform: spec.transform,
        transformAlignment: spec.transformAlignment,
        clipBehavior: spec.clipBehavior,
      );

  // Factory constructors for common use cases

  /// Gradient factory
  factory ContainerMix.gradient(GradientMix value) {
    return ContainerMix(decoration: DecorationMix.gradient(value));
  }

  /// Color factory
  factory ContainerMix.color(Color value) {
    return ContainerMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory ContainerMix.decoration(DecorationMix value) {
    return ContainerMix(decoration: value);
  }

  /// Foreground decoration factory
  factory ContainerMix.foregroundDecoration(DecorationMix value) {
    return ContainerMix(foregroundDecoration: value);
  }

  /// Alignment factory
  factory ContainerMix.alignment(AlignmentGeometry value) {
    return ContainerMix(alignment: value);
  }

  /// Padding factory
  factory ContainerMix.padding(EdgeInsetsGeometryMix value) {
    return ContainerMix(padding: value);
  }

  /// Margin factory
  factory ContainerMix.margin(EdgeInsetsGeometryMix value) {
    return ContainerMix(margin: value);
  }

  /// Transform factory
  factory ContainerMix.transform(Matrix4 value) {
    return ContainerMix(transform: value);
  }

  /// Transform alignment factory
  factory ContainerMix.transformAlignment(AlignmentGeometry value) {
    return ContainerMix(transformAlignment: value);
  }

  /// Clip behavior factory
  factory ContainerMix.clipBehavior(Clip value) {
    return ContainerMix(clipBehavior: value);
  }

  /// Constraints factory
  factory ContainerMix.constraints(BoxConstraintsMix value) {
    return ContainerMix(constraints: value);
  }

  /// Border factory
  factory ContainerMix.border(BoxBorderMix value) {
    return ContainerMix(decoration: DecorationMix.border(value));
  }

  /// Border radius factory
  factory ContainerMix.borderRadius(BorderRadiusGeometryMix value) {
    return ContainerMix(decoration: DecorationMix.borderRadius(value));
  }

  /// Shadow factory
  factory ContainerMix.shadow(BoxShadowMix value) {
    return ContainerMix(decoration: DecorationMix.boxShadow([value]));
  }

  /// Width factory
  factory ContainerMix.width(double value) {
    return ContainerMix(constraints: BoxConstraintsMix.width(value));
  }

  /// Height factory
  factory ContainerMix.height(double value) {
    return ContainerMix(constraints: BoxConstraintsMix.height(value));
  }

  /// minWidth factory
  factory ContainerMix.minWidth(double value) {
    return ContainerMix(constraints: BoxConstraintsMix.minWidth(value));
  }

  /// maxWidth factory
  factory ContainerMix.maxWidth(double value) {
    return ContainerMix(constraints: BoxConstraintsMix.maxWidth(value));
  }

  /// minHeight factory
  factory ContainerMix.minHeight(double value) {
    return ContainerMix(constraints: BoxConstraintsMix.minHeight(value));
  }

  /// maxHeight factory
  factory ContainerMix.maxHeight(double value) {
    return ContainerMix(constraints: BoxConstraintsMix.maxHeight(value));
  }

  /// Constructor that accepts a nullable [ContainerSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [ContainerMix.value].
  static ContainerMix? maybeValue(ContainerSpec? spec) {
    return spec != null ? ContainerMix.value(spec) : null;
  }

  /// Returns a copy with the specified foreground decoration.
  ContainerMix foregroundDecoration(DecorationMix value) {
    return merge(ContainerMix.foregroundDecoration(value));
  }

  /// Returns a copy with the specified alignment.
  ContainerMix alignment(AlignmentGeometry value) {
    return merge(ContainerMix.alignment(value));
  }

  /// Returns a copy with the specified transform alignment.
  ContainerMix transformAlignment(AlignmentGeometry value) {
    return merge(ContainerMix.transformAlignment(value));
  }

  /// Returns a copy with the specified clip behavior.
  ContainerMix clipBehavior(Clip value) {
    return merge(ContainerMix.clipBehavior(value));
  }

  /// Returns a copy with the specified border radius.
  @override
  ContainerMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(ContainerMix.borderRadius(value));
  }

  /// Returns a copy with the specified padding.
  @override
  ContainerMix padding(EdgeInsetsGeometryMix value) {
    return merge(ContainerMix.padding(value));
  }

  /// Returns a copy with the specified margin.
  @override
  ContainerMix margin(EdgeInsetsGeometryMix value) {
    return merge(ContainerMix.margin(value));
  }

  /// Returns a copy with the specified transform.
  @override
  ContainerMix transform(Matrix4 value) {
    return merge(ContainerMix.transform(value));
  }

  /// Returns a copy with the specified constraints.
  @override
  ContainerMix constraints(BoxConstraintsMix value) {
    return merge(ContainerMix.constraints(value));
  }

  /// Returns a copy with the specified decoration.
  @override
  ContainerMix decoration(DecorationMix value) {
    return merge(ContainerMix.decoration(value));
  }

  /// Resolves to [ContainerSpec] using the provided [BuildContext].
  @override
  ContainerSpec resolve(BuildContext context) {
    return ContainerSpec(
      alignment: MixOps.resolve(context, $alignment),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      constraints: MixOps.resolve(context, $constraints),
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [ContainerMix] with the properties of [other].
  @override
  ContainerMix merge(ContainerMix? other) {
    if (other == null) return this;

    return ContainerMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other.$foregroundDecoration,
      ),
      padding: MixOps.merge($padding, other.$padding),
      margin: MixOps.merge($margin, other.$margin),
      alignment: MixOps.merge($alignment, other.$alignment),
      constraints: MixOps.merge($constraints, other.$constraints),
      transform: MixOps.merge($transform, other.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other.$transformAlignment,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
    $decoration,
    $foregroundDecoration,
    $padding,
    $margin,
    $alignment,
    $constraints,
    $transform,
    $transformAlignment,
    $clipBehavior,
  ];
}

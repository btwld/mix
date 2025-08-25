import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/mix_element.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import 'container_spec.dart';

/// Mix class for configuring [ContainerSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for container layouts with support for
/// proper Mix framework integration.
final class ContainerSpecMix extends Mix<ContainerSpec> with Diagnosticable {
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
  ContainerSpecMix({
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
  const ContainerSpecMix.create({
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<AlignmentGeometry>? alignment,
    Prop<BoxConstraints>? constraints,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
  })  : $decoration = decoration,
        $foregroundDecoration = foregroundDecoration,
        $padding = padding,
        $margin = margin,
        $alignment = alignment,
        $constraints = constraints,
        $transform = transform,
        $transformAlignment = transformAlignment,
        $clipBehavior = clipBehavior;

  /// Constructor that accepts a [ContainerSpec] value and extracts its properties.
  ContainerSpecMix.value(ContainerSpec spec)
      : this(
          decoration: DecorationMix.maybeValue(spec.decoration),
          foregroundDecoration:
              DecorationMix.maybeValue(spec.foregroundDecoration),
          padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
          margin: EdgeInsetsGeometryMix.maybeValue(spec.margin),
          alignment: spec.alignment,
          constraints: BoxConstraintsMix.maybeValue(spec.constraints),
          transform: spec.transform,
          transformAlignment: spec.transformAlignment,
          clipBehavior: spec.clipBehavior,
        );

  // Factory constructors for common use cases

  /// Color factory
  factory ContainerSpecMix.color(Color value) {
    return ContainerSpecMix(decoration: DecorationMix.color(value));
  }

  /// Decoration factory
  factory ContainerSpecMix.decoration(DecorationMix value) {
    return ContainerSpecMix(decoration: value);
  }

  /// Foreground decoration factory
  factory ContainerSpecMix.foregroundDecoration(DecorationMix value) {
    return ContainerSpecMix(foregroundDecoration: value);
  }

  /// Alignment factory
  factory ContainerSpecMix.alignment(AlignmentGeometry value) {
    return ContainerSpecMix(alignment: value);
  }

  /// Padding factory
  factory ContainerSpecMix.padding(EdgeInsetsGeometryMix value) {
    return ContainerSpecMix(padding: value);
  }

  /// Margin factory
  factory ContainerSpecMix.margin(EdgeInsetsGeometryMix value) {
    return ContainerSpecMix(margin: value);
  }

  /// Transform factory
  factory ContainerSpecMix.transform(Matrix4 value) {
    return ContainerSpecMix(transform: value);
  }

  /// Transform alignment factory
  factory ContainerSpecMix.transformAlignment(AlignmentGeometry value) {
    return ContainerSpecMix(transformAlignment: value);
  }

  /// Clip behavior factory
  factory ContainerSpecMix.clipBehavior(Clip value) {
    return ContainerSpecMix(clipBehavior: value);
  }

  /// Constraints factory
  factory ContainerSpecMix.constraints(BoxConstraintsMix value) {
    return ContainerSpecMix(constraints: value);
  }

  /// Border factory
  factory ContainerSpecMix.border(BoxBorderMix value) {
    return ContainerSpecMix(decoration: DecorationMix.border(value));
  }

  /// Border radius factory
  factory ContainerSpecMix.borderRadius(BorderRadiusGeometryMix value) {
    return ContainerSpecMix(decoration: DecorationMix.borderRadius(value));
  }

  /// Shadow factory
  factory ContainerSpecMix.shadow(BoxShadowMix value) {
    return ContainerSpecMix(decoration: DecorationMix.boxShadow([value]));
  }

  /// Width factory
  factory ContainerSpecMix.width(double value) {
    return ContainerSpecMix(constraints: BoxConstraintsMix.width(value));
  }

  /// Height factory
  factory ContainerSpecMix.height(double value) {
    return ContainerSpecMix(constraints: BoxConstraintsMix.height(value));
  }


  /// Constructor that accepts a nullable [ContainerSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [ContainerSpecMix.value].
  static ContainerSpecMix? maybeValue(ContainerSpec? spec) {
    return spec != null ? ContainerSpecMix.value(spec) : null;
  }

  // Chainable instance methods

  /// Returns a copy with the specified color.
  ContainerSpecMix color(Color value) {
    return merge(ContainerSpecMix.color(value));
  }

  /// Returns a copy with the specified decoration.
  ContainerSpecMix decoration(DecorationMix value) {
    return merge(ContainerSpecMix.decoration(value));
  }

  /// Returns a copy with the specified foreground decoration.
  ContainerSpecMix foregroundDecoration(DecorationMix value) {
    return merge(ContainerSpecMix.foregroundDecoration(value));
  }

  /// Returns a copy with the specified alignment.
  ContainerSpecMix alignment(AlignmentGeometry value) {
    return merge(ContainerSpecMix.alignment(value));
  }

  /// Returns a copy with the specified padding.
  ContainerSpecMix padding(EdgeInsetsGeometryMix value) {
    return merge(ContainerSpecMix.padding(value));
  }

  /// Returns a copy with the specified margin.
  ContainerSpecMix margin(EdgeInsetsGeometryMix value) {
    return merge(ContainerSpecMix.margin(value));
  }

  /// Returns a copy with the specified transform.
  ContainerSpecMix transform(Matrix4 value) {
    return merge(ContainerSpecMix.transform(value));
  }

  /// Returns a copy with the specified transform alignment.
  ContainerSpecMix transformAlignment(AlignmentGeometry value) {
    return merge(ContainerSpecMix.transformAlignment(value));
  }

  /// Returns a copy with the specified clip behavior.
  ContainerSpecMix clipBehavior(Clip value) {
    return merge(ContainerSpecMix.clipBehavior(value));
  }

  /// Returns a copy with the specified constraints.
  ContainerSpecMix constraints(BoxConstraintsMix value) {
    return merge(ContainerSpecMix.constraints(value));
  }

  /// Returns a copy with the specified border.
  ContainerSpecMix border(BoxBorderMix value) {
    return merge(ContainerSpecMix.border(value));
  }

  /// Returns a copy with the specified border radius.
  ContainerSpecMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(ContainerSpecMix.borderRadius(value));
  }

  /// Returns a copy with the specified shadow.
  ContainerSpecMix shadow(BoxShadowMix value) {
    return merge(ContainerSpecMix.shadow(value));
  }

  /// Returns a copy with the specified width.
  ContainerSpecMix width(double value) {
    return merge(ContainerSpecMix.width(value));
  }

  /// Returns a copy with the specified height.
  ContainerSpecMix height(double value) {
    return merge(ContainerSpecMix.height(value));
  }

  /// Resolves to [ContainerSpec] using the provided [BuildContext].
  @override
  ContainerSpec resolve(BuildContext context) {
    return ContainerSpec(
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      alignment: MixOps.resolve(context, $alignment),
      constraints: MixOps.resolve(context, $constraints),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [ContainerSpecMix] with the properties of [other].
  @override
  ContainerSpecMix merge(ContainerSpecMix? other) {
    if (other == null) return this;

    return ContainerSpecMix.create(
      decoration: MixOps.merge($decoration, other.$decoration),
      foregroundDecoration:
          MixOps.merge($foregroundDecoration, other.$foregroundDecoration),
      padding: MixOps.merge($padding, other.$padding),
      margin: MixOps.merge($margin, other.$margin),
      alignment: MixOps.merge($alignment, other.$alignment),
      constraints: MixOps.merge($constraints, other.$constraints),
      transform: MixOps.merge($transform, other.$transform),
      transformAlignment:
          MixOps.merge($transformAlignment, other.$transformAlignment),
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
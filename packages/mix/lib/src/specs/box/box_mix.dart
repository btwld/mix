import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/helpers.dart';
import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/constraints_mixin.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/layout/spacing_mixin.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/decoration_mixin.dart';
import '../../properties/transform_mixin.dart';
import 'box_spec.dart';
import 'box_style.dart';

/// Mix class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts with support for
/// proper Mix framework integration.
final class BoxMix extends Mix<BoxSpec>
    with
        DecorationMixin<BoxMix>,
        SpacingMixin<BoxMix>,
        ConstraintsMixin<BoxMix>,
        TransformMixin<BoxMix>,
        BorderRadiusMixin<BoxMix>,
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
  BoxMix({
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
  const BoxMix.create({
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

  /// Factory constructor to create BoxMix from BoxSpec.
  static BoxMix value(BoxSpec spec) {
    return BoxMix(
      decoration: DecorationMix.maybeValue(spec.decoration),
      foregroundDecoration: DecorationMix.maybeValue(spec.foregroundDecoration),
      padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
      margin: EdgeInsetsGeometryMix.maybeValue(spec.margin),
      alignment: spec.alignment,
      constraints: BoxConstraintsMix.maybeValue(spec.constraints),
      transform: spec.transform,
      transformAlignment: spec.transformAlignment,
      clipBehavior: spec.clipBehavior,
    );
  }

  /// Constructor that accepts a nullable [BoxSpec] value.
  ///
  /// Returns null if the input is null, otherwise uses [BoxMix.value].
  static BoxMix? maybeValue(BoxSpec? spec) {
    return spec != null ? BoxMix.value(spec) : null;
  }

  /// Returns a copy with the specified foreground decoration.
  BoxMix foregroundDecoration(DecorationMix value) {
    return merge(BoxMix(foregroundDecoration: value));
  }

  /// Returns a copy with the specified alignment.
  BoxMix alignment(AlignmentGeometry value) {
    return merge(BoxMix(alignment: value));
  }

  /// Returns a copy with the specified transform alignment.
  BoxMix transformAlignment(AlignmentGeometry value) {
    return merge(BoxMix(transformAlignment: value));
  }

  /// Returns a copy with the specified clip behavior.
  BoxMix clipBehavior(Clip value) {
    return merge(BoxMix(clipBehavior: value));
  }

  /// Returns a copy with the specified border radius.
  @override
  BoxMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(BoxMix(decoration: DecorationMix.borderRadius(value)));
  }

  /// Returns a copy with the specified padding.
  @override
  BoxMix padding(EdgeInsetsGeometryMix value) {
    return merge(BoxMix(padding: value));
  }

  /// Returns a copy with the specified margin.
  @override
  BoxMix margin(EdgeInsetsGeometryMix value) {
    return merge(BoxMix(margin: value));
  }

  /// Returns a copy with the specified transform.
  @override
  BoxMix transform(Matrix4 value) {
    return merge(BoxMix(transform: value));
  }

  /// Returns a copy with the specified constraints.
  @override
  BoxMix constraints(BoxConstraintsMix value) {
    return merge(BoxMix(constraints: value));
  }

  /// Returns a copy with the specified decoration.
  @override
  BoxMix decoration(DecorationMix value) {
    return merge(BoxMix(decoration: value));
  }

  /// Resolves to [BoxSpec] using the provided [BuildContext].
  @override
  BoxSpec resolve(BuildContext context) {
    return BoxSpec(
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

  /// Merges the properties of this [BoxMix] with the properties of [other].
  @override
  BoxMix merge(BoxMix? other) {
    if (other == null) return this;

    return BoxMix.create(
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

extension BoxMixToStyle on BoxMix {
  /// Converts this BoxMix to a BoxStyle
  BoxStyle toStyle() => BoxStyle.from(this);
}

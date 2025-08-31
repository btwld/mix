import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/constraints_mixin.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/layout/spacing_mixin.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/border_radius_util.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/decoration_mixin.dart';
import '../../properties/transform_mixin.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'box_spec.dart';
import 'box_util.dart';
import 'box_widget.dart';

typedef BoxMix = BoxStyler;

/// Style class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts with support for
/// widget modifiers, variants, and animations.
class BoxStyler extends Style<BoxSpec>
    with
        Diagnosticable,
        StyleModifierMixin<BoxStyler, BoxSpec>,
        StyleVariantMixin<BoxStyler, BoxSpec>,
        BorderRadiusMixin<BoxStyler>,
        DecorationMixin<BoxStyler>,
        SpacingMixin<BoxStyler>,
        TransformMixin<BoxStyler>,
        ConstraintsMixin<BoxStyler>,
        StyleAnimationMixin<BoxSpec, BoxStyler> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<EdgeInsetsGeometry>? $margin;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Decoration>? $decoration;
  final Prop<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  const BoxStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<BoxConstraints>? constraints,
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    super.variants,
    super.modifier,
    super.animation,
  }) : $alignment = alignment,
       $padding = padding,
       $margin = margin,
       $constraints = constraints,
       $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  BoxStyler({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    BoxConstraintsMix? constraints,
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    AnimationConfig? animation,
    ModifierConfig? modifier,
    List<VariantStyle<BoxSpec>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         padding: Prop.maybeMix(padding),
         margin: Prop.maybeMix(margin),
         constraints: Prop.maybeMix(constraints),
         decoration: Prop.maybeMix(decoration),
         foregroundDecoration: Prop.maybeMix(foregroundDecoration),
         transform: Prop.maybe(transform),
         transformAlignment: Prop.maybe(transformAlignment),
         clipBehavior: Prop.maybe(clipBehavior),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BoxStyler.builder(BoxStyler Function(BuildContext) fn) {
    return BoxStyler().builder(fn);
  }

  static BoxSpecUtility get chain => BoxSpecUtility(BoxStyler());

  BoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(BoxStyler(transformAlignment: value));
  }

  BoxStyler clipBehavior(Clip value) {
    return merge(BoxStyler(clipBehavior: value));
  }

  BoxStyler alignment(AlignmentGeometry value) {
    return merge(BoxStyler(alignment: value));
  }

  /// Foreground decoration instance method
  BoxStyler foregroundDecoration(DecorationMix value) {
    return merge(BoxStyler(foregroundDecoration: value));
  }

  Box call({Widget? child}) {
    return Box(style: this, child: child);
  }

  /// Modifier instance method
  BoxStyler modifier(ModifierConfig value) {
    return merge(BoxStyler(modifier: value));
  }

  @override
  BoxStyler transform(Matrix4 value) {
    return merge(BoxStyler(transform: value));
  }

  /// Constraints instance method
  @override
  BoxStyler constraints(BoxConstraintsMix value) {
    return merge(BoxStyler(constraints: value));
  }

  /// Padding instance method
  @override
  BoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(padding: value));
  }

  /// Margin instance method
  @override
  BoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(margin: value));
  }

  /// Decoration instance method
  @override
  BoxStyler decoration(DecorationMix value) {
    return merge(BoxStyler(decoration: value));
  }

  /// Animation instance method
  @override
  BoxStyler animate(AnimationConfig animation) {
    return merge(BoxStyler(animation: animation));
  }

  /// Mixin implementation
  @override
  BoxStyler wrap(ModifierConfig value) {
    return modifier(value);
  }

  /// Border radius instance method
  @override
  BoxStyler borderRadius(BorderRadiusGeometryMix value) {
    return merge(BoxStyler(decoration: DecorationMix.borderRadius(value)));
  }

  @override
  BoxStyler variants(List<VariantStyle<BoxSpec>> value) {
    return merge(BoxStyler(variants: value));
  }

  @override
  BoxStyler variant(Variant variant, BoxStyler style) {
    return merge(BoxStyler(variants: [VariantStyle(variant, style)]));
  }

  /// Resolves to [StyleSpec<BoxSpec>] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final wrappedSpec = BoxStyle(...).resolve(context);
  /// ```
  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    // Build the pure BoxSpec
    final boxSpec = BoxSpec(
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

    // Wrap with metadata
    return StyleSpec(
      spec: boxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [BoxStyler] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxStyler] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxStyler merge(BoxStyler? other) {
    return BoxStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      padding: MixOps.merge($padding, other?.$padding),
      margin: MixOps.merge($margin, other?.$margin),
      constraints: MixOps.merge($constraints, other?.$constraints),
      decoration: MixOps.merge($decoration, other?.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other?.$foregroundDecoration,
      ),
      transform: MixOps.merge($transform, other?.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other?.$transformAlignment,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxStyler] instances for equality.
  @override
  List<Object?> get props => [
    $alignment,
    $padding,
    $margin,
    $constraints,
    $decoration,
    $foregroundDecoration,
    $transform,
    $transformAlignment,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}

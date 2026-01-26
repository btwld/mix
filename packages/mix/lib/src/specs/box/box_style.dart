import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../style/mixins/animation_style_mixin.dart';
import '../../style/mixins/border_radius_style_mixin.dart';
import '../../style/mixins/border_style_mixin.dart';
import '../../style/mixins/constraint_style_mixin.dart';
import '../../style/mixins/decoration_style_mixin.dart';
import '../../style/mixins/shadow_style_mixin.dart';
import '../../style/mixins/spacing_style_mixin.dart';
import '../../style/mixins/transform_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import '../../style/mixins/widget_state_variant_mixin.dart';
import 'box_spec.dart';

part 'box_style.g.dart';

@Deprecated('Use BoxStyler instead')
typedef BoxMix = BoxStyler;

/// Style class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts with support for
/// widget modifiers, variants, and animations.
@mixableStyler
class BoxStyler extends Style<BoxSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<BoxStyler, BoxSpec>,
        VariantStyleMixin<BoxStyler, BoxSpec>,
        WidgetStateVariantMixin<BoxStyler, BoxSpec>,
        BorderStyleMixin<BoxStyler>,
        BorderRadiusStyleMixin<BoxStyler>,
        ShadowStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        SpacingStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler>,
        ConstraintStyleMixin<BoxStyler>,
        AnimationStyleMixin<BoxStyler, BoxSpec>,
        _$BoxStylerMixin {
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<EdgeInsetsGeometry>? $padding;
  @override
  final Prop<EdgeInsetsGeometry>? $margin;
  @override
  final Prop<BoxConstraints>? $constraints;
  @override
  final Prop<Decoration>? $decoration;
  @override
  final Prop<Decoration>? $foregroundDecoration;

  @override
  @MixableField(ignoreSetter: true)
  final Prop<Matrix4>? $transform;

  @override
  @MixableField(ignoreSetter: true)
  final Prop<AlignmentGeometry>? $transformAlignment;
  @override
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
    WidgetModifierConfig? modifier,
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

  @override
  BoxStyler transform(Matrix4 value, {Alignment alignment = Alignment.center}) {
    return BoxStyler(transform: value, transformAlignment: alignment);
  }
}

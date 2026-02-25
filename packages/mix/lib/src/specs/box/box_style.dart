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
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/gradient_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../style/abstracts/styler.dart';
import '../../style/mixins/border_radius_style_mixin.dart';
import '../../style/mixins/border_style_mixin.dart';
import '../../style/mixins/constraint_style_mixin.dart';
import '../../style/mixins/decoration_style_mixin.dart';
import '../../style/mixins/shadow_style_mixin.dart';
import '../../style/mixins/spacing_style_mixin.dart';
import '../../style/mixins/transform_style_mixin.dart';
import 'box_mutable_style.dart';
import 'box_spec.dart';
import 'box_widget.dart';

part 'box_style.g.dart';

@Deprecated('Use BoxStyler instead')
typedef BoxMix = BoxStyler;

/// Style class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts with support for
/// widget modifiers, variants, and animations.
@MixableStyler()
class BoxStyler extends MixStyler<BoxStyler, BoxSpec>
    with
        BorderStyleMixin<BoxStyler>,
        BorderRadiusStyleMixin<BoxStyler>,
        ShadowStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        SpacingStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler>,
        ConstraintStyleMixin<BoxStyler>,
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
  @MixableField(ignoreSetter: true)
  @override
  final Prop<Matrix4>? $transform;
  @MixableField(ignoreSetter: true)
  @override
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

  // Factory constructors for dot-shorthand notation (e.g., `.color(Colors.blue)`)
  // These enable concise syntax when BoxStyler is used as a sub-styler in compound widgets.

  // Direct constructor params
  factory BoxStyler.alignment(AlignmentGeometry value) =>
      BoxStyler(alignment: value);
  factory BoxStyler.padding(EdgeInsetsGeometryMix value) =>
      BoxStyler(padding: value);
  factory BoxStyler.margin(EdgeInsetsGeometryMix value) =>
      BoxStyler(margin: value);
  factory BoxStyler.constraints(BoxConstraintsMix value) =>
      BoxStyler(constraints: value);
  factory BoxStyler.decoration(DecorationMix value) =>
      BoxStyler(decoration: value);
  factory BoxStyler.foregroundDecoration(DecorationMix value) =>
      BoxStyler(foregroundDecoration: value);
  factory BoxStyler.clipBehavior(Clip value) => BoxStyler(clipBehavior: value);

  // Decoration convenience
  factory BoxStyler.color(Color value) => BoxStyler().color(value);
  factory BoxStyler.gradient(GradientMix value) => BoxStyler().gradient(value);
  factory BoxStyler.border(BoxBorderMix value) => BoxStyler().border(value);
  factory BoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      BoxStyler().borderRadius(value);
  factory BoxStyler.elevation(ElevationShadow value) =>
      BoxStyler().elevation(value);

  // Spacing convenience
  factory BoxStyler.paddingAll(double value) => BoxStyler().paddingAll(value);
  factory BoxStyler.paddingX(double value) => BoxStyler().paddingX(value);
  factory BoxStyler.paddingY(double value) => BoxStyler().paddingY(value);
  factory BoxStyler.marginAll(double value) => BoxStyler().marginAll(value);
  factory BoxStyler.marginX(double value) => BoxStyler().marginX(value);
  factory BoxStyler.marginY(double value) => BoxStyler().marginY(value);

  // Border radius convenience
  factory BoxStyler.borderRounded(double value) =>
      BoxStyler().borderRounded(value);

  // Constraints convenience
  factory BoxStyler.width(double value) => BoxStyler().width(value);
  factory BoxStyler.height(double value) => BoxStyler().height(value);
  factory BoxStyler.size(double width, double height) =>
      BoxStyler().size(width, height);

  // Transform convenience
  factory BoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      BoxStyler().scale(scale, alignment: alignment);
  factory BoxStyler.rotate(double angle, {Alignment alignment = .center}) =>
      BoxStyler().rotate(angle, alignment: alignment);

  static BoxMutableStyler get chain => .new(BoxStyler());

  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }

  @override
  BoxStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return merge(BoxStyler(transform: value, transformAlignment: alignment));
  }
}

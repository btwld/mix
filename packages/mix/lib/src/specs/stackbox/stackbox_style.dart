import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
import '../box/box_spec.dart';
import '../box/box_style.dart';
import '../stack/stack_spec.dart';
import '../stack/stack_style.dart';
import 'stackbox_mutable_style.dart';
import 'stackbox_spec.dart';
import 'stackbox_widget.dart';

part 'stackbox_style.g.dart';

/// Represents the attributes of a [StackBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackBoxSpec].
///
/// Use this class to configure the attributes of a [StackBoxSpec] and pass it to
/// the [StackBoxSpec] constructor.
@MixableStyler(methods: GeneratedStylerMethods.skipSetters)
class StackBoxStyler extends MixStyler<StackBoxStyler, StackBoxSpec>
    with
        BorderStyleMixin<StackBoxStyler>,
        BorderRadiusStyleMixin<StackBoxStyler>,
        ShadowStyleMixin<StackBoxStyler>,
        DecorationStyleMixin<StackBoxStyler>,
        SpacingStyleMixin<StackBoxStyler>,
        TransformStyleMixin<StackBoxStyler>,
        ConstraintStyleMixin<StackBoxStyler>,
        _$StackBoxStylerMixin {
  @override
  final Prop<StyleSpec<BoxSpec>>? $box;
  @override
  final Prop<StyleSpec<StackSpec>>? $stack;

  /// Main constructor with individual property parameters
  StackBoxStyler({
    // Box properties
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    // Stack properties
    AlignmentGeometry? stackAlignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? stackClipBehavior,
    // Style properties
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<StackBoxSpec>>? variants,
  }) : this.create(
         box: Prop.maybeMix(
           BoxStyler(
             alignment: alignment,
             padding: padding,
             margin: margin,
             constraints: constraints,
             decoration: decoration,
             foregroundDecoration: foregroundDecoration,
             transform: transform,
             transformAlignment: transformAlignment,
             clipBehavior: clipBehavior,
           ),
         ),
         stack: Prop.maybeMix(
           StackStyler(
             alignment: stackAlignment,
             fit: fit,
             textDirection: textDirection,
             clipBehavior: stackClipBehavior,
           ),
         ),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  /// Create constructor with Prop`<T>` types for internal use
  const StackBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<StackSpec>>? stack,
    super.animation,
    super.modifier,
    super.variants,
  }) : $box = box,
       $stack = stack;

  // Factory constructors for dot-shorthand notation.
  // Keep only base primitives and non-compound conveniences.

  // Direct constructor params (Box + Stack)
  factory StackBoxStyler.alignment(AlignmentGeometry value) =>
      StackBoxStyler(alignment: value);
  factory StackBoxStyler.padding(EdgeInsetsGeometryMix value) =>
      StackBoxStyler(padding: value);
  factory StackBoxStyler.margin(EdgeInsetsGeometryMix value) =>
      StackBoxStyler(margin: value);
  factory StackBoxStyler.constraints(BoxConstraintsMix value) =>
      StackBoxStyler(constraints: value);
  factory StackBoxStyler.decoration(DecorationMix value) =>
      StackBoxStyler(decoration: value);
  factory StackBoxStyler.foregroundDecoration(DecorationMix value) =>
      StackBoxStyler(foregroundDecoration: value);
  factory StackBoxStyler.clipBehavior(Clip value) =>
      StackBoxStyler(clipBehavior: value);
  factory StackBoxStyler.stackAlignment(AlignmentGeometry value) =>
      StackBoxStyler(stackAlignment: value);
  factory StackBoxStyler.fit(StackFit value) => StackBoxStyler(fit: value);

  // Decoration convenience
  factory StackBoxStyler.color(Color value) => StackBoxStyler().color(value);
  factory StackBoxStyler.gradient(GradientMix value) =>
      StackBoxStyler().gradient(value);
  factory StackBoxStyler.border(BoxBorderMix value) =>
      StackBoxStyler().border(value);
  factory StackBoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      StackBoxStyler().borderRadius(value);
  factory StackBoxStyler.elevation(ElevationShadow value) =>
      StackBoxStyler().elevation(value);
  factory StackBoxStyler.shadow(BoxShadowMix value) =>
      StackBoxStyler().shadow(value);
  factory StackBoxStyler.shadows(List<BoxShadowMix> value) =>
      StackBoxStyler().shadows(value);

  // Constraints convenience
  factory StackBoxStyler.width(double value) => StackBoxStyler().width(value);
  factory StackBoxStyler.height(double value) => StackBoxStyler().height(value);
  factory StackBoxStyler.size(double width, double height) =>
      StackBoxStyler().size(width, height);
  factory StackBoxStyler.minWidth(double value) =>
      StackBoxStyler().minWidth(value);
  factory StackBoxStyler.maxWidth(double value) =>
      StackBoxStyler().maxWidth(value);
  factory StackBoxStyler.minHeight(double value) =>
      StackBoxStyler().minHeight(value);
  factory StackBoxStyler.maxHeight(double value) =>
      StackBoxStyler().maxHeight(value);

  // Transform convenience
  factory StackBoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      StackBoxStyler().scale(scale, alignment: alignment);
  factory StackBoxStyler.rotate(
    double angle, {
    Alignment alignment = .center,
  }) => StackBoxStyler().rotate(angle, alignment: alignment);

  // Style metadata convenience
  factory StackBoxStyler.animate(AnimationConfig value) =>
      StackBoxStyler().animate(value);

  static StackBoxMutableStyler get chain => .new(StackBoxStyler());

  // Box-style instance methods

  /// Sets the alignment for the box.
  StackBoxStyler alignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(alignment: value));
  }

  /// Sets the transform alignment for the box.
  StackBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(transformAlignment: value));
  }

  /// Sets the clip behavior for the box.
  StackBoxStyler clipBehavior(Clip value) {
    return merge(StackBoxStyler(clipBehavior: value));
  }

  /// Sets the widget modifier.
  StackBoxStyler modifier(WidgetModifierConfig value) {
    return merge(StackBoxStyler(modifier: value));
  }

  StackBox call({Key? key, required List<Widget> children}) {
    return StackBox(key: key, style: this, children: children);
  }

  // Stack property methods
  /// Sets the alignment for the Stack widget.
  StackBoxStyler stackAlignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(stackAlignment: value));
  }

  /// Sets how the Stack widget sizes itself based on its children.
  StackBoxStyler fit(StackFit value) {
    return merge(StackBoxStyler(fit: value));
  }

  /// Sets the text direction for the Stack widget.
  StackBoxStyler textDirection(TextDirection value) {
    return merge(StackBoxStyler(textDirection: value));
  }

  /// Sets the clip behavior for the Stack widget.
  StackBoxStyler stackClipBehavior(Clip value) {
    return merge(StackBoxStyler(stackClipBehavior: value));
  }

  /// Applies a custom StackStyler to the StackBox.
  StackBoxStyler stack(StackStyler value) {
    return merge(StackBoxStyler.create(stack: Prop.maybeMix(value)));
  }

  /// Sets animation
  @override
  StackBoxStyler animate(AnimationConfig animation) {
    return merge(StackBoxStyler(animation: animation));
  }

  /// Foreground decoration instance method
  @override
  StackBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(StackBoxStyler(foregroundDecoration: value));
  }

  /// Padding instance method
  @override
  StackBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyler(padding: value));
  }

  /// Margin instance method
  @override
  StackBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyler(margin: value));
  }

  /// Sets the transform for the box.
  @override
  StackBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      StackBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  /// Decoration instance method - delegates to box
  @override
  StackBoxStyler decoration(DecorationMix value) {
    return merge(StackBoxStyler(decoration: value));
  }

  /// Constraints instance method
  @override
  StackBoxStyler constraints(BoxConstraintsMix value) {
    return merge(StackBoxStyler(constraints: value));
  }

  /// Modifier instance method
  @override
  StackBoxStyler wrap(WidgetModifierConfig value) {
    return modifier(value);
  }

  /// Sets the variants list.
  @override
  StackBoxStyler variants(List<VariantStyle<StackBoxSpec>> variants) {
    return merge(StackBoxStyler(variants: variants));
  }

  /// Sets the border radius property via decoration.
  @override
  StackBoxStyler borderRadius(BorderRadiusGeometryMix value) {
    return merge(StackBoxStyler(decoration: DecorationMix.borderRadius(value)));
  }

  /// Border instance method
  @override
  StackBoxStyler border(BoxBorderMix value) {
    return merge(StackBoxStyler(decoration: DecorationMix.border(value)));
  }
}

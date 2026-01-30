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
import '../../style/mixins/animation_style_mixin.dart';
import '../../style/mixins/border_radius_style_mixin.dart';
import '../../style/mixins/border_style_mixin.dart';
import '../../style/mixins/constraint_style_mixin.dart';
import '../../style/mixins/decoration_style_mixin.dart';
import '../../style/mixins/flex_style_mixin.dart';
import '../../style/mixins/shadow_style_mixin.dart';
import '../../style/mixins/spacing_style_mixin.dart';
import '../../style/mixins/transform_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import '../../style/mixins/widget_state_variant_mixin.dart';
import '../box/box_spec.dart';
import '../box/box_style.dart';
import '../flex/flex_spec.dart';
import '../flex/flex_style.dart';
import 'flexbox_mutable_style.dart';
import 'flexbox_spec.dart';
import 'flexbox_widget.dart';

part 'flexbox_style.g.dart';

@Deprecated('Use FlexBoxStyler instead')
typedef FlexBoxMix = FlexBoxStyler;

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
@MixableStyler(methods: GeneratedStylerMethods.skipSetters)
class FlexBoxStyler extends Style<FlexBoxSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<FlexBoxStyler, FlexBoxSpec>,
        VariantStyleMixin<FlexBoxStyler, FlexBoxSpec>,
        WidgetStateVariantMixin<FlexBoxStyler, FlexBoxSpec>,
        BorderStyleMixin<FlexBoxStyler>,
        BorderRadiusStyleMixin<FlexBoxStyler>,
        ShadowStyleMixin<FlexBoxStyler>,
        DecorationStyleMixin<FlexBoxStyler>,
        SpacingStyleMixin<FlexBoxStyler>,
        TransformStyleMixin<FlexBoxStyler>,
        ConstraintStyleMixin<FlexBoxStyler>,
        FlexStyleMixin<FlexBoxStyler>,
        AnimationStyleMixin<FlexBoxStyler, FlexBoxSpec>,
        _$FlexBoxStylerMixin {
  @override
  final Prop<StyleSpec<BoxSpec>>? $box;
  @override
  final Prop<StyleSpec<FlexSpec>>? $flex;

  /// Main constructor with individual property parameters
  FlexBoxStyler({
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
    // Flex properties
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? flexClipBehavior,
    double? spacing,
    // Style properties
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<FlexBoxSpec>>? variants,
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
         flex: Prop.maybeMix(
           FlexStyler(
             direction: direction,
             mainAxisAlignment: mainAxisAlignment,
             crossAxisAlignment: crossAxisAlignment,
             mainAxisSize: mainAxisSize,
             verticalDirection: verticalDirection,
             textDirection: textDirection,
             textBaseline: textBaseline,
             clipBehavior: flexClipBehavior,
             spacing: spacing,
           ),
         ),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  /// Create constructor with Prop`<T>` types for internal use
  const FlexBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<FlexSpec>>? flex,
    super.animation,
    super.modifier,
    super.variants,
  }) : $box = box,
       $flex = flex;

  static FlexBoxMutableStyler get chain => .new(FlexBoxStyler());

  // BoxMix instance methods

  /// Sets the alignment property.
  FlexBoxStyler alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(alignment: value));
  }

  /// Sets the transform alignment.
  FlexBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(transformAlignment: value));
  }

  /// Sets the clip behavior.
  FlexBoxStyler clipBehavior(Clip value) {
    return merge(FlexBoxStyler(clipBehavior: value));
  }

  /// Sets gap value (deprecated).
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyler gap(double value) {
    return merge(FlexBoxStyler(spacing: value));
  }

  /// Sets the widget modifier.
  FlexBoxStyler modifier(WidgetModifierConfig value) {
    return merge(FlexBoxStyler(modifier: value));
  }

  /// Creates a FlexBox widget with children.
  FlexBox call({Key? key, required List<Widget> children}) {
    return FlexBox(key: key, style: this, children: children);
  }

  /// Sets the animation property.
  @override
  FlexBoxStyler animate(AnimationConfig animation) {
    return merge(FlexBoxStyler(animation: animation));
  }

  /// Sets the foreground decoration.
  @override
  FlexBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyler(foregroundDecoration: value));
  }

  /// Sets the flex property.
  @override
  FlexBoxStyler flex(FlexStyler value) {
    return merge(FlexBoxStyler.create(flex: Prop.maybeMix(value)));
  }

  /// Sets the padding property.
  @override
  FlexBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(padding: value));
  }

  /// Sets the margin property.
  @override
  FlexBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(margin: value));
  }

  /// Sets the transform property.
  @override
  FlexBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      FlexBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  /// Sets the decoration property.
  @override
  FlexBoxStyler decoration(DecorationMix value) {
    return merge(FlexBoxStyler(decoration: value));
  }

  /// Sets the constraints property.
  @override
  FlexBoxStyler constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyler(constraints: value));
  }

  /// Sets the widget modifier (wrap).
  @override
  FlexBoxStyler wrap(WidgetModifierConfig value) {
    return modifier(value);
  }

  /// Sets the variants list.
  @override
  FlexBoxStyler variants(List<VariantStyle<FlexBoxSpec>> variants) {
    return merge(FlexBoxStyler(variants: variants));
  }

  /// Sets the border radius property via decoration.
  @override
  FlexBoxStyler borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxStyler(decoration: DecorationMix.borderRadius(value)));
  }

  /// Sets the border property via decoration.
  @override
  FlexBoxStyler border(BoxBorderMix value) {
    return merge(FlexBoxStyler(decoration: DecorationMix.border(value)));
  }
}

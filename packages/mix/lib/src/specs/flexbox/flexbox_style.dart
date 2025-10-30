import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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

typedef FlexBoxMix = FlexBoxStyler;

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
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
        FlexStyleMixin<FlexBoxStyler> {
  final Prop<StyleSpec<BoxSpec>>? $box;
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

  static FlexBoxMutableStyler get chain =>
      FlexBoxMutableStyler(FlexBoxStyler());

  /// Sets animation
  FlexBoxStyler animate(AnimationConfig animation) {
    return merge(FlexBoxStyler(animation: animation));
  }

  // BoxMix instance methods

  FlexBoxStyler alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(alignment: value));
  }

  FlexBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(transformAlignment: value));
  }

  FlexBoxStyler clipBehavior(Clip value) {
    return merge(FlexBoxStyler(clipBehavior: value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyler gap(double value) {
    return merge(FlexBoxStyler(spacing: value));
  }

  FlexBoxStyler modifier(WidgetModifierConfig value) {
    return merge(FlexBoxStyler(modifier: value));
  }

  FlexBox call({Key? key, required List<Widget> children}) {
    return FlexBox(key: key, style: this, children: children);
  }

  /// Foreground decoration instance method
  @override
  FlexBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyler(foregroundDecoration: value));
  }

  // FlexMixin implementation
  @override
  FlexBoxStyler flex(FlexStyler value) {
    return merge(FlexBoxStyler.create(flex: Prop.maybeMix(value)));
  }

  /// Padding instance method
  @override
  FlexBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(padding: value));
  }

  /// Margin instance method
  @override
  FlexBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(margin: value));
  }

  @override
  FlexBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      FlexBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  /// Decoration instance method - delegates to box
  @override
  FlexBoxStyler decoration(DecorationMix value) {
    return merge(FlexBoxStyler(decoration: value));
  }

  /// Constraints instance method
  @override
  FlexBoxStyler constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyler(constraints: value));
  }

  /// Modifier instance method
  @override
  FlexBoxStyler wrap(WidgetModifierConfig value) {
    return modifier(value);
  }

  @override
  FlexBoxStyler variants(List<VariantStyle<FlexBoxSpec>> variants) {
    return merge(FlexBoxStyler(variants: variants));
  }

  /// Border radius instance method
  @override
  FlexBoxStyler borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxStyler(decoration: DecorationMix.borderRadius(value)));
  }

  /// Border instance method
  @override
  FlexBoxStyler border(BoxBorderMix value) {
    return merge(FlexBoxStyler(decoration: DecorationMix.border(value)));
  }

  /// Resolves to [FlexBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexBoxStyleSpec = FlexBoxStyler(...).resolve(context);
  /// ```
  @override
  StyleSpec<FlexBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final flexSpec = MixOps.resolve(context, $flex);

    final flexBoxSpec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

    return StyleSpec(
      spec: flexBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [FlexBoxStyler] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxStyler] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxStyler merge(FlexBoxStyler? other) {
    return FlexBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      flex: MixOps.merge($flex, other?.$flex),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      variants: MixOps.mergeVariants($variants, other?.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('flex', $flex));
  }

  /// The list of properties that constitute the state of this [FlexBoxStyler].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxStyler] instances for equality.
  @override
  List<Object?> get props => [$box, $flex];
}

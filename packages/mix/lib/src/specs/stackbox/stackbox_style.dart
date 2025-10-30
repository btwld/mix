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
import '../../style/mixins/shadow_style_mixin.dart';
import '../../style/mixins/spacing_style_mixin.dart';
import '../../style/mixins/transform_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import '../../style/mixins/widget_state_variant_mixin.dart';
import '../box/box_spec.dart';
import '../box/box_style.dart';
import '../stack/stack_spec.dart';
import '../stack/stack_style.dart';
import 'stackbox_mutable_style.dart';
import 'stackbox_spec.dart';
import 'stackbox_widget.dart';

typedef StackBoxMix = StackBoxStyler;

/// Represents the attributes of a [StackBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackBoxSpec].
///
/// Use this class to configure the attributes of a [StackBoxSpec] and pass it to
/// the [StackBoxSpec] constructor.
class StackBoxStyler extends Style<StackBoxSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<StackBoxStyler, StackBoxSpec>,
        VariantStyleMixin<StackBoxStyler, StackBoxSpec>,
        WidgetStateVariantMixin<StackBoxStyler, StackBoxSpec>,
        BorderStyleMixin<StackBoxStyler>,
        BorderRadiusStyleMixin<StackBoxStyler>,
        ShadowStyleMixin<StackBoxStyler>,
        DecorationStyleMixin<StackBoxStyler>,
        SpacingStyleMixin<StackBoxStyler>,
        TransformStyleMixin<StackBoxStyler>,
        ConstraintStyleMixin<StackBoxStyler> {
  final Prop<StyleSpec<BoxSpec>>? $box;
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

  static StackBoxMutableStyler get chain =>
      StackBoxMutableStyler(StackBoxStyler());

  /// Sets animation
  StackBoxStyler animate(AnimationConfig animation) {
    return merge(StackBoxStyler(animation: animation));
  }

  // BoxMix instance methods

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

  /// Resolves to [StackBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final stackBoxStyleSpec = StackBoxStyler(...).resolve(context);
  /// ```
  @override
  StyleSpec<StackBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final stackSpec = MixOps.resolve(context, $stack);

    final stackBoxSpec = StackBoxSpec(box: boxSpec, stack: stackSpec);

    return StyleSpec(
      spec: stackBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [StackBoxStyler] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackBoxStyler] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StackBoxStyler merge(StackBoxStyler? other) {
    return StackBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      stack: MixOps.merge($stack, other?.$stack),
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
      ..add(DiagnosticsProperty('stack', $stack));
  }

  /// The list of properties that constitute the state of this [StackBoxStyler].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxStyler] instances for equality.
  @override
  List<Object?> get props => [$box, $stack];
}

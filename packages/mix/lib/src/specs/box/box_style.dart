import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
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
import 'box_mix.dart';
import 'box_spec.dart';
import 'box_util.dart';
import 'box_widget.dart';

/// Style class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts with support for
/// widget modifiers, variants, and animations.
class BoxStyle extends Style<BoxSpec>
    with
        Diagnosticable,
        StyleModifierMixin<BoxStyle, BoxSpec>,
        StyleVariantMixin<BoxStyle, BoxSpec>,
        BorderRadiusMixin<BoxStyle>,
        DecorationMixin<BoxStyle>,
        SpacingMixin<BoxStyle>,
        TransformMixin<BoxStyle>,
        ConstraintsMixin<BoxStyle>,
        StyleAnimationMixin<BoxSpec, BoxStyle> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<EdgeInsetsGeometry>? $margin;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Decoration>? $decoration;
  final Prop<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  const BoxStyle.create({
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
    super.inherit,
  }) : $alignment = alignment,
       $padding = padding,
       $margin = margin,
       $constraints = constraints,
       $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  BoxStyle({
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
    bool? inherit,
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
         inherit: inherit,
       );

  /// Constructor that accepts a [BoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxSpec] instances to [BoxStyle].
  ///
  /// ```dart
  /// const spec = BoxSpec(alignment: Alignment.center, padding: EdgeInsets.all(8));
  /// final attr = BoxStyle.value(spec);
  /// ```
  BoxStyle.value(BoxSpec spec)
    : this(
        alignment: spec.alignment,
        padding: EdgeInsetsGeometryMix.maybeValue(spec.padding),
        margin: EdgeInsetsGeometryMix.maybeValue(spec.margin),
        constraints: BoxConstraintsMix.maybeValue(spec.constraints),
        decoration: DecorationMix.maybeValue(spec.decoration),
        foregroundDecoration: DecorationMix.maybeValue(
          spec.foregroundDecoration,
        ),
        transform: spec.transform,
        transformAlignment: spec.transformAlignment,
        clipBehavior: spec.clipBehavior,
      );

  /// Static method to create BoxStyle from nullable BoxSpec.
  static BoxStyle? maybeValue(BoxSpec? spec) {
    return spec != null ? BoxStyle.value(spec) : null;
  }

  /// Factory constructor to create BoxStyle from BoxMix.
  static BoxStyle from(BoxMix mix) {
    return BoxStyle.create(
      alignment: mix.$alignment,
      padding: mix.$padding,
      margin: mix.$margin,
      constraints: mix.$constraints,
      decoration: mix.$decoration,
      foregroundDecoration: mix.$foregroundDecoration,
      transform: mix.$transform,
      transformAlignment: mix.$transformAlignment,
      clipBehavior: mix.$clipBehavior,
    );
  }

  BoxSpecUtility get builder => BoxSpecUtility(this);

  BoxStyle transformAlignment(AlignmentGeometry value) {
    return merge(BoxStyle(transformAlignment: value));
  }

  BoxStyle clipBehavior(Clip value) {
    return merge(BoxStyle(clipBehavior: value));
  }

  BoxStyle alignment(AlignmentGeometry value) {
    return merge(BoxStyle(alignment: value));
  }

  /// Foreground decoration instance method
  BoxStyle foregroundDecoration(DecorationMix value) {
    return merge(BoxStyle(foregroundDecoration: value));
  }

  Box call({Widget? child}) {
    return Box(style: this, child: child);
  }

  /// Modifier instance method
  BoxStyle modifier(ModifierConfig value) {
    return merge(BoxStyle(modifier: value));
  }

  @override
  BoxStyle transform(Matrix4 value) {
    return merge(BoxStyle(transform: value));
  }

  /// Constraints instance method
  @override
  BoxStyle constraints(BoxConstraintsMix value) {
    return merge(BoxStyle(constraints: value));
  }

  /// Padding instance method
  @override
  BoxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(BoxStyle(padding: value));
  }

  /// Margin instance method
  @override
  BoxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(BoxStyle(margin: value));
  }

  /// Decoration instance method
  @override
  BoxStyle decoration(DecorationMix value) {
    return merge(BoxStyle(decoration: value));
  }

  /// Animation instance method
  @override
  BoxStyle animate(AnimationConfig animation) {
    return merge(BoxStyle(animation: animation));
  }

  /// Mixin implementation
  @override
  BoxStyle wrap(ModifierConfig value) {
    return modifier(value);
  }

  /// Border radius instance method
  @override
  BoxStyle borderRadius(BorderRadiusGeometryMix value) {
    return merge(BoxStyle(decoration: DecorationMix.borderRadius(value)));
  }

  @override
  BoxStyle variants(List<VariantStyle<BoxSpec>> value) {
    return merge(BoxStyle(variants: value));
  }

  @override
  BoxStyle variant(Variant variant, BoxStyle style) {
    return merge(BoxStyle(variants: [VariantStyle(variant, style)]));
  }

  /// Resolves to [WidgetSpec<BoxSpec>] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final wrappedSpec = BoxStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<BoxSpec> resolve(BuildContext context) {
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
    return WidgetSpec(
      spec: boxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  /// Merges the properties of this [BoxStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxStyle merge(BoxStyle? other) {
    if (other == null) return this;

    return BoxStyle.create(
      alignment: MixOps.merge($alignment, other.$alignment),
      padding: MixOps.merge($padding, other.$padding),
      margin: MixOps.merge($margin, other.$margin),
      constraints: MixOps.merge($constraints, other.$constraints),
      decoration: MixOps.merge($decoration, other.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other.$foregroundDecoration,
      ),
      transform: MixOps.merge($transform, other.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other.$transformAlignment,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
      variants: mergeVariantLists($variants, other.$variants),
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      animation: other.$animation ?? $animation,
      inherit: other.$inherit ?? $inherit,
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
  /// compare two [BoxStyle] instances for equality.
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
    $inherit,
  ];
}

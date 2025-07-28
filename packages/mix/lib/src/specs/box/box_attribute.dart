import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_util.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/decoration_image_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../properties/painting/gradient_mix.dart';
import '../../properties/painting/shadow_mix.dart';
import '../../properties/painting/shape_border_mix.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'box_spec.dart';

/// Attribute class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts.
class BoxSpecAttribute extends StyleAttribute<BoxSpec>
    with
        Diagnosticable,
        ModifierMixin<BoxSpecAttribute, BoxSpec>,
        VariantMixin<BoxSpecAttribute, BoxSpec> {
  final Prop<AlignmentGeometry>? $alignment;
  final MixProp<EdgeInsetsGeometry>? $padding;
  final MixProp<EdgeInsetsGeometry>? $margin;
  final MixProp<BoxConstraints>? $constraints;
  final MixProp<Decoration>? $decoration;
  final MixProp<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  /// Color factory
  factory BoxSpecAttribute.color(Color value) {
    return BoxSpecAttribute(decoration: DecorationMix.color(value));
  }

  /// Gradient factory
  factory BoxSpecAttribute.gradient(GradientMix value) {
    return BoxSpecAttribute(decoration: DecorationMix.gradient(value));
  }

  /// Shape factory
  factory BoxSpecAttribute.shape(BoxShape value) {
    return BoxSpecAttribute(decoration: DecorationMix.shape(value));
  }

  factory BoxSpecAttribute.height(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.height(value));
  }

  factory BoxSpecAttribute.width(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.width(value));
  }

  /// constraints
  factory BoxSpecAttribute.constraints(BoxConstraintsMix value) {
    return BoxSpecAttribute(constraints: value);
  }

  /// minWidth
  factory BoxSpecAttribute.minWidth(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.minWidth(value));
  }

  /// maxWidth
  factory BoxSpecAttribute.maxWidth(double value) {
    return BoxSpecAttribute(constraints: BoxConstraintsMix.maxWidth(value));
  }

  /// Animation
  factory BoxSpecAttribute.animation(AnimationConfig value) {
    return BoxSpecAttribute(animation: value);
  }

  /// Variant
  factory BoxSpecAttribute.variant(Variant variant, BoxSpecAttribute value) {
    return BoxSpecAttribute(variants: [VariantStyleAttribute(variant, value)]);
  }

  /// minHeight
  factory BoxSpecAttribute.minHeight(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.minHeight(value));
  }

  /// maxHeight
  factory BoxSpecAttribute.maxHeight(double value) {
    return BoxSpecAttribute(constraints: BoxConstraintsMix.maxHeight(value));
  }

  factory BoxSpecAttribute.foregroundDecoration(DecorationMix value) {
    return BoxSpecAttribute(foregroundDecoration: value);
  }

  factory BoxSpecAttribute.decoration(DecorationMix value) {
    return BoxSpecAttribute(decoration: value);
  }

  factory BoxSpecAttribute.alignment(AlignmentGeometry value) {
    return BoxSpecAttribute(alignment: value);
  }

  factory BoxSpecAttribute.padding(EdgeInsetsGeometryMix value) {
    return BoxSpecAttribute(padding: value);
  }

  factory BoxSpecAttribute.margin(EdgeInsetsGeometryMix value) {
    return BoxSpecAttribute(margin: value);
  }

  factory BoxSpecAttribute.transform(Matrix4 value) {
    return BoxSpecAttribute(transform: value);
  }

  /// Animation
  factory BoxSpecAttribute.animate(AnimationConfig animation) {
    return BoxSpecAttribute(animation: animation);
  }

  factory BoxSpecAttribute.transformAlignment(AlignmentGeometry value) {
    return BoxSpecAttribute(transformAlignment: value);
  }

  factory BoxSpecAttribute.clipBehavior(Clip value) {
    return BoxSpecAttribute(clipBehavior: value);
  }

  /// border
  factory BoxSpecAttribute.border(BoxBorderMix value) {
    return BoxSpecAttribute(decoration: DecorationMix.border(value));
  }

  /// Border radius
  factory BoxSpecAttribute.borderRadius(BorderRadiusGeometryMix value) {
    return BoxSpecAttribute(decoration: DecorationMix.borderRadius(value));
  }

  const BoxSpecAttribute.raw({
    Prop<AlignmentGeometry>? alignment,
    MixProp<EdgeInsetsGeometry>? padding,
    MixProp<EdgeInsetsGeometry>? margin,
    MixProp<BoxConstraints>? constraints,
    MixProp<Decoration>? decoration,
    MixProp<Decoration>? foregroundDecoration,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $alignment = alignment,
       $padding = padding,
       $margin = margin,
       $constraints = constraints,
       $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  BoxSpecAttribute({
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
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<BoxSpec>>? variants,
  }) : this.raw(
         alignment: Prop.maybe(alignment),
         padding: MixProp.maybe(padding),
         margin: MixProp.maybe(margin),
         constraints: MixProp.maybe(constraints),
         decoration: MixProp.maybe(decoration),
         foregroundDecoration: MixProp.maybe(foregroundDecoration),
         transform: Prop.maybe(transform),
         transformAlignment: Prop.maybe(transformAlignment),
         clipBehavior: Prop.maybe(clipBehavior),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  /// Constructor that accepts a [BoxSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [BoxSpec] instances to [BoxSpecAttribute].
  ///
  /// ```dart
  /// const spec = BoxSpec(alignment: Alignment.center, padding: EdgeInsets.all(8));
  /// final attr = BoxSpecAttribute.value(spec);
  /// ```
  BoxSpecAttribute.value(BoxSpec spec)
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

  /// Constructor that accepts a nullable [BoxSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [BoxSpecAttribute.value].
  ///
  /// ```dart
  /// const BoxSpec? spec = BoxSpec(alignment: Alignment.center, padding: EdgeInsets.all(8));
  /// final attr = BoxSpecAttribute.maybeValue(spec); // Returns BoxSpecAttribute or null
  /// ```
  static BoxSpecAttribute? maybeValue(BoxSpec? spec) {
    return spec != null ? BoxSpecAttribute.value(spec) : null;
  }

  BoxSpecAttribute transformAlignment(AlignmentGeometry value) {
    return merge(BoxSpecAttribute(transformAlignment: value));
  }

  BoxSpecAttribute clipBehavior(Clip value) {
    return merge(BoxSpecAttribute(clipBehavior: value));
  }

  /// Sets background color
  BoxSpecAttribute color(Color value) {
    return decoration(DecorationMix.color(value));
  }

  /// Sets both min and max width to create a fixed width
  BoxSpecAttribute width(double value) {
    return constraints(BoxConstraintsMix.width(value));
  }

  /// Sets both min and max height to create a fixed height
  BoxSpecAttribute height(double value) {
    return constraints(BoxConstraintsMix.height(value));
  }

  /// Sets rotation transform
  BoxSpecAttribute rotate(double angle) {
    return transform(Matrix4.rotationZ(angle));
  }

  /// Sets scale transform
  BoxSpecAttribute scale(double scale) {
    return transform(Matrix4.diagonal3Values(scale, scale, 1.0));
  }

  /// Sets translation transform
  BoxSpecAttribute translate(double x, double y, [double z = 0.0]) {
    return transform(Matrix4.translationValues(x, y, z));
  }

  /// Sets skew transform
  BoxSpecAttribute skew(double skewX, double skewY) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 1, skewX);
    matrix.setEntry(1, 0, skewY);

    return transform(matrix);
  }

  /// Resets transform to identity (no effect)
  BoxSpecAttribute transformReset() {
    return transform(Matrix4.identity());
  }

  /// Sets minimum width constraint
  BoxSpecAttribute minWidth(double value) {
    return constraints(BoxConstraintsMix.minWidth(value));
  }

  /// Sets maximum width constraint
  BoxSpecAttribute maxWidth(double value) {
    return constraints(BoxConstraintsMix.maxWidth(value));
  }

  /// Sets minimum height constraint
  BoxSpecAttribute minHeight(double value) {
    return constraints(BoxConstraintsMix.minHeight(value));
  }

  /// Sets maximum height constraint
  BoxSpecAttribute maxHeight(double value) {
    return constraints(BoxConstraintsMix.maxHeight(value));
  }

  /// Sets both width and height to specific values
  BoxSpecAttribute size(double width, double height) {
    return constraints(
      BoxConstraintsMix(
        minWidth: width,
        maxWidth: width,
        minHeight: height,
        maxHeight: height,
      ),
    );
  }

  /// Sets box shape
  BoxSpecAttribute shape(ShapeBorderMix value) {
    return decoration(ShapeDecorationMix(shape: value));
  }

  BoxSpecAttribute alignment(AlignmentGeometry value) {
    return merge(BoxSpecAttribute(alignment: value));
  }

  /// Sets single shadow
  BoxSpecAttribute shadow(BoxShadowMix value) {
    return decoration(BoxDecorationMix.boxShadow([value]));
  }

  /// Sets multiple shadows
  BoxSpecAttribute shadows(List<BoxShadowMix> value) {
    return decoration(BoxDecorationMix.boxShadow(value));
  }

  /// Sets elevation shadow
  BoxSpecAttribute elevation(ElevationShadow value) {
    return decoration(
      BoxDecorationMix.boxShadow(BoxShadowMix.fromElevation(value)),
    );
  }

  /// Animation instance method
  BoxSpecAttribute animate(AnimationConfig animation) {
    return merge(BoxSpecAttribute(animation: animation));
  }

  /// Modifier instance method
  BoxSpecAttribute wrap(ModifierAttribute modifier) {
    return merge(BoxSpecAttribute(modifiers: [modifier]));
  }

  /// Border instance method
  BoxSpecAttribute border(BoxBorderMix value) {
    return merge(BoxSpecAttribute(decoration: DecorationMix.border(value)));
  }

  /// Padding instance method
  BoxSpecAttribute padding(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecAttribute(padding: value));
  }

  /// Margin instance method

  BoxSpecAttribute margin(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecAttribute(margin: value));
  }

  /// Border radius instance method

  BoxSpecAttribute borderRadius(BorderRadiusGeometryMix value) {
    return merge(
      BoxSpecAttribute(decoration: DecorationMix.borderRadius(value)),
    );
  }

  BoxSpecAttribute transform(Matrix4 value) {
    return merge(BoxSpecAttribute(transform: value));
  }

  /// Color instance method
  /// Decoration instance method
  BoxSpecAttribute decoration(DecorationMix value) {
    return merge(BoxSpecAttribute(decoration: value));
  }

  /// Foreground decoration instance method
  BoxSpecAttribute foregroundDecoration(DecorationMix value) {
    return merge(BoxSpecAttribute.foregroundDecoration(value));
  }

  /// Constraints instance method
  BoxSpecAttribute constraints(BoxConstraintsMix value) {
    return merge(BoxSpecAttribute.constraints(value));
  }

  /// Sets gradient with any GradientMix type
  BoxSpecAttribute gradient(GradientMix value) {
    return merge(BoxSpecAttribute.gradient(value));
  }

  /// Sets image decoration
  BoxSpecAttribute image(DecorationImageMix value) {
    return decoration(DecorationMix.image(value));
  }

  @override
  BoxSpecAttribute variants(List<VariantStyleAttribute<BoxSpec>> value) {
    return merge(BoxSpecAttribute(variants: value));
  }

  @override
  BoxSpecAttribute variant(Variant variant, BoxSpecAttribute style) {
    return merge(
      BoxSpecAttribute(variants: [VariantStyleAttribute(variant, style)]),
    );
  }

  /// The list of properties that constitute the state of this [BoxSpecAttribute].
  @override
  BoxSpecAttribute modifiers(List<ModifierAttribute> value) {
    return merge(BoxSpecAttribute(modifiers: value));
  }

  /// Resolves to [BoxSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final boxSpec = BoxSpecAttribute(...).resolve(mix);
  /// ```
  @override
  BoxSpec resolve(BuildContext context) {
    return BoxSpec(
      alignment: MixHelpers.resolve(context, $alignment),
      padding: MixHelpers.resolve(context, $padding),
      margin: MixHelpers.resolve(context, $margin),
      constraints: MixHelpers.resolve(context, $constraints),
      decoration: MixHelpers.resolve(context, $decoration),
      foregroundDecoration: MixHelpers.resolve(context, $foregroundDecoration),
      transform: MixHelpers.resolve(context, $transform),
      transformAlignment: MixHelpers.resolve(context, $transformAlignment),
      clipBehavior: MixHelpers.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [BoxSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxSpecAttribute merge(BoxSpecAttribute? other) {
    if (other == null) return this;

    return BoxSpecAttribute.raw(
      alignment: MixHelpers.merge($alignment, other.$alignment),
      padding: MixHelpers.merge($padding, other.$padding),
      margin: MixHelpers.merge($margin, other.$margin),
      constraints: MixHelpers.merge($constraints, other.$constraints),
      decoration: MixHelpers.merge($decoration, other.$decoration),
      foregroundDecoration: MixHelpers.merge(
        $foregroundDecoration,
        other.$foregroundDecoration,
      ),
      transform: MixHelpers.merge($transform, other.$transform),
      transformAlignment: MixHelpers.merge(
        $transformAlignment,
        other.$transformAlignment,
      ),
      clipBehavior: MixHelpers.merge($clipBehavior, other.$clipBehavior),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', $alignment, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('padding', $padding, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('margin', $margin, defaultValue: null));
    properties.add(
      DiagnosticsProperty('constraints', $constraints, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('decoration', $decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'foregroundDecoration',
        $foregroundDecoration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('transform', $transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'transformAlignment',
        $transformAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', $clipBehavior, defaultValue: null),
    );
  }

  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxSpecAttribute] instances for equality.
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
    $modifiers,
    $variants,
  ];
}

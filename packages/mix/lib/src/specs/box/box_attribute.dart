import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/spec.dart';
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

abstract class StyleMixAttribute<T extends Style<S>, S extends Spec<S>>
    extends Style<S>
    with StyleModifierMixin<T, S>, StyleVariantMixin<T, S> {}

/// Attribute class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts.
class BoxMix extends Style<BoxSpec>
    with
        Diagnosticable,
        StyleModifierMixin<BoxMix, BoxSpec>,
        StyleVariantMixin<BoxMix, BoxSpec> {
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
  factory BoxMix.color(Color value) {
    return BoxMix(decoration: DecorationMix.color(value));
  }

  /// Gradient factory
  factory BoxMix.gradient(GradientMix value) {
    return BoxMix(decoration: DecorationMix.gradient(value));
  }

  /// Shape factory
  factory BoxMix.shape(BoxShape value) {
    return BoxMix(decoration: DecorationMix.shape(value));
  }

  factory BoxMix.height(double value) {
    return BoxMix.constraints(BoxConstraintsMix.height(value));
  }

  factory BoxMix.width(double value) {
    return BoxMix.constraints(BoxConstraintsMix.width(value));
  }

  /// constraints
  factory BoxMix.constraints(BoxConstraintsMix value) {
    return BoxMix(constraints: value);
  }

  /// minWidth
  factory BoxMix.minWidth(double value) {
    return BoxMix.constraints(BoxConstraintsMix.minWidth(value));
  }

  /// maxWidth
  factory BoxMix.maxWidth(double value) {
    return BoxMix(constraints: BoxConstraintsMix.maxWidth(value));
  }

  /// Animation
  factory BoxMix.animation(AnimationConfig value) {
    return BoxMix(animation: value);
  }

  /// Variant
  factory BoxMix.variant(Variant variant, BoxMix value) {
    return BoxMix(variants: [VariantStyleAttribute(variant, value)]);
  }

  /// minHeight
  factory BoxMix.minHeight(double value) {
    return BoxMix.constraints(BoxConstraintsMix.minHeight(value));
  }

  /// maxHeight
  factory BoxMix.maxHeight(double value) {
    return BoxMix(constraints: BoxConstraintsMix.maxHeight(value));
  }

  factory BoxMix.foregroundDecoration(DecorationMix value) {
    return BoxMix(foregroundDecoration: value);
  }

  factory BoxMix.decoration(DecorationMix value) {
    return BoxMix(decoration: value);
  }

  factory BoxMix.alignment(AlignmentGeometry value) {
    return BoxMix(alignment: value);
  }

  factory BoxMix.padding(EdgeInsetsGeometryMix value) {
    return BoxMix(padding: value);
  }

  factory BoxMix.margin(EdgeInsetsGeometryMix value) {
    return BoxMix(margin: value);
  }

  factory BoxMix.transform(Matrix4 value) {
    return BoxMix(transform: value);
  }

  /// Animation
  factory BoxMix.animate(AnimationConfig animation) {
    return BoxMix(animation: animation);
  }

  factory BoxMix.transformAlignment(AlignmentGeometry value) {
    return BoxMix(transformAlignment: value);
  }

  factory BoxMix.clipBehavior(Clip value) {
    return BoxMix(clipBehavior: value);
  }

  /// border
  factory BoxMix.border(BoxBorderMix value) {
    return BoxMix(decoration: DecorationMix.border(value));
  }

  /// Border radius
  factory BoxMix.borderRadius(BorderRadiusGeometryMix value) {
    return BoxMix(decoration: DecorationMix.borderRadius(value));
  }

  const BoxMix.raw({
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

  BoxMix({
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
  /// This is useful for converting existing [BoxSpec] instances to [BoxMix].
  ///
  /// ```dart
  /// const spec = BoxSpec(alignment: Alignment.center, padding: EdgeInsets.all(8));
  /// final attr = BoxSpecAttribute.value(spec);
  /// ```
  BoxMix.value(BoxSpec spec)
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
  static BoxMix? maybeValue(BoxSpec? spec) {
    return spec != null ? BoxMix.value(spec) : null;
  }

  BoxMix transformAlignment(AlignmentGeometry value) {
    return merge(BoxMix(transformAlignment: value));
  }

  BoxMix clipBehavior(Clip value) {
    return merge(BoxMix(clipBehavior: value));
  }

  /// Sets background color
  BoxMix color(Color value) {
    return decoration(DecorationMix.color(value));
  }

  /// Sets both min and max width to create a fixed width
  BoxMix width(double value) {
    return constraints(BoxConstraintsMix.width(value));
  }

  /// Sets both min and max height to create a fixed height
  BoxMix height(double value) {
    return constraints(BoxConstraintsMix.height(value));
  }

  /// Sets rotation transform
  BoxMix rotate(double angle) {
    return transform(Matrix4.rotationZ(angle));
  }

  /// Sets scale transform
  BoxMix scale(double scale) {
    return transform(Matrix4.diagonal3Values(scale, scale, 1.0));
  }

  /// Sets translation transform
  BoxMix translate(double x, double y, [double z = 0.0]) {
    return transform(Matrix4.translationValues(x, y, z));
  }

  /// Sets skew transform
  BoxMix skew(double skewX, double skewY) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 1, skewX);
    matrix.setEntry(1, 0, skewY);

    return transform(matrix);
  }

  /// Resets transform to identity (no effect)
  BoxMix transformReset() {
    return transform(Matrix4.identity());
  }

  /// Sets minimum width constraint
  BoxMix minWidth(double value) {
    return constraints(BoxConstraintsMix.minWidth(value));
  }

  /// Sets maximum width constraint
  BoxMix maxWidth(double value) {
    return constraints(BoxConstraintsMix.maxWidth(value));
  }

  /// Sets minimum height constraint
  BoxMix minHeight(double value) {
    return constraints(BoxConstraintsMix.minHeight(value));
  }

  /// Sets maximum height constraint
  BoxMix maxHeight(double value) {
    return constraints(BoxConstraintsMix.maxHeight(value));
  }

  /// Sets both width and height to specific values
  BoxMix size(double width, double height) {
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
  BoxMix shape(ShapeBorderMix value) {
    return decoration(ShapeDecorationMix(shape: value));
  }

  BoxMix alignment(AlignmentGeometry value) {
    return merge(BoxMix(alignment: value));
  }

  /// Sets single shadow
  BoxMix shadow(BoxShadowMix value) {
    return decoration(BoxDecorationMix.boxShadow([value]));
  }

  /// Sets multiple shadows
  BoxMix shadows(List<BoxShadowMix> value) {
    return decoration(BoxDecorationMix.boxShadow(value));
  }

  /// Sets elevation shadow
  BoxMix elevation(ElevationShadow value) {
    return decoration(
      BoxDecorationMix.boxShadow(BoxShadowMix.fromElevation(value)),
    );
  }

  /// Animation instance method
  BoxMix animate(AnimationConfig animation) {
    return merge(BoxMix(animation: animation));
  }

  /// Modifier instance method
  BoxMix wrap(ModifierAttribute modifier) {
    return merge(BoxMix(modifiers: [modifier]));
  }

  /// Border instance method
  BoxMix border(BoxBorderMix value) {
    return merge(BoxMix(decoration: DecorationMix.border(value)));
  }

  /// Padding instance method
  BoxMix padding(EdgeInsetsGeometryMix value) {
    return merge(BoxMix(padding: value));
  }

  /// Margin instance method

  BoxMix margin(EdgeInsetsGeometryMix value) {
    return merge(BoxMix(margin: value));
  }

  /// Border radius instance method

  BoxMix borderRadius(BorderRadiusGeometryMix value) {
    return merge(BoxMix(decoration: DecorationMix.borderRadius(value)));
  }

  BoxMix transform(Matrix4 value) {
    return merge(BoxMix(transform: value));
  }

  /// Color instance method
  /// Decoration instance method
  BoxMix decoration(DecorationMix value) {
    return merge(BoxMix(decoration: value));
  }

  /// Foreground decoration instance method
  BoxMix foregroundDecoration(DecorationMix value) {
    return merge(BoxMix.foregroundDecoration(value));
  }

  /// Constraints instance method
  BoxMix constraints(BoxConstraintsMix value) {
    return merge(BoxMix.constraints(value));
  }

  /// Sets gradient with any GradientMix type
  BoxMix gradient(GradientMix value) {
    return merge(BoxMix.gradient(value));
  }

  /// Sets image decoration
  BoxMix image(DecorationImageMix value) {
    return decoration(DecorationMix.image(value));
  }

  @override
  BoxMix variants(List<VariantStyleAttribute<BoxSpec>> value) {
    return merge(BoxMix(variants: value));
  }

  @override
  BoxMix variant(Variant variant, BoxMix style) {
    return merge(BoxMix(variants: [VariantStyleAttribute(variant, style)]));
  }

  /// The list of properties that constitute the state of this [BoxMix].
  @override
  BoxMix modifiers(List<ModifierAttribute> value) {
    return merge(BoxMix(modifiers: value));
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

  /// Merges the properties of this [BoxMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [BoxMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  BoxMix merge(BoxMix? other) {
    if (other == null) return this;

    return BoxMix.raw(
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
  /// compare two [BoxMix] instances for equality.
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

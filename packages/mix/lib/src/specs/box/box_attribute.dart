import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../attributes/border_mix.dart';
import '../../attributes/border_radius_mix.dart';
import '../../attributes/constraints_mix.dart';
import '../../attributes/constraints_util.dart';
import '../../attributes/decoration_mix.dart';
import '../../attributes/decoration_util.dart';
import '../../attributes/edge_insets_geometry_mix.dart';
import '../../attributes/edge_insets_geometry_util.dart';
import '../../attributes/scalar_util.dart';
import '../../attributes/shadow_mix.dart';
import '../../animation/animation_util.dart';
import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import '../../core/variant.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant_util.dart';
import 'box_spec.dart';

/// Attribute class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts.
class BoxSpecAttribute extends StyleAttribute<BoxSpec> with Diagnosticable {
  final Prop<AlignmentGeometry>? $alignment;
  final MixProp<EdgeInsetsGeometry>? $padding;
  final MixProp<EdgeInsetsGeometry>? $margin;
  final MixProp<BoxConstraints>? $constraints;
  final MixProp<Decoration>? $decoration;
  final MixProp<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  late final on = OnContextVariantUtility<BoxSpec, BoxSpecAttribute>(
    (v) => merge(BoxSpecAttribute(variants: [v])),
  );

  late final padding = EdgeInsetsGeometryUtility(
    (prop) => merge(BoxSpecAttribute(padding: prop)),
  );

  late final margin = EdgeInsetsGeometryUtility(
    (prop) => merge(BoxSpecAttribute(margin: prop)),
  );

  late final constraints = BoxConstraintsUtility(
    (prop) => merge(BoxSpecAttribute(constraints: prop)),
  );

  late final decoration = DecorationUtility(
    (prop) => merge(BoxSpecAttribute(decoration: prop)),
  );

  late final animate = AnimationConfigUtility(
    (prop) => merge(BoxSpecAttribute(animation: prop)),
  );

  late final boxDecoration = decoration.box;

  late final shapeDecoration = decoration.shape;

  late final foregroundDecoration = DecorationUtility(
    (prop) => merge(BoxSpecAttribute(foregroundDecoration: prop)),
  );

  late final transform = PropUtility<BoxSpecAttribute, Matrix4>(
    (prop) => merge(BoxSpecAttribute(transform: prop)),
  );

  late final transformAlignment = PropUtility<BoxSpecAttribute, AlignmentGeometry>(
    (prop) => merge(BoxSpecAttribute(transformAlignment: prop)),
  );

  late final clipBehavior = PropUtility<BoxSpecAttribute, Clip>(
    (prop) => merge(BoxSpecAttribute(clipBehavior: prop)),
  );

  late final wrap = ModifierUtility(
    (prop) => merge(BoxSpecAttribute.modifier(prop)),
  );

  late final width = constraints.width;

  late final height = constraints.height;

  late final alignment = AlignmentGeometryUtility(
    (prop) => merge(BoxSpecAttribute(alignment: prop)),
  );

  late final minWidth = constraints.minWidth;

  late final maxWidth = constraints.maxWidth;

  late final maxHeight = constraints.maxHeight;

  late final minHeight = constraints.minHeight;

  late final border = decoration.box.border;

  late final borderDirectional = decoration.box.borderDirectional;

  late final borderRadius = decoration.box.borderRadius;

  late final borderRadiusDirectional = decoration.box.borderRadiusDirectional;
  late final color = decoration.box.color;

  late final gradient = decoration.box.gradient;

  late final linearGradient = decoration.box.gradient.linear;

  late final radialGradient = decoration.box.gradient.radial;

  late final sweepGradient = decoration.box.gradient.sweep;

  late final shape = decoration.box.shape;

  factory BoxSpecAttribute.height(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.height(value));
  }

  factory BoxSpecAttribute.width(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.width(value));
  }

  // constraints
  factory BoxSpecAttribute.constraints(BoxConstraintsMix value) {
    return BoxSpecAttribute.only(constraints: value);
  }

  // minWidth
  factory BoxSpecAttribute.minWidth(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.minWidth(value));
  }

  // maxWidth
  factory BoxSpecAttribute.maxWidth(double value) {
    return BoxSpecAttribute.only(
      constraints: BoxConstraintsMix.maxWidth(value),
    );
  }

  /// Animation
  factory BoxSpecAttribute.animation(AnimationConfig value) {
    return BoxSpecAttribute.only(animation: value);
  }

  /// Variant
  factory BoxSpecAttribute.variant(Variant variant, BoxSpecAttribute value) {
    return BoxSpecAttribute.only(
      variants: [VariantStyleAttribute(variant, value)],
    );
  }

  // minHeight
  factory BoxSpecAttribute.minHeight(double value) {
    return BoxSpecAttribute.constraints(BoxConstraintsMix.minHeight(value));
  }

  factory BoxSpecAttribute.modifier(ModifierAttribute value) {
    return BoxSpecAttribute.only(modifiers: [value]);
  }

  // maxHeight
  factory BoxSpecAttribute.maxHeight(double value) {
    return BoxSpecAttribute.only(
      constraints: BoxConstraintsMix.maxHeight(value),
    );
  }

  factory BoxSpecAttribute.foregroundDecoration(DecorationMix value) {
    return BoxSpecAttribute.only(foregroundDecoration: value);
  }

  factory BoxSpecAttribute.decoration(DecorationMix value) {
    return BoxSpecAttribute.only(decoration: value);
  }

  factory BoxSpecAttribute.alignment(AlignmentGeometry value) {
    return BoxSpecAttribute.only(alignment: value);
  }

  factory BoxSpecAttribute.padding(EdgeInsetsGeometryMix value) {
    return BoxSpecAttribute.only(padding: value);
  }

  factory BoxSpecAttribute.margin(EdgeInsetsGeometryMix value) {
    return BoxSpecAttribute.only(margin: value);
  }

  factory BoxSpecAttribute.transform(Matrix4 value) {
    return BoxSpecAttribute.only(transform: value);
  }

  /// Animation
  factory BoxSpecAttribute.animate(AnimationConfig animation) {
    return BoxSpecAttribute.only(animation: animation);
  }

  factory BoxSpecAttribute.transformAlignment(AlignmentGeometry value) {
    return BoxSpecAttribute.only(transformAlignment: value);
  }

  factory BoxSpecAttribute.clipBehavior(Clip value) {
    return BoxSpecAttribute.only(clipBehavior: value);
  }

  // border
  factory BoxSpecAttribute.border(BoxBorderMix value) {
    return BoxSpecAttribute.only(decoration: DecorationMix.border(value));
  }

  // Border radius
  factory BoxSpecAttribute.borderRadius(BorderRadiusGeometryMix value) {
    return BoxSpecAttribute.only(decoration: DecorationMix.borderRadius(value));
  }

  BoxSpecAttribute({
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

  BoxSpecAttribute.only({
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
  }) : this(
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
    : this.only(
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

  /// The list of properties that constitute the state of this [BoxSpecAttribute].
  ///

  BoxSpecAttribute modifier(ModifierAttribute value) {
    return merge(BoxSpecAttribute.only(modifiers: [value]));
  }

  BoxSpecAttribute variant(Variant variant, BoxSpecAttribute value) {
    return merge(
      BoxSpecAttribute.only(variants: [VariantStyleAttribute(variant, value)]),
    );
  }

  BoxSpecAttribute animation(AnimationConfig animation) {
    return BoxSpecAttribute.only(animation: animation);
  }

  BoxSpecAttribute shadows(List<BoxShadowMix> value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationMix.only(boxShadow: value),
    );
  }

  BoxSpecAttribute shadow(BoxShadowMix value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationMix.only(boxShadow: [value]),
    );
  }

  BoxSpecAttribute elevation(ElevationShadow value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationMix.only(
        boxShadow: BoxShadowMix.fromElevation(value),
      ),
    );
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

    return BoxSpecAttribute(
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
  ];
}

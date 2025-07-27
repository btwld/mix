import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
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
import 'box_spec.dart';

/// Attribute class for configuring [BoxSpec] properties.
///
/// Encapsulates alignment, padding, margin, constraints, decoration,
/// and other styling properties for box layouts.
class BoxSpecAttribute extends StyleAttribute<BoxSpec>
    with Diagnosticable, SpecAttributeMixin<BoxSpec> {
  final Prop<AlignmentGeometry>? $alignment;
  final MixProp<EdgeInsetsGeometry>? $padding;
  final MixProp<EdgeInsetsGeometry>? $margin;
  final MixProp<BoxConstraints>? $constraints;
  final MixProp<Decoration>? $decoration;
  final MixProp<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  // Color factory
  factory BoxSpecAttribute.color(Color value) {
    return BoxSpecAttribute.only(decoration: DecorationMix.color(value));
  }

  // Gradient factory
  factory BoxSpecAttribute.gradient(GradientMix value) {
    return BoxSpecAttribute.only(decoration: DecorationMix.gradient(value));
  }

  // Shape factory
  factory BoxSpecAttribute.shape(BoxShape value) {
    return BoxSpecAttribute.only(decoration: DecorationMix.shape(value));
  }

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

  const BoxSpecAttribute({
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

  BoxSpecAttribute shadows(List<BoxShadowMix> value) {
    return merge(
      BoxSpecAttribute.only(
        decoration: BoxDecorationMix.only(boxShadow: value),
      ),
    );
  }

  BoxSpecAttribute shadow(BoxShadowMix value) {
    return merge(
      BoxSpecAttribute.only(
        decoration: BoxDecorationMix.only(boxShadow: [value]),
      ),
    );
  }

  BoxSpecAttribute elevation(ElevationShadow value) {
    return merge(
      BoxSpecAttribute.only(
        decoration: BoxDecorationMix.only(
          boxShadow: BoxShadowMix.fromElevation(value),
        ),
      ),
    );
  }

  BoxSpecAttribute transform(Matrix4 value) {
    return merge(BoxSpecAttribute.only(transform: value));
  }

  BoxSpecAttribute transformAlignment(AlignmentGeometry value) {
    return merge(BoxSpecAttribute.only(transformAlignment: value));
  }

  BoxSpecAttribute clipBehavior(Clip value) {
    return merge(BoxSpecAttribute.only(clipBehavior: value));
  }

  BoxSpecAttribute alignment(AlignmentGeometry value) {
    return merge(BoxSpecAttribute.only(alignment: value));
  }

  // Dimension instance methods
  BoxSpecAttribute width(double value) {
    return merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix.width(value)),
    );
  }

  BoxSpecAttribute height(double value) {
    return merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix.height(value)),
    );
  }

  BoxSpecAttribute minWidth(double value) {
    return merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix.minWidth(value)),
    );
  }

  BoxSpecAttribute maxWidth(double value) {
    return merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix.maxWidth(value)),
    );
  }

  BoxSpecAttribute minHeight(double value) {
    return merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix.minHeight(value)),
    );
  }

  BoxSpecAttribute maxHeight(double value) {
    return merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix.maxHeight(value)),
    );
  }

  // Animation instance method
  BoxSpecAttribute animate(AnimationConfig animation) {
    return merge(BoxSpecAttribute.only(animation: animation));
  }

  // Color instance method
  BoxSpecAttribute color(Color value) {
    return merge(BoxSpecAttribute.only(decoration: DecorationMix.color(value)));
  }

  // Shape instance method
  BoxSpecAttribute shape(BoxShape value) {
    return merge(BoxSpecAttribute.only(decoration: DecorationMix.shape(value)));
  }

  // Padding instance method
  BoxSpecAttribute padding(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecAttribute.only(padding: value));
  }

  // Margin instance method
  BoxSpecAttribute margin(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecAttribute.only(margin: value));
  }

  // Constraints instance method
  BoxSpecAttribute constraints(BoxConstraintsMix value) {
    return merge(BoxSpecAttribute.only(constraints: value));
  }

  // Decoration instance method
  BoxSpecAttribute decoration(DecorationMix value) {
    return merge(BoxSpecAttribute.only(decoration: value));
  }

  // Foreground decoration instance method
  BoxSpecAttribute foregroundDecoration(DecorationMix value) {
    return merge(BoxSpecAttribute.only(foregroundDecoration: value));
  }

  // Modifier instance method
  BoxSpecAttribute wrap(ModifierAttribute modifier) {
    return merge(BoxSpecAttribute.only(modifiers: [modifier]));
  }

  // Box decoration instance method with .only() parameters
  BoxSpecAttribute boxDecoration({
    BoxBorderMix? border,
    BorderRadiusGeometryMix? borderRadius,
    BoxShape? shape,
    BlendMode? backgroundBlendMode,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? boxShadow,
  }) {
    return merge(
      BoxSpecAttribute.only(
        decoration: BoxDecorationMix.only(
          border: border,
          borderRadius: borderRadius,
          shape: shape,
          backgroundBlendMode: backgroundBlendMode,
          color: color,
          image: image,
          gradient: gradient,
          boxShadow: boxShadow,
        ),
      ),
    );
  }

  // Shape decoration instance method with .only() parameters
  BoxSpecAttribute shapeDecoration({
    ShapeBorderMix? shape,
    Color? color,
    DecorationImageMix? image,
    GradientMix? gradient,
    List<BoxShadowMix>? shadows,
  }) {
    return merge(
      BoxSpecAttribute.only(
        decoration: ShapeDecorationMix.only(
          shape: shape,
          color: color,
          image: image,
          gradient: gradient,
          shadows: shadows,
        ),
      ),
    );
  }

  // Border instance method
  BoxSpecAttribute border(BoxBorderMix value) {
    return merge(
      BoxSpecAttribute.only(decoration: DecorationMix.border(value)),
    );
  }

  // Border radius instance method
  BoxSpecAttribute borderRadius(BorderRadiusGeometryMix value) {
    return merge(
      BoxSpecAttribute.only(decoration: DecorationMix.borderRadius(value)),
    );
  }

  // Gradient instance method
  BoxSpecAttribute gradient(GradientMix value) {
    return merge(
      BoxSpecAttribute.only(decoration: DecorationMix.gradient(value)),
    );
  }

  // Linear gradient instance method with .only() parameters
  BoxSpecAttribute linearGradient({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return merge(
      BoxSpecAttribute.only(
        decoration: DecorationMix.gradient(
          LinearGradientMix.only(
            begin: begin,
            end: end,
            tileMode: tileMode,
            transform: transform,
            colors: colors,
            stops: stops,
          ),
        ),
      ),
    );
  }

  // Radial gradient instance method with .only() parameters
  BoxSpecAttribute radialGradient({
    AlignmentGeometry? center,
    double? radius,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return merge(
      BoxSpecAttribute.only(
        decoration: DecorationMix.gradient(
          RadialGradientMix.only(
            center: center,
            radius: radius,
            tileMode: tileMode,
            focal: focal,
            focalRadius: focalRadius,
            transform: transform,
            colors: colors,
            stops: stops,
          ),
        ),
      ),
    );
  }

  // Sweep gradient instance method with .only() parameters
  BoxSpecAttribute sweepGradient({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
    List<Color>? colors,
    List<double>? stops,
  }) {
    return merge(
      BoxSpecAttribute.only(
        decoration: DecorationMix.gradient(
          SweepGradientMix.only(
            center: center,
            startAngle: startAngle,
            endAngle: endAngle,
            tileMode: tileMode,
            transform: transform,
            colors: colors,
            stops: stops,
          ),
        ),
      ),
    );
  }

  /// The list of properties that constitute the state of this [BoxSpecAttribute].
  ///

  @override
  BoxSpecAttribute modifiers(List<ModifierAttribute> value) {
    return merge(BoxSpecAttribute.only(modifiers: value));
  }

  @override
  BoxSpecAttribute variants(List<VariantStyleAttribute<BoxSpec>> value) {
    return merge(BoxSpecAttribute.only(variants: value));
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
    $animation,
    $modifiers,
    $variants,
  ];
}

/// Extension that replicates EdgeInsets factory constructors as padding methods
extension BoxSpecAttributePaddingExtension on BoxSpecAttribute {
  /// Sets padding to the same value on all sides
  /// Replicates EdgeInsets.all()
  BoxSpecAttribute paddingAll(double value) {
    return padding(EdgeInsetsGeometryMix.all(value));
  }

  /// Sets symmetric padding
  /// Replicates EdgeInsets.symmetric()
  BoxSpecAttribute paddingSymmetric({double? vertical, double? horizontal}) {
    return padding(
      EdgeInsetsGeometryMix.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
    );
  }

  /// Sets padding on specific sides only
  /// Replicates EdgeInsets.only()
  BoxSpecAttribute paddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return padding(
      EdgeInsetsGeometryMix.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
    );
  }

  /// Convenience methods for individual sides
  BoxSpecAttribute paddingHorizontal(double value) {
    return paddingSymmetric(horizontal: value);
  }

  BoxSpecAttribute paddingVertical(double value) {
    return paddingSymmetric(vertical: value);
  }

  BoxSpecAttribute paddingTop(double value) {
    return paddingOnly(top: value);
  }

  BoxSpecAttribute paddingBottom(double value) {
    return paddingOnly(bottom: value);
  }

  BoxSpecAttribute paddingLeft(double value) {
    return paddingOnly(left: value);
  }

  BoxSpecAttribute paddingRight(double value) {
    return paddingOnly(right: value);
  }
}

/// Extension that replicates EdgeInsets factory constructors as margin methods
extension BoxSpecAttributeMarginExtension on BoxSpecAttribute {
  /// Sets margin to the same value on all sides
  /// Replicates EdgeInsets.all()
  BoxSpecAttribute marginAll(double value) {
    return margin(EdgeInsetsGeometryMix.all(value));
  }

  /// Sets symmetric margin
  /// Replicates EdgeInsets.symmetric()
  BoxSpecAttribute marginSymmetric({double? vertical, double? horizontal}) {
    return margin(
      EdgeInsetsGeometryMix.symmetric(
        vertical: vertical,
        horizontal: horizontal,
      ),
    );
  }

  /// Sets margin on specific sides only
  /// Replicates EdgeInsets.only()
  BoxSpecAttribute marginOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return margin(
      EdgeInsetsGeometryMix.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
    );
  }

  /// Convenience methods for individual sides
  BoxSpecAttribute marginHorizontal(double value) {
    return marginSymmetric(horizontal: value);
  }

  BoxSpecAttribute marginVertical(double value) {
    return marginSymmetric(vertical: value);
  }

  BoxSpecAttribute marginTop(double value) {
    return marginOnly(top: value);
  }

  BoxSpecAttribute marginBottom(double value) {
    return marginOnly(bottom: value);
  }

  BoxSpecAttribute marginLeft(double value) {
    return marginOnly(left: value);
  }

  BoxSpecAttribute marginRight(double value) {
    return marginOnly(right: value);
  }
}

/// Extension that replicates BoxConstraints factory constructors and common size methods
extension BoxSpecAttributeConstraintsExtension on BoxSpecAttribute {
  /// Sets a fixed width and height
  BoxSpecAttribute size(double width, double height) {
    return this.width(width).height(height);
  }

  /// Sets a square size (width = height)
  BoxSpecAttribute square(double size) {
    return width(size).height(size);
  }
}

/// Extension for decoration convenience methods
extension BoxSpecAttributeDecorationExtension on BoxSpecAttribute {
  /// Sets rounded corners on all sides - clean and simple
  BoxSpecAttribute rounded(double radius) {
    return borderRadius(BorderRadiusGeometryMix.circular(radius));
  }

  /// Sets rounded corner on top-left only
  BoxSpecAttribute roundedTopLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topLeft(Radius.circular(radius)));
  }

  /// Sets rounded corner on top-right only
  BoxSpecAttribute roundedTopRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.topRight(Radius.circular(radius)));
  }

  /// Sets rounded corner on bottom-left only
  BoxSpecAttribute roundedBottomLeft(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomLeft(Radius.circular(radius)));
  }

  /// Sets rounded corner on bottom-right only
  BoxSpecAttribute roundedBottomRight(double radius) {
    return borderRadius(BorderRadiusGeometryMix.bottomRight(Radius.circular(radius)));
  }

  /// Sets rounded corners on top sides (top-left and top-right)
  BoxSpecAttribute roundedTop(double radius) {
    return borderRadius(BorderRadiusMix.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    ));
  }

  /// Sets rounded corners on bottom sides (bottom-left and bottom-right)
  BoxSpecAttribute roundedBottom(double radius) {
    return borderRadius(BorderRadiusMix.only(
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ));
  }

  /// Sets rounded corners on left sides (top-left and bottom-left)
  BoxSpecAttribute roundedLeft(double radius) {
    return borderRadius(BorderRadiusMix.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
    ));
  }

  /// Sets rounded corners on right sides (top-right and bottom-right)
  BoxSpecAttribute roundedRight(double radius) {
    return borderRadius(BorderRadiusMix.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ));
  }

  /// Sets oval border radius on all corners
  BoxSpecAttribute oval(double xRadius, double yRadius) {
    return borderRadius(BorderRadiusGeometryMix.elliptical(xRadius, yRadius));
  }

  /// Sets border on all sides with the same properties
  BoxSpecAttribute borderAll({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix.only(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return border(BorderMix.all(side));
  }

  /// Sets border on top side only
  BoxSpecAttribute borderTop({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.only(
        top: BorderSideMix.only(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  /// Sets border on bottom side only
  BoxSpecAttribute borderBottom({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.only(
        bottom: BorderSideMix.only(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  /// Sets border on left side only
  BoxSpecAttribute borderLeft({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.only(
        left: BorderSideMix.only(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  /// Sets border on right side only
  BoxSpecAttribute borderRight({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderMix.only(
        right: BorderSideMix.only(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  /// Sets border on horizontal sides (top and bottom)
  BoxSpecAttribute borderHorizontal({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix.only(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return border(BorderMix.horizontal(side));
  }

  /// Sets border on vertical sides (left and right)
  BoxSpecAttribute borderVertical({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    final side = BorderSideMix.only(
      color: color,
      strokeAlign: strokeAlign,
      style: style,
      width: width,
    );

    return border(BorderMix.vertical(side));
  }

  /// Sets border on start side (respects text direction)
  BoxSpecAttribute borderStart({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderDirectionalMix.only(
        start: BorderSideMix.only(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }

  /// Sets border on end side (respects text direction)
  BoxSpecAttribute borderEnd({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
  }) {
    return border(
      BorderDirectionalMix.only(
        end: BorderSideMix.only(
          color: color,
          strokeAlign: strokeAlign,
          style: style,
          width: width,
        ),
      ),
    );
  }
}

/// Extension for transform effect convenience methods
extension BoxSpecAttributeTransformExtension on BoxSpecAttribute {
  /// Sets rotation transform effect
  BoxSpecAttribute rotateEffect(double angle) {
    return transform(Matrix4.rotationZ(angle));
  }

  /// Sets scale transform effect
  BoxSpecAttribute scaleEffect(double scale) {
    return transform(Matrix4.diagonal3Values(scale, scale, 1.0));
  }

  /// Sets translation transform effect
  BoxSpecAttribute translateEffect(double x, double y) {
    return transform(Matrix4.translationValues(x, y, 0.0));
  }

  /// Sets skew transform effect
  BoxSpecAttribute skewEffect(double skewX, double skewY) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 1, skewX);
    matrix.setEntry(1, 0, skewY);

    return transform(matrix);
  }

  /// Resets transform to identity (no effect)
  BoxSpecAttribute transformReset() {
    return transform(Matrix4.identity());
  }
}

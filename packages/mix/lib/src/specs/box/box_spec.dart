import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../attributes/border/border_dto.dart';
import '../../attributes/border/border_radius_dto.dart';
import '../../attributes/constraints/constraints_dto.dart';
import '../../attributes/constraints/constraints_util.dart';
import '../../attributes/decoration/decoration_dto.dart';
import '../../attributes/decoration/decoration_util.dart';
import '../../attributes/enum/enum_util.dart';
import '../../attributes/gradient/gradient_dto.dart';
import '../../attributes/scalars/scalar_util.dart';
import '../../attributes/shadow/shadow_dto.dart';
import '../../attributes/spacing/edge_insets_dto.dart';
import '../../attributes/spacing/spacing_util.dart';
import '../../core/animation_config.dart';
import '../../core/attribute.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/resolved_style_provider.dart';
import '../../core/spec.dart';
import '../../core/utility.dart';

final class BoxSpec extends Spec<BoxSpec> with Diagnosticable {
  /// Aligns the child within the box.
  final AlignmentGeometry? alignment;

  /// Adds empty space inside the box.
  final EdgeInsetsGeometry? padding;

  /// Adds empty space around the box.
  final EdgeInsetsGeometry? margin;

  /// Applies additional constraints to the child.
  final BoxConstraints? constraints;

  /// Paints a decoration behind the child.
  final Decoration? decoration;

  /// Paints a decoration in front of the child.
  final Decoration? foregroundDecoration;

  /// Applies a transformation matrix before painting the box.
  final Matrix4? transform;

  /// Aligns the origin of the coordinate system for the [transform].
  final AlignmentGeometry? transformAlignment;

  /// Defines the clip behavior for the box
  /// when [BoxConstraints] has a negative minimum extent.
  final Clip? clipBehavior;

  /// Specifies the width of the box.
  final double? width;

  /// Specifies the height of the box.
  final double? height;

  const BoxSpec({
    this.alignment,
    this.padding,
    this.margin,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
    this.width,
    this.height,
  });

  static BoxSpec? maybeOf(BuildContext context) {
    return ResolvedStyleProvider.of<BoxSpec>(context)?.spec;
  }

  /// {@template box_spec_of}
  /// Retrieves the [BoxSpec] from the nearest [ResolvedStyleProvider] ancestor in the widget tree.
  ///
  /// This method provides the resolved BoxSpec from the style system.
  /// If no ancestor [ResolvedStyleProvider] is found, this method returns an empty [BoxSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final boxSpec = BoxSpec.of(context);
  /// ```
  /// {@endtemplate}
  static BoxSpec of(BuildContext context) {
    return maybeOf(context) ?? const BoxSpec();
  }

  void _debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(
      DiagnosticsProperty('alignment', alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('padding', padding, defaultValue: null));
    properties.add(DiagnosticsProperty('margin', margin, defaultValue: null));
    properties.add(
      DiagnosticsProperty('constraints', constraints, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('decoration', decoration, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'foregroundDecoration',
        foregroundDecoration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('transform', transform, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty(
        'transformAlignment',
        transformAlignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', clipBehavior, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('width', width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', height, defaultValue: null));
  }

  /// Creates a copy of this [BoxSpec] but with the given fields
  /// replaced with the new values.
  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  /// Linearly interpolates between this [BoxSpec] and another [BoxSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [BoxSpec] is returned. When [t] is 1.0, the [other] [BoxSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [BoxSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [BoxSpec] instance.
  ///
  /// The interpolation is performed on each property of the [BoxSpec] using the appropriate
  /// interpolation method:
  /// - [AlignmentGeometry.lerp] for [alignment] and [transformAlignment].
  /// - [EdgeInsetsGeometry.lerp] for [padding] and [margin].
  /// - [BoxConstraints.lerp] for [constraints].
  /// - [Decoration.lerp] for [decoration] and [foregroundDecoration].
  /// - [MixHelpers.lerpMatrix4] for [transform].
  /// - [MixHelpers.lerpDouble] for [width] and [height].
  /// For [clipBehavior], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [BoxSpec] is used. Otherwise, the value
  /// from the [other] [BoxSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [BoxSpec] configurations.
  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    if (other == null) return this;

    return BoxSpec(
      alignment: AlignmentGeometry.lerp(alignment, other.alignment, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      constraints: BoxConstraints.lerp(constraints, other.constraints, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
      foregroundDecoration: Decoration.lerp(
        foregroundDecoration,
        other.foregroundDecoration,
        t,
      ),
      transform: MixHelpers.lerpMatrix4(transform, other.transform, t),
      transformAlignment: AlignmentGeometry.lerp(
        transformAlignment,
        other.transformAlignment,
        t,
      ),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      width: MixHelpers.lerpDouble(width, other.width, t),
      height: MixHelpers.lerpDouble(height, other.height, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperties(properties);
  }

  /// The list of properties that constitute the state of this [BoxSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [BoxSpec] instances for equality.
  @override
  List<Object?> get props => [
    alignment,
    padding,
    margin,
    constraints,
    decoration,
    foregroundDecoration,
    transform,
    transformAlignment,
    clipBehavior,
    width,
    height,
  ];
}

/// Represents the attributes of a [BoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [BoxSpec].
///
/// Use this class to configure the attributes of a [BoxSpec] and pass it to
/// the [BoxSpec] constructor.
class BoxSpecAttribute extends SpecAttribute<BoxSpec> with Diagnosticable {
  final Prop<AlignmentGeometry>? $alignment;
  final MixProp<EdgeInsetsGeometry>? $padding;
  final MixProp<EdgeInsetsGeometry>? $margin;
  final MixProp<BoxConstraints>? $constraints;
  final MixProp<Decoration>? $decoration;
  final MixProp<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $width;
  final Prop<double>? $height;

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
    Prop<double>? width,
    Prop<double>? height,
    super.animation,
    super.modifiers,
    super.variants,
  }) : $width = width,
       $height = height,
       $alignment = alignment,
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
    EdgeInsetsGeometryDto? padding,
    EdgeInsetsGeometryDto? margin,
    BoxConstraintsDto? constraints,
    DecorationDto? decoration,
    DecorationDto? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
    AnimationConfig? animation,
    List<ModifierSpecAttribute>? modifiers,
    List<VariantAttribute<BoxSpec>>? variants,
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
         width: Prop.maybe(width),
         height: Prop.maybe(height),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
       );

  BoxSpecAttribute.padding(EdgeInsetsGeometryDto value)
    : this.only(padding: value);

  BoxSpecAttribute.margin(EdgeInsetsGeometryDto value)
    : this.only(margin: value);

  BoxSpecAttribute.constraints(BoxConstraintsDto value)
    : this.only(constraints: value);

  BoxSpecAttribute.decoration(DecorationDto value)
    : this.only(decoration: value);

  BoxSpecAttribute.foregroundDecoration(DecorationDto value)
    : this.only(foregroundDecoration: value);

  BoxSpecAttribute.transform(Matrix4 value) : this.only(transform: value);

  BoxSpecAttribute.transformAlignment(AlignmentGeometry value)
    : this.only(transformAlignment: value);

  BoxSpecAttribute.clipBehavior(Clip value) : this.only(clipBehavior: value);

  BoxSpecAttribute.width(double value) : this.only(width: value);

  BoxSpecAttribute.height(double value) : this.only(height: value);

  BoxSpecAttribute.alignment(AlignmentGeometry value)
    : this.only(alignment: value);

  BoxSpecAttribute.minWidth(double value)
    : this.only(constraints: BoxConstraintsDto.minWidth(value));
  BoxSpecAttribute.maxWidth(double value)
    : this.only(constraints: BoxConstraintsDto.maxWidth(value));
  BoxSpecAttribute.minHeight(double value)
    : this.only(constraints: BoxConstraintsDto.minHeight(value));
  BoxSpecAttribute.maxHeight(double value)
    : this.only(constraints: BoxConstraintsDto.maxHeight(value));

  // Border
  BoxSpecAttribute.border(BoxBorderDto value)
    : this.only(decoration: BoxDecorationDto.border(value));

  BoxSpecAttribute.borderDirectional(BorderDirectionalDto value)
    : this.only(decoration: BoxDecorationDto.borderDirectional(value));

  BoxSpecAttribute.borderRadius(BorderRadiusGeometryDto value)
    : this.only(decoration: BoxDecorationDto.borderRadius(value));

  BoxSpecAttribute.borderRadiusDirectional(BorderRadiusDirectionalDto value)
    : this.only(decoration: BoxDecorationDto.borderRadius(value));

  BoxSpecAttribute.color(Color value)
    : this.only(decoration: BoxDecorationDto.color(value));

  BoxSpecAttribute.gradient(GradientDto value)
    : this.only(decoration: BoxDecorationDto.only(gradient: value));
  BoxSpecAttribute.linearGradient(LinearGradientDto value)
    : this.only(decoration: BoxDecorationDto.only(gradient: value));

  // radial
  BoxSpecAttribute.radialGradient(RadialGradientDto value)
    : this.only(decoration: BoxDecorationDto.only(gradient: value));

  BoxSpecAttribute.sweepGradient(SweepGradientDto value)
    : this.only(decoration: BoxDecorationDto.only(gradient: value));

  BoxSpecAttribute.shadows(List<BoxShadowDto> value)
    : this.only(decoration: BoxDecorationDto.only(boxShadow: value));

  BoxSpecAttribute.shadow(BoxShadowDto value)
    : this.only(decoration: BoxDecorationDto.only(boxShadow: [value]));

  BoxSpecAttribute.elevation(ElevationShadow value)
    : this.only(
        decoration: BoxDecorationDto.only(
          boxShadow: BoxShadowDto.fromElevation(value),
        ),
      );

  BoxSpecAttribute.shapeDecoration(ShapeDecorationDto value)
    : this.only(decoration: value);

  BoxSpecAttribute.shape(BoxShape value)
    : this.only(decoration: BoxDecorationDto.only(shape: value));

  BoxSpecAttribute.animate(AnimationConfig animation)
    : this.only(animation: animation);

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
        padding: EdgeInsetsGeometryDto.maybeValue(spec.padding),
        margin: EdgeInsetsGeometryDto.maybeValue(spec.margin),
        constraints: BoxConstraintsDto.maybeValue(spec.constraints),
        decoration: DecorationDto.maybeValue(spec.decoration),
        foregroundDecoration: DecorationDto.maybeValue(
          spec.foregroundDecoration,
        ),
        transform: spec.transform,
        transformAlignment: spec.transformAlignment,
        clipBehavior: spec.clipBehavior,
        width: spec.width,
        height: spec.height,
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

  BoxSpecAttribute animate(AnimationConfig animation) {
    return BoxSpecAttribute.only(animation: animation);
  }

  BoxSpecAttribute padding(EdgeInsetsGeometryDto value) {
    return BoxSpecAttribute.only(padding: value);
  }

  BoxSpecAttribute margin(EdgeInsetsGeometryDto value) {
    return BoxSpecAttribute.only(margin: value);
  }

  BoxSpecAttribute constraints(BoxConstraintsDto value) {
    return BoxSpecAttribute.only(constraints: value);
  }

  BoxSpecAttribute decoration(DecorationDto value) {
    return BoxSpecAttribute.only(decoration: value);
  }

  BoxSpecAttribute foregroundDecoration(DecorationDto value) {
    return BoxSpecAttribute.only(foregroundDecoration: value);
  }

  BoxSpecAttribute transform(Matrix4 value) {
    return BoxSpecAttribute.only(transform: value);
  }

  BoxSpecAttribute transformAlignment(AlignmentGeometry value) {
    return BoxSpecAttribute.only(transformAlignment: value);
  }

  BoxSpecAttribute clipBehavior(Clip value) {
    return BoxSpecAttribute.only(clipBehavior: value);
  }

  BoxSpecAttribute width(double value) {
    return BoxSpecAttribute.only(width: value);
  }

  BoxSpecAttribute height(double value) {
    return BoxSpecAttribute.only(height: value);
  }

  BoxSpecAttribute alignment(AlignmentGeometry value) {
    return BoxSpecAttribute.only(alignment: value);
  }

  BoxSpecAttribute minWidth(double value) {
    return BoxSpecAttribute.only(
      constraints: BoxConstraintsDto.only(minWidth: value),
    );
  }

  BoxSpecAttribute maxWidth(double value) {
    return BoxSpecAttribute.only(
      constraints: BoxConstraintsDto.only(maxWidth: value),
    );
  }

  BoxSpecAttribute minHeight(double value) {
    return BoxSpecAttribute.only(
      constraints: BoxConstraintsDto.only(minHeight: value),
    );
  }

  BoxSpecAttribute maxHeight(double value) {
    return BoxSpecAttribute.only(
      constraints: BoxConstraintsDto.only(maxHeight: value),
    );
  }

  // Border
  BoxSpecAttribute border(BoxBorderDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(border: value),
    );
  }

  BoxSpecAttribute borderDirectional(BorderDirectionalDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(border: value),
    );
  }

  BoxSpecAttribute borderRadius(BorderRadiusGeometryDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(borderRadius: value),
    );
  }

  BoxSpecAttribute borderRadiusDirectional(BorderRadiusDirectionalDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(borderRadius: value),
    );
  }

  BoxSpecAttribute color(Color value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(color: value),
    );
  }

  BoxSpecAttribute gradient(GradientDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(gradient: value),
    );
  }

  BoxSpecAttribute linearGradient(LinearGradientDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(gradient: value),
    );
  }

  BoxSpecAttribute radialGradient(RadialGradientDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(gradient: value),
    );
  }

  BoxSpecAttribute sweepGradient(SweepGradientDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(gradient: value),
    );
  }

  BoxSpecAttribute shadows(List<BoxShadowDto> value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(boxShadow: value),
    );
  }

  BoxSpecAttribute shadow(BoxShadowDto value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(boxShadow: [value]),
    );
  }

  BoxSpecAttribute elevation(ElevationShadow value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(
        boxShadow: BoxShadowDto.fromElevation(value),
      ),
    );
  }

  BoxSpecAttribute shapeDecoration(ShapeDecorationDto value) {
    return BoxSpecAttribute.only(decoration: value);
  }

  BoxSpecAttribute shape(BoxShape value) {
    return BoxSpecAttribute.only(
      decoration: BoxDecorationDto.only(shape: value),
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
  BoxSpec resolveSpec(BuildContext context) {
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
      width: MixHelpers.resolve(context, $width),
      height: MixHelpers.resolve(context, $height),
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
      width: MixHelpers.merge($width, other.$width),
      height: MixHelpers.merge($height, other.$height),
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
    properties.add(DiagnosticsProperty('width', $width, defaultValue: null));
    properties.add(DiagnosticsProperty('height', $height, defaultValue: null));
  }

  /// The list of properties that constitute the state of this [BoxSpecAttribute].
  ///
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
    $width,
    $height,
  ];
}

/// Utility class for configuring [BoxSpec] properties.
///
/// This class provides methods to set individual properties of a [BoxSpec].
/// Use the methods of this class to configure specific properties of a [BoxSpec].
class BoxSpecUtility extends SpecUtility<BoxSpec> {
  @override
  final BoxSpecAttribute attribute;

  /// Utility for defining [BoxSpecAttribute.alignment]
  late final alignment = AlignmentGeometryUtility(
    (v) => build(BoxSpecAttribute(alignment: v)),
  );

  /// Utility for defining [BoxSpecAttribute.padding]
  late final padding = EdgeInsetsGeometryUtility(
    (v) => build(BoxSpecAttribute(padding: v)),
  );

  /// Utility for defining [BoxSpecAttribute.margin]
  late final margin = EdgeInsetsGeometryUtility(
    (v) => build(BoxSpecAttribute(margin: v)),
  );

  /// Utility for defining [BoxSpecAttribute.constraints]
  late final constraints = BoxConstraintsUtility(
    (v) => build(BoxSpecAttribute(constraints: v)),
  );

  /// Utility for defining [BoxSpecAttribute.constraints.minWidth]
  late final minWidth = constraints.minWidth;

  /// Utility for defining [BoxSpecAttribute.constraints.maxWidth]
  late final maxWidth = constraints.maxWidth;

  /// Utility for defining [BoxSpecAttribute.constraints.minHeight]
  late final minHeight = constraints.minHeight;

  /// Utility for defining [BoxSpecAttribute.constraints.maxHeight]
  late final maxHeight = constraints.maxHeight;

  /// Utility for defining [BoxSpecAttribute.decoration]
  late final decoration = BoxDecorationUtility(
    (v) => build(BoxSpecAttribute(decoration: v)),
  );

  /// Utility for defining [BoxSpecAttribute.decoration.color]
  late final color = decoration.color;

  /// Utility for defining [BoxSpecAttribute.decoration.border]
  late final border = decoration.border;

  /// Utility for defining [BoxSpecAttribute.decoration.border.directional]
  late final borderDirectional = decoration.border.directional;

  /// Utility for defining [BoxSpecAttribute.decoration.borderRadius]
  late final borderRadius = decoration.borderRadius;

  /// Utility for defining [BoxSpecAttribute.decoration.borderRadius.directional]
  late final borderRadiusDirectional = decoration.borderRadius.directional;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient]
  late final gradient = decoration.gradient;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.sweep]
  late final sweepGradient = decoration.gradient.sweep;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.radial]
  late final radialGradient = decoration.gradient.radial;

  /// Utility for defining [BoxSpecAttribute.decoration.gradient.linear]
  late final linearGradient = decoration.gradient.linear;

  /// Utility for defining [BoxSpecAttribute.decoration.boxShadows]
  late final shadows = decoration.boxShadows;

  /// Utility for defining [BoxSpecAttribute.decoration.boxShadow]
  late final shadow = decoration.boxShadow;

  /// Utility for defining [BoxSpecAttribute.decoration.elevation]
  late final elevation = decoration.elevation;

  /// Utility for defining [BoxSpecAttribute.decoration]
  late final shapeDecoration = ShapeDecorationUtility(
    (v) => build(BoxSpecAttribute(decoration: v)),
  );

  /// Utility for defining [BoxSpecAttribute.shapeDecoration.shape]
  late final shape = shapeDecoration.shape;

  /// Utility for defining [BoxSpecAttribute.foregroundDecoration]
  late final foregroundDecoration = BoxDecorationUtility(
    (v) => build(BoxSpecAttribute(foregroundDecoration: v)),
  );

  /// Utility for defining [BoxSpecAttribute.transform]
  late final transform = Matrix4Utility(
    (v) => build(BoxSpecAttribute(transform: v)),
  );

  /// Utility for defining [BoxSpecAttribute.transformAlignment]
  late final transformAlignment = AlignmentGeometryUtility(
    (v) => build(BoxSpecAttribute(transformAlignment: v)),
  );

  /// Utility for defining [BoxSpecAttribute.clipBehavior]
  late final clipBehavior = ClipUtility(
    (v) => build(BoxSpecAttribute(clipBehavior: v)),
  );

  /// Utility for defining [BoxSpecAttribute.width]
  late final width = DoubleUtility(
    (prop) => build(BoxSpecAttribute(width: prop)),
  );

  /// Utility for defining [BoxSpecAttribute.height]
  late final height = DoubleUtility(
    (prop) => build(BoxSpecAttribute(height: prop)),
  );

  // TODO: add animated back into it
  //TODO: add wrap

  BoxSpecUtility({this.attribute = const BoxSpecAttribute()});

  BoxSpecUtility animate(AnimationConfig animation) {
    return build(BoxSpecAttribute(animation: animation));
  }

  BoxSpecUtility modifier(ModifierSpecAttribute modifier) {
    return build(BoxSpecAttribute(modifiers: [modifier]));
  }

  @override
  BoxSpecUtility build(BoxSpecAttribute attribute) {
    return BoxSpecUtility(attribute: this.attribute.merge(attribute));
  }
}

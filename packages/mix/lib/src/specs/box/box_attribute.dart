import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../attributes/border_radius_util.dart';
import '../../attributes/border_util.dart';
import '../../attributes/color/color_util.dart';
import '../../attributes/constraints_dto.dart';
import '../../attributes/constraints_util.dart';
import '../../attributes/decoration_dto.dart';
import '../../attributes/decoration_util.dart';
import '../../attributes/edge_insets_dto.dart';
import '../../attributes/edge_insets_geometry_util.dart';
import '../../attributes/gradient_util.dart';
import '../../attributes/scalar_util.dart';
import '../../attributes/shadow_dto.dart';
import '../../core/animation_config.dart';
import '../../core/attribute.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import 'box_spec.dart';

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

  final padding = EdgeInsetsGeometryUtility(
    (prop) => BoxSpecAttribute(padding: prop),
  );

  final margin = EdgeInsetsGeometryUtility(
    (prop) => BoxSpecAttribute(margin: prop),
  );

  final constraints = BoxConstraintsUtility(
    (prop) => BoxSpecAttribute(constraints: prop),
  );

  final decoration = DecorationUtility(
    (prop) => BoxSpecAttribute(decoration: prop),
  );

  final foregroundDecoration = DecorationUtility(
    (prop) => BoxSpecAttribute(foregroundDecoration: prop),
  );

  final transform = Matrix4Utility((prop) => BoxSpecAttribute(transform: prop));

  final transformAlignment = AlignmentGeometryUtility(
    (prop) => BoxSpecAttribute(transformAlignment: prop),
  );

  final clipBehavior = ClipUtility(
    (prop) => BoxSpecAttribute(clipBehavior: prop),
  );

  final width = DoubleUtility((prop) => BoxSpecAttribute(width: prop));

  final height = DoubleUtility((prop) => BoxSpecAttribute(height: prop));

  final alignment = AlignmentGeometryUtility(
    (prop) => BoxSpecAttribute(alignment: prop),
  );

  final minWidth = DoubleUtility(
    (prop) =>
        BoxSpecAttribute.only(constraints: BoxConstraintsDto(minWidth: prop)),
  );

  final maxWidth = DoubleUtility(
    (prop) =>
        BoxSpecAttribute.only(constraints: BoxConstraintsDto(maxWidth: prop)),
  );

  final maxHeight = DoubleUtility(
    (prop) =>
        BoxSpecAttribute.only(constraints: BoxConstraintsDto(maxHeight: prop)),
  );

  final minHeight = DoubleUtility(
    (prop) =>
        BoxSpecAttribute.only(constraints: BoxConstraintsDto(minHeight: prop)),
  );

  final border = BoxBorderUtility(
    (prop) => BoxSpecAttribute.only(decoration: BoxDecorationDto(border: prop)),
  );

  final borderDirectional = BorderDirectionalUtility(
    (prop) => BoxSpecAttribute.only(decoration: BoxDecorationDto(border: prop)),
  );

  final borderRadius = BorderRadiusGeometryUtility(
    (prop) =>
        BoxSpecAttribute.only(decoration: BoxDecorationDto(borderRadius: prop)),
  );

  final borderRadiusDirectional = BorderRadiusDirectionalUtility(
    (prop) =>
        BoxSpecAttribute.only(decoration: BoxDecorationDto(borderRadius: prop)),
  );

  final color = ColorUtility(
    (prop) => BoxSpecAttribute.only(decoration: BoxDecorationDto(color: prop)),
  );

  final gradient = GradientUtility(
    (prop) =>
        BoxSpecAttribute.only(decoration: BoxDecorationDto(gradient: prop)),
  );

  final linearGradient = LinearGradientUtility(
    (prop) =>
        BoxSpecAttribute.only(decoration: BoxDecorationDto(gradient: prop)),
  );

  final radialGradient = RadialGradientUtility(
    (prop) =>
        BoxSpecAttribute.only(decoration: BoxDecorationDto(gradient: prop)),
  );

  final sweepGradient = SweepGradientUtility(
    (prop) =>
        BoxSpecAttribute.only(decoration: BoxDecorationDto(gradient: prop)),
  );

  final shapeDecoration = ShapeDecorationUtility(
    (prop) => BoxSpecAttribute(decoration: prop),
  );

  final shape = BoxShapeUtility(
    (prop) => BoxSpecAttribute.only(decoration: BoxDecorationDto(shape: prop)),
  );

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
    List<ModifierAttribute>? modifiers,
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

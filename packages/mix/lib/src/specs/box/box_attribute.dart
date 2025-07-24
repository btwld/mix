import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../attributes/border_radius_util.dart';
import '../../attributes/border_util.dart';
import '../../attributes/color_util.dart';
import '../../attributes/constraints_mix.dart';
import '../../attributes/constraints_util.dart';
import '../../attributes/decoration_mix.dart';
import '../../attributes/decoration_util.dart';
import '../../attributes/edge_insets_geometry_mix.dart';
import '../../attributes/edge_insets_geometry_util.dart';
import '../../attributes/gradient_util.dart';
import '../../attributes/scalar_util.dart';
import '../../attributes/shadow_mix.dart';
import '../../core/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import 'box_spec.dart';

/// Represents the attributes of a [BoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [BoxSpec].
///
/// Use this class to configure the attributes of a [BoxSpec] and pass it to
/// the [BoxSpec] constructor.
class BoxSpecAttribute extends SpecStyle<BoxSpec> with Diagnosticable {
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

  late final foregroundDecoration = DecorationUtility(
    (prop) => merge(BoxSpecAttribute(foregroundDecoration: prop)),
  );

  late final transform = Matrix4Utility(
    (prop) => merge(BoxSpecAttribute(transform: prop)),
  );

  late final transformAlignment = AlignmentGeometryUtility(
    (prop) => merge(BoxSpecAttribute(transformAlignment: prop)),
  );

  late final clipBehavior = ClipUtility(
    (prop) => merge(BoxSpecAttribute(clipBehavior: prop)),
  );

  late final width = DoubleUtility(
    (prop) => merge(BoxSpecAttribute(width: prop)),
  );

  late final height = DoubleUtility(
    (prop) => merge(BoxSpecAttribute(height: prop)),
  );

  late final alignment = AlignmentGeometryUtility(
    (prop) => merge(BoxSpecAttribute(alignment: prop)),
  );

  late final minWidth = DoubleUtility(
    (prop) => merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix(minWidth: prop)),
    ),
  );

  late final maxWidth = DoubleUtility(
    (prop) => merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix(maxWidth: prop)),
    ),
  );

  late final maxHeight = DoubleUtility(
    (prop) => merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix(maxHeight: prop)),
    ),
  );

  late final minHeight = DoubleUtility(
    (prop) => merge(
      BoxSpecAttribute.only(constraints: BoxConstraintsMix(minHeight: prop)),
    ),
  );

  late final border = BoxBorderUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(border: prop)),
    ),
  );

  late final borderDirectional = BorderDirectionalUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(border: prop)),
    ),
  );

  late final borderRadius = BorderRadiusGeometryUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(borderRadius: prop)),
    ),
  );

  late final borderRadiusDirectional = BorderRadiusDirectionalUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(borderRadius: prop)),
    ),
  );

  late final color = ColorUtility(
    (prop) =>
        merge(BoxSpecAttribute.only(decoration: BoxDecorationMix(color: prop))),
  );

  late final gradient = GradientUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(gradient: prop)),
    ),
  );

  late final linearGradient = LinearGradientUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(gradient: prop)),
    ),
  );

  late final radialGradient = RadialGradientUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(gradient: prop)),
    ),
  );

  late final sweepGradient = SweepGradientUtility(
    (prop) => merge(
      BoxSpecAttribute.only(decoration: BoxDecorationMix(gradient: prop)),
    ),
  );

  late final shapeDecoration = ShapeDecorationUtility(
    (prop) => merge(BoxSpecAttribute(decoration: prop)),
  );

  late final shape = BoxShapeUtility(
    (prop) =>
        merge(BoxSpecAttribute.only(decoration: BoxDecorationMix(shape: prop))),
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
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    BoxConstraintsMix? constraints,
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? width,
    double? height,
    AnimationConfig? animation,
    List<ModifierAttribute>? modifiers,
    List<VariantSpecAttribute<BoxSpec>>? variants,
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
      animation: other.animation ?? animation,
      modifiers: mergeModifierLists(modifiers, other.modifiers),
      variants: mergeVariantLists(variants, other.variants),
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

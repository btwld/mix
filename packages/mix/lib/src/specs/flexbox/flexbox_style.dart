import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
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
import '../box/box_spec.dart';
import '../box/box_style.dart';
import '../flex/flex_spec.dart';
import '../flex/flex_style.dart';
import 'flexbox_spec.dart';
import 'flexbox_util.dart';

typedef FlexBoxMix = FlexBoxStyle;

/// Represents the attributes of a [FlexBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexBoxSpec].
///
/// Use this class to configure the attributes of a [FlexBoxSpec] and pass it to
/// the [FlexBoxSpec] constructor.
class FlexBoxStyle extends Style<FlexBoxSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexBoxStyle, FlexBoxSpec>,
        StyleVariantMixin<FlexBoxStyle, FlexBoxSpec>,
        BorderRadiusMixin<FlexBoxStyle>,
        DecorationMixin<FlexBoxStyle>,
        SpacingMixin<FlexBoxStyle>,
        TransformMixin<FlexBoxStyle>,
        ConstraintsMixin<FlexBoxStyle> {
  final Prop<WidgetSpec<BoxSpec>>? $box;
  final Prop<WidgetSpec<FlexSpec>>? $flex;

  /// Main constructor with individual property parameters
  FlexBoxStyle({
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
    ModifierConfig? modifier,
    List<VariantStyle<FlexBoxSpec>>? variants,
  }) : this.create(
         box: Prop.maybeMix(
           BoxStyle(
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
           FlexStyle(
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
  const FlexBoxStyle.create({
    Prop<WidgetSpec<BoxSpec>>? box,
    Prop<WidgetSpec<FlexSpec>>? flex,
    super.animation,
    super.modifier,
    super.variants,
  }) : $box = box,
       $flex = flex;

  factory FlexBoxStyle.builder(FlexBoxStyle Function(BuildContext) fn) {
    return FlexBoxStyle().builder(fn);
  }

  static FlexBoxSpecUtility get chain => FlexBoxSpecUtility(FlexBoxStyle());

  /// Sets animation
  FlexBoxStyle animate(AnimationConfig animation) {
    return merge(FlexBoxStyle(animation: animation));
  }

  // BoxMix instance methods

  FlexBoxStyle alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyle(alignment: value));
  }

  /// Foreground decoration instance method
  FlexBoxStyle foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyle(foregroundDecoration: value));
  }

  FlexBoxStyle transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyle(transformAlignment: value));
  }

  FlexBoxStyle clipBehavior(Clip value) {
    return merge(FlexBoxStyle(clipBehavior: value));
  }

  // FlexMix instance methods
  /// Sets flex direction
  FlexBoxStyle direction(Axis value) {
    return merge(FlexBoxStyle(direction: value));
  }

  /// Sets main axis alignment
  FlexBoxStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexBoxStyle(mainAxisAlignment: value));
  }

  /// Sets cross axis alignment
  FlexBoxStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexBoxStyle(crossAxisAlignment: value));
  }

  /// Sets main axis size
  FlexBoxStyle mainAxisSize(MainAxisSize value) {
    return merge(FlexBoxStyle(mainAxisSize: value));
  }

  /// Sets vertical direction
  FlexBoxStyle verticalDirection(VerticalDirection value) {
    return merge(FlexBoxStyle(verticalDirection: value));
  }

  /// Sets text direction
  FlexBoxStyle textDirection(TextDirection value) {
    return merge(FlexBoxStyle(textDirection: value));
  }

  /// Sets text baseline
  FlexBoxStyle textBaseline(TextBaseline value) {
    return merge(FlexBoxStyle(textBaseline: value));
  }

  /// Sets spacing
  FlexBoxStyle spacing(double value) {
    return merge(FlexBoxStyle(spacing: value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexBoxStyle gap(double value) {
    return merge(FlexBoxStyle(spacing: value));
  }

  FlexBoxStyle modifier(ModifierConfig value) {
    return merge(FlexBoxStyle(modifier: value));
  }

  /// Padding instance method
  @override
  FlexBoxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyle(padding: value));
  }

  /// Margin instance method
  @override
  FlexBoxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyle(margin: value));
  }

  @override
  FlexBoxStyle transform(Matrix4 value) {
    return merge(FlexBoxStyle(transform: value));
  }

  /// Decoration instance method - delegates to box
  @override
  FlexBoxStyle decoration(DecorationMix value) {
    return merge(FlexBoxStyle(decoration: value));
  }

  /// Constraints instance method
  @override
  FlexBoxStyle constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyle(constraints: value));
  }

  /// Modifier instance method
  @override
  FlexBoxStyle wrap(ModifierConfig value) {
    return modifier(value);
  }

  @override
  FlexBoxStyle variants(List<VariantStyle<FlexBoxSpec>> variants) {
    return merge(FlexBoxStyle(variants: variants));
  }

  @override
  FlexBoxStyle variant(Variant variant, FlexBoxStyle style) {
    return merge(FlexBoxStyle(variants: [VariantStyle(variant, style)]));
  }

  /// Border radius instance method
  @override
  FlexBoxStyle borderRadius(BorderRadiusGeometryMix value) {
    return merge(FlexBoxStyle(decoration: DecorationMix.borderRadius(value)));
  }

  /// Resolves to [FlexBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexBoxWidgetSpec = FlexBoxStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<FlexBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final flexSpec = MixOps.resolve(context, $flex);

    final flexBoxSpec = FlexBoxSpec(box: boxSpec, flex: flexSpec);

    return WidgetSpec(
      spec: flexBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [FlexBoxStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexBoxStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexBoxStyle merge(FlexBoxStyle? other) {
    if (other == null) return this;

    return FlexBoxStyle.create(
      box: MixOps.merge($box, other.$box),
      flex: MixOps.merge($flex, other.$flex),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('flex', $flex));
  }

  /// The list of properties that constitute the state of this [FlexBoxStyle].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [FlexBoxStyle] instances for equality.
  @override
  List<Object?> get props => [$box, $flex];
}

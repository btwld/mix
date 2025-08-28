import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
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
import 'stack_box_spec.dart';
import 'stack_spec.dart';
import 'stack_style.dart';

typedef StackBoxMix = StackBoxStyle;

/// Represents the attributes of a [ZBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ZBoxSpec].
///
/// Use this class to configure the attributes of a [ZBoxSpec] and pass it to
/// the [ZBoxSpec] constructor.
class StackBoxStyle extends Style<ZBoxSpec>
    with
        Diagnosticable,
        StyleVariantMixin<StackBoxStyle, ZBoxSpec>,
        BorderRadiusMixin<StackBoxStyle>,
        DecorationMixin<StackBoxStyle>,
        SpacingMixin<StackBoxStyle>,
        TransformMixin<StackBoxStyle>,
        ConstraintsMixin<StackBoxStyle> {
  final Prop<WidgetSpec<BoxSpec>>? $box;
  final Prop<WidgetSpec<StackSpec>>? $stack;

  StackBoxStyle({
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
    Clip? stackClipBehavior,
    // Style properties
    super.modifier,
    super.animation,
    super.variants,
    super.inherit,
  }) : $box = Prop.maybeMix(
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
       $stack = Prop.maybeMix(
         StackStyle(
           alignment: stackAlignment,
           fit: fit,
           clipBehavior: stackClipBehavior,
         ),
       );

  const StackBoxStyle.create({
    Prop<WidgetSpec<BoxSpec>>? box,
    Prop<WidgetSpec<StackSpec>>? stack,
    super.modifier,
    super.animation,
    super.variants,

    super.inherit,
  }) : $box = box,
       $stack = stack;

  /// Sets animation
  StackBoxStyle animate(AnimationConfig animation) {
    return merge(StackBoxStyle(animation: animation));
  }

  StackBoxStyle modifier(ModifierConfig value) {
    return merge(StackBoxStyle(modifier: value));
  }

  @override
  StackBoxStyle variants(List<VariantStyle<ZBoxSpec>> variants) {
    return merge(StackBoxStyle(variants: variants));
  }

  @override
  StackBoxStyle variant(Variant variant, StackBoxStyle style) {
    return merge(StackBoxStyle(variants: [VariantStyle(variant, style)]));
  }

  // Mixin implementations - delegate to BoxMix

  /// Padding instance method - delegates to box
  @override
  StackBoxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyle(padding: value));
  }

  /// Margin instance method - delegates to box
  @override
  StackBoxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyle(margin: value));
  }

  /// Transform instance method - delegates to box
  @override
  StackBoxStyle transform(Matrix4 value) {
    return merge(StackBoxStyle(transform: value));
  }

  /// Decoration instance method - delegates to box
  @override
  StackBoxStyle decoration(DecorationMix value) {
    return merge(StackBoxStyle(decoration: value));
  }

  /// Constraints instance method - delegates to box
  @override
  StackBoxStyle constraints(BoxConstraintsMix value) {
    return merge(StackBoxStyle(constraints: value));
  }

  /// Border radius instance method - delegates to box
  @override
  StackBoxStyle borderRadius(BorderRadiusGeometryMix value) {
    return merge(StackBoxStyle(decoration: DecorationMix.borderRadius(value)));
  }

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final zBoxSpec = StackBoxStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<ZBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final stackSpec = MixOps.resolve(context, $stack);

    final zBoxSpec = ZBoxSpec(box: boxSpec, stack: stackSpec);

    return WidgetSpec(
      spec: zBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  /// Merges the properties of this [StackBoxStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackBoxStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StackBoxStyle merge(StackBoxStyle? other) {
    if (other == null) return this;

    return StackBoxStyle.create(
      box: MixOps.merge($box, other.$box),
      stack: MixOps.merge($stack, other.$stack),
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      animation: other.$animation ?? $animation,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('stack', $stack));
  }

  /// The list of properties that constitute the state of this [StackBoxStyle].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxStyle] instances for equality.
  @override
  List<Object?> get props => [$box, $stack];
}

/// Utility class for configuring [ZBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [ZBoxSpec].
/// Use the methods of this class to configure specific properties of a [ZBoxSpec].
class StackBoxSpecUtility {
  /// Utility for defining [StackBoxStyle] box properties
  final box = BoxStyle();

  /// Utility for defining [StackBoxStyle.stack]
  final stack = StackStyle();

  StackBoxSpecUtility();

  static StackBoxSpecUtility get self => StackBoxSpecUtility();

  /// Returns a new [StackBoxStyle] with the specified properties.
  StackBoxStyle only({
    // Box properties
    DecorationMix? decoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    BoxConstraintsMix? constraints,
    AlignmentGeometry? alignment,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    // Stack properties
    AlignmentGeometry? stackAlignment,
    StackFit? fit,
    Clip? stackClipBehavior,
    // Style properties
    ModifierConfig? modifier,
    AnimationConfig? animation,
    List<VariantStyle<ZBoxSpec>>? variants,
  }) {
    return StackBoxStyle(
      decoration: decoration,
      padding: padding,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      stackAlignment: stackAlignment,
      fit: fit,
      stackClipBehavior: stackClipBehavior,
      modifier: modifier,
      animation: animation,
      variants: variants,
    );
  }
}

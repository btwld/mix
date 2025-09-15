import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../properties/layout/constraints_mix.dart';
import '../../properties/layout/edge_insets_geometry_mix.dart';
import '../../properties/painting/border_radius_mix.dart';
import '../../properties/painting/decoration_mix.dart';
import '../../style/mixins/border_radius_style_mixin.dart';
import '../../style/mixins/constraint_style_mixin.dart';
import '../../style/mixins/decoration_style_mixin.dart';
import '../../style/mixins/spacing_style_mixin.dart';
import '../../style/mixins/transform_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../variants/variant.dart';
import '../box/box_spec.dart';
import '../box/box_style.dart';
import 'stack_box_spec.dart';
import 'stack_spec.dart';
import 'stack_style.dart';

typedef StackBoxMix = StackBoxStyler;

/// Represents the attributes of a [ZBoxSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ZBoxSpec].
///
/// Use this class to configure the attributes of a [ZBoxSpec] and pass it to
/// the [ZBoxSpec] constructor.
class StackBoxStyler extends Style<ZBoxSpec>
    with
        Diagnosticable,
        VariantStyleMixin<StackBoxStyler, ZBoxSpec>,
        BorderRadiusStyleMixin<StackBoxStyler>,
        DecorationStyleMixin<StackBoxStyler>,
        SpacingStyleMixin<StackBoxStyler>,
        TransformStyleMixin<StackBoxStyler>,
        ConstraintStyleMixin<StackBoxStyler> {
  final Prop<StyleSpec<BoxSpec>>? $box;
  final Prop<StyleSpec<StackSpec>>? $stack;

  StackBoxStyler({
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
    TextDirection? textDirection,
    Clip? stackClipBehavior,
    // Style properties
    super.modifier,
    super.animation,
    super.variants,
  }) : $box = Prop.maybeMix(
         BoxStyler(
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
         StackStyler(
           alignment: stackAlignment,
           fit: fit,
           textDirection: textDirection,
           clipBehavior: stackClipBehavior,
         ),
       );

  const StackBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<StackSpec>>? stack,
    super.modifier,
    super.animation,
    super.variants,
  }) : $box = box,
       $stack = stack;

  static StackBoxMutableStyler get chain => StackBoxMutableStyler.self;

  /// Sets animation
  StackBoxStyler animate(AnimationConfig animation) {
    return merge(StackBoxStyler(animation: animation));
  }

  StackBoxStyler modifier(WidgetModifierConfig value) {
    return merge(StackBoxStyler(modifier: value));
  }

  // Stack property convenience methods

  /// Sets stack alignment
  StackBoxStyler stackAlignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(stackAlignment: value));
  }

  /// Sets stack fit
  StackBoxStyler fit(StackFit value) {
    return merge(StackBoxStyler(fit: value));
  }

  /// Sets text direction
  StackBoxStyler textDirection(TextDirection value) {
    return merge(StackBoxStyler(textDirection: value));
  }

  /// Sets stack clip behavior
  StackBoxStyler stackClipBehavior(Clip value) {
    return merge(StackBoxStyler(stackClipBehavior: value));
  }

  // Box property convenience methods

  /// Sets box alignment
  StackBoxStyler alignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(alignment: value));
  }

  /// Sets transform alignment
  StackBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(transformAlignment: value));
  }

  /// Sets box clip behavior
  StackBoxStyler clipBehavior(Clip value) {
    return merge(StackBoxStyler(clipBehavior: value));
  }

  /// Sets foreground decoration
  @override
  StackBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(StackBoxStyler(foregroundDecoration: value));
  }

  @override
  StackBoxStyler withVariants(List<Variant<ZBoxSpec>> variants) {
    return merge(StackBoxStyler(variants: variants));
  }

  // Mixin implementations - delegate to BoxMix

  /// Padding instance method - delegates to box
  @override
  StackBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyler(padding: value));
  }

  /// Margin instance method - delegates to box
  @override
  StackBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyler(margin: value));
  }

  /// Transform instance method - delegates to box
  @override
  StackBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      StackBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  /// Decoration instance method - delegates to box
  @override
  StackBoxStyler decoration(DecorationMix value) {
    return merge(StackBoxStyler(decoration: value));
  }

  /// Constraints instance method - delegates to box
  @override
  StackBoxStyler constraints(BoxConstraintsMix value) {
    return merge(StackBoxStyler(constraints: value));
  }

  /// Border radius instance method - delegates to box
  @override
  StackBoxStyler borderRadius(BorderRadiusGeometryMix value) {
    return merge(StackBoxStyler(decoration: DecorationMix.borderRadius(value)));
  }

  /// Resolves to [ZBoxSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final zBoxSpec = StackBoxStyler(...).resolve(context);
  /// ```
  @override
  StyleSpec<ZBoxSpec> resolve(BuildContext context) {
    final boxSpec = MixOps.resolve(context, $box);
    final stackSpec = MixOps.resolve(context, $stack);

    final zBoxSpec = ZBoxSpec(box: boxSpec, stack: stackSpec);

    return StyleSpec(
      spec: zBoxSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [StackBoxStyler] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [StackBoxStyler] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  StackBoxStyler merge(StackBoxStyler? other) {
    return StackBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      stack: MixOps.merge($stack, other?.$stack),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      variants: MixOps.mergeVariants($variants, other?.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('stack', $stack));
  }

  /// The list of properties that constitute the state of this [StackBoxStyler].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [StackBoxStyler] instances for equality.
  @override
  List<Object?> get props => [$box, $stack];
}

/// Utility class for configuring [ZBoxSpec] properties.
///
/// This class provides methods to set individual properties of a [ZBoxSpec].
/// Use the methods of this class to configure specific properties of a [ZBoxSpec].
class StackBoxMutableStyler {
  /// Utility for defining [StackBoxStyler] box properties
  final box = BoxStyler();

  /// Utility for defining [StackBoxStyler.stack]
  final stack = StackStyler();

  StackBoxMutableStyler();

  static StackBoxMutableStyler get self => StackBoxMutableStyler();

  /// Returns a new [StackBoxStyler] with the specified properties.
  StackBoxStyler only({
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
    TextDirection? textDirection,
    Clip? stackClipBehavior,
    // Style properties
    WidgetModifierConfig? modifier,
    AnimationConfig? animation,
    List<Variant<ZBoxSpec>>? variants,
  }) {
    return StackBoxStyler(
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
      textDirection: textDirection,
      stackClipBehavior: stackClipBehavior,
      modifier: modifier,
      animation: animation,
      variants: variants,
    );
  }
}

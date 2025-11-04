import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../style/mixins/animation_style_mixin.dart';
import '../../style/mixins/variant_style_mixin.dart';
import '../../style/mixins/widget_modifier_style_mixin.dart';
import '../../style/mixins/widget_state_variant_mixin.dart';
import 'stack_spec.dart';

typedef StackMix = StackStyler;

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackStyler extends Style<StackSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<StackStyler, StackSpec>,
        VariantStyleMixin<StackStyler, StackSpec>,
        WidgetStateVariantMixin<StackStyler, StackSpec>,
        AnimationStyleMixin<StackStyler, StackSpec> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
  final Prop<Clip>? $clipBehavior;

  const StackStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    super.animation,
    super.modifier,
    super.variants,
  }) : $alignment = alignment,
       $fit = fit,
       $textDirection = textDirection,
       $clipBehavior = clipBehavior;

  StackStyler({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<StackSpec>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  /// Sets stack alignment
  StackStyler alignment(AlignmentGeometry value) {
    return merge(StackStyler(alignment: value));
  }

  /// Sets stack fit
  StackStyler fit(StackFit value) {
    return merge(StackStyler(fit: value));
  }

  /// Sets text direction
  StackStyler textDirection(TextDirection value) {
    return merge(StackStyler(textDirection: value));
  }

  /// Sets clip behavior
  StackStyler clipBehavior(Clip value) {
    return merge(StackStyler(clipBehavior: value));
  }

  StackStyler modifier(WidgetModifierConfig value) {
    return merge(StackStyler(modifier: value));
  }

  /// Convenience method for animating the StackStyleSpec
  @override
  StackStyler animate(AnimationConfig animation) {
    return merge(StackStyler(animation: animation));
  }

  @override
  StackStyler variants(List<VariantStyle<StackSpec>> variants) {
    return merge(StackStyler(variants: variants));
  }

  /// Resolves to [StackSpec] using the provided [BuildContext].
  @override
  StyleSpec<StackSpec> resolve(BuildContext context) {
    final stackSpec = StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );

    return StyleSpec(
      spec: stackSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [StackStyler] with the properties of [other].
  @override
  StackStyler merge(StackStyler? other) {
    return StackStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      fit: MixOps.merge($fit, other?.$fit),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      variants: MixOps.mergeVariants($variants, other?.$variants),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  StackStyler wrap(WidgetModifierConfig value) {
    return modifier(value);
  }

  @override
  List<Object?> get props => [
    $alignment,
    $fit,
    $textDirection,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}

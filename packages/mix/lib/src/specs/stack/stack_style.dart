import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

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
import 'stack_mutable_style.dart';
import 'stack_spec.dart';

part 'stack_style.g.dart';

@Deprecated('Use StackStyler instead')
typedef StackMix = StackStyler;

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
@MixableStyler()
class StackStyler extends Style<StackSpec>
    with
        Diagnosticable,
        WidgetModifierStyleMixin<StackStyler, StackSpec>,
        VariantStyleMixin<StackStyler, StackSpec>,
        WidgetStateVariantMixin<StackStyler, StackSpec>,
        AnimationStyleMixin<StackStyler, StackSpec>,
        _$StackStylerMixin {
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<StackFit>? $fit;
  @override
  final Prop<TextDirection>? $textDirection;
  @override
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

  static StackMutableStyler get chain => StackMutableStyler(StackStyler());

  /// Sets the widget modifier.
  StackStyler modifier(WidgetModifierConfig value) {
    return merge(StackStyler(modifier: value));
  }
}

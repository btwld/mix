import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/widget_modifier_config.dart';
import '../../style/abstracts/styler.dart';
import '../../style/mixins/flex_style_mixin.dart';
import 'flex_mutable_style.dart';
import 'flex_spec.dart';

part 'flex_style.g.dart';

@Deprecated('Use FlexStyler instead')
typedef FlexMix = FlexStyler;

/// Represents the attributes of a [FlexSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexSpec].
///
/// Use this class to configure the attributes of a [FlexSpec] and pass it to
/// the [FlexSpec] constructor.
/// A style/attribute class for [FlexSpec], used to configure and compose flex layout properties.
@MixableStyler()
class FlexStyler extends MixStyler<FlexStyler, FlexSpec>
    with FlexStyleMixin<FlexStyler>, _$FlexStylerMixin {
  @override
  final Prop<Axis>? $direction;
  @override
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  @override
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  @override
  final Prop<MainAxisSize>? $mainAxisSize;
  @override
  final Prop<VerticalDirection>? $verticalDirection;
  @override
  final Prop<TextDirection>? $textDirection;
  @override
  final Prop<TextBaseline>? $textBaseline;
  @override
  final Prop<Clip>? $clipBehavior;
  @override
  final Prop<double>? $spacing;

  const FlexStyler.create({
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<Clip>? clipBehavior,
    Prop<double>? spacing,
    @Deprecated(
      'Use spacing instead. '
      'This feature was deprecated after Mix v2.0.0.',
    )
    Prop<double>? gap,
    super.animation,
    super.modifier,
    super.variants,
  }) : $direction = direction,
       $mainAxisAlignment = mainAxisAlignment,
       $crossAxisAlignment = crossAxisAlignment,
       $mainAxisSize = mainAxisSize,
       $verticalDirection = verticalDirection,
       $textDirection = textDirection,
       $textBaseline = textBaseline,
       $clipBehavior = clipBehavior,
       $spacing = spacing ?? gap;

  FlexStyler({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<FlexSpec>>? variants,
  }) : this.create(
         direction: Prop.maybe(direction),
         mainAxisAlignment: Prop.maybe(mainAxisAlignment),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         mainAxisSize: Prop.maybe(mainAxisSize),
         verticalDirection: Prop.maybe(verticalDirection),
         textDirection: Prop.maybe(textDirection),
         textBaseline: Prop.maybe(textBaseline),
         clipBehavior: Prop.maybe(clipBehavior),
         spacing: Prop.maybe(spacing),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  static FlexMutableStyler get chain => .new(FlexStyler());

  /// Sets the widget modifier.
  FlexStyler modifier(WidgetModifierConfig value) {
    return merge(FlexStyler(modifier: value));
  }

  // FlexMixin implementation
  @override
  FlexStyler flex(FlexStyler value) {
    return merge(value);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/style_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'flex_spec.dart';
import 'flex_util.dart';

typedef FlexMix = FlexStyler;

/// Represents the attributes of a [FlexSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexSpec].
///
/// Use this class to configure the attributes of a [FlexSpec] and pass it to
/// the [FlexSpec] constructor.
/// A style/attribute class for [FlexSpec], used to configure and compose flex layout properties.
class FlexStyler extends Style<FlexSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexStyler, FlexSpec>,
        StyleVariantMixin<FlexStyler, FlexSpec>,
        StyleAnimationMixin<FlexSpec, FlexStyler> {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
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
    @Deprecated(
      'Use spacing instead. '
      'This feature was deprecated after Mix v2.0.0.',
    )
    double? gap,
    AnimationConfig? animation,
    ModifierConfig? modifier,
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
         spacing: Prop.maybe(spacing ?? gap),
         animation: animation,
         modifier: modifier,
         variants: variants,
       );

  factory FlexStyler.builder(FlexStyler Function(BuildContext) fn) {
    return FlexStyler().builder(fn);
  }

  static FlexSpecUtility get chain => FlexSpecUtility(FlexStyler());

  /// The gap between children.
  @Deprecated(
    'Use \$spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  Prop<double>? get $gap => $spacing;

  /// Sets flex direction
  FlexStyler direction(Axis value) {
    return merge(FlexStyler(direction: value));
  }

  /// Sets main axis alignment
  FlexStyler mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexStyler(mainAxisAlignment: value));
  }

  /// Sets spacing

  /// Sets cross axis alignment
  FlexStyler crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexStyler(crossAxisAlignment: value));
  }

  /// Sets main axis size
  FlexStyler mainAxisSize(MainAxisSize value) {
    return merge(FlexStyler(mainAxisSize: value));
  }

  /// Sets vertical direction
  FlexStyler verticalDirection(VerticalDirection value) {
    return merge(FlexStyler(verticalDirection: value));
  }

  /// Sets text direction
  FlexStyler textDirection(TextDirection value) {
    return merge(FlexStyler(textDirection: value));
  }

  /// Sets text baseline
  FlexStyler textBaseline(TextBaseline value) {
    return merge(FlexStyler(textBaseline: value));
  }

  /// Sets clip behavior
  FlexStyler clipBehavior(Clip value) {
    return merge(FlexStyler(clipBehavior: value));
  }

  /// Sets spacing
  FlexStyler spacing(double value) {
    return merge(FlexStyler(spacing: value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexStyler gap(double value) {
    return merge(FlexStyler(spacing: value));
  }

  /// Convenience method for setting direction to horizontal (row)
  FlexStyler row() => direction(Axis.horizontal);

  /// Convenience method for setting direction to vertical (column)
  FlexStyler column() => direction(Axis.vertical);

  FlexStyler modifier(ModifierConfig value) {
    return merge(FlexStyler(modifier: value));
  }

  /// Convenience method for animating the FlexStyleSpec
  @override
  FlexStyler animate(AnimationConfig animation) {
    return merge(FlexStyler(animation: animation));
  }

  @override
  FlexStyler variants(List<VariantStyle<FlexSpec>> variants) {
    return merge(FlexStyler(variants: variants));
  }

  /// Resolves to [FlexSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexStyleSpec = FlexStyler(...).resolve(context);
  /// ```
  @override
  StyleSpec<FlexSpec> resolve(BuildContext context) {
    final flexSpec = FlexSpec(
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      textDirection: MixOps.resolve(context, $textDirection),
      textBaseline: MixOps.resolve(context, $textBaseline),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      spacing: MixOps.resolve(context, $spacing),
    );

    return StyleSpec(
      spec: flexSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  /// Merges the properties of this [FlexStyler] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexStyler] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexStyler merge(FlexStyler? other) {
    return FlexStyler.create(
      direction: MixOps.merge($direction, other?.$direction),
      mainAxisAlignment: MixOps.merge(
        $mainAxisAlignment,
        other?.$mainAxisAlignment,
      ),
      crossAxisAlignment: MixOps.merge(
        $crossAxisAlignment,
        other?.$crossAxisAlignment,
      ),
      mainAxisSize: MixOps.merge($mainAxisSize, other?.$mainAxisSize),
      verticalDirection: MixOps.merge(
        $verticalDirection,
        other?.$verticalDirection,
      ),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other?.$textBaseline),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      spacing: MixOps.merge($spacing, other?.$spacing),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      variants: MixOps.mergeVariants($variants, other?.$variants),
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('spacing', $spacing));
  }

  @override
  FlexStyler variant(Variant variant, FlexStyler style) {
    return merge(FlexStyler(variants: [VariantStyle(variant, style)]));
  }

  @override
  FlexStyler wrap(ModifierConfig value) {
    return modifier(value);
  }

  @override
  /// Returns a list of properties used for equality comparison and hashing.
  @override
  List<Object?> get props => [
    $direction,
    $mainAxisAlignment,
    $crossAxisAlignment,
    $mainAxisSize,
    $verticalDirection,
    $textDirection,
    $textBaseline,
    $clipBehavior,
    $spacing,
    $animation,
    $modifier,
    $variants,
  ];
}

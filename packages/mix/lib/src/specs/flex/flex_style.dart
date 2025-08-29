import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/widget_spec.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'flex_spec.dart';
import 'flex_util.dart';

typedef FlexMix = FlexStyle;

/// Represents the attributes of a [FlexSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexSpec].
///
/// Use this class to configure the attributes of a [FlexSpec] and pass it to
/// the [FlexSpec] constructor.
/// A style/attribute class for [FlexSpec], used to configure and compose flex layout properties.
class FlexStyle extends Style<FlexSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexStyle, FlexSpec>,
        StyleVariantMixin<FlexStyle, FlexSpec>,
        StyleAnimationMixin<FlexSpec, FlexStyle> {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $spacing;

  const FlexStyle.create({
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

  FlexStyle({
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

  factory FlexStyle.builder(FlexStyle Function(BuildContext) fn) {
    return FlexStyle().builder(fn);
  }

  static FlexSpecUtility get chain => FlexSpecUtility(FlexStyle());

  /// The gap between children.
  @Deprecated(
    'Use \$spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  Prop<double>? get $gap => $spacing;

  /// Sets flex direction
  FlexStyle direction(Axis value) {
    return merge(FlexStyle(direction: value));
  }

  /// Sets main axis alignment
  FlexStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexStyle(mainAxisAlignment: value));
  }

  /// Sets spacing

  /// Sets cross axis alignment
  FlexStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexStyle(crossAxisAlignment: value));
  }

  /// Sets main axis size
  FlexStyle mainAxisSize(MainAxisSize value) {
    return merge(FlexStyle(mainAxisSize: value));
  }

  /// Sets vertical direction
  FlexStyle verticalDirection(VerticalDirection value) {
    return merge(FlexStyle(verticalDirection: value));
  }

  /// Sets text direction
  FlexStyle textDirection(TextDirection value) {
    return merge(FlexStyle(textDirection: value));
  }

  /// Sets text baseline
  FlexStyle textBaseline(TextBaseline value) {
    return merge(FlexStyle(textBaseline: value));
  }

  /// Sets clip behavior
  FlexStyle clipBehavior(Clip value) {
    return merge(FlexStyle(clipBehavior: value));
  }

  /// Sets spacing
  FlexStyle spacing(double value) {
    return merge(FlexStyle(spacing: value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexStyle gap(double value) {
    return merge(FlexStyle(spacing: value));
  }

  /// Convenience method for setting direction to horizontal (row)
  FlexStyle row() => direction(Axis.horizontal);

  /// Convenience method for setting direction to vertical (column)
  FlexStyle column() => direction(Axis.vertical);

  FlexStyle modifier(ModifierConfig value) {
    return merge(FlexStyle(modifier: value));
  }

  /// Convenience method for animating the FlexStyleSpec
  @override
  FlexStyle animate(AnimationConfig animation) {
    return merge(FlexStyle(animation: animation));
  }

  @override
  FlexStyle variants(List<VariantStyle<FlexSpec>> variants) {
    return merge(FlexStyle(variants: variants));
  }

  /// Resolves to [FlexSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexStyleSpec = FlexStyle(...).resolve(context);
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

  /// Merges the properties of this [FlexStyle] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexStyle] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexStyle merge(FlexStyle? other) {
    if (other == null) return this;

    return FlexStyle.create(
      direction: MixOps.merge($direction, other.$direction),
      mainAxisAlignment: MixOps.merge(
        $mainAxisAlignment,
        other.$mainAxisAlignment,
      ),
      crossAxisAlignment: MixOps.merge(
        $crossAxisAlignment,
        other.$crossAxisAlignment,
      ),
      mainAxisSize: MixOps.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixOps.merge(
        $verticalDirection,
        other.$verticalDirection,
      ),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other.$textBaseline),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
      spacing: MixOps.merge($spacing, other.$spacing),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),
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
  FlexStyle variant(Variant variant, FlexStyle style) {
    return merge(FlexStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  FlexStyle wrap(ModifierConfig value) {
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

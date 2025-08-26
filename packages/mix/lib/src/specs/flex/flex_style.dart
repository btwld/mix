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

/// Represents the attributes of a [FlexSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [FlexSpec].
///
/// Use this class to configure the attributes of a [FlexSpec] and pass it to
/// the [FlexSpec] constructor.
/// A style/attribute container for [FlexSpec], used to configure and compose flex layout properties.
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
  @Deprecated(
    'Use \$spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  final Prop<double>? $gap;

  /// Factory for flex direction
  factory FlexStyle.direction(Axis value) {
    return FlexStyle(direction: value);
  }

  /// Factory for main axis alignment
  factory FlexStyle.mainAxisAlignment(MainAxisAlignment value) {
    return FlexStyle(mainAxisAlignment: value);
  }

  /// Factory for cross axis alignment
  factory FlexStyle.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexStyle(crossAxisAlignment: value);
  }

  /// Factory for main axis size
  factory FlexStyle.mainAxisSize(MainAxisSize value) {
    return FlexStyle(mainAxisSize: value);
  }

  /// Factory for vertical direction
  factory FlexStyle.verticalDirection(VerticalDirection value) {
    return FlexStyle(verticalDirection: value);
  }

  /// Factory for text direction
  factory FlexStyle.textDirection(TextDirection value) {
    return FlexStyle(textDirection: value);
  }

  /// Factory for text baseline
  factory FlexStyle.textBaseline(TextBaseline value) {
    return FlexStyle(textBaseline: value);
  }

  /// Factory for clip behavior
  factory FlexStyle.clipBehavior(Clip value) {
    return FlexStyle(clipBehavior: value);
  }

  /// Factory for spacing
  factory FlexStyle.spacing(double value) {
    return FlexStyle(spacing: value);
  }

  /// Factory for gap
  @Deprecated(
    'Use FlexMix.spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  factory FlexStyle.gap(double value) {
    return FlexStyle(spacing: value);
  }

  /// Factory for animation
  factory FlexStyle.animate(AnimationConfig animation) {
    return FlexStyle(animation: animation);
  }

  /// Factory for variant
  factory FlexStyle.variant(Variant variant, FlexStyle value) {
    return FlexStyle(variants: [VariantStyle(variant, value)]);
  }

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

    super.inherit,
  }) : $direction = direction,
       $mainAxisAlignment = mainAxisAlignment,
       $crossAxisAlignment = crossAxisAlignment,
       $mainAxisSize = mainAxisSize,
       $verticalDirection = verticalDirection,
       $textDirection = textDirection,
       $textBaseline = textBaseline,
       $clipBehavior = clipBehavior,
       $spacing = spacing ?? gap,
       $gap = gap;

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
    bool? inherit,
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
         inherit: inherit,
       );

  /// Constructor that accepts a [FlexSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexSpec] instances to [FlexStyle].
  ///
  /// ```dart
  /// const spec = FlexWidgetSpec(direction: Axis.horizontal, spacing: 8.0);
  /// final attr = FlexStyle.value(spec);
  /// ```
  FlexStyle.value(FlexSpec spec)
    : this(
        direction: spec.direction,
        mainAxisAlignment: spec.mainAxisAlignment,
        crossAxisAlignment: spec.crossAxisAlignment,
        mainAxisSize: spec.mainAxisSize,
        verticalDirection: spec.verticalDirection,
        textDirection: spec.textDirection,
        textBaseline: spec.textBaseline,
        clipBehavior: spec.clipBehavior,
        spacing: spec.spacing ?? spec.gap,
      );

  /// Factory for widget modifier
  factory FlexStyle.modifier(ModifierConfig modifier) {
    return FlexStyle(modifier: modifier);
  }

  /// Factory for widget modifier
  factory FlexStyle.wrap(ModifierConfig value) {
    return FlexStyle(modifier: value);
  }

  /// Constructor that accepts a nullable [FlexSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexStyle.value].
  ///
  /// ```dart
  /// const FlexWidgetSpec? spec = FlexWidgetSpec(direction: Axis.horizontal, spacing: 8.0);
  /// final attr = FlexStyle.maybeValue(spec); // Returns FlexStyle or null
  /// ```
  static FlexStyle? maybeValue(FlexSpec? spec) {
    return spec != null ? FlexStyle.value(spec) : null;
  }

  /// Sets flex direction
  FlexStyle direction(Axis value) {
    return merge(FlexStyle.direction(value));
  }

  /// Sets main axis alignment
  FlexStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexStyle.mainAxisAlignment(value));
  }

  /// Sets spacing

  /// Sets cross axis alignment
  FlexStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexStyle.crossAxisAlignment(value));
  }

  /// Sets main axis size
  FlexStyle mainAxisSize(MainAxisSize value) {
    return merge(FlexStyle.mainAxisSize(value));
  }

  /// Sets vertical direction
  FlexStyle verticalDirection(VerticalDirection value) {
    return merge(FlexStyle.verticalDirection(value));
  }

  /// Sets text direction
  FlexStyle textDirection(TextDirection value) {
    return merge(FlexStyle.textDirection(value));
  }

  /// Sets text baseline
  FlexStyle textBaseline(TextBaseline value) {
    return merge(FlexStyle.textBaseline(value));
  }

  /// Sets clip behavior
  FlexStyle clipBehavior(Clip value) {
    return merge(FlexStyle.clipBehavior(value));
  }

  /// Sets spacing
  FlexStyle spacing(double value) {
    return merge(FlexStyle.spacing(value));
  }

  /// Sets gap
  @Deprecated(
    'Use spacing instead. '
    'This feature was deprecated after Mix v2.0.0.',
  )
  FlexStyle gap(double value) {
    return merge(FlexStyle.spacing(value));
  }

  /// Convenience method for setting direction to horizontal (row)
  FlexStyle row() => direction(Axis.horizontal);

  /// Convenience method for setting direction to vertical (column)
  FlexStyle column() => direction(Axis.vertical);

  FlexStyle modifier(ModifierConfig value) {
    return merge(FlexStyle(modifier: value));
  }

  /// Convenience method for animating the FlexWidgetSpec
  @override
  FlexStyle animate(AnimationConfig animation) {
    return merge(FlexStyle.animate(animation));
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
  /// final flexWidgetSpec = FlexStyle(...).resolve(context);
  /// ```
  @override
  WidgetSpec<FlexSpec> resolve(BuildContext context) {
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
    
    return WidgetSpec(
      spec: flexSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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
      inherit: other.$inherit ?? $inherit,
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

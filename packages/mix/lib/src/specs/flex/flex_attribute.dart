import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
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
class FlexMix extends Style<FlexSpec>
    with
        Diagnosticable,
        StyleModifierMixin<FlexMix, FlexSpec>,
        StyleVariantMixin<FlexMix, FlexSpec> {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $gap;

  /// Factory for flex direction
  factory FlexMix.direction(Axis value) {
    return FlexMix(direction: value);
  }

  /// Factory for main axis alignment
  factory FlexMix.mainAxisAlignment(MainAxisAlignment value) {
    return FlexMix(mainAxisAlignment: value);
  }

  /// Factory for cross axis alignment
  factory FlexMix.crossAxisAlignment(CrossAxisAlignment value) {
    return FlexMix(crossAxisAlignment: value);
  }

  /// Factory for main axis size
  factory FlexMix.mainAxisSize(MainAxisSize value) {
    return FlexMix(mainAxisSize: value);
  }

  /// Factory for vertical direction
  factory FlexMix.verticalDirection(VerticalDirection value) {
    return FlexMix(verticalDirection: value);
  }

  /// Factory for text direction
  factory FlexMix.textDirection(TextDirection value) {
    return FlexMix(textDirection: value);
  }

  /// Factory for text baseline
  factory FlexMix.textBaseline(TextBaseline value) {
    return FlexMix(textBaseline: value);
  }

  /// Factory for clip behavior
  factory FlexMix.clipBehavior(Clip value) {
    return FlexMix(clipBehavior: value);
  }

  /// Factory for gap
  factory FlexMix.gap(double value) {
    return FlexMix(gap: value);
  }

  /// Factory for animation
  factory FlexMix.animate(AnimationConfig animation) {
    return FlexMix(animation: animation);
  }

  /// Factory for variant
  factory FlexMix.variant(Variant variant, FlexMix value) {
    return FlexMix(variants: [VariantStyleAttribute(variant, value)]);
  }

  const FlexMix.raw({
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<Clip>? clipBehavior,
    Prop<double>? gap,
    super.animation,
    super.modifierConfig,
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
       $gap = gap;

  FlexMix({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? gap,
    AnimationConfig? animation,
    ModifierConfig? modifierConfig,
    List<VariantStyleAttribute<FlexSpec>>? variants,
    bool? inherit,
  }) : this.raw(
         direction: Prop.maybe(direction),
         mainAxisAlignment: Prop.maybe(mainAxisAlignment),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         mainAxisSize: Prop.maybe(mainAxisSize),
         verticalDirection: Prop.maybe(verticalDirection),
         textDirection: Prop.maybe(textDirection),
         textBaseline: Prop.maybe(textBaseline),
         clipBehavior: Prop.maybe(clipBehavior),
         gap: Prop.maybe(gap),
         animation: animation,
         modifierConfig: modifierConfig,
         variants: variants,
         inherit: inherit,
       );

  /// Constructor that accepts a [FlexSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [FlexSpec] instances to [FlexMix].
  ///
  /// ```dart
  /// const spec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
  /// final attr = FlexMix.value(spec);
  /// ```
  FlexMix.value(FlexSpec spec)
    : this(
        direction: spec.direction,
        mainAxisAlignment: spec.mainAxisAlignment,
        crossAxisAlignment: spec.crossAxisAlignment,
        mainAxisSize: spec.mainAxisSize,
        verticalDirection: spec.verticalDirection,
        textDirection: spec.textDirection,
        textBaseline: spec.textBaseline,
        clipBehavior: spec.clipBehavior,
        gap: spec.gap,
      );

  /// Constructor that accepts a nullable [FlexSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [FlexMix.value].
  ///
  /// ```dart
  /// const FlexSpec? spec = FlexSpec(direction: Axis.horizontal, gap: 8.0);
  /// final attr = FlexMix.maybeValue(spec); // Returns FlexMix or null
  /// ```
  static FlexMix? maybeValue(FlexSpec? spec) {
    return spec != null ? FlexMix.value(spec) : null;
  }

  /// Sets flex direction
  FlexMix direction(Axis value) {
    return merge(FlexMix.direction(value));
  }

  /// Sets main axis alignment
  FlexMix mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexMix.mainAxisAlignment(value));
  }

  /// Sets cross axis alignment
  FlexMix crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexMix.crossAxisAlignment(value));
  }

  /// Sets main axis size
  FlexMix mainAxisSize(MainAxisSize value) {
    return merge(FlexMix.mainAxisSize(value));
  }

  /// Sets vertical direction
  FlexMix verticalDirection(VerticalDirection value) {
    return merge(FlexMix.verticalDirection(value));
  }

  /// Sets text direction
  FlexMix textDirection(TextDirection value) {
    return merge(FlexMix.textDirection(value));
  }

  /// Sets text baseline
  FlexMix textBaseline(TextBaseline value) {
    return merge(FlexMix.textBaseline(value));
  }

  /// Sets clip behavior
  FlexMix clipBehavior(Clip value) {
    return merge(FlexMix.clipBehavior(value));
  }

  /// Sets gap
  FlexMix gap(double value) {
    return merge(FlexMix.gap(value));
  }

  /// Convenience method for setting direction to horizontal (row)
  FlexMix row() => direction(Axis.horizontal);

  /// Convenience method for setting direction to vertical (column)
  FlexMix column() => direction(Axis.vertical);

  /// Convenience method for animating the FlexSpec
  FlexMix animate(AnimationConfig animation) {
    return merge(FlexMix.animate(animation));
  }

  @override
  FlexMix variants(List<VariantStyleAttribute<FlexSpec>> variants) {
    return merge(FlexMix(variants: variants));
  }

  @override
  FlexMix modifier(ModifierConfig value) {
    return merge(FlexMix(modifierConfig: value));
  }

  /// Resolves to [FlexSpec] using the provided [BuildContext].
  ///
  /// If a property is null in the context, it uses the default value
  /// defined in the property specification.
  ///
  /// ```dart
  /// final flexSpec = FlexMix(...).resolve(mix);
  /// ```
  @override
  FlexSpec resolve(BuildContext context) {
    return FlexSpec(
      direction: MixHelpers.resolve(context, $direction),
      mainAxisAlignment: MixHelpers.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixHelpers.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixHelpers.resolve(context, $mainAxisSize),
      verticalDirection: MixHelpers.resolve(context, $verticalDirection),
      textDirection: MixHelpers.resolve(context, $textDirection),
      textBaseline: MixHelpers.resolve(context, $textBaseline),
      clipBehavior: MixHelpers.resolve(context, $clipBehavior),
      gap: MixHelpers.resolve(context, $gap),
    );
  }

  /// Merges the properties of this [FlexMix] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [FlexMix] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  FlexMix merge(FlexMix? other) {
    if (other == null) return this;

    return FlexMix.raw(
      direction: MixHelpers.merge($direction, other.$direction),
      mainAxisAlignment: MixHelpers.merge(
        $mainAxisAlignment,
        other.$mainAxisAlignment,
      ),
      crossAxisAlignment: MixHelpers.merge(
        $crossAxisAlignment,
        other.$crossAxisAlignment,
      ),
      mainAxisSize: MixHelpers.merge($mainAxisSize, other.$mainAxisSize),
      verticalDirection: MixHelpers.merge(
        $verticalDirection,
        other.$verticalDirection,
      ),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      textBaseline: MixHelpers.merge($textBaseline, other.$textBaseline),
      clipBehavior: MixHelpers.merge($clipBehavior, other.$clipBehavior),
      gap: MixHelpers.merge($gap, other.$gap),
      animation: other.$animation ?? $animation,
      modifierConfig:
          $modifierConfig?.merge(other.$modifierConfig) ??
          other.$modifierConfig,
      variants: mergeVariantLists($variants, other.$variants),
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('direction', $direction));
    properties.add(
      DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment),
    );
    properties.add(
      DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment),
    );
    properties.add(DiagnosticsProperty('mainAxisSize', $mainAxisSize));
    properties.add(
      DiagnosticsProperty('verticalDirection', $verticalDirection),
    );
    properties.add(DiagnosticsProperty('textDirection', $textDirection));
    properties.add(DiagnosticsProperty('textBaseline', $textBaseline));
    properties.add(DiagnosticsProperty('clipBehavior', $clipBehavior));
    properties.add(DiagnosticsProperty('gap', $gap));
  }

  @override
  FlexMix variant(Variant variant, FlexMix style) {
    return merge(FlexMix(variants: [VariantStyleAttribute(variant, style)]));
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
    $gap,
    $animation,
    $modifierConfig,
    $variants,
  ];
}

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../animation/animation_mixin.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../modifiers/modifier_config.dart';
import '../../modifiers/modifier_util.dart';
import '../../variants/variant.dart';
import '../../variants/variant_util.dart';
import 'stack_spec.dart';

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackMix extends Style<StackSpec>
    with
        Diagnosticable,
        StyleModifierMixin<StackMix, StackSpec>,
        StyleVariantMixin<StackMix, StackSpec>,
        StyleAnimationMixin<StackSpec, StackMix> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
  final Prop<Clip>? $clipBehavior;

  /// Factory for stack alignment
  factory StackMix.alignment(AlignmentGeometry value) {
    return StackMix(alignment: value);
  }

  /// Factory for stack fit
  factory StackMix.fit(StackFit value) {
    return StackMix(fit: value);
  }

  /// Factory for text direction
  factory StackMix.textDirection(TextDirection value) {
    return StackMix(textDirection: value);
  }

  /// Factory for clip behavior
  factory StackMix.clipBehavior(Clip value) {
    return StackMix(clipBehavior: value);
  }

  /// Factory for animation
  factory StackMix.animate(AnimationConfig animation) {
    return StackMix(animation: animation);
  }

  /// Factory for variant
  factory StackMix.variant(Variant variant, StackMix value) {
    return StackMix(variants: [VariantStyle(variant, value)]);
  }

  /// Factory for widget modifier
  factory StackMix.modifier(ModifierConfig modifier) {
    return StackMix(modifier: modifier);
  }

  factory StackMix.wrap(ModifierConfig value) {
    return StackMix(modifier: value);
  }

  const StackMix.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    super.animation,
    super.modifier,
    super.variants,

    super.inherit,
  }) : $alignment = alignment,
       $fit = fit,
       $textDirection = textDirection,
       $clipBehavior = clipBehavior;

  StackMix({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    ModifierConfig? modifier,
    List<VariantStyle<StackSpec>>? variants,
    bool? inherit,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         animation: animation,
         modifier: modifier,
         variants: variants,
         inherit: inherit,
       );

  /// Constructor that accepts a [StackSpec] value and extracts its properties.
  ///
  /// This is useful for converting existing [StackSpec] instances to [StackMix].
  ///
  /// ```dart
  /// const spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackMix.value(spec);
  /// ```
  StackMix.value(StackSpec spec)
    : this(
        alignment: spec.alignment,
        fit: spec.fit,
        textDirection: spec.textDirection,
        clipBehavior: spec.clipBehavior,
      );

  /// Constructor that accepts a nullable [StackSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackMix.value].
  ///
  /// ```dart
  /// const StackSpec? spec = StackSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackMix.maybeValue(spec); // Returns StackMix or null
  /// ```
  static StackMix? maybeValue(StackSpec? spec) {
    return spec != null ? StackMix.value(spec) : null;
  }

  /// Sets stack alignment
  StackMix alignment(AlignmentGeometry value) {
    return merge(StackMix.alignment(value));
  }

  /// Sets stack fit
  StackMix fit(StackFit value) {
    return merge(StackMix.fit(value));
  }

  /// Sets text direction
  StackMix textDirection(TextDirection value) {
    return merge(StackMix.textDirection(value));
  }

  /// Sets clip behavior
  StackMix clipBehavior(Clip value) {
    return merge(StackMix.clipBehavior(value));
  }

  /// Convenience method for animating the StackSpec
  @override
  StackMix animate(AnimationConfig animation) {
    return merge(StackMix.animate(animation));
  }

  StackMix modifier(ModifierConfig value) {
    return merge(StackMix(modifier: value));
  }

  @override
  StackMix variants(List<VariantStyle<StackSpec>> variants) {
    return merge(StackMix(variants: variants));
  }

  /// Resolves to [StackSpec] using the provided [BuildContext].
  @override
  StackSpec resolve(BuildContext context) {
    return StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [StackMix] with the properties of [other].
  @override
  StackMix merge(StackMix? other) {
    if (other == null) return this;

    return StackMix.create(
      alignment: MixOps.merge($alignment, other.$alignment),
      fit: MixOps.merge($fit, other.$fit),
      textDirection: MixOps.merge($textDirection, other.$textDirection),
      clipBehavior: MixOps.merge($clipBehavior, other.$clipBehavior),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      variants: mergeVariantLists($variants, other.$variants),

      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('alignment', $alignment, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('fit', $fit, defaultValue: null));
    properties.add(
      DiagnosticsProperty('textDirection', $textDirection, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('clipBehavior', $clipBehavior, defaultValue: null),
    );
  }

  @override
  StackMix variant(Variant variant, StackMix style) {
    return merge(StackMix(variants: [VariantStyle(variant, style)]));
  }

  @override
  StackMix wrap(ModifierConfig value) {
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

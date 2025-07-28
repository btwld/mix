import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation_config.dart';
import '../../core/helpers.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
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
        StyleVariantMixin<StackMix, StackSpec> {
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
    return StackMix(variants: [VariantStyleAttribute(variant, value)]);
  }

  const StackMix.raw({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    super.animation,
    super.modifiers,
    super.variants,
    super.orderOfModifiers,
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
    List<ModifierAttribute>? modifiers,
    List<VariantStyleAttribute<StackSpec>>? variants,
    List<Type>? orderOfModifiers,
    bool? inherit,
  }) : this.raw(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         animation: animation,
         modifiers: modifiers,
         variants: variants,
         orderOfModifiers: orderOfModifiers,
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
  StackMix animate(AnimationConfig animation) {
    return merge(StackMix.animate(animation));
  }

  @override
  StackMix variants(List<VariantStyleAttribute<StackSpec>> variants) {
    return merge(StackMix(variants: variants));
  }

  @override
  StackMix modifiers(List<ModifierAttribute> modifiers) {
    return merge(StackMix(modifiers: modifiers));
  }

  /// Resolves to [StackSpec] using the provided [BuildContext].
  @override
  StackSpec resolve(BuildContext context) {
    return StackSpec(
      alignment: MixHelpers.resolve(context, $alignment),
      fit: MixHelpers.resolve(context, $fit),
      textDirection: MixHelpers.resolve(context, $textDirection),
      clipBehavior: MixHelpers.resolve(context, $clipBehavior),
    );
  }

  /// Merges the properties of this [StackMix] with the properties of [other].
  @override
  StackMix merge(StackMix? other) {
    if (other == null) return this;

    return StackMix.raw(
      alignment: MixHelpers.merge($alignment, other.$alignment),
      fit: MixHelpers.merge($fit, other.$fit),
      textDirection: MixHelpers.merge($textDirection, other.$textDirection),
      clipBehavior: MixHelpers.merge($clipBehavior, other.$clipBehavior),
      animation: other.$animation ?? $animation,
      modifiers: mergeModifierLists($modifiers, other.$modifiers),
      variants: mergeVariantLists($variants, other.$variants),
      orderOfModifiers: other.$orderOfModifiers.isNotEmpty
          ? other.$orderOfModifiers
          : $orderOfModifiers,
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
    return merge(StackMix(variants: [VariantStyleAttribute(variant, style)]));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $fit,
    $textDirection,
    $clipBehavior,
    $animation,
    $modifiers,
    $variants,
  ];
}

import 'package:flutter/foundation.dart';
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
import 'stack_spec.dart';

/// Represents the attributes of a [StackSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [StackSpec].
///
/// Use this class to configure the attributes of a [StackSpec] and pass it to
/// the [StackSpec] constructor.
class StackStyle extends Style<StackSpec>
    with
        Diagnosticable,
        StyleModifierMixin<StackStyle, StackSpec>,
        StyleVariantMixin<StackStyle, StackSpec>,
        StyleAnimationMixin<StackSpec, StackStyle> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
  final Prop<Clip>? $clipBehavior;


  const StackStyle.create({
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

  StackStyle({
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
  /// This is useful for converting existing [StackSpec] instances to [StackStyle].
  ///
  /// ```dart
  /// const spec = StackWidgetSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackStyle.value(spec);
  /// ```
  StackStyle.value(StackSpec spec)
    : this(
        alignment: spec.alignment,
        fit: spec.fit,
        textDirection: spec.textDirection,
        clipBehavior: spec.clipBehavior,
      );

  /// Constructor that accepts a nullable [StackSpec] value and extracts its properties.
  ///
  /// Returns null if the input is null, otherwise uses [StackStyle.value].
  ///
  /// ```dart
  /// const StackWidgetSpec? spec = StackWidgetSpec(alignment: AlignmentDirectional.topStart, fit: StackFit.loose);
  /// final attr = StackStyle.maybeValue(spec); // Returns StackStyle or null
  /// ```
  static StackStyle? maybeValue(StackSpec? spec) {
    return spec != null ? StackStyle.value(spec) : null;
  }

  /// Sets stack alignment
  StackStyle alignment(AlignmentGeometry value) {
    return merge(StackStyle(alignment: value));
  }

  /// Sets stack fit
  StackStyle fit(StackFit value) {
    return merge(StackStyle(fit: value));
  }

  /// Sets text direction
  StackStyle textDirection(TextDirection value) {
    return merge(StackStyle(textDirection: value));
  }

  /// Sets clip behavior
  StackStyle clipBehavior(Clip value) {
    return merge(StackStyle(clipBehavior: value));
  }

  StackStyle modifier(ModifierConfig value) {
    return merge(StackStyle(modifier: value));
  }

  /// Convenience method for animating the StackWidgetSpec
  @override
  StackStyle animate(AnimationConfig animation) {
    return merge(StackStyle(animation: animation));
  }

  @override
  StackStyle variants(List<VariantStyle<StackSpec>> variants) {
    return merge(StackStyle(variants: variants));
  }

  /// Resolves to [StackSpec] using the provided [BuildContext].
  @override
  WidgetSpec<StackSpec> resolve(BuildContext context) {
    final stackSpec = StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );

    return WidgetSpec(
      spec: stackSpec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  /// Merges the properties of this [StackStyle] with the properties of [other].
  @override
  StackStyle merge(StackStyle? other) {
    if (other == null) return this;

    return StackStyle.create(
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
    properties
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  StackStyle variant(Variant variant, StackStyle style) {
    return merge(StackStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  StackStyle wrap(ModifierConfig value) {
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

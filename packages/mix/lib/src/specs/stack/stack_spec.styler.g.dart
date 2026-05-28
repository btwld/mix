// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';

import 'stack_spec.dart';

class StackStyler extends MixStyler<StackStyler, StackSpec>
    with _$StackStylerMixin {
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
    super.variants,
    super.modifier,
    super.animation,
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
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory StackStyler.alignment(AlignmentGeometry value) =>
      StackStyler().alignment(value);
  factory StackStyler.fit(StackFit value) => StackStyler().fit(value);
  factory StackStyler.textDirection(TextDirection value) =>
      StackStyler().textDirection(value);
  factory StackStyler.clipBehavior(Clip value) =>
      StackStyler().clipBehavior(value);
}

mixin _$StackStylerMixin on Style<StackSpec>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<StackFit>? get $fit;
  Prop<TextDirection>? get $textDirection;
  Prop<Clip>? get $clipBehavior;

  /// Sets the alignment.
  StackStyler alignment(AlignmentGeometry value) {
    return merge(StackStyler(alignment: value));
  }

  /// Sets the fit.
  StackStyler fit(StackFit value) {
    return merge(StackStyler(fit: value));
  }

  /// Sets the textDirection.
  StackStyler textDirection(TextDirection value) {
    return merge(StackStyler(textDirection: value));
  }

  /// Sets the clipBehavior.
  StackStyler clipBehavior(Clip value) {
    return merge(StackStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  StackStyler animate(AnimationConfig value) {
    return merge(StackStyler(animation: value));
  }

  /// Sets the style variants.
  StackStyler variants(List<VariantStyle<StackSpec>> value) {
    return merge(StackStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  StackStyler wrap(WidgetModifierConfig value) {
    return merge(StackStyler(modifier: value));
  }

  /// Sets the widget modifier.
  StackStyler modifier(WidgetModifierConfig value) {
    return merge(StackStyler(modifier: value));
  }

  /// Merges with another [StackStyler].
  @override
  StackStyler merge(StackStyler? other) {
    return StackStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      fit: MixOps.merge($fit, other?.$fit),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<StackSpec>] using [context].
  @override
  StyleSpec<StackSpec> resolve(BuildContext context) {
    final spec = StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'box_spec_for_spike.dart';

class BoxSpecForSpikeStyler
    extends MixStyler<BoxSpecForSpikeStyler, BoxSpecForSpike>
    with
        SpacingStyleMixin<BoxSpecForSpikeStyler>,
        ConstraintStyleMixin<BoxSpecForSpikeStyler>,
        DecorationStyleMixin<BoxSpecForSpikeStyler>,
        BorderStyleMixin<BoxSpecForSpikeStyler>,
        BorderRadiusStyleMixin<BoxSpecForSpikeStyler>,
        ShadowStyleMixin<BoxSpecForSpikeStyler>,
        TransformStyleMixin<BoxSpecForSpikeStyler>,
        _$BoxSpecForSpikeStylerMixin {
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<EdgeInsetsGeometry>? $padding;
  @override
  final Prop<EdgeInsetsGeometry>? $margin;
  @override
  final Prop<BoxConstraints>? $constraints;
  @override
  final Prop<Decoration>? $decoration;
  @override
  final Prop<Decoration>? $foregroundDecoration;
  @override
  final Prop<Matrix4>? $transform;
  @override
  final Prop<AlignmentGeometry>? $transformAlignment;
  @override
  final Prop<Clip>? $clipBehavior;

  const BoxSpecForSpikeStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<BoxConstraints>? constraints,
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    super.variants,
    super.modifier,
    super.animation,
  }) : $alignment = alignment,
       $padding = padding,
       $margin = margin,
       $constraints = constraints,
       $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  BoxSpecForSpikeStyler({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    BoxConstraintsMix? constraints,
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BoxSpecForSpike>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         padding: Prop.maybeMix(padding),
         margin: Prop.maybeMix(margin),
         constraints: Prop.maybeMix(constraints),
         decoration: Prop.maybeMix(decoration),
         foregroundDecoration: Prop.maybeMix(foregroundDecoration),
         transform: Prop.maybe(transform),
         transformAlignment: Prop.maybe(transformAlignment),
         clipBehavior: Prop.maybe(clipBehavior),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BoxSpecForSpikeStyler.alignment(AlignmentGeometry value) =>
      BoxSpecForSpikeStyler().alignment(value);
  factory BoxSpecForSpikeStyler.padding(EdgeInsetsGeometryMix value) =>
      BoxSpecForSpikeStyler().padding(value);
  factory BoxSpecForSpikeStyler.margin(EdgeInsetsGeometryMix value) =>
      BoxSpecForSpikeStyler().margin(value);
  factory BoxSpecForSpikeStyler.constraints(BoxConstraintsMix value) =>
      BoxSpecForSpikeStyler().constraints(value);
  factory BoxSpecForSpikeStyler.decoration(DecorationMix value) =>
      BoxSpecForSpikeStyler().decoration(value);
  factory BoxSpecForSpikeStyler.foregroundDecoration(DecorationMix value) =>
      BoxSpecForSpikeStyler().foregroundDecoration(value);
  factory BoxSpecForSpikeStyler.clipBehavior(Clip value) =>
      BoxSpecForSpikeStyler().clipBehavior(value);
  factory BoxSpecForSpikeStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => BoxSpecForSpikeStyler().transform(value, alignment: alignment);

  @override
  BoxSpecForSpikeStyler transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) {
    return merge(
      BoxSpecForSpikeStyler(transform: value, transformAlignment: alignment),
    );
  }
}

mixin _$BoxSpecForSpikeStylerMixin on Style<BoxSpecForSpike>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<EdgeInsetsGeometry>? get $padding;
  Prop<EdgeInsetsGeometry>? get $margin;
  Prop<BoxConstraints>? get $constraints;
  Prop<Decoration>? get $decoration;
  Prop<Decoration>? get $foregroundDecoration;
  Prop<Matrix4>? get $transform;
  Prop<AlignmentGeometry>? get $transformAlignment;
  Prop<Clip>? get $clipBehavior;

  /// Sets the alignment.
  BoxSpecForSpikeStyler alignment(AlignmentGeometry value) {
    return merge(BoxSpecForSpikeStyler(alignment: value));
  }

  /// Sets the padding.
  BoxSpecForSpikeStyler padding(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecForSpikeStyler(padding: value));
  }

  /// Sets the margin.
  BoxSpecForSpikeStyler margin(EdgeInsetsGeometryMix value) {
    return merge(BoxSpecForSpikeStyler(margin: value));
  }

  /// Sets the constraints.
  BoxSpecForSpikeStyler constraints(BoxConstraintsMix value) {
    return merge(BoxSpecForSpikeStyler(constraints: value));
  }

  /// Sets the decoration.
  BoxSpecForSpikeStyler decoration(DecorationMix value) {
    return merge(BoxSpecForSpikeStyler(decoration: value));
  }

  /// Sets the foregroundDecoration.
  BoxSpecForSpikeStyler foregroundDecoration(DecorationMix value) {
    return merge(BoxSpecForSpikeStyler(foregroundDecoration: value));
  }

  /// Sets the clipBehavior.
  BoxSpecForSpikeStyler clipBehavior(Clip value) {
    return merge(BoxSpecForSpikeStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  BoxSpecForSpikeStyler animate(AnimationConfig value) {
    return merge(BoxSpecForSpikeStyler(animation: value));
  }

  /// Sets the style variants.
  BoxSpecForSpikeStyler variants(List<VariantStyle<BoxSpecForSpike>> value) {
    return merge(BoxSpecForSpikeStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  BoxSpecForSpikeStyler wrap(WidgetModifierConfig value) {
    return merge(BoxSpecForSpikeStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BoxSpecForSpikeStyler modifier(WidgetModifierConfig value) {
    return merge(BoxSpecForSpikeStyler(modifier: value));
  }

  /// Merges with another [BoxSpecForSpikeStyler].
  @override
  BoxSpecForSpikeStyler merge(BoxSpecForSpikeStyler? other) {
    return BoxSpecForSpikeStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      padding: MixOps.merge($padding, other?.$padding),
      margin: MixOps.merge($margin, other?.$margin),
      constraints: MixOps.merge($constraints, other?.$constraints),
      decoration: MixOps.merge($decoration, other?.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other?.$foregroundDecoration,
      ),
      transform: MixOps.merge($transform, other?.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other?.$transformAlignment,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BoxSpecForSpike>] using [context].
  @override
  StyleSpec<BoxSpecForSpike> resolve(BuildContext context) {
    final spec = BoxSpecForSpike(
      alignment: MixOps.resolve(context, $alignment),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      constraints: MixOps.resolve(context, $constraints),
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
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
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $padding,
    $margin,
    $constraints,
    $decoration,
    $foregroundDecoration,
    $transform,
    $transformAlignment,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}

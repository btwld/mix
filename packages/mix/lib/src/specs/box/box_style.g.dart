// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$BoxStylerMixin on Style<BoxSpec>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<Clip>? get $clipBehavior;
  Prop<BoxConstraints>? get $constraints;
  Prop<Decoration>? get $decoration;
  Prop<Decoration>? get $foregroundDecoration;
  Prop<EdgeInsetsGeometry>? get $margin;
  Prop<EdgeInsetsGeometry>? get $padding;
  Prop<Matrix4>? get $transform;
  Prop<AlignmentGeometry>? get $transformAlignment;

  /// Sets the alignment.
  BoxStyler alignment(AlignmentGeometry value) {
    return merge(BoxStyler(alignment: value));
  }

  /// Sets the clipBehavior.
  BoxStyler clipBehavior(Clip value) {
    return merge(BoxStyler(clipBehavior: value));
  }

  /// Sets the constraints.
  BoxStyler constraints(BoxConstraintsMix value) {
    return merge(BoxStyler(constraints: value));
  }

  /// Sets the decoration.
  BoxStyler decoration(DecorationMix value) {
    return merge(BoxStyler(decoration: value));
  }

  /// Sets the foregroundDecoration.
  BoxStyler foregroundDecoration(DecorationMix value) {
    return merge(BoxStyler(foregroundDecoration: value));
  }

  /// Sets the margin.
  BoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(margin: value));
  }

  /// Sets the padding.
  BoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(padding: value));
  }

  /// Sets the animation configuration.
  BoxStyler animate(AnimationConfig value) {
    return merge(BoxStyler(animation: value));
  }

  /// Sets the style variants.
  BoxStyler variants(List<VariantStyle<BoxSpec>> value) {
    return merge(BoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  BoxStyler wrap(WidgetModifierConfig value) {
    return merge(BoxStyler(modifier: value));
  }

  /// Merges with another [BoxStyler].
  @override
  BoxStyler merge(BoxStyler? other) {
    return BoxStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      constraints: MixOps.merge($constraints, other?.$constraints),
      decoration: MixOps.merge($decoration, other?.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other?.$foregroundDecoration,
      ),
      margin: MixOps.merge($margin, other?.$margin),
      padding: MixOps.merge($padding, other?.$padding),
      transform: MixOps.merge($transform, other?.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other?.$transformAlignment,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BoxSpec>] using context.
  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    final spec = BoxSpec(
      alignment: MixOps.resolve(context, $alignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      constraints: MixOps.resolve(context, $constraints),
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      margin: MixOps.resolve(context, $margin),
      padding: MixOps.resolve(context, $padding),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
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
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $clipBehavior,
    $constraints,
    $decoration,
    $foregroundDecoration,
    $margin,
    $padding,
    $transform,
    $transformAlignment,
    $animation,
    $modifier,
    $variants,
  ];
}

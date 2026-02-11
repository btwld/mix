// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$StackStylerMixin on Style<StackSpec>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<Clip>? get $clipBehavior;
  Prop<StackFit>? get $fit;
  Prop<TextDirection>? get $textDirection;

  /// Sets the alignment.
  StackStyler alignment(AlignmentGeometry value) {
    return merge(StackStyler(alignment: value));
  }

  /// Sets the clipBehavior.
  StackStyler clipBehavior(Clip value) {
    return merge(StackStyler(clipBehavior: value));
  }

  /// Sets the fit.
  StackStyler fit(StackFit value) {
    return merge(StackStyler(fit: value));
  }

  /// Sets the textDirection.
  StackStyler textDirection(TextDirection value) {
    return merge(StackStyler(textDirection: value));
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

  /// Merges with another [StackStyler].
  @override
  StackStyler merge(StackStyler? other) {
    return StackStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      fit: MixOps.merge($fit, other?.$fit),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<StackSpec>] using context.
  @override
  StyleSpec<StackSpec> resolve(BuildContext context) {
    final spec = StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
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
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('textDirection', $textDirection));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $clipBehavior,
    $fit,
    $textDirection,
    $animation,
    $modifier,
    $variants,
  ];
}

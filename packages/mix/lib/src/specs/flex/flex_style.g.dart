// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$FlexStylerMixin on Style<FlexSpec>, Diagnosticable {
  Prop<Clip>? get $clipBehavior;
  Prop<CrossAxisAlignment>? get $crossAxisAlignment;
  Prop<Axis>? get $direction;
  Prop<MainAxisAlignment>? get $mainAxisAlignment;
  Prop<MainAxisSize>? get $mainAxisSize;
  Prop<double>? get $spacing;
  Prop<TextBaseline>? get $textBaseline;
  Prop<TextDirection>? get $textDirection;
  Prop<VerticalDirection>? get $verticalDirection;

  /// Sets the clipBehavior.
  FlexStyler clipBehavior(Clip value) {
    return merge(FlexStyler(clipBehavior: value));
  }

  /// Sets the crossAxisAlignment.
  FlexStyler crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexStyler(crossAxisAlignment: value));
  }

  /// Sets the direction.
  FlexStyler direction(Axis value) {
    return merge(FlexStyler(direction: value));
  }

  /// Sets the mainAxisAlignment.
  FlexStyler mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexStyler(mainAxisAlignment: value));
  }

  /// Sets the mainAxisSize.
  FlexStyler mainAxisSize(MainAxisSize value) {
    return merge(FlexStyler(mainAxisSize: value));
  }

  /// Sets the spacing.
  FlexStyler spacing(double value) {
    return merge(FlexStyler(spacing: value));
  }

  /// Sets the textBaseline.
  FlexStyler textBaseline(TextBaseline value) {
    return merge(FlexStyler(textBaseline: value));
  }

  /// Sets the textDirection.
  FlexStyler textDirection(TextDirection value) {
    return merge(FlexStyler(textDirection: value));
  }

  /// Sets the verticalDirection.
  FlexStyler verticalDirection(VerticalDirection value) {
    return merge(FlexStyler(verticalDirection: value));
  }

  /// Sets the animation configuration.
  FlexStyler animate(AnimationConfig value) {
    return merge(FlexStyler(animation: value));
  }

  /// Sets the style variants.
  FlexStyler variants(List<VariantStyle<FlexSpec>> value) {
    return merge(FlexStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  FlexStyler wrap(WidgetModifierConfig value) {
    return merge(FlexStyler(modifier: value));
  }

  @override
  FlexStyler merge(FlexStyler? other) {
    return FlexStyler.create(
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      crossAxisAlignment: MixOps.merge(
        $crossAxisAlignment,
        other?.$crossAxisAlignment,
      ),
      direction: MixOps.merge($direction, other?.$direction),
      mainAxisAlignment: MixOps.merge(
        $mainAxisAlignment,
        other?.$mainAxisAlignment,
      ),
      mainAxisSize: MixOps.merge($mainAxisSize, other?.$mainAxisSize),
      spacing: MixOps.merge($spacing, other?.$spacing),
      textBaseline: MixOps.merge($textBaseline, other?.$textBaseline),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      verticalDirection: MixOps.merge(
        $verticalDirection,
        other?.$verticalDirection,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  @override
  StyleSpec<FlexSpec> resolve(BuildContext context) {
    final spec = FlexSpec(
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      spacing: MixOps.resolve(context, $spacing),
      textBaseline: MixOps.resolve(context, $textBaseline),
      textDirection: MixOps.resolve(context, $textDirection),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
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
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('spacing', $spacing))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection));
  }

  @override
  List<Object?> get props => [
    $clipBehavior,
    $crossAxisAlignment,
    $direction,
    $mainAxisAlignment,
    $mainAxisSize,
    $spacing,
    $textBaseline,
    $textDirection,
    $verticalDirection,
    $animation,
    $modifier,
    $variants,
  ];
}

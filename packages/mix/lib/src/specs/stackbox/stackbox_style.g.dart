// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stackbox_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$StackBoxStylerMixin on Style<StackBoxSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $box;
  Prop<StyleSpec<StackSpec>>? get $stack;

  /// Merges with another [StackBoxStyler].
  @override
  StackBoxStyler merge(StackBoxStyler? other) {
    if (other != null && $inlineBuilder != null) {
      return StackBoxStyler.create(
        box: $box,
        stack: $stack,
        variants: $variants,
        modifier: $modifier,
        animation: $animation,
        inlineBuilder: $inlineBuilder!.append(other),
      );
    }

    return StackBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      stack: MixOps.merge($stack, other?.$stack),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
      inlineBuilder: other?.$inlineBuilder ?? $inlineBuilder,
    );
  }

  /// Returns a copy of this style with `$inlineBuilder` cleared.
  @override
  StackBoxStyler copyWithoutInlineBuilder() {
    return StackBoxStyler.create(
      box: $box,
      stack: $stack,
      variants: $variants,
      modifier: $modifier,
      animation: $animation,
      inlineBuilder: null,
    );
  }

  /// Resolves to [StyleSpec<StackBoxSpec>] using context.
  @override
  StyleSpec<StackBoxSpec> resolve(BuildContext context) {
    final spec = StackBoxSpec(
      box: MixOps.resolve(context, $box),
      stack: MixOps.resolve(context, $stack),
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
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('stack', $stack))
      ..add(DiagnosticsProperty('inlineBuilder', $inlineBuilder));
  }

  @override
  List<Object?> get props => [
    $box,
    $stack,
    $animation,
    $modifier,
    $variants,
    $inlineBuilder,
  ];
}

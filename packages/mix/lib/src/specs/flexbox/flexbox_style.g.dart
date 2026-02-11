// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexbox_style.dart';

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$FlexBoxStylerMixin on Style<FlexBoxSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $box;
  Prop<StyleSpec<FlexSpec>>? get $flex;

  /// Merges with another [FlexBoxStyler].
  @override
  FlexBoxStyler merge(FlexBoxStyler? other) {
    return FlexBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      flex: MixOps.merge($flex, other?.$flex),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<FlexBoxSpec>] using context.
  @override
  StyleSpec<FlexBoxSpec> resolve(BuildContext context) {
    final spec = FlexBoxSpec(
      box: MixOps.resolve(context, $box),
      flex: MixOps.resolve(context, $flex),
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
      ..add(DiagnosticsProperty('flex', $flex));
  }

  @override
  List<Object?> get props => [$box, $flex, $animation, $modifier, $variants];
}

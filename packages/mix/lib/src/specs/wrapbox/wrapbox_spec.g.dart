// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$WrapBoxSpec implements Spec<WrapBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<WrapSpec>? get flow;

  @override
  Type get type => WrapBoxSpec;

  @override
  WrapBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<WrapSpec>? flow}) {
    return WrapBoxSpec(box: box ?? this.box, flow: flow ?? this.flow);
  }

  @override
  WrapBoxSpec lerp(WrapBoxSpec? other, double t) {
    return WrapBoxSpec(
      box: box?.lerp(other?.box, t),
      flow: flow?.lerp(other?.flow, t),
    );
  }

  @override
  List<Object?> get props => [box, flow];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WrapBoxSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('flow', flow));
  }
}

@Deprecated(
  'Rename to `_\$WrapBoxSpec` and migrate the class declaration to `class WrapBoxSpec with _\$WrapBoxSpec`. The `_\$WrapBoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$WrapBoxSpecMethods = _$WrapBoxSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class WrapBoxStyler extends MixStyler<WrapBoxStyler, WrapBoxSpec> {
  final Prop<StyleSpec<BoxSpec>>? $box;
  final Prop<StyleSpec<WrapSpec>>? $flow;

  const WrapBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<WrapSpec>>? flow,
    super.variants,
    super.modifier,
    super.animation,
  }) : $box = box,
       $flow = flow;

  WrapBoxStyler({
    BoxStyler? box,
    WrapStyler? flow,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<WrapBoxSpec>>? variants,
  }) : this.create(
         box: Prop.maybeMix(box),
         flow: Prop.maybeMix(flow),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory WrapBoxStyler.box(BoxStyler value) => WrapBoxStyler().box(value);
  factory WrapBoxStyler.flow(WrapStyler value) => WrapBoxStyler().flow(value);

  /// Sets the box.
  WrapBoxStyler box(BoxStyler value) {
    return merge(WrapBoxStyler(box: value));
  }

  /// Sets the flow.
  WrapBoxStyler flow(WrapStyler value) {
    return merge(WrapBoxStyler(flow: value));
  }

  /// Sets the animation configuration.
  @override
  WrapBoxStyler animate(AnimationConfig value) {
    return merge(WrapBoxStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  WrapBoxStyler variants(List<VariantStyle<WrapBoxSpec>> value) {
    return merge(WrapBoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  WrapBoxStyler wrap(WidgetModifierConfig value) {
    return merge(WrapBoxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  WrapBoxStyler modifier(WidgetModifierConfig value) {
    return merge(WrapBoxStyler(modifier: value));
  }

  WrapBox call({Key? key, List<Widget> children = const <Widget>[]}) {
    return WrapBox(key: key, style: this, children: children);
  }

  /// Merges with another [WrapBoxStyler].
  @override
  WrapBoxStyler merge(WrapBoxStyler? other) {
    return WrapBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      flow: MixOps.merge($flow, other?.$flow),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<WrapBoxSpec>] using [context].
  @override
  StyleSpec<WrapBoxSpec> resolve(BuildContext context) {
    final spec = WrapBoxSpec(
      box: MixOps.resolve(context, $box),
      flow: MixOps.resolve(context, $flow),
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
      ..add(DiagnosticsProperty('flow', $flow));
  }

  @override
  List<Object?> get props => [$box, $flow, $animation, $modifier, $variants];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_frame_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartFrameSpec implements Spec<ChartFrameSpec>, Diagnosticable {
  Color? get backgroundColor;
  Border? get border;
  bool? get showBorder;
  bool? get clip;
  int? get rotationQuarterTurns;

  @override
  Type get type => ChartFrameSpec;

  @override
  ChartFrameSpec copyWith({
    Color? backgroundColor,
    Border? border,
    bool? showBorder,
    bool? clip,
    int? rotationQuarterTurns,
  }) {
    return ChartFrameSpec(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      showBorder: showBorder ?? this.showBorder,
      clip: clip ?? this.clip,
      rotationQuarterTurns: rotationQuarterTurns ?? this.rotationQuarterTurns,
    );
  }

  @override
  ChartFrameSpec lerp(ChartFrameSpec? other, double t) {
    return ChartFrameSpec(
      backgroundColor: MixOps.lerp(backgroundColor, other?.backgroundColor, t),
      border: MixOps.lerp(border, other?.border, t),
      showBorder: MixOps.lerpSnap(showBorder, other?.showBorder, t),
      clip: MixOps.lerpSnap(clip, other?.clip, t),
      rotationQuarterTurns: MixOps.lerpSnap(
        rotationQuarterTurns,
        other?.rotationQuarterTurns,
        t,
      ),
    );
  }

  @override
  List<Object?> get props => [
    backgroundColor,
    border,
    showBorder,
    clip,
    rotationQuarterTurns,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartFrameSpec &&
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
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('border', border))
      ..add(DiagnosticsProperty('showBorder', showBorder))
      ..add(DiagnosticsProperty('clip', clip))
      ..add(IntProperty('rotationQuarterTurns', rotationQuarterTurns));
  }
}

@Deprecated(
  'Rename to `_\$ChartFrameSpec` and migrate the class declaration to `class ChartFrameSpec with _\$ChartFrameSpec`. The `_\$ChartFrameSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartFrameSpecMethods = _$ChartFrameSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartFrameStyler extends MixStyler<ChartFrameStyler, ChartFrameSpec> {
  final Prop<Color>? $backgroundColor;
  final Prop<Border>? $border;
  final Prop<bool>? $showBorder;
  final Prop<bool>? $clip;
  final Prop<int>? $rotationQuarterTurns;

  const ChartFrameStyler.create({
    Prop<Color>? backgroundColor,
    Prop<Border>? border,
    Prop<bool>? showBorder,
    Prop<bool>? clip,
    Prop<int>? rotationQuarterTurns,
    super.variants,
    super.modifier,
    super.animation,
  }) : $backgroundColor = backgroundColor,
       $border = border,
       $showBorder = showBorder,
       $clip = clip,
       $rotationQuarterTurns = rotationQuarterTurns;

  ChartFrameStyler({
    Color? backgroundColor,
    Border? border,
    bool? showBorder,
    bool? clip,
    int? rotationQuarterTurns,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartFrameSpec>>? variants,
  }) : this.create(
         backgroundColor: Prop.maybe(backgroundColor),
         border: Prop.maybe(border),
         showBorder: Prop.maybe(showBorder),
         clip: Prop.maybe(clip),
         rotationQuarterTurns: Prop.maybe(rotationQuarterTurns),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartFrameStyler.backgroundColor(Color value) =>
      ChartFrameStyler().backgroundColor(value);
  factory ChartFrameStyler.border(Border value) =>
      ChartFrameStyler().border(value);
  factory ChartFrameStyler.showBorder(bool value) =>
      ChartFrameStyler().showBorder(value);
  factory ChartFrameStyler.clip(bool value) => ChartFrameStyler().clip(value);
  factory ChartFrameStyler.rotationQuarterTurns(int value) =>
      ChartFrameStyler().rotationQuarterTurns(value);

  /// Sets the backgroundColor.
  ChartFrameStyler backgroundColor(Color value) {
    return merge(ChartFrameStyler(backgroundColor: value));
  }

  /// Sets the border.
  ChartFrameStyler border(Border value) {
    return merge(ChartFrameStyler(border: value));
  }

  /// Sets the showBorder.
  ChartFrameStyler showBorder(bool value) {
    return merge(ChartFrameStyler(showBorder: value));
  }

  /// Sets the clip.
  ChartFrameStyler clip(bool value) {
    return merge(ChartFrameStyler(clip: value));
  }

  /// Sets the rotationQuarterTurns.
  ChartFrameStyler rotationQuarterTurns(int value) {
    return merge(ChartFrameStyler(rotationQuarterTurns: value));
  }

  /// Sets the animation configuration.
  @override
  ChartFrameStyler animate(AnimationConfig value) {
    return merge(ChartFrameStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartFrameStyler variants(List<VariantStyle<ChartFrameSpec>> value) {
    return merge(ChartFrameStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartFrameStyler wrap(WidgetModifierConfig value) {
    return merge(ChartFrameStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartFrameStyler modifier(WidgetModifierConfig value) {
    return merge(ChartFrameStyler(modifier: value));
  }

  /// Merges with another [ChartFrameStyler].
  @override
  ChartFrameStyler merge(ChartFrameStyler? other) {
    return ChartFrameStyler.create(
      backgroundColor: MixOps.merge($backgroundColor, other?.$backgroundColor),
      border: MixOps.merge($border, other?.$border),
      showBorder: MixOps.merge($showBorder, other?.$showBorder),
      clip: MixOps.merge($clip, other?.$clip),
      rotationQuarterTurns: MixOps.merge(
        $rotationQuarterTurns,
        other?.$rotationQuarterTurns,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartFrameSpec>] using [context].
  @override
  StyleSpec<ChartFrameSpec> resolve(BuildContext context) {
    final spec = ChartFrameSpec(
      backgroundColor: MixOps.resolve(context, $backgroundColor),
      border: MixOps.resolve(context, $border),
      showBorder: MixOps.resolve(context, $showBorder),
      clip: MixOps.resolve(context, $clip),
      rotationQuarterTurns: MixOps.resolve(context, $rotationQuarterTurns),
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
      ..add(DiagnosticsProperty('backgroundColor', $backgroundColor))
      ..add(DiagnosticsProperty('border', $border))
      ..add(DiagnosticsProperty('showBorder', $showBorder))
      ..add(DiagnosticsProperty('clip', $clip))
      ..add(DiagnosticsProperty('rotationQuarterTurns', $rotationQuarterTurns));
  }

  @override
  List<Object?> get props => [
    $backgroundColor,
    $border,
    $showBorder,
    $clip,
    $rotationQuarterTurns,
    $animation,
    $modifier,
    $variants,
  ];
}

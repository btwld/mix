// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_area_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartAreaSpec implements Spec<ChartAreaSpec>, Diagnosticable {
  bool? get show;
  Color? get color;
  Gradient? get gradient;
  double? get cutoffY;
  bool? get applyCutoff;

  @override
  Type get type => ChartAreaSpec;

  @override
  ChartAreaSpec copyWith({
    bool? show,
    Color? color,
    Gradient? gradient,
    double? cutoffY,
    bool? applyCutoff,
  }) {
    return ChartAreaSpec(
      show: show ?? this.show,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      cutoffY: cutoffY ?? this.cutoffY,
      applyCutoff: applyCutoff ?? this.applyCutoff,
    );
  }

  @override
  ChartAreaSpec lerp(ChartAreaSpec? other, double t) {
    return ChartAreaSpec(
      show: MixOps.lerpSnap(show, other?.show, t),
      color: MixOps.lerp(color, other?.color, t),
      gradient: MixOps.lerp(gradient, other?.gradient, t),
      cutoffY: MixOps.lerp(cutoffY, other?.cutoffY, t),
      applyCutoff: MixOps.lerpSnap(applyCutoff, other?.applyCutoff, t),
    );
  }

  @override
  List<Object?> get props => [show, color, gradient, cutoffY, applyCutoff];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartAreaSpec &&
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
      ..add(DiagnosticsProperty('show', show))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty('gradient', gradient))
      ..add(DoubleProperty('cutoffY', cutoffY))
      ..add(DiagnosticsProperty('applyCutoff', applyCutoff));
  }
}

@Deprecated(
  'Rename to `_\$ChartAreaSpec` and migrate the class declaration to `class ChartAreaSpec with _\$ChartAreaSpec`. The `_\$ChartAreaSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartAreaSpecMethods = _$ChartAreaSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartAreaStyler extends MixStyler<ChartAreaStyler, ChartAreaSpec> {
  final Prop<bool>? $show;
  final Prop<Color>? $color;
  final Prop<Gradient>? $gradient;
  final Prop<double>? $cutoffY;
  final Prop<bool>? $applyCutoff;

  const ChartAreaStyler.create({
    Prop<bool>? show,
    Prop<Color>? color,
    Prop<Gradient>? gradient,
    Prop<double>? cutoffY,
    Prop<bool>? applyCutoff,
    super.variants,
    super.modifier,
    super.animation,
  }) : $show = show,
       $color = color,
       $gradient = gradient,
       $cutoffY = cutoffY,
       $applyCutoff = applyCutoff;

  ChartAreaStyler({
    bool? show,
    Color? color,
    Gradient? gradient,
    double? cutoffY,
    bool? applyCutoff,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartAreaSpec>>? variants,
  }) : this.create(
         show: Prop.maybe(show),
         color: Prop.maybe(color),
         gradient: Prop.maybe(gradient),
         cutoffY: Prop.maybe(cutoffY),
         applyCutoff: Prop.maybe(applyCutoff),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartAreaStyler.show(bool value) => ChartAreaStyler().show(value);
  factory ChartAreaStyler.color(Color value) => ChartAreaStyler().color(value);
  factory ChartAreaStyler.gradient(Gradient value) =>
      ChartAreaStyler().gradient(value);
  factory ChartAreaStyler.cutoffY(double value) =>
      ChartAreaStyler().cutoffY(value);
  factory ChartAreaStyler.applyCutoff(bool value) =>
      ChartAreaStyler().applyCutoff(value);

  /// Sets the show.
  ChartAreaStyler show(bool value) {
    return merge(ChartAreaStyler(show: value));
  }

  /// Sets the color.
  ChartAreaStyler color(Color value) {
    return merge(ChartAreaStyler(color: value));
  }

  /// Sets the gradient.
  ChartAreaStyler gradient(Gradient value) {
    return merge(ChartAreaStyler(gradient: value));
  }

  /// Sets the cutoffY.
  ChartAreaStyler cutoffY(double value) {
    return merge(ChartAreaStyler(cutoffY: value));
  }

  /// Sets the applyCutoff.
  ChartAreaStyler applyCutoff(bool value) {
    return merge(ChartAreaStyler(applyCutoff: value));
  }

  /// Sets the animation configuration.
  @override
  ChartAreaStyler animate(AnimationConfig value) {
    return merge(ChartAreaStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartAreaStyler variants(List<VariantStyle<ChartAreaSpec>> value) {
    return merge(ChartAreaStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartAreaStyler wrap(WidgetModifierConfig value) {
    return merge(ChartAreaStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartAreaStyler modifier(WidgetModifierConfig value) {
    return merge(ChartAreaStyler(modifier: value));
  }

  /// Merges with another [ChartAreaStyler].
  @override
  ChartAreaStyler merge(ChartAreaStyler? other) {
    return ChartAreaStyler.create(
      show: MixOps.merge($show, other?.$show),
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      cutoffY: MixOps.merge($cutoffY, other?.$cutoffY),
      applyCutoff: MixOps.merge($applyCutoff, other?.$applyCutoff),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartAreaSpec>] using [context].
  @override
  StyleSpec<ChartAreaSpec> resolve(BuildContext context) {
    final spec = ChartAreaSpec(
      show: MixOps.resolve(context, $show),
      color: MixOps.resolve(context, $color),
      gradient: MixOps.resolve(context, $gradient),
      cutoffY: MixOps.resolve(context, $cutoffY),
      applyCutoff: MixOps.resolve(context, $applyCutoff),
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
      ..add(DiagnosticsProperty('show', $show))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('gradient', $gradient))
      ..add(DiagnosticsProperty('cutoffY', $cutoffY))
      ..add(DiagnosticsProperty('applyCutoff', $applyCutoff));
  }

  @override
  List<Object?> get props => [
    $show,
    $color,
    $gradient,
    $cutoffY,
    $applyCutoff,
    $animation,
    $modifier,
    $variants,
  ];
}

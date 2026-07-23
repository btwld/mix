// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_grid_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartGridSpec implements Spec<ChartGridSpec>, Diagnosticable {
  bool? get show;
  bool? get showHorizontal;
  bool? get showVertical;
  double? get horizontalInterval;
  double? get verticalInterval;
  StyleSpec<ChartStrokeSpec>? get stroke;

  @override
  Type get type => ChartGridSpec;

  @override
  ChartGridSpec copyWith({
    bool? show,
    bool? showHorizontal,
    bool? showVertical,
    double? horizontalInterval,
    double? verticalInterval,
    StyleSpec<ChartStrokeSpec>? stroke,
  }) {
    return ChartGridSpec(
      show: show ?? this.show,
      showHorizontal: showHorizontal ?? this.showHorizontal,
      showVertical: showVertical ?? this.showVertical,
      horizontalInterval: horizontalInterval ?? this.horizontalInterval,
      verticalInterval: verticalInterval ?? this.verticalInterval,
      stroke: stroke ?? this.stroke,
    );
  }

  @override
  ChartGridSpec lerp(ChartGridSpec? other, double t) {
    return ChartGridSpec(
      show: MixOps.lerpSnap(show, other?.show, t),
      showHorizontal: MixOps.lerpSnap(showHorizontal, other?.showHorizontal, t),
      showVertical: MixOps.lerpSnap(showVertical, other?.showVertical, t),
      horizontalInterval: MixOps.lerp(
        horizontalInterval,
        other?.horizontalInterval,
        t,
      ),
      verticalInterval: MixOps.lerp(
        verticalInterval,
        other?.verticalInterval,
        t,
      ),
      stroke: stroke?.lerp(other?.stroke, t),
    );
  }

  @override
  List<Object?> get props => [
    show,
    showHorizontal,
    showVertical,
    horizontalInterval,
    verticalInterval,
    stroke,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartGridSpec &&
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
      ..add(DiagnosticsProperty('showHorizontal', showHorizontal))
      ..add(DiagnosticsProperty('showVertical', showVertical))
      ..add(DoubleProperty('horizontalInterval', horizontalInterval))
      ..add(DoubleProperty('verticalInterval', verticalInterval))
      ..add(DiagnosticsProperty('stroke', stroke));
  }
}

@Deprecated(
  'Rename to `_\$ChartGridSpec` and migrate the class declaration to `class ChartGridSpec with _\$ChartGridSpec`. The `_\$ChartGridSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartGridSpecMethods = _$ChartGridSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartGridStyler extends MixStyler<ChartGridStyler, ChartGridSpec> {
  final Prop<bool>? $show;
  final Prop<bool>? $showHorizontal;
  final Prop<bool>? $showVertical;
  final Prop<double>? $horizontalInterval;
  final Prop<double>? $verticalInterval;
  final Prop<StyleSpec<ChartStrokeSpec>>? $stroke;

  const ChartGridStyler.create({
    Prop<bool>? show,
    Prop<bool>? showHorizontal,
    Prop<bool>? showVertical,
    Prop<double>? horizontalInterval,
    Prop<double>? verticalInterval,
    Prop<StyleSpec<ChartStrokeSpec>>? stroke,
    super.variants,
    super.modifier,
    super.animation,
  }) : $show = show,
       $showHorizontal = showHorizontal,
       $showVertical = showVertical,
       $horizontalInterval = horizontalInterval,
       $verticalInterval = verticalInterval,
       $stroke = stroke;

  ChartGridStyler({
    bool? show,
    bool? showHorizontal,
    bool? showVertical,
    double? horizontalInterval,
    double? verticalInterval,
    ChartStrokeStyler? stroke,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartGridSpec>>? variants,
  }) : this.create(
         show: Prop.maybe(show),
         showHorizontal: Prop.maybe(showHorizontal),
         showVertical: Prop.maybe(showVertical),
         horizontalInterval: Prop.maybe(horizontalInterval),
         verticalInterval: Prop.maybe(verticalInterval),
         stroke: Prop.maybeMix(stroke),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartGridStyler.show(bool value) => ChartGridStyler().show(value);
  factory ChartGridStyler.showHorizontal(bool value) =>
      ChartGridStyler().showHorizontal(value);
  factory ChartGridStyler.showVertical(bool value) =>
      ChartGridStyler().showVertical(value);
  factory ChartGridStyler.horizontalInterval(double value) =>
      ChartGridStyler().horizontalInterval(value);
  factory ChartGridStyler.verticalInterval(double value) =>
      ChartGridStyler().verticalInterval(value);
  factory ChartGridStyler.stroke(ChartStrokeStyler value) =>
      ChartGridStyler().stroke(value);

  /// Sets the show.
  ChartGridStyler show(bool value) {
    return merge(ChartGridStyler(show: value));
  }

  /// Sets the showHorizontal.
  ChartGridStyler showHorizontal(bool value) {
    return merge(ChartGridStyler(showHorizontal: value));
  }

  /// Sets the showVertical.
  ChartGridStyler showVertical(bool value) {
    return merge(ChartGridStyler(showVertical: value));
  }

  /// Sets the horizontalInterval.
  ChartGridStyler horizontalInterval(double value) {
    return merge(ChartGridStyler(horizontalInterval: value));
  }

  /// Sets the verticalInterval.
  ChartGridStyler verticalInterval(double value) {
    return merge(ChartGridStyler(verticalInterval: value));
  }

  /// Sets the stroke.
  ChartGridStyler stroke(ChartStrokeStyler value) {
    return merge(ChartGridStyler(stroke: value));
  }

  /// Sets the animation configuration.
  @override
  ChartGridStyler animate(AnimationConfig value) {
    return merge(ChartGridStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartGridStyler variants(List<VariantStyle<ChartGridSpec>> value) {
    return merge(ChartGridStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartGridStyler wrap(WidgetModifierConfig value) {
    return merge(ChartGridStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartGridStyler modifier(WidgetModifierConfig value) {
    return merge(ChartGridStyler(modifier: value));
  }

  /// Merges with another [ChartGridStyler].
  @override
  ChartGridStyler merge(ChartGridStyler? other) {
    return ChartGridStyler.create(
      show: MixOps.merge($show, other?.$show),
      showHorizontal: MixOps.merge($showHorizontal, other?.$showHorizontal),
      showVertical: MixOps.merge($showVertical, other?.$showVertical),
      horizontalInterval: MixOps.merge(
        $horizontalInterval,
        other?.$horizontalInterval,
      ),
      verticalInterval: MixOps.merge(
        $verticalInterval,
        other?.$verticalInterval,
      ),
      stroke: MixOps.merge($stroke, other?.$stroke),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartGridSpec>] using [context].
  @override
  StyleSpec<ChartGridSpec> resolve(BuildContext context) {
    final spec = ChartGridSpec(
      show: MixOps.resolve(context, $show),
      showHorizontal: MixOps.resolve(context, $showHorizontal),
      showVertical: MixOps.resolve(context, $showVertical),
      horizontalInterval: MixOps.resolve(context, $horizontalInterval),
      verticalInterval: MixOps.resolve(context, $verticalInterval),
      stroke: MixOps.resolve(context, $stroke),
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
      ..add(DiagnosticsProperty('showHorizontal', $showHorizontal))
      ..add(DiagnosticsProperty('showVertical', $showVertical))
      ..add(DiagnosticsProperty('horizontalInterval', $horizontalInterval))
      ..add(DiagnosticsProperty('verticalInterval', $verticalInterval))
      ..add(DiagnosticsProperty('stroke', $stroke));
  }

  @override
  List<Object?> get props => [
    $show,
    $showHorizontal,
    $showVertical,
    $horizontalInterval,
    $verticalInterval,
    $stroke,
    $animation,
    $modifier,
    $variants,
  ];
}

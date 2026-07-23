// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_chart_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$LineChartSpec implements Spec<LineChartSpec>, Diagnosticable {
  StyleSpec<ChartFrameSpec>? get frame;
  StyleSpec<ChartAxisSpec>? get axis;
  StyleSpec<ChartAxisSpec>? get xAxis;
  StyleSpec<ChartAxisSpec>? get yAxis;
  StyleSpec<ChartAxisSpec>? get topAxis;
  StyleSpec<ChartAxisSpec>? get rightAxis;
  StyleSpec<ChartGridSpec>? get grid;
  StyleSpec<LineSeriesSpec>? get series;
  List<Color>? get palette;
  StyleSpec<ChartTooltipSpec>? get tooltip;

  @override
  Type get type => LineChartSpec;

  @override
  LineChartSpec copyWith({
    StyleSpec<ChartFrameSpec>? frame,
    StyleSpec<ChartAxisSpec>? axis,
    StyleSpec<ChartAxisSpec>? xAxis,
    StyleSpec<ChartAxisSpec>? yAxis,
    StyleSpec<ChartAxisSpec>? topAxis,
    StyleSpec<ChartAxisSpec>? rightAxis,
    StyleSpec<ChartGridSpec>? grid,
    StyleSpec<LineSeriesSpec>? series,
    List<Color>? palette,
    StyleSpec<ChartTooltipSpec>? tooltip,
  }) {
    return LineChartSpec(
      frame: frame ?? this.frame,
      axis: axis ?? this.axis,
      xAxis: xAxis ?? this.xAxis,
      yAxis: yAxis ?? this.yAxis,
      topAxis: topAxis ?? this.topAxis,
      rightAxis: rightAxis ?? this.rightAxis,
      grid: grid ?? this.grid,
      series: series ?? this.series,
      palette: palette ?? this.palette,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  @override
  LineChartSpec lerp(LineChartSpec? other, double t) {
    return LineChartSpec(
      frame: frame?.lerp(other?.frame, t),
      axis: axis?.lerp(other?.axis, t),
      xAxis: xAxis?.lerp(other?.xAxis, t),
      yAxis: yAxis?.lerp(other?.yAxis, t),
      topAxis: topAxis?.lerp(other?.topAxis, t),
      rightAxis: rightAxis?.lerp(other?.rightAxis, t),
      grid: grid?.lerp(other?.grid, t),
      series: series?.lerp(other?.series, t),
      palette: MixOps.lerpSnap(palette, other?.palette, t),
      tooltip: tooltip?.lerp(other?.tooltip, t),
    );
  }

  @override
  List<Object?> get props => [
    frame,
    axis,
    xAxis,
    yAxis,
    topAxis,
    rightAxis,
    grid,
    series,
    palette,
    tooltip,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LineChartSpec &&
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
      ..add(DiagnosticsProperty('frame', frame))
      ..add(DiagnosticsProperty('axis', axis))
      ..add(DiagnosticsProperty('xAxis', xAxis))
      ..add(DiagnosticsProperty('yAxis', yAxis))
      ..add(DiagnosticsProperty('topAxis', topAxis))
      ..add(DiagnosticsProperty('rightAxis', rightAxis))
      ..add(DiagnosticsProperty('grid', grid))
      ..add(DiagnosticsProperty('series', series))
      ..add(IterableProperty<Color>('palette', palette))
      ..add(DiagnosticsProperty('tooltip', tooltip));
  }
}

@Deprecated(
  'Rename to `_\$LineChartSpec` and migrate the class declaration to `class LineChartSpec with _\$LineChartSpec`. The `_\$LineChartSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$LineChartSpecMethods = _$LineChartSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class LineChartStyler extends MixStyler<LineChartStyler, LineChartSpec> {
  final Prop<StyleSpec<ChartFrameSpec>>? $frame;
  final Prop<StyleSpec<ChartAxisSpec>>? $axis;
  final Prop<StyleSpec<ChartAxisSpec>>? $xAxis;
  final Prop<StyleSpec<ChartAxisSpec>>? $yAxis;
  final Prop<StyleSpec<ChartAxisSpec>>? $topAxis;
  final Prop<StyleSpec<ChartAxisSpec>>? $rightAxis;
  final Prop<StyleSpec<ChartGridSpec>>? $grid;
  final Prop<StyleSpec<LineSeriesSpec>>? $series;
  final Prop<List<Color>>? $palette;
  final Prop<StyleSpec<ChartTooltipSpec>>? $tooltip;

  const LineChartStyler.create({
    Prop<StyleSpec<ChartFrameSpec>>? frame,
    Prop<StyleSpec<ChartAxisSpec>>? axis,
    Prop<StyleSpec<ChartAxisSpec>>? xAxis,
    Prop<StyleSpec<ChartAxisSpec>>? yAxis,
    Prop<StyleSpec<ChartAxisSpec>>? topAxis,
    Prop<StyleSpec<ChartAxisSpec>>? rightAxis,
    Prop<StyleSpec<ChartGridSpec>>? grid,
    Prop<StyleSpec<LineSeriesSpec>>? series,
    Prop<List<Color>>? palette,
    Prop<StyleSpec<ChartTooltipSpec>>? tooltip,
    super.variants,
    super.modifier,
    super.animation,
  }) : $frame = frame,
       $axis = axis,
       $xAxis = xAxis,
       $yAxis = yAxis,
       $topAxis = topAxis,
       $rightAxis = rightAxis,
       $grid = grid,
       $series = series,
       $palette = palette,
       $tooltip = tooltip;

  LineChartStyler({
    ChartFrameStyler? frame,
    ChartAxisStyler? axis,
    ChartAxisStyler? xAxis,
    ChartAxisStyler? yAxis,
    ChartAxisStyler? topAxis,
    ChartAxisStyler? rightAxis,
    ChartGridStyler? grid,
    LineSeriesStyler? series,
    List<Color>? palette,
    ChartTooltipStyler? tooltip,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<LineChartSpec>>? variants,
  }) : this.create(
         frame: Prop.maybeMix(frame),
         axis: Prop.maybeMix(axis),
         xAxis: Prop.maybeMix(xAxis),
         yAxis: Prop.maybeMix(yAxis),
         topAxis: Prop.maybeMix(topAxis),
         rightAxis: Prop.maybeMix(rightAxis),
         grid: Prop.maybeMix(grid),
         series: Prop.maybeMix(series),
         palette: Prop.maybe(palette),
         tooltip: Prop.maybeMix(tooltip),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory LineChartStyler.frame(ChartFrameStyler value) =>
      LineChartStyler().frame(value);
  factory LineChartStyler.axis(ChartAxisStyler value) =>
      LineChartStyler().axis(value);
  factory LineChartStyler.xAxis(ChartAxisStyler value) =>
      LineChartStyler().xAxis(value);
  factory LineChartStyler.yAxis(ChartAxisStyler value) =>
      LineChartStyler().yAxis(value);
  factory LineChartStyler.topAxis(ChartAxisStyler value) =>
      LineChartStyler().topAxis(value);
  factory LineChartStyler.rightAxis(ChartAxisStyler value) =>
      LineChartStyler().rightAxis(value);
  factory LineChartStyler.grid(ChartGridStyler value) =>
      LineChartStyler().grid(value);
  factory LineChartStyler.series(LineSeriesStyler value) =>
      LineChartStyler().series(value);
  factory LineChartStyler.palette(List<Color> value) =>
      LineChartStyler().palette(value);
  factory LineChartStyler.tooltip(ChartTooltipStyler value) =>
      LineChartStyler().tooltip(value);

  /// Sets the frame.
  LineChartStyler frame(ChartFrameStyler value) {
    return merge(LineChartStyler(frame: value));
  }

  /// Sets the axis.
  LineChartStyler axis(ChartAxisStyler value) {
    return merge(LineChartStyler(axis: value));
  }

  /// Sets the xAxis.
  LineChartStyler xAxis(ChartAxisStyler value) {
    return merge(LineChartStyler(xAxis: value));
  }

  /// Sets the yAxis.
  LineChartStyler yAxis(ChartAxisStyler value) {
    return merge(LineChartStyler(yAxis: value));
  }

  /// Sets the topAxis.
  LineChartStyler topAxis(ChartAxisStyler value) {
    return merge(LineChartStyler(topAxis: value));
  }

  /// Sets the rightAxis.
  LineChartStyler rightAxis(ChartAxisStyler value) {
    return merge(LineChartStyler(rightAxis: value));
  }

  /// Sets the grid.
  LineChartStyler grid(ChartGridStyler value) {
    return merge(LineChartStyler(grid: value));
  }

  /// Sets the series.
  LineChartStyler series(LineSeriesStyler value) {
    return merge(LineChartStyler(series: value));
  }

  /// Sets the palette.
  LineChartStyler palette(List<Color> value) {
    return merge(LineChartStyler(palette: value));
  }

  /// Sets the tooltip.
  LineChartStyler tooltip(ChartTooltipStyler value) {
    return merge(LineChartStyler(tooltip: value));
  }

  /// Sets the animation configuration.
  @override
  LineChartStyler animate(AnimationConfig value) {
    return merge(LineChartStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  LineChartStyler variants(List<VariantStyle<LineChartSpec>> value) {
    return merge(LineChartStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  LineChartStyler wrap(WidgetModifierConfig value) {
    return merge(LineChartStyler(modifier: value));
  }

  /// Sets the widget modifier.
  LineChartStyler modifier(WidgetModifierConfig value) {
    return merge(LineChartStyler(modifier: value));
  }

  LineChart call({
    Key? key,
    required List<LineSeries> series,
    ChartAxis? xAxis,
    ChartAxis? yAxis,
    ChartAxis? topAxis,
    ChartAxis? rightAxis,
    ChartViewport? viewport,
    ChartDataTransition dataTransition = ChartDataTransition.none,
    Set<LinePointKey> selectedPoints = const {},
    ValueChanged<LineChartHit?>? onPointHover,
    ValueChanged<LineChartHit>? onPointTap,
    ValueChanged<LineChartHit>? onPointLongPress,
    ChartTooltipBuilder? tooltipBuilder,
    double hitTestRadius = 10,
    ChartMouseCursorResolver<LineChartHit>? mouseCursorResolver,
    String? semanticsLabel,
    String? semanticsValue,
    bool excludeFromSemantics = false,
  }) {
    return LineChart(
      key: key,
      style: this,
      series: series,
      xAxis: xAxis,
      yAxis: yAxis,
      topAxis: topAxis,
      rightAxis: rightAxis,
      viewport: viewport,
      dataTransition: dataTransition,
      selectedPoints: selectedPoints,
      onPointHover: onPointHover,
      onPointTap: onPointTap,
      onPointLongPress: onPointLongPress,
      tooltipBuilder: tooltipBuilder,
      hitTestRadius: hitTestRadius,
      mouseCursorResolver: mouseCursorResolver,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }

  /// Merges with another [LineChartStyler].
  @override
  LineChartStyler merge(LineChartStyler? other) {
    return LineChartStyler.create(
      frame: MixOps.merge($frame, other?.$frame),
      axis: MixOps.merge($axis, other?.$axis),
      xAxis: MixOps.merge($xAxis, other?.$xAxis),
      yAxis: MixOps.merge($yAxis, other?.$yAxis),
      topAxis: MixOps.merge($topAxis, other?.$topAxis),
      rightAxis: MixOps.merge($rightAxis, other?.$rightAxis),
      grid: MixOps.merge($grid, other?.$grid),
      series: MixOps.merge($series, other?.$series),
      palette: MixOps.merge($palette, other?.$palette),
      tooltip: MixOps.merge($tooltip, other?.$tooltip),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<LineChartSpec>] using [context].
  @override
  StyleSpec<LineChartSpec> resolve(BuildContext context) {
    final spec = LineChartSpec(
      frame: MixOps.resolve(context, $frame),
      axis: MixOps.resolve(context, $axis),
      xAxis: MixOps.resolve(context, $xAxis),
      yAxis: MixOps.resolve(context, $yAxis),
      topAxis: MixOps.resolve(context, $topAxis),
      rightAxis: MixOps.resolve(context, $rightAxis),
      grid: MixOps.resolve(context, $grid),
      series: MixOps.resolve(context, $series),
      palette: MixOps.resolve(context, $palette),
      tooltip: MixOps.resolve(context, $tooltip),
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
      ..add(DiagnosticsProperty('frame', $frame))
      ..add(DiagnosticsProperty('axis', $axis))
      ..add(DiagnosticsProperty('xAxis', $xAxis))
      ..add(DiagnosticsProperty('yAxis', $yAxis))
      ..add(DiagnosticsProperty('topAxis', $topAxis))
      ..add(DiagnosticsProperty('rightAxis', $rightAxis))
      ..add(DiagnosticsProperty('grid', $grid))
      ..add(DiagnosticsProperty('series', $series))
      ..add(DiagnosticsProperty('palette', $palette))
      ..add(DiagnosticsProperty('tooltip', $tooltip));
  }

  @override
  List<Object?> get props => [
    $frame,
    $axis,
    $xAxis,
    $yAxis,
    $topAxis,
    $rightAxis,
    $grid,
    $series,
    $palette,
    $tooltip,
    $animation,
    $modifier,
    $variants,
  ];
}

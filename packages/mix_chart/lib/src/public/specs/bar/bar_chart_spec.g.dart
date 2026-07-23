// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_chart_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$BarChartSpec implements Spec<BarChartSpec>, Diagnosticable {
  StyleSpec<ChartFrameSpec>? get frame;
  StyleSpec<ChartAxisSpec>? get axis;
  StyleSpec<ChartAxisSpec>? get xAxis;
  StyleSpec<ChartAxisSpec>? get yAxis;
  StyleSpec<ChartAxisSpec>? get topAxis;
  StyleSpec<ChartAxisSpec>? get rightAxis;
  StyleSpec<ChartGridSpec>? get grid;
  StyleSpec<BarSpec>? get bar;
  StyleSpec<BarSegmentSpec>? get segment;
  List<Color>? get palette;
  double? get groupSpacing;
  double? get barSpacing;
  BarAlignment? get alignment;
  StyleSpec<ChartTooltipSpec>? get tooltip;

  @override
  Type get type => BarChartSpec;

  @override
  BarChartSpec copyWith({
    StyleSpec<ChartFrameSpec>? frame,
    StyleSpec<ChartAxisSpec>? axis,
    StyleSpec<ChartAxisSpec>? xAxis,
    StyleSpec<ChartAxisSpec>? yAxis,
    StyleSpec<ChartAxisSpec>? topAxis,
    StyleSpec<ChartAxisSpec>? rightAxis,
    StyleSpec<ChartGridSpec>? grid,
    StyleSpec<BarSpec>? bar,
    StyleSpec<BarSegmentSpec>? segment,
    List<Color>? palette,
    double? groupSpacing,
    double? barSpacing,
    BarAlignment? alignment,
    StyleSpec<ChartTooltipSpec>? tooltip,
  }) {
    return BarChartSpec(
      frame: frame ?? this.frame,
      axis: axis ?? this.axis,
      xAxis: xAxis ?? this.xAxis,
      yAxis: yAxis ?? this.yAxis,
      topAxis: topAxis ?? this.topAxis,
      rightAxis: rightAxis ?? this.rightAxis,
      grid: grid ?? this.grid,
      bar: bar ?? this.bar,
      segment: segment ?? this.segment,
      palette: palette ?? this.palette,
      groupSpacing: groupSpacing ?? this.groupSpacing,
      barSpacing: barSpacing ?? this.barSpacing,
      alignment: alignment ?? this.alignment,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  @override
  BarChartSpec lerp(BarChartSpec? other, double t) {
    return BarChartSpec(
      frame: frame?.lerp(other?.frame, t),
      axis: axis?.lerp(other?.axis, t),
      xAxis: xAxis?.lerp(other?.xAxis, t),
      yAxis: yAxis?.lerp(other?.yAxis, t),
      topAxis: topAxis?.lerp(other?.topAxis, t),
      rightAxis: rightAxis?.lerp(other?.rightAxis, t),
      grid: grid?.lerp(other?.grid, t),
      bar: bar?.lerp(other?.bar, t),
      segment: segment?.lerp(other?.segment, t),
      palette: MixOps.lerpSnap(palette, other?.palette, t),
      groupSpacing: MixOps.lerp(groupSpacing, other?.groupSpacing, t),
      barSpacing: MixOps.lerp(barSpacing, other?.barSpacing, t),
      alignment: MixOps.lerpSnap(alignment, other?.alignment, t),
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
    bar,
    segment,
    palette,
    groupSpacing,
    barSpacing,
    alignment,
    tooltip,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BarChartSpec &&
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
      ..add(DiagnosticsProperty('bar', bar))
      ..add(DiagnosticsProperty('segment', segment))
      ..add(IterableProperty<Color>('palette', palette))
      ..add(DoubleProperty('groupSpacing', groupSpacing))
      ..add(DoubleProperty('barSpacing', barSpacing))
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DiagnosticsProperty('tooltip', tooltip));
  }
}

@Deprecated(
  'Rename to `_\$BarChartSpec` and migrate the class declaration to `class BarChartSpec with _\$BarChartSpec`. The `_\$BarChartSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$BarChartSpecMethods = _$BarChartSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class BarChartStyler extends MixStyler<BarChartStyler, BarChartSpec> {
  final Prop<StyleSpec<ChartFrameSpec>>? $frame;
  final Prop<StyleSpec<ChartAxisSpec>>? $axis;
  final Prop<StyleSpec<ChartAxisSpec>>? $xAxis;
  final Prop<StyleSpec<ChartAxisSpec>>? $yAxis;
  final Prop<StyleSpec<ChartAxisSpec>>? $topAxis;
  final Prop<StyleSpec<ChartAxisSpec>>? $rightAxis;
  final Prop<StyleSpec<ChartGridSpec>>? $grid;
  final Prop<StyleSpec<BarSpec>>? $bar;
  final Prop<StyleSpec<BarSegmentSpec>>? $segment;
  final Prop<List<Color>>? $palette;
  final Prop<double>? $groupSpacing;
  final Prop<double>? $barSpacing;
  final Prop<BarAlignment>? $alignment;
  final Prop<StyleSpec<ChartTooltipSpec>>? $tooltip;

  const BarChartStyler.create({
    Prop<StyleSpec<ChartFrameSpec>>? frame,
    Prop<StyleSpec<ChartAxisSpec>>? axis,
    Prop<StyleSpec<ChartAxisSpec>>? xAxis,
    Prop<StyleSpec<ChartAxisSpec>>? yAxis,
    Prop<StyleSpec<ChartAxisSpec>>? topAxis,
    Prop<StyleSpec<ChartAxisSpec>>? rightAxis,
    Prop<StyleSpec<ChartGridSpec>>? grid,
    Prop<StyleSpec<BarSpec>>? bar,
    Prop<StyleSpec<BarSegmentSpec>>? segment,
    Prop<List<Color>>? palette,
    Prop<double>? groupSpacing,
    Prop<double>? barSpacing,
    Prop<BarAlignment>? alignment,
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
       $bar = bar,
       $segment = segment,
       $palette = palette,
       $groupSpacing = groupSpacing,
       $barSpacing = barSpacing,
       $alignment = alignment,
       $tooltip = tooltip;

  BarChartStyler({
    ChartFrameStyler? frame,
    ChartAxisStyler? axis,
    ChartAxisStyler? xAxis,
    ChartAxisStyler? yAxis,
    ChartAxisStyler? topAxis,
    ChartAxisStyler? rightAxis,
    ChartGridStyler? grid,
    BarStyler? bar,
    BarSegmentStyler? segment,
    List<Color>? palette,
    double? groupSpacing,
    double? barSpacing,
    BarAlignment? alignment,
    ChartTooltipStyler? tooltip,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BarChartSpec>>? variants,
  }) : this.create(
         frame: Prop.maybeMix(frame),
         axis: Prop.maybeMix(axis),
         xAxis: Prop.maybeMix(xAxis),
         yAxis: Prop.maybeMix(yAxis),
         topAxis: Prop.maybeMix(topAxis),
         rightAxis: Prop.maybeMix(rightAxis),
         grid: Prop.maybeMix(grid),
         bar: Prop.maybeMix(bar),
         segment: Prop.maybeMix(segment),
         palette: Prop.maybe(palette),
         groupSpacing: Prop.maybe(groupSpacing),
         barSpacing: Prop.maybe(barSpacing),
         alignment: Prop.maybe(alignment),
         tooltip: Prop.maybeMix(tooltip),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BarChartStyler.frame(ChartFrameStyler value) =>
      BarChartStyler().frame(value);
  factory BarChartStyler.axis(ChartAxisStyler value) =>
      BarChartStyler().axis(value);
  factory BarChartStyler.xAxis(ChartAxisStyler value) =>
      BarChartStyler().xAxis(value);
  factory BarChartStyler.yAxis(ChartAxisStyler value) =>
      BarChartStyler().yAxis(value);
  factory BarChartStyler.topAxis(ChartAxisStyler value) =>
      BarChartStyler().topAxis(value);
  factory BarChartStyler.rightAxis(ChartAxisStyler value) =>
      BarChartStyler().rightAxis(value);
  factory BarChartStyler.grid(ChartGridStyler value) =>
      BarChartStyler().grid(value);
  factory BarChartStyler.bar(BarStyler value) => BarChartStyler().bar(value);
  factory BarChartStyler.segment(BarSegmentStyler value) =>
      BarChartStyler().segment(value);
  factory BarChartStyler.palette(List<Color> value) =>
      BarChartStyler().palette(value);
  factory BarChartStyler.groupSpacing(double value) =>
      BarChartStyler().groupSpacing(value);
  factory BarChartStyler.barSpacing(double value) =>
      BarChartStyler().barSpacing(value);
  factory BarChartStyler.alignment(BarAlignment value) =>
      BarChartStyler().alignment(value);
  factory BarChartStyler.tooltip(ChartTooltipStyler value) =>
      BarChartStyler().tooltip(value);

  /// Sets the frame.
  BarChartStyler frame(ChartFrameStyler value) {
    return merge(BarChartStyler(frame: value));
  }

  /// Sets the axis.
  BarChartStyler axis(ChartAxisStyler value) {
    return merge(BarChartStyler(axis: value));
  }

  /// Sets the xAxis.
  BarChartStyler xAxis(ChartAxisStyler value) {
    return merge(BarChartStyler(xAxis: value));
  }

  /// Sets the yAxis.
  BarChartStyler yAxis(ChartAxisStyler value) {
    return merge(BarChartStyler(yAxis: value));
  }

  /// Sets the topAxis.
  BarChartStyler topAxis(ChartAxisStyler value) {
    return merge(BarChartStyler(topAxis: value));
  }

  /// Sets the rightAxis.
  BarChartStyler rightAxis(ChartAxisStyler value) {
    return merge(BarChartStyler(rightAxis: value));
  }

  /// Sets the grid.
  BarChartStyler grid(ChartGridStyler value) {
    return merge(BarChartStyler(grid: value));
  }

  /// Sets the bar.
  BarChartStyler bar(BarStyler value) {
    return merge(BarChartStyler(bar: value));
  }

  /// Sets the segment.
  BarChartStyler segment(BarSegmentStyler value) {
    return merge(BarChartStyler(segment: value));
  }

  /// Sets the palette.
  BarChartStyler palette(List<Color> value) {
    return merge(BarChartStyler(palette: value));
  }

  /// Sets the groupSpacing.
  BarChartStyler groupSpacing(double value) {
    return merge(BarChartStyler(groupSpacing: value));
  }

  /// Sets the barSpacing.
  BarChartStyler barSpacing(double value) {
    return merge(BarChartStyler(barSpacing: value));
  }

  /// Sets the alignment.
  BarChartStyler alignment(BarAlignment value) {
    return merge(BarChartStyler(alignment: value));
  }

  /// Sets the tooltip.
  BarChartStyler tooltip(ChartTooltipStyler value) {
    return merge(BarChartStyler(tooltip: value));
  }

  /// Sets the animation configuration.
  @override
  BarChartStyler animate(AnimationConfig value) {
    return merge(BarChartStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  BarChartStyler variants(List<VariantStyle<BarChartSpec>> value) {
    return merge(BarChartStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  BarChartStyler wrap(WidgetModifierConfig value) {
    return merge(BarChartStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BarChartStyler modifier(WidgetModifierConfig value) {
    return merge(BarChartStyler(modifier: value));
  }

  BarChart call({
    Key? key,
    required List<BarGroup> groups,
    ChartAxis? xAxis,
    ChartAxis? yAxis,
    ChartAxis? topAxis,
    ChartAxis? rightAxis,
    ChartViewport? viewport,
    ChartDataTransition dataTransition = ChartDataTransition.none,
    Set<BarSelectionKey> selectedItems = const {},
    ValueChanged<BarChartHit?>? onBarHover,
    ValueChanged<BarChartHit>? onBarTap,
    ValueChanged<BarChartHit>? onBarLongPress,
    ChartTooltipBuilder? tooltipBuilder,
    EdgeInsets hitTestPadding = const EdgeInsets.all(4),
    ChartMouseCursorResolver<BarChartHit>? mouseCursorResolver,
    String? semanticsLabel,
    String? semanticsValue,
    bool excludeFromSemantics = false,
  }) {
    return BarChart(
      key: key,
      style: this,
      groups: groups,
      xAxis: xAxis,
      yAxis: yAxis,
      topAxis: topAxis,
      rightAxis: rightAxis,
      viewport: viewport,
      dataTransition: dataTransition,
      selectedItems: selectedItems,
      onBarHover: onBarHover,
      onBarTap: onBarTap,
      onBarLongPress: onBarLongPress,
      tooltipBuilder: tooltipBuilder,
      hitTestPadding: hitTestPadding,
      mouseCursorResolver: mouseCursorResolver,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }

  /// Merges with another [BarChartStyler].
  @override
  BarChartStyler merge(BarChartStyler? other) {
    return BarChartStyler.create(
      frame: MixOps.merge($frame, other?.$frame),
      axis: MixOps.merge($axis, other?.$axis),
      xAxis: MixOps.merge($xAxis, other?.$xAxis),
      yAxis: MixOps.merge($yAxis, other?.$yAxis),
      topAxis: MixOps.merge($topAxis, other?.$topAxis),
      rightAxis: MixOps.merge($rightAxis, other?.$rightAxis),
      grid: MixOps.merge($grid, other?.$grid),
      bar: MixOps.merge($bar, other?.$bar),
      segment: MixOps.merge($segment, other?.$segment),
      palette: MixOps.merge($palette, other?.$palette),
      groupSpacing: MixOps.merge($groupSpacing, other?.$groupSpacing),
      barSpacing: MixOps.merge($barSpacing, other?.$barSpacing),
      alignment: MixOps.merge($alignment, other?.$alignment),
      tooltip: MixOps.merge($tooltip, other?.$tooltip),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BarChartSpec>] using [context].
  @override
  StyleSpec<BarChartSpec> resolve(BuildContext context) {
    final spec = BarChartSpec(
      frame: MixOps.resolve(context, $frame),
      axis: MixOps.resolve(context, $axis),
      xAxis: MixOps.resolve(context, $xAxis),
      yAxis: MixOps.resolve(context, $yAxis),
      topAxis: MixOps.resolve(context, $topAxis),
      rightAxis: MixOps.resolve(context, $rightAxis),
      grid: MixOps.resolve(context, $grid),
      bar: MixOps.resolve(context, $bar),
      segment: MixOps.resolve(context, $segment),
      palette: MixOps.resolve(context, $palette),
      groupSpacing: MixOps.resolve(context, $groupSpacing),
      barSpacing: MixOps.resolve(context, $barSpacing),
      alignment: MixOps.resolve(context, $alignment),
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
      ..add(DiagnosticsProperty('bar', $bar))
      ..add(DiagnosticsProperty('segment', $segment))
      ..add(DiagnosticsProperty('palette', $palette))
      ..add(DiagnosticsProperty('groupSpacing', $groupSpacing))
      ..add(DiagnosticsProperty('barSpacing', $barSpacing))
      ..add(DiagnosticsProperty('alignment', $alignment))
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
    $bar,
    $segment,
    $palette,
    $groupSpacing,
    $barSpacing,
    $alignment,
    $tooltip,
    $animation,
    $modifier,
    $variants,
  ];
}

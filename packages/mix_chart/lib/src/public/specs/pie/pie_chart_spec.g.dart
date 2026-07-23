// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pie_chart_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$PieChartSpec implements Spec<PieChartSpec>, Diagnosticable {
  StyleSpec<ChartFrameSpec>? get frame;
  StyleSpec<PieSliceSpec>? get slice;
  List<Color>? get palette;
  double? get centerRadius;
  Color? get centerColor;
  double? get sliceSpacing;
  double? get startAngle;
  bool? get sunbeamLabels;
  StyleSpec<ChartTooltipSpec>? get tooltip;

  @override
  Type get type => PieChartSpec;

  @override
  PieChartSpec copyWith({
    StyleSpec<ChartFrameSpec>? frame,
    StyleSpec<PieSliceSpec>? slice,
    List<Color>? palette,
    double? centerRadius,
    Color? centerColor,
    double? sliceSpacing,
    double? startAngle,
    bool? sunbeamLabels,
    StyleSpec<ChartTooltipSpec>? tooltip,
  }) {
    return PieChartSpec(
      frame: frame ?? this.frame,
      slice: slice ?? this.slice,
      palette: palette ?? this.palette,
      centerRadius: centerRadius ?? this.centerRadius,
      centerColor: centerColor ?? this.centerColor,
      sliceSpacing: sliceSpacing ?? this.sliceSpacing,
      startAngle: startAngle ?? this.startAngle,
      sunbeamLabels: sunbeamLabels ?? this.sunbeamLabels,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  @override
  PieChartSpec lerp(PieChartSpec? other, double t) {
    return PieChartSpec(
      frame: frame?.lerp(other?.frame, t),
      slice: slice?.lerp(other?.slice, t),
      palette: MixOps.lerpSnap(palette, other?.palette, t),
      centerRadius: MixOps.lerp(centerRadius, other?.centerRadius, t),
      centerColor: MixOps.lerp(centerColor, other?.centerColor, t),
      sliceSpacing: MixOps.lerp(sliceSpacing, other?.sliceSpacing, t),
      startAngle: MixOps.lerp(startAngle, other?.startAngle, t),
      sunbeamLabels: MixOps.lerpSnap(sunbeamLabels, other?.sunbeamLabels, t),
      tooltip: tooltip?.lerp(other?.tooltip, t),
    );
  }

  @override
  List<Object?> get props => [
    frame,
    slice,
    palette,
    centerRadius,
    centerColor,
    sliceSpacing,
    startAngle,
    sunbeamLabels,
    tooltip,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PieChartSpec &&
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
      ..add(DiagnosticsProperty('slice', slice))
      ..add(IterableProperty<Color>('palette', palette))
      ..add(DoubleProperty('centerRadius', centerRadius))
      ..add(ColorProperty('centerColor', centerColor))
      ..add(DoubleProperty('sliceSpacing', sliceSpacing))
      ..add(DoubleProperty('startAngle', startAngle))
      ..add(DiagnosticsProperty('sunbeamLabels', sunbeamLabels))
      ..add(DiagnosticsProperty('tooltip', tooltip));
  }
}

@Deprecated(
  'Rename to `_\$PieChartSpec` and migrate the class declaration to `class PieChartSpec with _\$PieChartSpec`. The `_\$PieChartSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$PieChartSpecMethods = _$PieChartSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class PieChartStyler extends MixStyler<PieChartStyler, PieChartSpec> {
  final Prop<StyleSpec<ChartFrameSpec>>? $frame;
  final Prop<StyleSpec<PieSliceSpec>>? $slice;
  final Prop<List<Color>>? $palette;
  final Prop<double>? $centerRadius;
  final Prop<Color>? $centerColor;
  final Prop<double>? $sliceSpacing;
  final Prop<double>? $startAngle;
  final Prop<bool>? $sunbeamLabels;
  final Prop<StyleSpec<ChartTooltipSpec>>? $tooltip;

  const PieChartStyler.create({
    Prop<StyleSpec<ChartFrameSpec>>? frame,
    Prop<StyleSpec<PieSliceSpec>>? slice,
    Prop<List<Color>>? palette,
    Prop<double>? centerRadius,
    Prop<Color>? centerColor,
    Prop<double>? sliceSpacing,
    Prop<double>? startAngle,
    Prop<bool>? sunbeamLabels,
    Prop<StyleSpec<ChartTooltipSpec>>? tooltip,
    super.variants,
    super.modifier,
    super.animation,
  }) : $frame = frame,
       $slice = slice,
       $palette = palette,
       $centerRadius = centerRadius,
       $centerColor = centerColor,
       $sliceSpacing = sliceSpacing,
       $startAngle = startAngle,
       $sunbeamLabels = sunbeamLabels,
       $tooltip = tooltip;

  PieChartStyler({
    ChartFrameStyler? frame,
    PieSliceStyler? slice,
    List<Color>? palette,
    double? centerRadius,
    Color? centerColor,
    double? sliceSpacing,
    double? startAngle,
    bool? sunbeamLabels,
    ChartTooltipStyler? tooltip,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<PieChartSpec>>? variants,
  }) : this.create(
         frame: Prop.maybeMix(frame),
         slice: Prop.maybeMix(slice),
         palette: Prop.maybe(palette),
         centerRadius: Prop.maybe(centerRadius),
         centerColor: Prop.maybe(centerColor),
         sliceSpacing: Prop.maybe(sliceSpacing),
         startAngle: Prop.maybe(startAngle),
         sunbeamLabels: Prop.maybe(sunbeamLabels),
         tooltip: Prop.maybeMix(tooltip),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory PieChartStyler.frame(ChartFrameStyler value) =>
      PieChartStyler().frame(value);
  factory PieChartStyler.slice(PieSliceStyler value) =>
      PieChartStyler().slice(value);
  factory PieChartStyler.palette(List<Color> value) =>
      PieChartStyler().palette(value);
  factory PieChartStyler.centerRadius(double value) =>
      PieChartStyler().centerRadius(value);
  factory PieChartStyler.centerColor(Color value) =>
      PieChartStyler().centerColor(value);
  factory PieChartStyler.sliceSpacing(double value) =>
      PieChartStyler().sliceSpacing(value);
  factory PieChartStyler.startAngle(double value) =>
      PieChartStyler().startAngle(value);
  factory PieChartStyler.sunbeamLabels(bool value) =>
      PieChartStyler().sunbeamLabels(value);
  factory PieChartStyler.tooltip(ChartTooltipStyler value) =>
      PieChartStyler().tooltip(value);

  /// Sets the frame.
  PieChartStyler frame(ChartFrameStyler value) {
    return merge(PieChartStyler(frame: value));
  }

  /// Sets the slice.
  PieChartStyler slice(PieSliceStyler value) {
    return merge(PieChartStyler(slice: value));
  }

  /// Sets the palette.
  PieChartStyler palette(List<Color> value) {
    return merge(PieChartStyler(palette: value));
  }

  /// Sets the centerRadius.
  PieChartStyler centerRadius(double value) {
    return merge(PieChartStyler(centerRadius: value));
  }

  /// Sets the centerColor.
  PieChartStyler centerColor(Color value) {
    return merge(PieChartStyler(centerColor: value));
  }

  /// Sets the sliceSpacing.
  PieChartStyler sliceSpacing(double value) {
    return merge(PieChartStyler(sliceSpacing: value));
  }

  /// Sets the startAngle.
  PieChartStyler startAngle(double value) {
    return merge(PieChartStyler(startAngle: value));
  }

  /// Sets the sunbeamLabels.
  PieChartStyler sunbeamLabels(bool value) {
    return merge(PieChartStyler(sunbeamLabels: value));
  }

  /// Sets the tooltip.
  PieChartStyler tooltip(ChartTooltipStyler value) {
    return merge(PieChartStyler(tooltip: value));
  }

  /// Sets the animation configuration.
  @override
  PieChartStyler animate(AnimationConfig value) {
    return merge(PieChartStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  PieChartStyler variants(List<VariantStyle<PieChartSpec>> value) {
    return merge(PieChartStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  PieChartStyler wrap(WidgetModifierConfig value) {
    return merge(PieChartStyler(modifier: value));
  }

  /// Sets the widget modifier.
  PieChartStyler modifier(WidgetModifierConfig value) {
    return merge(PieChartStyler(modifier: value));
  }

  PieChart call({
    Key? key,
    required List<PieSlice> slices,
    ChartDataTransition dataTransition = ChartDataTransition.none,
    Set<Object> selectedSliceIds = const {},
    ValueChanged<PieChartHit?>? onSliceHover,
    ValueChanged<PieChartHit>? onSliceTap,
    ValueChanged<PieChartHit>? onSliceLongPress,
    ChartTooltipBuilder? tooltipBuilder,
    ChartMouseCursorResolver<PieChartHit>? mouseCursorResolver,
    ChartAxisLabelFormatter? valueFormatter,
    String? semanticsLabel,
    String? semanticsValue,
    bool excludeFromSemantics = false,
  }) {
    return PieChart(
      key: key,
      style: this,
      slices: slices,
      dataTransition: dataTransition,
      selectedSliceIds: selectedSliceIds,
      onSliceHover: onSliceHover,
      onSliceTap: onSliceTap,
      onSliceLongPress: onSliceLongPress,
      tooltipBuilder: tooltipBuilder,
      mouseCursorResolver: mouseCursorResolver,
      valueFormatter: valueFormatter,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeFromSemantics: excludeFromSemantics,
    );
  }

  /// Merges with another [PieChartStyler].
  @override
  PieChartStyler merge(PieChartStyler? other) {
    return PieChartStyler.create(
      frame: MixOps.merge($frame, other?.$frame),
      slice: MixOps.merge($slice, other?.$slice),
      palette: MixOps.merge($palette, other?.$palette),
      centerRadius: MixOps.merge($centerRadius, other?.$centerRadius),
      centerColor: MixOps.merge($centerColor, other?.$centerColor),
      sliceSpacing: MixOps.merge($sliceSpacing, other?.$sliceSpacing),
      startAngle: MixOps.merge($startAngle, other?.$startAngle),
      sunbeamLabels: MixOps.merge($sunbeamLabels, other?.$sunbeamLabels),
      tooltip: MixOps.merge($tooltip, other?.$tooltip),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<PieChartSpec>] using [context].
  @override
  StyleSpec<PieChartSpec> resolve(BuildContext context) {
    final spec = PieChartSpec(
      frame: MixOps.resolve(context, $frame),
      slice: MixOps.resolve(context, $slice),
      palette: MixOps.resolve(context, $palette),
      centerRadius: MixOps.resolve(context, $centerRadius),
      centerColor: MixOps.resolve(context, $centerColor),
      sliceSpacing: MixOps.resolve(context, $sliceSpacing),
      startAngle: MixOps.resolve(context, $startAngle),
      sunbeamLabels: MixOps.resolve(context, $sunbeamLabels),
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
      ..add(DiagnosticsProperty('slice', $slice))
      ..add(DiagnosticsProperty('palette', $palette))
      ..add(DiagnosticsProperty('centerRadius', $centerRadius))
      ..add(DiagnosticsProperty('centerColor', $centerColor))
      ..add(DiagnosticsProperty('sliceSpacing', $sliceSpacing))
      ..add(DiagnosticsProperty('startAngle', $startAngle))
      ..add(DiagnosticsProperty('sunbeamLabels', $sunbeamLabels))
      ..add(DiagnosticsProperty('tooltip', $tooltip));
  }

  @override
  List<Object?> get props => [
    $frame,
    $slice,
    $palette,
    $centerRadius,
    $centerColor,
    $sliceSpacing,
    $startAngle,
    $sunbeamLabels,
    $tooltip,
    $animation,
    $modifier,
    $variants,
  ];
}

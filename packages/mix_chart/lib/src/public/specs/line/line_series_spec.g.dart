// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_series_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$LineSeriesSpec implements Spec<LineSeriesSpec>, Diagnosticable {
  bool? get show;
  StyleSpec<ChartStrokeSpec>? get stroke;
  LineCurve? get curve;
  double? get smoothness;
  bool? get preventCurveOvershooting;
  double? get curveOvershootingThreshold;
  bool? get roundStrokeCap;
  bool? get roundStrokeJoin;
  StyleSpec<ChartMarkerSpec>? get marker;
  StyleSpec<ChartAreaSpec>? get belowArea;
  StyleSpec<ChartAreaSpec>? get aboveArea;
  Shadow? get shadow;

  @override
  Type get type => LineSeriesSpec;

  @override
  LineSeriesSpec copyWith({
    bool? show,
    StyleSpec<ChartStrokeSpec>? stroke,
    LineCurve? curve,
    double? smoothness,
    bool? preventCurveOvershooting,
    double? curveOvershootingThreshold,
    bool? roundStrokeCap,
    bool? roundStrokeJoin,
    StyleSpec<ChartMarkerSpec>? marker,
    StyleSpec<ChartAreaSpec>? belowArea,
    StyleSpec<ChartAreaSpec>? aboveArea,
    Shadow? shadow,
  }) {
    return LineSeriesSpec(
      show: show ?? this.show,
      stroke: stroke ?? this.stroke,
      curve: curve ?? this.curve,
      smoothness: smoothness ?? this.smoothness,
      preventCurveOvershooting:
          preventCurveOvershooting ?? this.preventCurveOvershooting,
      curveOvershootingThreshold:
          curveOvershootingThreshold ?? this.curveOvershootingThreshold,
      roundStrokeCap: roundStrokeCap ?? this.roundStrokeCap,
      roundStrokeJoin: roundStrokeJoin ?? this.roundStrokeJoin,
      marker: marker ?? this.marker,
      belowArea: belowArea ?? this.belowArea,
      aboveArea: aboveArea ?? this.aboveArea,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  LineSeriesSpec lerp(LineSeriesSpec? other, double t) {
    return LineSeriesSpec(
      show: MixOps.lerpSnap(show, other?.show, t),
      stroke: stroke?.lerp(other?.stroke, t),
      curve: MixOps.lerpSnap(curve, other?.curve, t),
      smoothness: MixOps.lerp(smoothness, other?.smoothness, t),
      preventCurveOvershooting: MixOps.lerpSnap(
        preventCurveOvershooting,
        other?.preventCurveOvershooting,
        t,
      ),
      curveOvershootingThreshold: MixOps.lerp(
        curveOvershootingThreshold,
        other?.curveOvershootingThreshold,
        t,
      ),
      roundStrokeCap: MixOps.lerpSnap(roundStrokeCap, other?.roundStrokeCap, t),
      roundStrokeJoin: MixOps.lerpSnap(
        roundStrokeJoin,
        other?.roundStrokeJoin,
        t,
      ),
      marker: marker?.lerp(other?.marker, t),
      belowArea: belowArea?.lerp(other?.belowArea, t),
      aboveArea: aboveArea?.lerp(other?.aboveArea, t),
      shadow: MixOps.lerp(shadow, other?.shadow, t),
    );
  }

  @override
  List<Object?> get props => [
    show,
    stroke,
    curve,
    smoothness,
    preventCurveOvershooting,
    curveOvershootingThreshold,
    roundStrokeCap,
    roundStrokeJoin,
    marker,
    belowArea,
    aboveArea,
    shadow,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LineSeriesSpec &&
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
      ..add(DiagnosticsProperty('stroke', stroke))
      ..add(DiagnosticsProperty('curve', curve))
      ..add(DoubleProperty('smoothness', smoothness))
      ..add(
        DiagnosticsProperty(
          'preventCurveOvershooting',
          preventCurveOvershooting,
        ),
      )
      ..add(
        DoubleProperty(
          'curveOvershootingThreshold',
          curveOvershootingThreshold,
        ),
      )
      ..add(DiagnosticsProperty('roundStrokeCap', roundStrokeCap))
      ..add(DiagnosticsProperty('roundStrokeJoin', roundStrokeJoin))
      ..add(DiagnosticsProperty('marker', marker))
      ..add(DiagnosticsProperty('belowArea', belowArea))
      ..add(DiagnosticsProperty('aboveArea', aboveArea))
      ..add(DiagnosticsProperty('shadow', shadow));
  }
}

@Deprecated(
  'Rename to `_\$LineSeriesSpec` and migrate the class declaration to `class LineSeriesSpec with _\$LineSeriesSpec`. The `_\$LineSeriesSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$LineSeriesSpecMethods = _$LineSeriesSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class LineSeriesStyler extends MixStyler<LineSeriesStyler, LineSeriesSpec> {
  final Prop<bool>? $show;
  final Prop<StyleSpec<ChartStrokeSpec>>? $stroke;
  final Prop<LineCurve>? $curve;
  final Prop<double>? $smoothness;
  final Prop<bool>? $preventCurveOvershooting;
  final Prop<double>? $curveOvershootingThreshold;
  final Prop<bool>? $roundStrokeCap;
  final Prop<bool>? $roundStrokeJoin;
  final Prop<StyleSpec<ChartMarkerSpec>>? $marker;
  final Prop<StyleSpec<ChartAreaSpec>>? $belowArea;
  final Prop<StyleSpec<ChartAreaSpec>>? $aboveArea;
  final Prop<Shadow>? $shadow;

  const LineSeriesStyler.create({
    Prop<bool>? show,
    Prop<StyleSpec<ChartStrokeSpec>>? stroke,
    Prop<LineCurve>? curve,
    Prop<double>? smoothness,
    Prop<bool>? preventCurveOvershooting,
    Prop<double>? curveOvershootingThreshold,
    Prop<bool>? roundStrokeCap,
    Prop<bool>? roundStrokeJoin,
    Prop<StyleSpec<ChartMarkerSpec>>? marker,
    Prop<StyleSpec<ChartAreaSpec>>? belowArea,
    Prop<StyleSpec<ChartAreaSpec>>? aboveArea,
    Prop<Shadow>? shadow,
    super.variants,
    super.modifier,
    super.animation,
  }) : $show = show,
       $stroke = stroke,
       $curve = curve,
       $smoothness = smoothness,
       $preventCurveOvershooting = preventCurveOvershooting,
       $curveOvershootingThreshold = curveOvershootingThreshold,
       $roundStrokeCap = roundStrokeCap,
       $roundStrokeJoin = roundStrokeJoin,
       $marker = marker,
       $belowArea = belowArea,
       $aboveArea = aboveArea,
       $shadow = shadow;

  LineSeriesStyler({
    bool? show,
    ChartStrokeStyler? stroke,
    LineCurve? curve,
    double? smoothness,
    bool? preventCurveOvershooting,
    double? curveOvershootingThreshold,
    bool? roundStrokeCap,
    bool? roundStrokeJoin,
    ChartMarkerStyler? marker,
    ChartAreaStyler? belowArea,
    ChartAreaStyler? aboveArea,
    ShadowMix? shadow,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<LineSeriesSpec>>? variants,
  }) : this.create(
         show: Prop.maybe(show),
         stroke: Prop.maybeMix(stroke),
         curve: Prop.maybe(curve),
         smoothness: Prop.maybe(smoothness),
         preventCurveOvershooting: Prop.maybe(preventCurveOvershooting),
         curveOvershootingThreshold: Prop.maybe(curveOvershootingThreshold),
         roundStrokeCap: Prop.maybe(roundStrokeCap),
         roundStrokeJoin: Prop.maybe(roundStrokeJoin),
         marker: Prop.maybeMix(marker),
         belowArea: Prop.maybeMix(belowArea),
         aboveArea: Prop.maybeMix(aboveArea),
         shadow: Prop.maybeMix(shadow),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory LineSeriesStyler.show(bool value) => LineSeriesStyler().show(value);
  factory LineSeriesStyler.stroke(ChartStrokeStyler value) =>
      LineSeriesStyler().stroke(value);
  factory LineSeriesStyler.curve(LineCurve value) =>
      LineSeriesStyler().curve(value);
  factory LineSeriesStyler.smoothness(double value) =>
      LineSeriesStyler().smoothness(value);
  factory LineSeriesStyler.preventCurveOvershooting(bool value) =>
      LineSeriesStyler().preventCurveOvershooting(value);
  factory LineSeriesStyler.curveOvershootingThreshold(double value) =>
      LineSeriesStyler().curveOvershootingThreshold(value);
  factory LineSeriesStyler.roundStrokeCap(bool value) =>
      LineSeriesStyler().roundStrokeCap(value);
  factory LineSeriesStyler.roundStrokeJoin(bool value) =>
      LineSeriesStyler().roundStrokeJoin(value);
  factory LineSeriesStyler.marker(ChartMarkerStyler value) =>
      LineSeriesStyler().marker(value);
  factory LineSeriesStyler.belowArea(ChartAreaStyler value) =>
      LineSeriesStyler().belowArea(value);
  factory LineSeriesStyler.aboveArea(ChartAreaStyler value) =>
      LineSeriesStyler().aboveArea(value);
  factory LineSeriesStyler.shadow(ShadowMix value) =>
      LineSeriesStyler().shadow(value);

  /// Sets the show.
  LineSeriesStyler show(bool value) {
    return merge(LineSeriesStyler(show: value));
  }

  /// Sets the stroke.
  LineSeriesStyler stroke(ChartStrokeStyler value) {
    return merge(LineSeriesStyler(stroke: value));
  }

  /// Sets the curve.
  LineSeriesStyler curve(LineCurve value) {
    return merge(LineSeriesStyler(curve: value));
  }

  /// Sets the smoothness.
  LineSeriesStyler smoothness(double value) {
    return merge(LineSeriesStyler(smoothness: value));
  }

  /// Sets the preventCurveOvershooting.
  LineSeriesStyler preventCurveOvershooting(bool value) {
    return merge(LineSeriesStyler(preventCurveOvershooting: value));
  }

  /// Sets the curveOvershootingThreshold.
  LineSeriesStyler curveOvershootingThreshold(double value) {
    return merge(LineSeriesStyler(curveOvershootingThreshold: value));
  }

  /// Sets the roundStrokeCap.
  LineSeriesStyler roundStrokeCap(bool value) {
    return merge(LineSeriesStyler(roundStrokeCap: value));
  }

  /// Sets the roundStrokeJoin.
  LineSeriesStyler roundStrokeJoin(bool value) {
    return merge(LineSeriesStyler(roundStrokeJoin: value));
  }

  /// Sets the marker.
  LineSeriesStyler marker(ChartMarkerStyler value) {
    return merge(LineSeriesStyler(marker: value));
  }

  /// Sets the belowArea.
  LineSeriesStyler belowArea(ChartAreaStyler value) {
    return merge(LineSeriesStyler(belowArea: value));
  }

  /// Sets the aboveArea.
  LineSeriesStyler aboveArea(ChartAreaStyler value) {
    return merge(LineSeriesStyler(aboveArea: value));
  }

  /// Sets the shadow.
  LineSeriesStyler shadow(ShadowMix value) {
    return merge(LineSeriesStyler(shadow: value));
  }

  /// Sets the animation configuration.
  @override
  LineSeriesStyler animate(AnimationConfig value) {
    return merge(LineSeriesStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  LineSeriesStyler variants(List<VariantStyle<LineSeriesSpec>> value) {
    return merge(LineSeriesStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  LineSeriesStyler wrap(WidgetModifierConfig value) {
    return merge(LineSeriesStyler(modifier: value));
  }

  /// Sets the widget modifier.
  LineSeriesStyler modifier(WidgetModifierConfig value) {
    return merge(LineSeriesStyler(modifier: value));
  }

  /// Merges with another [LineSeriesStyler].
  @override
  LineSeriesStyler merge(LineSeriesStyler? other) {
    return LineSeriesStyler.create(
      show: MixOps.merge($show, other?.$show),
      stroke: MixOps.merge($stroke, other?.$stroke),
      curve: MixOps.merge($curve, other?.$curve),
      smoothness: MixOps.merge($smoothness, other?.$smoothness),
      preventCurveOvershooting: MixOps.merge(
        $preventCurveOvershooting,
        other?.$preventCurveOvershooting,
      ),
      curveOvershootingThreshold: MixOps.merge(
        $curveOvershootingThreshold,
        other?.$curveOvershootingThreshold,
      ),
      roundStrokeCap: MixOps.merge($roundStrokeCap, other?.$roundStrokeCap),
      roundStrokeJoin: MixOps.merge($roundStrokeJoin, other?.$roundStrokeJoin),
      marker: MixOps.merge($marker, other?.$marker),
      belowArea: MixOps.merge($belowArea, other?.$belowArea),
      aboveArea: MixOps.merge($aboveArea, other?.$aboveArea),
      shadow: MixOps.merge($shadow, other?.$shadow),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<LineSeriesSpec>] using [context].
  @override
  StyleSpec<LineSeriesSpec> resolve(BuildContext context) {
    final spec = LineSeriesSpec(
      show: MixOps.resolve(context, $show),
      stroke: MixOps.resolve(context, $stroke),
      curve: MixOps.resolve(context, $curve),
      smoothness: MixOps.resolve(context, $smoothness),
      preventCurveOvershooting: MixOps.resolve(
        context,
        $preventCurveOvershooting,
      ),
      curveOvershootingThreshold: MixOps.resolve(
        context,
        $curveOvershootingThreshold,
      ),
      roundStrokeCap: MixOps.resolve(context, $roundStrokeCap),
      roundStrokeJoin: MixOps.resolve(context, $roundStrokeJoin),
      marker: MixOps.resolve(context, $marker),
      belowArea: MixOps.resolve(context, $belowArea),
      aboveArea: MixOps.resolve(context, $aboveArea),
      shadow: MixOps.resolve(context, $shadow),
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
      ..add(DiagnosticsProperty('stroke', $stroke))
      ..add(DiagnosticsProperty('curve', $curve))
      ..add(DiagnosticsProperty('smoothness', $smoothness))
      ..add(
        DiagnosticsProperty(
          'preventCurveOvershooting',
          $preventCurveOvershooting,
        ),
      )
      ..add(
        DiagnosticsProperty(
          'curveOvershootingThreshold',
          $curveOvershootingThreshold,
        ),
      )
      ..add(DiagnosticsProperty('roundStrokeCap', $roundStrokeCap))
      ..add(DiagnosticsProperty('roundStrokeJoin', $roundStrokeJoin))
      ..add(DiagnosticsProperty('marker', $marker))
      ..add(DiagnosticsProperty('belowArea', $belowArea))
      ..add(DiagnosticsProperty('aboveArea', $aboveArea))
      ..add(DiagnosticsProperty('shadow', $shadow));
  }

  @override
  List<Object?> get props => [
    $show,
    $stroke,
    $curve,
    $smoothness,
    $preventCurveOvershooting,
    $curveOvershootingThreshold,
    $roundStrokeCap,
    $roundStrokeJoin,
    $marker,
    $belowArea,
    $aboveArea,
    $shadow,
    $animation,
    $modifier,
    $variants,
  ];
}

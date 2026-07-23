// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_axis_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartAxisSpec implements Spec<ChartAxisSpec>, Diagnosticable {
  bool? get showLabels;
  StyleSpec<TextSpec>? get label;
  double? get reservedSize;
  double? get labelSpace;
  double? get labelAngle;
  bool? get fitInside;
  double? get fitInsideDistance;
  double? get nameSize;
  bool? get drawBelowEverything;
  ChartAxisLabelAlignment? get alignment;

  @override
  Type get type => ChartAxisSpec;

  @override
  ChartAxisSpec copyWith({
    bool? showLabels,
    StyleSpec<TextSpec>? label,
    double? reservedSize,
    double? labelSpace,
    double? labelAngle,
    bool? fitInside,
    double? fitInsideDistance,
    double? nameSize,
    bool? drawBelowEverything,
    ChartAxisLabelAlignment? alignment,
  }) {
    return ChartAxisSpec(
      showLabels: showLabels ?? this.showLabels,
      label: label ?? this.label,
      reservedSize: reservedSize ?? this.reservedSize,
      labelSpace: labelSpace ?? this.labelSpace,
      labelAngle: labelAngle ?? this.labelAngle,
      fitInside: fitInside ?? this.fitInside,
      fitInsideDistance: fitInsideDistance ?? this.fitInsideDistance,
      nameSize: nameSize ?? this.nameSize,
      drawBelowEverything: drawBelowEverything ?? this.drawBelowEverything,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  ChartAxisSpec lerp(ChartAxisSpec? other, double t) {
    return ChartAxisSpec(
      showLabels: MixOps.lerpSnap(showLabels, other?.showLabels, t),
      label: label?.lerp(other?.label, t),
      reservedSize: MixOps.lerp(reservedSize, other?.reservedSize, t),
      labelSpace: MixOps.lerp(labelSpace, other?.labelSpace, t),
      labelAngle: MixOps.lerp(labelAngle, other?.labelAngle, t),
      fitInside: MixOps.lerpSnap(fitInside, other?.fitInside, t),
      fitInsideDistance: MixOps.lerp(
        fitInsideDistance,
        other?.fitInsideDistance,
        t,
      ),
      nameSize: MixOps.lerp(nameSize, other?.nameSize, t),
      drawBelowEverything: MixOps.lerpSnap(
        drawBelowEverything,
        other?.drawBelowEverything,
        t,
      ),
      alignment: MixOps.lerpSnap(alignment, other?.alignment, t),
    );
  }

  @override
  List<Object?> get props => [
    showLabels,
    label,
    reservedSize,
    labelSpace,
    labelAngle,
    fitInside,
    fitInsideDistance,
    nameSize,
    drawBelowEverything,
    alignment,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartAxisSpec &&
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
      ..add(DiagnosticsProperty('showLabels', showLabels))
      ..add(DiagnosticsProperty('label', label))
      ..add(DoubleProperty('reservedSize', reservedSize))
      ..add(DoubleProperty('labelSpace', labelSpace))
      ..add(DoubleProperty('labelAngle', labelAngle))
      ..add(DiagnosticsProperty('fitInside', fitInside))
      ..add(DoubleProperty('fitInsideDistance', fitInsideDistance))
      ..add(DoubleProperty('nameSize', nameSize))
      ..add(DiagnosticsProperty('drawBelowEverything', drawBelowEverything))
      ..add(DiagnosticsProperty('alignment', alignment));
  }
}

@Deprecated(
  'Rename to `_\$ChartAxisSpec` and migrate the class declaration to `class ChartAxisSpec with _\$ChartAxisSpec`. The `_\$ChartAxisSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartAxisSpecMethods = _$ChartAxisSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartAxisStyler extends MixStyler<ChartAxisStyler, ChartAxisSpec> {
  final Prop<bool>? $showLabels;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<double>? $reservedSize;
  final Prop<double>? $labelSpace;
  final Prop<double>? $labelAngle;
  final Prop<bool>? $fitInside;
  final Prop<double>? $fitInsideDistance;
  final Prop<double>? $nameSize;
  final Prop<bool>? $drawBelowEverything;
  final Prop<ChartAxisLabelAlignment>? $alignment;

  const ChartAxisStyler.create({
    Prop<bool>? showLabels,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<double>? reservedSize,
    Prop<double>? labelSpace,
    Prop<double>? labelAngle,
    Prop<bool>? fitInside,
    Prop<double>? fitInsideDistance,
    Prop<double>? nameSize,
    Prop<bool>? drawBelowEverything,
    Prop<ChartAxisLabelAlignment>? alignment,
    super.variants,
    super.modifier,
    super.animation,
  }) : $showLabels = showLabels,
       $label = label,
       $reservedSize = reservedSize,
       $labelSpace = labelSpace,
       $labelAngle = labelAngle,
       $fitInside = fitInside,
       $fitInsideDistance = fitInsideDistance,
       $nameSize = nameSize,
       $drawBelowEverything = drawBelowEverything,
       $alignment = alignment;

  ChartAxisStyler({
    bool? showLabels,
    TextStyler? label,
    double? reservedSize,
    double? labelSpace,
    double? labelAngle,
    bool? fitInside,
    double? fitInsideDistance,
    double? nameSize,
    bool? drawBelowEverything,
    ChartAxisLabelAlignment? alignment,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartAxisSpec>>? variants,
  }) : this.create(
         showLabels: Prop.maybe(showLabels),
         label: Prop.maybeMix(label),
         reservedSize: Prop.maybe(reservedSize),
         labelSpace: Prop.maybe(labelSpace),
         labelAngle: Prop.maybe(labelAngle),
         fitInside: Prop.maybe(fitInside),
         fitInsideDistance: Prop.maybe(fitInsideDistance),
         nameSize: Prop.maybe(nameSize),
         drawBelowEverything: Prop.maybe(drawBelowEverything),
         alignment: Prop.maybe(alignment),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartAxisStyler.showLabels(bool value) =>
      ChartAxisStyler().showLabels(value);
  factory ChartAxisStyler.label(TextStyler value) =>
      ChartAxisStyler().label(value);
  factory ChartAxisStyler.reservedSize(double value) =>
      ChartAxisStyler().reservedSize(value);
  factory ChartAxisStyler.labelSpace(double value) =>
      ChartAxisStyler().labelSpace(value);
  factory ChartAxisStyler.labelAngle(double value) =>
      ChartAxisStyler().labelAngle(value);
  factory ChartAxisStyler.fitInside(bool value) =>
      ChartAxisStyler().fitInside(value);
  factory ChartAxisStyler.fitInsideDistance(double value) =>
      ChartAxisStyler().fitInsideDistance(value);
  factory ChartAxisStyler.nameSize(double value) =>
      ChartAxisStyler().nameSize(value);
  factory ChartAxisStyler.drawBelowEverything(bool value) =>
      ChartAxisStyler().drawBelowEverything(value);
  factory ChartAxisStyler.alignment(ChartAxisLabelAlignment value) =>
      ChartAxisStyler().alignment(value);

  /// Sets the showLabels.
  ChartAxisStyler showLabels(bool value) {
    return merge(ChartAxisStyler(showLabels: value));
  }

  /// Sets the label.
  ChartAxisStyler label(TextStyler value) {
    return merge(ChartAxisStyler(label: value));
  }

  /// Sets the reservedSize.
  ChartAxisStyler reservedSize(double value) {
    return merge(ChartAxisStyler(reservedSize: value));
  }

  /// Sets the labelSpace.
  ChartAxisStyler labelSpace(double value) {
    return merge(ChartAxisStyler(labelSpace: value));
  }

  /// Sets the labelAngle.
  ChartAxisStyler labelAngle(double value) {
    return merge(ChartAxisStyler(labelAngle: value));
  }

  /// Sets the fitInside.
  ChartAxisStyler fitInside(bool value) {
    return merge(ChartAxisStyler(fitInside: value));
  }

  /// Sets the fitInsideDistance.
  ChartAxisStyler fitInsideDistance(double value) {
    return merge(ChartAxisStyler(fitInsideDistance: value));
  }

  /// Sets the nameSize.
  ChartAxisStyler nameSize(double value) {
    return merge(ChartAxisStyler(nameSize: value));
  }

  /// Sets the drawBelowEverything.
  ChartAxisStyler drawBelowEverything(bool value) {
    return merge(ChartAxisStyler(drawBelowEverything: value));
  }

  /// Sets the alignment.
  ChartAxisStyler alignment(ChartAxisLabelAlignment value) {
    return merge(ChartAxisStyler(alignment: value));
  }

  /// Sets the animation configuration.
  @override
  ChartAxisStyler animate(AnimationConfig value) {
    return merge(ChartAxisStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartAxisStyler variants(List<VariantStyle<ChartAxisSpec>> value) {
    return merge(ChartAxisStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartAxisStyler wrap(WidgetModifierConfig value) {
    return merge(ChartAxisStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartAxisStyler modifier(WidgetModifierConfig value) {
    return merge(ChartAxisStyler(modifier: value));
  }

  /// Merges with another [ChartAxisStyler].
  @override
  ChartAxisStyler merge(ChartAxisStyler? other) {
    return ChartAxisStyler.create(
      showLabels: MixOps.merge($showLabels, other?.$showLabels),
      label: MixOps.merge($label, other?.$label),
      reservedSize: MixOps.merge($reservedSize, other?.$reservedSize),
      labelSpace: MixOps.merge($labelSpace, other?.$labelSpace),
      labelAngle: MixOps.merge($labelAngle, other?.$labelAngle),
      fitInside: MixOps.merge($fitInside, other?.$fitInside),
      fitInsideDistance: MixOps.merge(
        $fitInsideDistance,
        other?.$fitInsideDistance,
      ),
      nameSize: MixOps.merge($nameSize, other?.$nameSize),
      drawBelowEverything: MixOps.merge(
        $drawBelowEverything,
        other?.$drawBelowEverything,
      ),
      alignment: MixOps.merge($alignment, other?.$alignment),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartAxisSpec>] using [context].
  @override
  StyleSpec<ChartAxisSpec> resolve(BuildContext context) {
    final spec = ChartAxisSpec(
      showLabels: MixOps.resolve(context, $showLabels),
      label: MixOps.resolve(context, $label),
      reservedSize: MixOps.resolve(context, $reservedSize),
      labelSpace: MixOps.resolve(context, $labelSpace),
      labelAngle: MixOps.resolve(context, $labelAngle),
      fitInside: MixOps.resolve(context, $fitInside),
      fitInsideDistance: MixOps.resolve(context, $fitInsideDistance),
      nameSize: MixOps.resolve(context, $nameSize),
      drawBelowEverything: MixOps.resolve(context, $drawBelowEverything),
      alignment: MixOps.resolve(context, $alignment),
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
      ..add(DiagnosticsProperty('showLabels', $showLabels))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('reservedSize', $reservedSize))
      ..add(DiagnosticsProperty('labelSpace', $labelSpace))
      ..add(DiagnosticsProperty('labelAngle', $labelAngle))
      ..add(DiagnosticsProperty('fitInside', $fitInside))
      ..add(DiagnosticsProperty('fitInsideDistance', $fitInsideDistance))
      ..add(DiagnosticsProperty('nameSize', $nameSize))
      ..add(DiagnosticsProperty('drawBelowEverything', $drawBelowEverything))
      ..add(DiagnosticsProperty('alignment', $alignment));
  }

  @override
  List<Object?> get props => [
    $showLabels,
    $label,
    $reservedSize,
    $labelSpace,
    $labelAngle,
    $fitInside,
    $fitInsideDistance,
    $nameSize,
    $drawBelowEverything,
    $alignment,
    $animation,
    $modifier,
    $variants,
  ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_stroke_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartStrokeSpec implements Spec<ChartStrokeSpec>, Diagnosticable {
  Color? get color;
  Gradient? get gradient;
  double? get width;
  List<int>? get dashArray;
  double? get opacity;

  @override
  Type get type => ChartStrokeSpec;

  @override
  ChartStrokeSpec copyWith({
    Color? color,
    Gradient? gradient,
    double? width,
    List<int>? dashArray,
    double? opacity,
  }) {
    return ChartStrokeSpec(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      dashArray: dashArray ?? this.dashArray,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  ChartStrokeSpec lerp(ChartStrokeSpec? other, double t) {
    return ChartStrokeSpec(
      color: MixOps.lerp(color, other?.color, t),
      gradient: MixOps.lerp(gradient, other?.gradient, t),
      width: MixOps.lerp(width, other?.width, t),
      dashArray: MixOps.lerpSnap(dashArray, other?.dashArray, t),
      opacity: MixOps.lerp(opacity, other?.opacity, t),
    );
  }

  @override
  List<Object?> get props => [color, gradient, width, dashArray, opacity];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartStrokeSpec &&
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
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty('gradient', gradient))
      ..add(DoubleProperty('width', width))
      ..add(IterableProperty<int>('dashArray', dashArray))
      ..add(DoubleProperty('opacity', opacity));
  }
}

@Deprecated(
  'Rename to `_\$ChartStrokeSpec` and migrate the class declaration to `class ChartStrokeSpec with _\$ChartStrokeSpec`. The `_\$ChartStrokeSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartStrokeSpecMethods = _$ChartStrokeSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartStrokeStyler extends MixStyler<ChartStrokeStyler, ChartStrokeSpec> {
  final Prop<Color>? $color;
  final Prop<Gradient>? $gradient;
  final Prop<double>? $width;
  final Prop<List<int>>? $dashArray;
  final Prop<double>? $opacity;

  const ChartStrokeStyler.create({
    Prop<Color>? color,
    Prop<Gradient>? gradient,
    Prop<double>? width,
    Prop<List<int>>? dashArray,
    Prop<double>? opacity,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color,
       $gradient = gradient,
       $width = width,
       $dashArray = dashArray,
       $opacity = opacity;

  ChartStrokeStyler({
    Color? color,
    Gradient? gradient,
    double? width,
    List<int>? dashArray,
    double? opacity,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartStrokeSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         gradient: Prop.maybe(gradient),
         width: Prop.maybe(width),
         dashArray: Prop.maybe(dashArray),
         opacity: Prop.maybe(opacity),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartStrokeStyler.color(Color value) =>
      ChartStrokeStyler().color(value);
  factory ChartStrokeStyler.gradient(Gradient value) =>
      ChartStrokeStyler().gradient(value);
  factory ChartStrokeStyler.width(double value) =>
      ChartStrokeStyler().width(value);
  factory ChartStrokeStyler.dashArray(List<int> value) =>
      ChartStrokeStyler().dashArray(value);
  factory ChartStrokeStyler.opacity(double value) =>
      ChartStrokeStyler().opacity(value);

  /// Sets the color.
  ChartStrokeStyler color(Color value) {
    return merge(ChartStrokeStyler(color: value));
  }

  /// Sets the gradient.
  ChartStrokeStyler gradient(Gradient value) {
    return merge(ChartStrokeStyler(gradient: value));
  }

  /// Sets the width.
  ChartStrokeStyler width(double value) {
    return merge(ChartStrokeStyler(width: value));
  }

  /// Sets the dashArray.
  ChartStrokeStyler dashArray(List<int> value) {
    return merge(ChartStrokeStyler(dashArray: value));
  }

  /// Sets the opacity.
  ChartStrokeStyler opacity(double value) {
    return merge(ChartStrokeStyler(opacity: value));
  }

  /// Sets the animation configuration.
  @override
  ChartStrokeStyler animate(AnimationConfig value) {
    return merge(ChartStrokeStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartStrokeStyler variants(List<VariantStyle<ChartStrokeSpec>> value) {
    return merge(ChartStrokeStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartStrokeStyler wrap(WidgetModifierConfig value) {
    return merge(ChartStrokeStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartStrokeStyler modifier(WidgetModifierConfig value) {
    return merge(ChartStrokeStyler(modifier: value));
  }

  /// Merges with another [ChartStrokeStyler].
  @override
  ChartStrokeStyler merge(ChartStrokeStyler? other) {
    return ChartStrokeStyler.create(
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      width: MixOps.merge($width, other?.$width),
      dashArray: MixOps.merge($dashArray, other?.$dashArray),
      opacity: MixOps.merge($opacity, other?.$opacity),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartStrokeSpec>] using [context].
  @override
  StyleSpec<ChartStrokeSpec> resolve(BuildContext context) {
    final spec = ChartStrokeSpec(
      color: MixOps.resolve(context, $color),
      gradient: MixOps.resolve(context, $gradient),
      width: MixOps.resolve(context, $width),
      dashArray: MixOps.resolve(context, $dashArray),
      opacity: MixOps.resolve(context, $opacity),
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
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('gradient', $gradient))
      ..add(DiagnosticsProperty('width', $width))
      ..add(DiagnosticsProperty('dashArray', $dashArray))
      ..add(DiagnosticsProperty('opacity', $opacity));
  }

  @override
  List<Object?> get props => [
    $color,
    $gradient,
    $width,
    $dashArray,
    $opacity,
    $animation,
    $modifier,
    $variants,
  ];
}

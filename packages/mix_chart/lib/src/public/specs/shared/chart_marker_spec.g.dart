// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_marker_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartMarkerSpec implements Spec<ChartMarkerSpec>, Diagnosticable {
  bool? get show;
  ChartMarkerShape? get shape;
  Color? get color;
  double? get radius;
  Color? get borderColor;
  double? get borderWidth;
  Shadow? get shadow;

  @override
  Type get type => ChartMarkerSpec;

  @override
  ChartMarkerSpec copyWith({
    bool? show,
    ChartMarkerShape? shape,
    Color? color,
    double? radius,
    Color? borderColor,
    double? borderWidth,
    Shadow? shadow,
  }) {
    return ChartMarkerSpec(
      show: show ?? this.show,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      radius: radius ?? this.radius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ChartMarkerSpec lerp(ChartMarkerSpec? other, double t) {
    return ChartMarkerSpec(
      show: MixOps.lerpSnap(show, other?.show, t),
      shape: MixOps.lerpSnap(shape, other?.shape, t),
      color: MixOps.lerp(color, other?.color, t),
      radius: MixOps.lerp(radius, other?.radius, t),
      borderColor: MixOps.lerp(borderColor, other?.borderColor, t),
      borderWidth: MixOps.lerp(borderWidth, other?.borderWidth, t),
      shadow: MixOps.lerp(shadow, other?.shadow, t),
    );
  }

  @override
  List<Object?> get props => [
    show,
    shape,
    color,
    radius,
    borderColor,
    borderWidth,
    shadow,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartMarkerSpec &&
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
      ..add(DiagnosticsProperty('shape', shape))
      ..add(ColorProperty('color', color))
      ..add(DoubleProperty('radius', radius))
      ..add(ColorProperty('borderColor', borderColor))
      ..add(DoubleProperty('borderWidth', borderWidth))
      ..add(DiagnosticsProperty('shadow', shadow));
  }
}

@Deprecated(
  'Rename to `_\$ChartMarkerSpec` and migrate the class declaration to `class ChartMarkerSpec with _\$ChartMarkerSpec`. The `_\$ChartMarkerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartMarkerSpecMethods = _$ChartMarkerSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartMarkerStyler extends MixStyler<ChartMarkerStyler, ChartMarkerSpec> {
  final Prop<bool>? $show;
  final Prop<ChartMarkerShape>? $shape;
  final Prop<Color>? $color;
  final Prop<double>? $radius;
  final Prop<Color>? $borderColor;
  final Prop<double>? $borderWidth;
  final Prop<Shadow>? $shadow;

  const ChartMarkerStyler.create({
    Prop<bool>? show,
    Prop<ChartMarkerShape>? shape,
    Prop<Color>? color,
    Prop<double>? radius,
    Prop<Color>? borderColor,
    Prop<double>? borderWidth,
    Prop<Shadow>? shadow,
    super.variants,
    super.modifier,
    super.animation,
  }) : $show = show,
       $shape = shape,
       $color = color,
       $radius = radius,
       $borderColor = borderColor,
       $borderWidth = borderWidth,
       $shadow = shadow;

  ChartMarkerStyler({
    bool? show,
    ChartMarkerShape? shape,
    Color? color,
    double? radius,
    Color? borderColor,
    double? borderWidth,
    ShadowMix? shadow,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartMarkerSpec>>? variants,
  }) : this.create(
         show: Prop.maybe(show),
         shape: Prop.maybe(shape),
         color: Prop.maybe(color),
         radius: Prop.maybe(radius),
         borderColor: Prop.maybe(borderColor),
         borderWidth: Prop.maybe(borderWidth),
         shadow: Prop.maybeMix(shadow),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartMarkerStyler.show(bool value) => ChartMarkerStyler().show(value);
  factory ChartMarkerStyler.shape(ChartMarkerShape value) =>
      ChartMarkerStyler().shape(value);
  factory ChartMarkerStyler.color(Color value) =>
      ChartMarkerStyler().color(value);
  factory ChartMarkerStyler.radius(double value) =>
      ChartMarkerStyler().radius(value);
  factory ChartMarkerStyler.borderColor(Color value) =>
      ChartMarkerStyler().borderColor(value);
  factory ChartMarkerStyler.borderWidth(double value) =>
      ChartMarkerStyler().borderWidth(value);
  factory ChartMarkerStyler.shadow(ShadowMix value) =>
      ChartMarkerStyler().shadow(value);

  /// Sets the show.
  ChartMarkerStyler show(bool value) {
    return merge(ChartMarkerStyler(show: value));
  }

  /// Sets the shape.
  ChartMarkerStyler shape(ChartMarkerShape value) {
    return merge(ChartMarkerStyler(shape: value));
  }

  /// Sets the color.
  ChartMarkerStyler color(Color value) {
    return merge(ChartMarkerStyler(color: value));
  }

  /// Sets the radius.
  ChartMarkerStyler radius(double value) {
    return merge(ChartMarkerStyler(radius: value));
  }

  /// Sets the borderColor.
  ChartMarkerStyler borderColor(Color value) {
    return merge(ChartMarkerStyler(borderColor: value));
  }

  /// Sets the borderWidth.
  ChartMarkerStyler borderWidth(double value) {
    return merge(ChartMarkerStyler(borderWidth: value));
  }

  /// Sets the shadow.
  ChartMarkerStyler shadow(ShadowMix value) {
    return merge(ChartMarkerStyler(shadow: value));
  }

  /// Sets the animation configuration.
  @override
  ChartMarkerStyler animate(AnimationConfig value) {
    return merge(ChartMarkerStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartMarkerStyler variants(List<VariantStyle<ChartMarkerSpec>> value) {
    return merge(ChartMarkerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartMarkerStyler wrap(WidgetModifierConfig value) {
    return merge(ChartMarkerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartMarkerStyler modifier(WidgetModifierConfig value) {
    return merge(ChartMarkerStyler(modifier: value));
  }

  /// Merges with another [ChartMarkerStyler].
  @override
  ChartMarkerStyler merge(ChartMarkerStyler? other) {
    return ChartMarkerStyler.create(
      show: MixOps.merge($show, other?.$show),
      shape: MixOps.merge($shape, other?.$shape),
      color: MixOps.merge($color, other?.$color),
      radius: MixOps.merge($radius, other?.$radius),
      borderColor: MixOps.merge($borderColor, other?.$borderColor),
      borderWidth: MixOps.merge($borderWidth, other?.$borderWidth),
      shadow: MixOps.merge($shadow, other?.$shadow),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartMarkerSpec>] using [context].
  @override
  StyleSpec<ChartMarkerSpec> resolve(BuildContext context) {
    final spec = ChartMarkerSpec(
      show: MixOps.resolve(context, $show),
      shape: MixOps.resolve(context, $shape),
      color: MixOps.resolve(context, $color),
      radius: MixOps.resolve(context, $radius),
      borderColor: MixOps.resolve(context, $borderColor),
      borderWidth: MixOps.resolve(context, $borderWidth),
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
      ..add(DiagnosticsProperty('shape', $shape))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('radius', $radius))
      ..add(DiagnosticsProperty('borderColor', $borderColor))
      ..add(DiagnosticsProperty('borderWidth', $borderWidth))
      ..add(DiagnosticsProperty('shadow', $shadow));
  }

  @override
  List<Object?> get props => [
    $show,
    $shape,
    $color,
    $radius,
    $borderColor,
    $borderWidth,
    $shadow,
    $animation,
    $modifier,
    $variants,
  ];
}

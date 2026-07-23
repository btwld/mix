// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_background_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$BarBackgroundSpec implements Spec<BarBackgroundSpec>, Diagnosticable {
  bool? get show;
  double? get fromY;
  double? get toY;
  Color? get color;
  Gradient? get gradient;

  @override
  Type get type => BarBackgroundSpec;

  @override
  BarBackgroundSpec copyWith({
    bool? show,
    double? fromY,
    double? toY,
    Color? color,
    Gradient? gradient,
  }) {
    return BarBackgroundSpec(
      show: show ?? this.show,
      fromY: fromY ?? this.fromY,
      toY: toY ?? this.toY,
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  BarBackgroundSpec lerp(BarBackgroundSpec? other, double t) {
    return BarBackgroundSpec(
      show: MixOps.lerpSnap(show, other?.show, t),
      fromY: MixOps.lerp(fromY, other?.fromY, t),
      toY: MixOps.lerp(toY, other?.toY, t),
      color: MixOps.lerp(color, other?.color, t),
      gradient: MixOps.lerp(gradient, other?.gradient, t),
    );
  }

  @override
  List<Object?> get props => [show, fromY, toY, color, gradient];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BarBackgroundSpec &&
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
      ..add(DoubleProperty('fromY', fromY))
      ..add(DoubleProperty('toY', toY))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty('gradient', gradient));
  }
}

@Deprecated(
  'Rename to `_\$BarBackgroundSpec` and migrate the class declaration to `class BarBackgroundSpec with _\$BarBackgroundSpec`. The `_\$BarBackgroundSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$BarBackgroundSpecMethods = _$BarBackgroundSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class BarBackgroundStyler
    extends MixStyler<BarBackgroundStyler, BarBackgroundSpec> {
  final Prop<bool>? $show;
  final Prop<double>? $fromY;
  final Prop<double>? $toY;
  final Prop<Color>? $color;
  final Prop<Gradient>? $gradient;

  const BarBackgroundStyler.create({
    Prop<bool>? show,
    Prop<double>? fromY,
    Prop<double>? toY,
    Prop<Color>? color,
    Prop<Gradient>? gradient,
    super.variants,
    super.modifier,
    super.animation,
  }) : $show = show,
       $fromY = fromY,
       $toY = toY,
       $color = color,
       $gradient = gradient;

  BarBackgroundStyler({
    bool? show,
    double? fromY,
    double? toY,
    Color? color,
    Gradient? gradient,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BarBackgroundSpec>>? variants,
  }) : this.create(
         show: Prop.maybe(show),
         fromY: Prop.maybe(fromY),
         toY: Prop.maybe(toY),
         color: Prop.maybe(color),
         gradient: Prop.maybe(gradient),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BarBackgroundStyler.show(bool value) =>
      BarBackgroundStyler().show(value);
  factory BarBackgroundStyler.fromY(double value) =>
      BarBackgroundStyler().fromY(value);
  factory BarBackgroundStyler.toY(double value) =>
      BarBackgroundStyler().toY(value);
  factory BarBackgroundStyler.color(Color value) =>
      BarBackgroundStyler().color(value);
  factory BarBackgroundStyler.gradient(Gradient value) =>
      BarBackgroundStyler().gradient(value);

  /// Sets the show.
  BarBackgroundStyler show(bool value) {
    return merge(BarBackgroundStyler(show: value));
  }

  /// Sets the fromY.
  BarBackgroundStyler fromY(double value) {
    return merge(BarBackgroundStyler(fromY: value));
  }

  /// Sets the toY.
  BarBackgroundStyler toY(double value) {
    return merge(BarBackgroundStyler(toY: value));
  }

  /// Sets the color.
  BarBackgroundStyler color(Color value) {
    return merge(BarBackgroundStyler(color: value));
  }

  /// Sets the gradient.
  BarBackgroundStyler gradient(Gradient value) {
    return merge(BarBackgroundStyler(gradient: value));
  }

  /// Sets the animation configuration.
  @override
  BarBackgroundStyler animate(AnimationConfig value) {
    return merge(BarBackgroundStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  BarBackgroundStyler variants(List<VariantStyle<BarBackgroundSpec>> value) {
    return merge(BarBackgroundStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  BarBackgroundStyler wrap(WidgetModifierConfig value) {
    return merge(BarBackgroundStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BarBackgroundStyler modifier(WidgetModifierConfig value) {
    return merge(BarBackgroundStyler(modifier: value));
  }

  /// Merges with another [BarBackgroundStyler].
  @override
  BarBackgroundStyler merge(BarBackgroundStyler? other) {
    return BarBackgroundStyler.create(
      show: MixOps.merge($show, other?.$show),
      fromY: MixOps.merge($fromY, other?.$fromY),
      toY: MixOps.merge($toY, other?.$toY),
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BarBackgroundSpec>] using [context].
  @override
  StyleSpec<BarBackgroundSpec> resolve(BuildContext context) {
    final spec = BarBackgroundSpec(
      show: MixOps.resolve(context, $show),
      fromY: MixOps.resolve(context, $fromY),
      toY: MixOps.resolve(context, $toY),
      color: MixOps.resolve(context, $color),
      gradient: MixOps.resolve(context, $gradient),
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
      ..add(DiagnosticsProperty('fromY', $fromY))
      ..add(DiagnosticsProperty('toY', $toY))
      ..add(DiagnosticsProperty('color', $color))
      ..add(DiagnosticsProperty('gradient', $gradient));
  }

  @override
  List<Object?> get props => [
    $show,
    $fromY,
    $toY,
    $color,
    $gradient,
    $animation,
    $modifier,
    $variants,
  ];
}

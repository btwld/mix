// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_tooltip_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ChartTooltipSpec implements Spec<ChartTooltipSpec>, Diagnosticable {
  Color? get backgroundColor;
  BorderSide? get border;
  BorderRadius? get borderRadius;
  EdgeInsets? get padding;
  double? get margin;
  double? get maxWidth;
  bool? get fitHorizontally;
  bool? get fitVertically;
  StyleSpec<TextSpec>? get text;

  @override
  Type get type => ChartTooltipSpec;

  @override
  ChartTooltipSpec copyWith({
    Color? backgroundColor,
    BorderSide? border,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? margin,
    double? maxWidth,
    bool? fitHorizontally,
    bool? fitVertically,
    StyleSpec<TextSpec>? text,
  }) {
    return ChartTooltipSpec(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      maxWidth: maxWidth ?? this.maxWidth,
      fitHorizontally: fitHorizontally ?? this.fitHorizontally,
      fitVertically: fitVertically ?? this.fitVertically,
      text: text ?? this.text,
    );
  }

  @override
  ChartTooltipSpec lerp(ChartTooltipSpec? other, double t) {
    return ChartTooltipSpec(
      backgroundColor: MixOps.lerp(backgroundColor, other?.backgroundColor, t),
      border: MixOps.lerp(border, other?.border, t),
      borderRadius: MixOps.lerp(borderRadius, other?.borderRadius, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      margin: MixOps.lerp(margin, other?.margin, t),
      maxWidth: MixOps.lerp(maxWidth, other?.maxWidth, t),
      fitHorizontally: MixOps.lerpSnap(
        fitHorizontally,
        other?.fitHorizontally,
        t,
      ),
      fitVertically: MixOps.lerpSnap(fitVertically, other?.fitVertically, t),
      text: text?.lerp(other?.text, t),
    );
  }

  @override
  List<Object?> get props => [
    backgroundColor,
    border,
    borderRadius,
    padding,
    margin,
    maxWidth,
    fitHorizontally,
    fitVertically,
    text,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChartTooltipSpec &&
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
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty('border', border))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DoubleProperty('margin', margin))
      ..add(DoubleProperty('maxWidth', maxWidth))
      ..add(DiagnosticsProperty('fitHorizontally', fitHorizontally))
      ..add(DiagnosticsProperty('fitVertically', fitVertically))
      ..add(DiagnosticsProperty('text', text));
  }
}

@Deprecated(
  'Rename to `_\$ChartTooltipSpec` and migrate the class declaration to `class ChartTooltipSpec with _\$ChartTooltipSpec`. The `_\$ChartTooltipSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ChartTooltipSpecMethods = _$ChartTooltipSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ChartTooltipStyler
    extends MixStyler<ChartTooltipStyler, ChartTooltipSpec> {
  final Prop<Color>? $backgroundColor;
  final Prop<BorderSide>? $border;
  final Prop<BorderRadius>? $borderRadius;
  final Prop<EdgeInsets>? $padding;
  final Prop<double>? $margin;
  final Prop<double>? $maxWidth;
  final Prop<bool>? $fitHorizontally;
  final Prop<bool>? $fitVertically;
  final Prop<StyleSpec<TextSpec>>? $text;

  const ChartTooltipStyler.create({
    Prop<Color>? backgroundColor,
    Prop<BorderSide>? border,
    Prop<BorderRadius>? borderRadius,
    Prop<EdgeInsets>? padding,
    Prop<double>? margin,
    Prop<double>? maxWidth,
    Prop<bool>? fitHorizontally,
    Prop<bool>? fitVertically,
    Prop<StyleSpec<TextSpec>>? text,
    super.variants,
    super.modifier,
    super.animation,
  }) : $backgroundColor = backgroundColor,
       $border = border,
       $borderRadius = borderRadius,
       $padding = padding,
       $margin = margin,
       $maxWidth = maxWidth,
       $fitHorizontally = fitHorizontally,
       $fitVertically = fitVertically,
       $text = text;

  ChartTooltipStyler({
    Color? backgroundColor,
    BorderSide? border,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    double? margin,
    double? maxWidth,
    bool? fitHorizontally,
    bool? fitVertically,
    TextStyler? text,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ChartTooltipSpec>>? variants,
  }) : this.create(
         backgroundColor: Prop.maybe(backgroundColor),
         border: Prop.maybe(border),
         borderRadius: Prop.maybe(borderRadius),
         padding: Prop.maybe(padding),
         margin: Prop.maybe(margin),
         maxWidth: Prop.maybe(maxWidth),
         fitHorizontally: Prop.maybe(fitHorizontally),
         fitVertically: Prop.maybe(fitVertically),
         text: Prop.maybeMix(text),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ChartTooltipStyler.backgroundColor(Color value) =>
      ChartTooltipStyler().backgroundColor(value);
  factory ChartTooltipStyler.border(BorderSide value) =>
      ChartTooltipStyler().border(value);
  factory ChartTooltipStyler.borderRadius(BorderRadius value) =>
      ChartTooltipStyler().borderRadius(value);
  factory ChartTooltipStyler.padding(EdgeInsets value) =>
      ChartTooltipStyler().padding(value);
  factory ChartTooltipStyler.margin(double value) =>
      ChartTooltipStyler().margin(value);
  factory ChartTooltipStyler.maxWidth(double value) =>
      ChartTooltipStyler().maxWidth(value);
  factory ChartTooltipStyler.fitHorizontally(bool value) =>
      ChartTooltipStyler().fitHorizontally(value);
  factory ChartTooltipStyler.fitVertically(bool value) =>
      ChartTooltipStyler().fitVertically(value);
  factory ChartTooltipStyler.text(TextStyler value) =>
      ChartTooltipStyler().text(value);

  /// Sets the backgroundColor.
  ChartTooltipStyler backgroundColor(Color value) {
    return merge(ChartTooltipStyler(backgroundColor: value));
  }

  /// Sets the border.
  ChartTooltipStyler border(BorderSide value) {
    return merge(ChartTooltipStyler(border: value));
  }

  /// Sets the borderRadius.
  ChartTooltipStyler borderRadius(BorderRadius value) {
    return merge(ChartTooltipStyler(borderRadius: value));
  }

  /// Sets the padding.
  ChartTooltipStyler padding(EdgeInsets value) {
    return merge(ChartTooltipStyler(padding: value));
  }

  /// Sets the margin.
  ChartTooltipStyler margin(double value) {
    return merge(ChartTooltipStyler(margin: value));
  }

  /// Sets the maxWidth.
  ChartTooltipStyler maxWidth(double value) {
    return merge(ChartTooltipStyler(maxWidth: value));
  }

  /// Sets the fitHorizontally.
  ChartTooltipStyler fitHorizontally(bool value) {
    return merge(ChartTooltipStyler(fitHorizontally: value));
  }

  /// Sets the fitVertically.
  ChartTooltipStyler fitVertically(bool value) {
    return merge(ChartTooltipStyler(fitVertically: value));
  }

  /// Sets the text.
  ChartTooltipStyler text(TextStyler value) {
    return merge(ChartTooltipStyler(text: value));
  }

  /// Sets the animation configuration.
  @override
  ChartTooltipStyler animate(AnimationConfig value) {
    return merge(ChartTooltipStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ChartTooltipStyler variants(List<VariantStyle<ChartTooltipSpec>> value) {
    return merge(ChartTooltipStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ChartTooltipStyler wrap(WidgetModifierConfig value) {
    return merge(ChartTooltipStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ChartTooltipStyler modifier(WidgetModifierConfig value) {
    return merge(ChartTooltipStyler(modifier: value));
  }

  /// Merges with another [ChartTooltipStyler].
  @override
  ChartTooltipStyler merge(ChartTooltipStyler? other) {
    return ChartTooltipStyler.create(
      backgroundColor: MixOps.merge($backgroundColor, other?.$backgroundColor),
      border: MixOps.merge($border, other?.$border),
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      padding: MixOps.merge($padding, other?.$padding),
      margin: MixOps.merge($margin, other?.$margin),
      maxWidth: MixOps.merge($maxWidth, other?.$maxWidth),
      fitHorizontally: MixOps.merge($fitHorizontally, other?.$fitHorizontally),
      fitVertically: MixOps.merge($fitVertically, other?.$fitVertically),
      text: MixOps.merge($text, other?.$text),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ChartTooltipSpec>] using [context].
  @override
  StyleSpec<ChartTooltipSpec> resolve(BuildContext context) {
    final spec = ChartTooltipSpec(
      backgroundColor: MixOps.resolve(context, $backgroundColor),
      border: MixOps.resolve(context, $border),
      borderRadius: MixOps.resolve(context, $borderRadius),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      maxWidth: MixOps.resolve(context, $maxWidth),
      fitHorizontally: MixOps.resolve(context, $fitHorizontally),
      fitVertically: MixOps.resolve(context, $fitVertically),
      text: MixOps.resolve(context, $text),
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
      ..add(DiagnosticsProperty('backgroundColor', $backgroundColor))
      ..add(DiagnosticsProperty('border', $border))
      ..add(DiagnosticsProperty('borderRadius', $borderRadius))
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('maxWidth', $maxWidth))
      ..add(DiagnosticsProperty('fitHorizontally', $fitHorizontally))
      ..add(DiagnosticsProperty('fitVertically', $fitVertically))
      ..add(DiagnosticsProperty('text', $text));
  }

  @override
  List<Object?> get props => [
    $backgroundColor,
    $border,
    $borderRadius,
    $padding,
    $margin,
    $maxWidth,
    $fitHorizontally,
    $fitVertically,
    $text,
    $animation,
    $modifier,
    $variants,
  ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$BarSpec implements Spec<BarSpec>, Diagnosticable {
  Color? get color;
  Gradient? get gradient;
  double? get width;
  BorderRadius? get borderRadius;
  BorderSide? get border;
  List<int>? get borderDashArray;
  StyleSpec<BarBackgroundSpec>? get background;
  StyleSpec<TextSpec>? get label;
  Offset? get labelOffset;
  double? get labelAngle;

  @override
  Type get type => BarSpec;

  @override
  BarSpec copyWith({
    Color? color,
    Gradient? gradient,
    double? width,
    BorderRadius? borderRadius,
    BorderSide? border,
    List<int>? borderDashArray,
    StyleSpec<BarBackgroundSpec>? background,
    StyleSpec<TextSpec>? label,
    Offset? labelOffset,
    double? labelAngle,
  }) {
    return BarSpec(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      borderDashArray: borderDashArray ?? this.borderDashArray,
      background: background ?? this.background,
      label: label ?? this.label,
      labelOffset: labelOffset ?? this.labelOffset,
      labelAngle: labelAngle ?? this.labelAngle,
    );
  }

  @override
  BarSpec lerp(BarSpec? other, double t) {
    return BarSpec(
      color: MixOps.lerp(color, other?.color, t),
      gradient: MixOps.lerp(gradient, other?.gradient, t),
      width: MixOps.lerp(width, other?.width, t),
      borderRadius: MixOps.lerp(borderRadius, other?.borderRadius, t),
      border: MixOps.lerp(border, other?.border, t),
      borderDashArray: MixOps.lerpSnap(
        borderDashArray,
        other?.borderDashArray,
        t,
      ),
      background: background?.lerp(other?.background, t),
      label: label?.lerp(other?.label, t),
      labelOffset: MixOps.lerp(labelOffset, other?.labelOffset, t),
      labelAngle: MixOps.lerp(labelAngle, other?.labelAngle, t),
    );
  }

  @override
  List<Object?> get props => [
    color,
    gradient,
    width,
    borderRadius,
    border,
    borderDashArray,
    background,
    label,
    labelOffset,
    labelAngle,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BarSpec &&
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
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('border', border))
      ..add(IterableProperty<int>('borderDashArray', borderDashArray))
      ..add(DiagnosticsProperty('background', background))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('labelOffset', labelOffset))
      ..add(DoubleProperty('labelAngle', labelAngle));
  }
}

@Deprecated(
  'Rename to `_\$BarSpec` and migrate the class declaration to `class BarSpec with _\$BarSpec`. The `_\$BarSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$BarSpecMethods = _$BarSpec; // ignore: unused_element

mixin _$BarSegmentSpec implements Spec<BarSegmentSpec>, Diagnosticable {
  Color? get color;
  Gradient? get gradient;
  BorderSide? get border;
  StyleSpec<TextSpec>? get label;

  @override
  Type get type => BarSegmentSpec;

  @override
  BarSegmentSpec copyWith({
    Color? color,
    Gradient? gradient,
    BorderSide? border,
    StyleSpec<TextSpec>? label,
  }) {
    return BarSegmentSpec(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      border: border ?? this.border,
      label: label ?? this.label,
    );
  }

  @override
  BarSegmentSpec lerp(BarSegmentSpec? other, double t) {
    return BarSegmentSpec(
      color: MixOps.lerp(color, other?.color, t),
      gradient: MixOps.lerp(gradient, other?.gradient, t),
      border: MixOps.lerp(border, other?.border, t),
      label: label?.lerp(other?.label, t),
    );
  }

  @override
  List<Object?> get props => [color, gradient, border, label];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BarSegmentSpec &&
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
      ..add(DiagnosticsProperty('border', border))
      ..add(DiagnosticsProperty('label', label));
  }
}

@Deprecated(
  'Rename to `_\$BarSegmentSpec` and migrate the class declaration to `class BarSegmentSpec with _\$BarSegmentSpec`. The `_\$BarSegmentSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$BarSegmentSpecMethods = _$BarSegmentSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class BarStyler extends MixStyler<BarStyler, BarSpec> {
  final Prop<Color>? $color;
  final Prop<Gradient>? $gradient;
  final Prop<double>? $width;
  final Prop<BorderRadius>? $borderRadius;
  final Prop<BorderSide>? $border;
  final Prop<List<int>>? $borderDashArray;
  final Prop<StyleSpec<BarBackgroundSpec>>? $background;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<Offset>? $labelOffset;
  final Prop<double>? $labelAngle;

  const BarStyler.create({
    Prop<Color>? color,
    Prop<Gradient>? gradient,
    Prop<double>? width,
    Prop<BorderRadius>? borderRadius,
    Prop<BorderSide>? border,
    Prop<List<int>>? borderDashArray,
    Prop<StyleSpec<BarBackgroundSpec>>? background,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<Offset>? labelOffset,
    Prop<double>? labelAngle,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color,
       $gradient = gradient,
       $width = width,
       $borderRadius = borderRadius,
       $border = border,
       $borderDashArray = borderDashArray,
       $background = background,
       $label = label,
       $labelOffset = labelOffset,
       $labelAngle = labelAngle;

  BarStyler({
    Color? color,
    Gradient? gradient,
    double? width,
    BorderRadius? borderRadius,
    BorderSide? border,
    List<int>? borderDashArray,
    BarBackgroundStyler? background,
    TextStyler? label,
    Offset? labelOffset,
    double? labelAngle,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BarSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         gradient: Prop.maybe(gradient),
         width: Prop.maybe(width),
         borderRadius: Prop.maybe(borderRadius),
         border: Prop.maybe(border),
         borderDashArray: Prop.maybe(borderDashArray),
         background: Prop.maybeMix(background),
         label: Prop.maybeMix(label),
         labelOffset: Prop.maybe(labelOffset),
         labelAngle: Prop.maybe(labelAngle),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BarStyler.color(Color value) => BarStyler().color(value);
  factory BarStyler.gradient(Gradient value) => BarStyler().gradient(value);
  factory BarStyler.width(double value) => BarStyler().width(value);
  factory BarStyler.borderRadius(BorderRadius value) =>
      BarStyler().borderRadius(value);
  factory BarStyler.border(BorderSide value) => BarStyler().border(value);
  factory BarStyler.borderDashArray(List<int> value) =>
      BarStyler().borderDashArray(value);
  factory BarStyler.background(BarBackgroundStyler value) =>
      BarStyler().background(value);
  factory BarStyler.label(TextStyler value) => BarStyler().label(value);
  factory BarStyler.labelOffset(Offset value) => BarStyler().labelOffset(value);
  factory BarStyler.labelAngle(double value) => BarStyler().labelAngle(value);

  /// Sets the color.
  BarStyler color(Color value) {
    return merge(BarStyler(color: value));
  }

  /// Sets the gradient.
  BarStyler gradient(Gradient value) {
    return merge(BarStyler(gradient: value));
  }

  /// Sets the width.
  BarStyler width(double value) {
    return merge(BarStyler(width: value));
  }

  /// Sets the borderRadius.
  BarStyler borderRadius(BorderRadius value) {
    return merge(BarStyler(borderRadius: value));
  }

  /// Sets the border.
  BarStyler border(BorderSide value) {
    return merge(BarStyler(border: value));
  }

  /// Sets the borderDashArray.
  BarStyler borderDashArray(List<int> value) {
    return merge(BarStyler(borderDashArray: value));
  }

  /// Sets the background.
  BarStyler background(BarBackgroundStyler value) {
    return merge(BarStyler(background: value));
  }

  /// Sets the label.
  BarStyler label(TextStyler value) {
    return merge(BarStyler(label: value));
  }

  /// Sets the labelOffset.
  BarStyler labelOffset(Offset value) {
    return merge(BarStyler(labelOffset: value));
  }

  /// Sets the labelAngle.
  BarStyler labelAngle(double value) {
    return merge(BarStyler(labelAngle: value));
  }

  /// Sets the animation configuration.
  @override
  BarStyler animate(AnimationConfig value) {
    return merge(BarStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  BarStyler variants(List<VariantStyle<BarSpec>> value) {
    return merge(BarStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  BarStyler wrap(WidgetModifierConfig value) {
    return merge(BarStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BarStyler modifier(WidgetModifierConfig value) {
    return merge(BarStyler(modifier: value));
  }

  /// Merges with another [BarStyler].
  @override
  BarStyler merge(BarStyler? other) {
    return BarStyler.create(
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      width: MixOps.merge($width, other?.$width),
      borderRadius: MixOps.merge($borderRadius, other?.$borderRadius),
      border: MixOps.merge($border, other?.$border),
      borderDashArray: MixOps.merge($borderDashArray, other?.$borderDashArray),
      background: MixOps.merge($background, other?.$background),
      label: MixOps.merge($label, other?.$label),
      labelOffset: MixOps.merge($labelOffset, other?.$labelOffset),
      labelAngle: MixOps.merge($labelAngle, other?.$labelAngle),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BarSpec>] using [context].
  @override
  StyleSpec<BarSpec> resolve(BuildContext context) {
    final spec = BarSpec(
      color: MixOps.resolve(context, $color),
      gradient: MixOps.resolve(context, $gradient),
      width: MixOps.resolve(context, $width),
      borderRadius: MixOps.resolve(context, $borderRadius),
      border: MixOps.resolve(context, $border),
      borderDashArray: MixOps.resolve(context, $borderDashArray),
      background: MixOps.resolve(context, $background),
      label: MixOps.resolve(context, $label),
      labelOffset: MixOps.resolve(context, $labelOffset),
      labelAngle: MixOps.resolve(context, $labelAngle),
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
      ..add(DiagnosticsProperty('borderRadius', $borderRadius))
      ..add(DiagnosticsProperty('border', $border))
      ..add(DiagnosticsProperty('borderDashArray', $borderDashArray))
      ..add(DiagnosticsProperty('background', $background))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('labelOffset', $labelOffset))
      ..add(DiagnosticsProperty('labelAngle', $labelAngle));
  }

  @override
  List<Object?> get props => [
    $color,
    $gradient,
    $width,
    $borderRadius,
    $border,
    $borderDashArray,
    $background,
    $label,
    $labelOffset,
    $labelAngle,
    $animation,
    $modifier,
    $variants,
  ];
}

class BarSegmentStyler extends MixStyler<BarSegmentStyler, BarSegmentSpec> {
  final Prop<Color>? $color;
  final Prop<Gradient>? $gradient;
  final Prop<BorderSide>? $border;
  final Prop<StyleSpec<TextSpec>>? $label;

  const BarSegmentStyler.create({
    Prop<Color>? color,
    Prop<Gradient>? gradient,
    Prop<BorderSide>? border,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color,
       $gradient = gradient,
       $border = border,
       $label = label;

  BarSegmentStyler({
    Color? color,
    Gradient? gradient,
    BorderSide? border,
    TextStyler? label,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BarSegmentSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         gradient: Prop.maybe(gradient),
         border: Prop.maybe(border),
         label: Prop.maybeMix(label),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BarSegmentStyler.color(Color value) =>
      BarSegmentStyler().color(value);
  factory BarSegmentStyler.gradient(Gradient value) =>
      BarSegmentStyler().gradient(value);
  factory BarSegmentStyler.border(BorderSide value) =>
      BarSegmentStyler().border(value);
  factory BarSegmentStyler.label(TextStyler value) =>
      BarSegmentStyler().label(value);

  /// Sets the color.
  BarSegmentStyler color(Color value) {
    return merge(BarSegmentStyler(color: value));
  }

  /// Sets the gradient.
  BarSegmentStyler gradient(Gradient value) {
    return merge(BarSegmentStyler(gradient: value));
  }

  /// Sets the border.
  BarSegmentStyler border(BorderSide value) {
    return merge(BarSegmentStyler(border: value));
  }

  /// Sets the label.
  BarSegmentStyler label(TextStyler value) {
    return merge(BarSegmentStyler(label: value));
  }

  /// Sets the animation configuration.
  @override
  BarSegmentStyler animate(AnimationConfig value) {
    return merge(BarSegmentStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  BarSegmentStyler variants(List<VariantStyle<BarSegmentSpec>> value) {
    return merge(BarSegmentStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  BarSegmentStyler wrap(WidgetModifierConfig value) {
    return merge(BarSegmentStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BarSegmentStyler modifier(WidgetModifierConfig value) {
    return merge(BarSegmentStyler(modifier: value));
  }

  /// Merges with another [BarSegmentStyler].
  @override
  BarSegmentStyler merge(BarSegmentStyler? other) {
    return BarSegmentStyler.create(
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      border: MixOps.merge($border, other?.$border),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BarSegmentSpec>] using [context].
  @override
  StyleSpec<BarSegmentSpec> resolve(BuildContext context) {
    final spec = BarSegmentSpec(
      color: MixOps.resolve(context, $color),
      gradient: MixOps.resolve(context, $gradient),
      border: MixOps.resolve(context, $border),
      label: MixOps.resolve(context, $label),
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
      ..add(DiagnosticsProperty('border', $border))
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $color,
    $gradient,
    $border,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}

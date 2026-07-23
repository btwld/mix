// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pie_slice_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$PieSliceSpec implements Spec<PieSliceSpec>, Diagnosticable {
  Color? get color;
  Gradient? get gradient;
  double? get radius;
  bool? get showLabel;
  StyleSpec<TextSpec>? get label;
  double? get labelPosition;
  BorderSide? get border;
  double? get cornerRadius;
  double? get badgePosition;

  @override
  Type get type => PieSliceSpec;

  @override
  PieSliceSpec copyWith({
    Color? color,
    Gradient? gradient,
    double? radius,
    bool? showLabel,
    StyleSpec<TextSpec>? label,
    double? labelPosition,
    BorderSide? border,
    double? cornerRadius,
    double? badgePosition,
  }) {
    return PieSliceSpec(
      color: color ?? this.color,
      gradient: gradient ?? this.gradient,
      radius: radius ?? this.radius,
      showLabel: showLabel ?? this.showLabel,
      label: label ?? this.label,
      labelPosition: labelPosition ?? this.labelPosition,
      border: border ?? this.border,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      badgePosition: badgePosition ?? this.badgePosition,
    );
  }

  @override
  PieSliceSpec lerp(PieSliceSpec? other, double t) {
    return PieSliceSpec(
      color: MixOps.lerp(color, other?.color, t),
      gradient: MixOps.lerp(gradient, other?.gradient, t),
      radius: MixOps.lerp(radius, other?.radius, t),
      showLabel: MixOps.lerpSnap(showLabel, other?.showLabel, t),
      label: label?.lerp(other?.label, t),
      labelPosition: MixOps.lerp(labelPosition, other?.labelPosition, t),
      border: MixOps.lerp(border, other?.border, t),
      cornerRadius: MixOps.lerp(cornerRadius, other?.cornerRadius, t),
      badgePosition: MixOps.lerp(badgePosition, other?.badgePosition, t),
    );
  }

  @override
  List<Object?> get props => [
    color,
    gradient,
    radius,
    showLabel,
    label,
    labelPosition,
    border,
    cornerRadius,
    badgePosition,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PieSliceSpec &&
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
      ..add(DoubleProperty('radius', radius))
      ..add(DiagnosticsProperty('showLabel', showLabel))
      ..add(DiagnosticsProperty('label', label))
      ..add(DoubleProperty('labelPosition', labelPosition))
      ..add(DiagnosticsProperty('border', border))
      ..add(DoubleProperty('cornerRadius', cornerRadius))
      ..add(DoubleProperty('badgePosition', badgePosition));
  }
}

@Deprecated(
  'Rename to `_\$PieSliceSpec` and migrate the class declaration to `class PieSliceSpec with _\$PieSliceSpec`. The `_\$PieSliceSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$PieSliceSpecMethods = _$PieSliceSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class PieSliceStyler extends MixStyler<PieSliceStyler, PieSliceSpec> {
  final Prop<Color>? $color;
  final Prop<Gradient>? $gradient;
  final Prop<double>? $radius;
  final Prop<bool>? $showLabel;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<double>? $labelPosition;
  final Prop<BorderSide>? $border;
  final Prop<double>? $cornerRadius;
  final Prop<double>? $badgePosition;

  const PieSliceStyler.create({
    Prop<Color>? color,
    Prop<Gradient>? gradient,
    Prop<double>? radius,
    Prop<bool>? showLabel,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<double>? labelPosition,
    Prop<BorderSide>? border,
    Prop<double>? cornerRadius,
    Prop<double>? badgePosition,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color,
       $gradient = gradient,
       $radius = radius,
       $showLabel = showLabel,
       $label = label,
       $labelPosition = labelPosition,
       $border = border,
       $cornerRadius = cornerRadius,
       $badgePosition = badgePosition;

  PieSliceStyler({
    Color? color,
    Gradient? gradient,
    double? radius,
    bool? showLabel,
    TextStyler? label,
    double? labelPosition,
    BorderSide? border,
    double? cornerRadius,
    double? badgePosition,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<PieSliceSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         gradient: Prop.maybe(gradient),
         radius: Prop.maybe(radius),
         showLabel: Prop.maybe(showLabel),
         label: Prop.maybeMix(label),
         labelPosition: Prop.maybe(labelPosition),
         border: Prop.maybe(border),
         cornerRadius: Prop.maybe(cornerRadius),
         badgePosition: Prop.maybe(badgePosition),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory PieSliceStyler.color(Color value) => PieSliceStyler().color(value);
  factory PieSliceStyler.gradient(Gradient value) =>
      PieSliceStyler().gradient(value);
  factory PieSliceStyler.radius(double value) => PieSliceStyler().radius(value);
  factory PieSliceStyler.showLabel(bool value) =>
      PieSliceStyler().showLabel(value);
  factory PieSliceStyler.label(TextStyler value) =>
      PieSliceStyler().label(value);
  factory PieSliceStyler.labelPosition(double value) =>
      PieSliceStyler().labelPosition(value);
  factory PieSliceStyler.border(BorderSide value) =>
      PieSliceStyler().border(value);
  factory PieSliceStyler.cornerRadius(double value) =>
      PieSliceStyler().cornerRadius(value);
  factory PieSliceStyler.badgePosition(double value) =>
      PieSliceStyler().badgePosition(value);

  /// Sets the color.
  PieSliceStyler color(Color value) {
    return merge(PieSliceStyler(color: value));
  }

  /// Sets the gradient.
  PieSliceStyler gradient(Gradient value) {
    return merge(PieSliceStyler(gradient: value));
  }

  /// Sets the radius.
  PieSliceStyler radius(double value) {
    return merge(PieSliceStyler(radius: value));
  }

  /// Sets the showLabel.
  PieSliceStyler showLabel(bool value) {
    return merge(PieSliceStyler(showLabel: value));
  }

  /// Sets the label.
  PieSliceStyler label(TextStyler value) {
    return merge(PieSliceStyler(label: value));
  }

  /// Sets the labelPosition.
  PieSliceStyler labelPosition(double value) {
    return merge(PieSliceStyler(labelPosition: value));
  }

  /// Sets the border.
  PieSliceStyler border(BorderSide value) {
    return merge(PieSliceStyler(border: value));
  }

  /// Sets the cornerRadius.
  PieSliceStyler cornerRadius(double value) {
    return merge(PieSliceStyler(cornerRadius: value));
  }

  /// Sets the badgePosition.
  PieSliceStyler badgePosition(double value) {
    return merge(PieSliceStyler(badgePosition: value));
  }

  /// Sets the animation configuration.
  @override
  PieSliceStyler animate(AnimationConfig value) {
    return merge(PieSliceStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  PieSliceStyler variants(List<VariantStyle<PieSliceSpec>> value) {
    return merge(PieSliceStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  PieSliceStyler wrap(WidgetModifierConfig value) {
    return merge(PieSliceStyler(modifier: value));
  }

  /// Sets the widget modifier.
  PieSliceStyler modifier(WidgetModifierConfig value) {
    return merge(PieSliceStyler(modifier: value));
  }

  /// Merges with another [PieSliceStyler].
  @override
  PieSliceStyler merge(PieSliceStyler? other) {
    return PieSliceStyler.create(
      color: MixOps.merge($color, other?.$color),
      gradient: MixOps.merge($gradient, other?.$gradient),
      radius: MixOps.merge($radius, other?.$radius),
      showLabel: MixOps.merge($showLabel, other?.$showLabel),
      label: MixOps.merge($label, other?.$label),
      labelPosition: MixOps.merge($labelPosition, other?.$labelPosition),
      border: MixOps.merge($border, other?.$border),
      cornerRadius: MixOps.merge($cornerRadius, other?.$cornerRadius),
      badgePosition: MixOps.merge($badgePosition, other?.$badgePosition),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<PieSliceSpec>] using [context].
  @override
  StyleSpec<PieSliceSpec> resolve(BuildContext context) {
    final spec = PieSliceSpec(
      color: MixOps.resolve(context, $color),
      gradient: MixOps.resolve(context, $gradient),
      radius: MixOps.resolve(context, $radius),
      showLabel: MixOps.resolve(context, $showLabel),
      label: MixOps.resolve(context, $label),
      labelPosition: MixOps.resolve(context, $labelPosition),
      border: MixOps.resolve(context, $border),
      cornerRadius: MixOps.resolve(context, $cornerRadius),
      badgePosition: MixOps.resolve(context, $badgePosition),
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
      ..add(DiagnosticsProperty('radius', $radius))
      ..add(DiagnosticsProperty('showLabel', $showLabel))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('labelPosition', $labelPosition))
      ..add(DiagnosticsProperty('border', $border))
      ..add(DiagnosticsProperty('cornerRadius', $cornerRadius))
      ..add(DiagnosticsProperty('badgePosition', $badgePosition));
  }

  @override
  List<Object?> get props => [
    $color,
    $gradient,
    $radius,
    $showLabel,
    $label,
    $labelPosition,
    $border,
    $cornerRadius,
    $badgePosition,
    $animation,
    $modifier,
    $variants,
  ];
}

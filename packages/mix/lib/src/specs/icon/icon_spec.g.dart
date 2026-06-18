// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$IconSpec implements Spec<IconSpec>, Diagnosticable {
  Color? get color;
  double? get size;
  double? get weight;
  double? get grade;
  double? get opticalSize;
  List<Shadow>? get shadows;
  TextDirection? get textDirection;
  bool? get applyTextScaling;
  double? get fill;
  String? get semanticsLabel;
  double? get opacity;
  BlendMode? get blendMode;
  IconData? get icon;

  @override
  Type get type => IconSpec;

  @override
  IconSpec copyWith({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<Shadow>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    String? semanticsLabel,
    double? opacity,
    BlendMode? blendMode,
    IconData? icon,
  }) {
    return IconSpec(
      color: color ?? this.color,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      shadows: shadows ?? this.shadows,
      textDirection: textDirection ?? this.textDirection,
      applyTextScaling: applyTextScaling ?? this.applyTextScaling,
      fill: fill ?? this.fill,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      icon: icon ?? this.icon,
    );
  }

  @override
  IconSpec lerp(IconSpec? other, double t) {
    return IconSpec(
      color: MixOps.lerp(color, other?.color, t),
      size: MixOps.lerp(size, other?.size, t),
      weight: MixOps.lerp(weight, other?.weight, t),
      grade: MixOps.lerp(grade, other?.grade, t),
      opticalSize: MixOps.lerp(opticalSize, other?.opticalSize, t),
      shadows: MixOps.lerp(shadows, other?.shadows, t),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      applyTextScaling: MixOps.lerpSnap(
        applyTextScaling,
        other?.applyTextScaling,
        t,
      ),
      fill: MixOps.lerp(fill, other?.fill, t),
      semanticsLabel: MixOps.lerpSnap(semanticsLabel, other?.semanticsLabel, t),
      opacity: MixOps.lerp(opacity, other?.opacity, t),
      blendMode: MixOps.lerpSnap(blendMode, other?.blendMode, t),
      icon: MixOps.lerpSnap(icon, other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [
    color,
    size,
    weight,
    grade,
    opticalSize,
    shadows,
    textDirection,
    applyTextScaling,
    fill,
    semanticsLabel,
    opacity,
    blendMode,
    icon,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is IconSpec &&
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
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('weight', weight))
      ..add(DoubleProperty('grade', grade))
      ..add(DoubleProperty('opticalSize', opticalSize))
      ..add(IterableProperty<Shadow>('shadows', shadows))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(
        FlagProperty(
          'applyTextScaling',
          value: applyTextScaling,
          ifTrue: 'scales with text',
        ),
      )
      ..add(DoubleProperty('fill', fill))
      ..add(StringProperty('semanticsLabel', semanticsLabel))
      ..add(DoubleProperty('opacity', opacity))
      ..add(EnumProperty<BlendMode>('blendMode', blendMode))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$IconSpec` and migrate the class declaration to `class IconSpec with _\$IconSpec`. The `_\$IconSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$IconSpecMethods = _$IconSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class IconStyler extends MixStyler<IconStyler, IconSpec> {
  final Prop<Color>? $color;
  final Prop<double>? $size;
  final Prop<double>? $weight;
  final Prop<double>? $grade;
  final Prop<double>? $opticalSize;
  final Prop<List<Shadow>>? $shadows;
  final Prop<TextDirection>? $textDirection;
  final Prop<bool>? $applyTextScaling;
  final Prop<double>? $fill;
  final Prop<String>? $semanticsLabel;
  final Prop<double>? $opacity;
  final Prop<BlendMode>? $blendMode;
  final Prop<IconData>? $icon;

  const IconStyler.create({
    Prop<Color>? color,
    Prop<double>? size,
    Prop<double>? weight,
    Prop<double>? grade,
    Prop<double>? opticalSize,
    Prop<List<Shadow>>? shadows,
    Prop<TextDirection>? textDirection,
    Prop<bool>? applyTextScaling,
    Prop<double>? fill,
    Prop<String>? semanticsLabel,
    Prop<double>? opacity,
    Prop<BlendMode>? blendMode,
    Prop<IconData>? icon,
    super.variants,
    super.modifier,
    super.animation,
  }) : $color = color,
       $size = size,
       $weight = weight,
       $grade = grade,
       $opticalSize = opticalSize,
       $shadows = shadows,
       $textDirection = textDirection,
       $applyTextScaling = applyTextScaling,
       $fill = fill,
       $semanticsLabel = semanticsLabel,
       $opacity = opacity,
       $blendMode = blendMode,
       $icon = icon;

  IconStyler({
    Color? color,
    double? size,
    double? weight,
    double? grade,
    double? opticalSize,
    List<ShadowMix>? shadows,
    TextDirection? textDirection,
    bool? applyTextScaling,
    double? fill,
    String? semanticsLabel,
    double? opacity,
    BlendMode? blendMode,
    IconData? icon,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<IconSpec>>? variants,
  }) : this.create(
         color: Prop.maybe(color),
         size: Prop.maybe(size),
         weight: Prop.maybe(weight),
         grade: Prop.maybe(grade),
         opticalSize: Prop.maybe(opticalSize),
         shadows: shadows != null ? Prop.mix(ShadowListMix(shadows)) : null,
         textDirection: Prop.maybe(textDirection),
         applyTextScaling: Prop.maybe(applyTextScaling),
         fill: Prop.maybe(fill),
         semanticsLabel: Prop.maybe(semanticsLabel),
         opacity: Prop.maybe(opacity),
         blendMode: Prop.maybe(blendMode),
         icon: Prop.maybe(icon),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory IconStyler.color(Color value) => IconStyler().color(value);
  factory IconStyler.size(double value) => IconStyler().size(value);
  factory IconStyler.weight(double value) => IconStyler().weight(value);
  factory IconStyler.grade(double value) => IconStyler().grade(value);
  factory IconStyler.opticalSize(double value) =>
      IconStyler().opticalSize(value);
  factory IconStyler.shadows(List<ShadowMix> value) =>
      IconStyler().shadows(value);
  factory IconStyler.textDirection(TextDirection value) =>
      IconStyler().textDirection(value);
  factory IconStyler.applyTextScaling(bool value) =>
      IconStyler().applyTextScaling(value);
  factory IconStyler.fill(double value) => IconStyler().fill(value);
  factory IconStyler.opacity(double value) => IconStyler().opacity(value);
  factory IconStyler.blendMode(BlendMode value) =>
      IconStyler().blendMode(value);
  factory IconStyler.icon(IconData value) => IconStyler().icon(value);
  factory IconStyler.shadow(ShadowMix value) => IconStyler().shadow(value);

  IconStyler shadow(ShadowMix value) {
    return merge(IconStyler(shadows: [value]));
  }

  /// Sets the color.
  IconStyler color(Color value) {
    return merge(IconStyler(color: value));
  }

  /// Sets the size.
  IconStyler size(double value) {
    return merge(IconStyler(size: value));
  }

  /// Sets the weight.
  IconStyler weight(double value) {
    return merge(IconStyler(weight: value));
  }

  /// Sets the grade.
  IconStyler grade(double value) {
    return merge(IconStyler(grade: value));
  }

  /// Sets the opticalSize.
  IconStyler opticalSize(double value) {
    return merge(IconStyler(opticalSize: value));
  }

  /// Sets the shadows.
  IconStyler shadows(List<ShadowMix> value) {
    return merge(IconStyler(shadows: value));
  }

  /// Sets the textDirection.
  IconStyler textDirection(TextDirection value) {
    return merge(IconStyler(textDirection: value));
  }

  /// Sets the applyTextScaling.
  IconStyler applyTextScaling(bool value) {
    return merge(IconStyler(applyTextScaling: value));
  }

  /// Sets the fill.
  IconStyler fill(double value) {
    return merge(IconStyler(fill: value));
  }

  /// Sets the semanticsLabel.
  IconStyler semanticsLabel(String value) {
    return merge(IconStyler(semanticsLabel: value));
  }

  /// Sets the opacity.
  IconStyler opacity(double value) {
    return merge(IconStyler(opacity: value));
  }

  /// Sets the blendMode.
  IconStyler blendMode(BlendMode value) {
    return merge(IconStyler(blendMode: value));
  }

  /// Sets the icon.
  IconStyler icon(IconData value) {
    return merge(IconStyler(icon: value));
  }

  /// Sets the animation configuration.
  ///
  /// When [reverse] is provided, it is used as the exit transition
  /// config when leaving this style.
  @override
  IconStyler animate(AnimationConfig value, {AnimationConfig? reverse}) {
    final config = reverse == null
        ? value
        : ReversibleAnimationConfig(forward: value, reverse: reverse);

    return merge(IconStyler(animation: config));
  }

  /// Sets the style variants.
  @override
  IconStyler variants(List<VariantStyle<IconSpec>> value) {
    return merge(IconStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  IconStyler wrap(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }

  /// Sets the widget modifier.
  IconStyler modifier(WidgetModifierConfig value) {
    return merge(IconStyler(modifier: value));
  }

  StyledIcon call({Key? key, IconData? icon, String? semanticLabel}) {
    return StyledIcon(
      key: key,
      style: this,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }

  /// Merges with another [IconStyler].
  @override
  IconStyler merge(IconStyler? other) {
    return IconStyler.create(
      color: MixOps.merge($color, other?.$color),
      size: MixOps.merge($size, other?.$size),
      weight: MixOps.merge($weight, other?.$weight),
      grade: MixOps.merge($grade, other?.$grade),
      opticalSize: MixOps.merge($opticalSize, other?.$opticalSize),
      shadows: MixOps.merge($shadows, other?.$shadows),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      applyTextScaling: MixOps.merge(
        $applyTextScaling,
        other?.$applyTextScaling,
      ),
      fill: MixOps.merge($fill, other?.$fill),
      semanticsLabel: MixOps.merge($semanticsLabel, other?.$semanticsLabel),
      opacity: MixOps.merge($opacity, other?.$opacity),
      blendMode: MixOps.merge($blendMode, other?.$blendMode),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<IconSpec>] using [context].
  @override
  StyleSpec<IconSpec> resolve(BuildContext context) {
    final spec = IconSpec(
      color: MixOps.resolve(context, $color),
      size: MixOps.resolve(context, $size),
      weight: MixOps.resolve(context, $weight),
      grade: MixOps.resolve(context, $grade),
      opticalSize: MixOps.resolve(context, $opticalSize),
      shadows: MixOps.resolve(context, $shadows),
      textDirection: MixOps.resolve(context, $textDirection),
      applyTextScaling: MixOps.resolve(context, $applyTextScaling),
      fill: MixOps.resolve(context, $fill),
      semanticsLabel: MixOps.resolve(context, $semanticsLabel),
      opacity: MixOps.resolve(context, $opacity),
      blendMode: MixOps.resolve(context, $blendMode),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('weight', $weight))
      ..add(DiagnosticsProperty('grade', $grade))
      ..add(DiagnosticsProperty('opticalSize', $opticalSize))
      ..add(DiagnosticsProperty('shadows', $shadows))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('applyTextScaling', $applyTextScaling))
      ..add(DiagnosticsProperty('fill', $fill))
      ..add(DiagnosticsProperty('semanticsLabel', $semanticsLabel))
      ..add(DiagnosticsProperty('opacity', $opacity))
      ..add(DiagnosticsProperty('blendMode', $blendMode))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $color,
    $size,
    $weight,
    $grade,
    $opticalSize,
    $shadows,
    $textDirection,
    $applyTextScaling,
    $fill,
    $semanticsLabel,
    $opacity,
    $blendMode,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}

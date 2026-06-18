// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$FlexSpec implements Spec<FlexSpec>, Diagnosticable {
  Axis? get direction;
  MainAxisAlignment? get mainAxisAlignment;
  CrossAxisAlignment? get crossAxisAlignment;
  MainAxisSize? get mainAxisSize;
  VerticalDirection? get verticalDirection;
  TextDirection? get textDirection;
  TextBaseline? get textBaseline;
  Clip? get clipBehavior;
  double? get spacing;

  @override
  Type get type => FlexSpec;

  @override
  FlexSpec copyWith({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
  }) {
    return FlexSpec(
      direction: direction ?? this.direction,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textDirection: textDirection ?? this.textDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  FlexSpec lerp(FlexSpec? other, double t) {
    return FlexSpec(
      direction: MixOps.lerpSnap(direction, other?.direction, t),
      mainAxisAlignment: MixOps.lerpSnap(
        mainAxisAlignment,
        other?.mainAxisAlignment,
        t,
      ),
      crossAxisAlignment: MixOps.lerpSnap(
        crossAxisAlignment,
        other?.crossAxisAlignment,
        t,
      ),
      mainAxisSize: MixOps.lerpSnap(mainAxisSize, other?.mainAxisSize, t),
      verticalDirection: MixOps.lerpSnap(
        verticalDirection,
        other?.verticalDirection,
        t,
      ),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      textBaseline: MixOps.lerpSnap(textBaseline, other?.textBaseline, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
    );
  }

  @override
  List<Object?> get props => [
    direction,
    mainAxisAlignment,
    crossAxisAlignment,
    mainAxisSize,
    verticalDirection,
    textDirection,
    textBaseline,
    clipBehavior,
    spacing,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FlexSpec &&
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
      ..add(EnumProperty<Axis>('direction', direction))
      ..add(
        EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment),
      )
      ..add(
        EnumProperty<CrossAxisAlignment>(
          'crossAxisAlignment',
          crossAxisAlignment,
        ),
      )
      ..add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize))
      ..add(
        EnumProperty<VerticalDirection>('verticalDirection', verticalDirection),
      )
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<TextBaseline>('textBaseline', textBaseline))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior))
      ..add(DoubleProperty('spacing', spacing));
  }
}

@Deprecated(
  'Rename to `_\$FlexSpec` and migrate the class declaration to `class FlexSpec with _\$FlexSpec`. The `_\$FlexSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$FlexSpecMethods = _$FlexSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class FlexStyler extends MixStyler<FlexStyler, FlexSpec>
    with FlexStyleMixin<FlexStyler> {
  final Prop<Axis>? $direction;
  final Prop<MainAxisAlignment>? $mainAxisAlignment;
  final Prop<CrossAxisAlignment>? $crossAxisAlignment;
  final Prop<MainAxisSize>? $mainAxisSize;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<TextDirection>? $textDirection;
  final Prop<TextBaseline>? $textBaseline;
  final Prop<Clip>? $clipBehavior;
  final Prop<double>? $spacing;

  const FlexStyler.create({
    Prop<Axis>? direction,
    Prop<MainAxisAlignment>? mainAxisAlignment,
    Prop<CrossAxisAlignment>? crossAxisAlignment,
    Prop<MainAxisSize>? mainAxisSize,
    Prop<VerticalDirection>? verticalDirection,
    Prop<TextDirection>? textDirection,
    Prop<TextBaseline>? textBaseline,
    Prop<Clip>? clipBehavior,
    Prop<double>? spacing,
    super.variants,
    super.modifier,
    super.animation,
  }) : $direction = direction,
       $mainAxisAlignment = mainAxisAlignment,
       $crossAxisAlignment = crossAxisAlignment,
       $mainAxisSize = mainAxisSize,
       $verticalDirection = verticalDirection,
       $textDirection = textDirection,
       $textBaseline = textBaseline,
       $clipBehavior = clipBehavior,
       $spacing = spacing;

  FlexStyler({
    Axis? direction,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<FlexSpec>>? variants,
  }) : this.create(
         direction: Prop.maybe(direction),
         mainAxisAlignment: Prop.maybe(mainAxisAlignment),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         mainAxisSize: Prop.maybe(mainAxisSize),
         verticalDirection: Prop.maybe(verticalDirection),
         textDirection: Prop.maybe(textDirection),
         textBaseline: Prop.maybe(textBaseline),
         clipBehavior: Prop.maybe(clipBehavior),
         spacing: Prop.maybe(spacing),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory FlexStyler.direction(Axis value) => FlexStyler().direction(value);
  factory FlexStyler.mainAxisAlignment(MainAxisAlignment value) =>
      FlexStyler().mainAxisAlignment(value);
  factory FlexStyler.crossAxisAlignment(CrossAxisAlignment value) =>
      FlexStyler().crossAxisAlignment(value);
  factory FlexStyler.mainAxisSize(MainAxisSize value) =>
      FlexStyler().mainAxisSize(value);
  factory FlexStyler.verticalDirection(VerticalDirection value) =>
      FlexStyler().verticalDirection(value);
  factory FlexStyler.textDirection(TextDirection value) =>
      FlexStyler().textDirection(value);
  factory FlexStyler.textBaseline(TextBaseline value) =>
      FlexStyler().textBaseline(value);
  factory FlexStyler.clipBehavior(Clip value) =>
      FlexStyler().clipBehavior(value);
  factory FlexStyler.spacing(double value) => FlexStyler().spacing(value);
  factory FlexStyler.row() => FlexStyler().row();
  factory FlexStyler.column() => FlexStyler().column();

  @override
  FlexStyler flex(FlexStyler value) {
    return merge(value);
  }

  /// Sets the direction.
  @override
  FlexStyler direction(Axis value) {
    return merge(FlexStyler(direction: value));
  }

  /// Sets the mainAxisAlignment.
  @override
  FlexStyler mainAxisAlignment(MainAxisAlignment value) {
    return merge(FlexStyler(mainAxisAlignment: value));
  }

  /// Sets the crossAxisAlignment.
  @override
  FlexStyler crossAxisAlignment(CrossAxisAlignment value) {
    return merge(FlexStyler(crossAxisAlignment: value));
  }

  /// Sets the mainAxisSize.
  @override
  FlexStyler mainAxisSize(MainAxisSize value) {
    return merge(FlexStyler(mainAxisSize: value));
  }

  /// Sets the verticalDirection.
  @override
  FlexStyler verticalDirection(VerticalDirection value) {
    return merge(FlexStyler(verticalDirection: value));
  }

  /// Sets the textDirection.
  @override
  FlexStyler textDirection(TextDirection value) {
    return merge(FlexStyler(textDirection: value));
  }

  /// Sets the textBaseline.
  @override
  FlexStyler textBaseline(TextBaseline value) {
    return merge(FlexStyler(textBaseline: value));
  }

  /// Sets the clipBehavior.
  FlexStyler clipBehavior(Clip value) {
    return merge(FlexStyler(clipBehavior: value));
  }

  /// Sets the spacing.
  @override
  FlexStyler spacing(double value) {
    return merge(FlexStyler(spacing: value));
  }

  /// Sets the animation configuration.
  ///
  /// When [reverse] is provided, it is used as the exit transition
  /// config when leaving this style.
  @override
  FlexStyler animate(AnimationConfig value, {AnimationConfig? reverse}) {
    final config = reverse == null
        ? value
        : ReversibleAnimationConfig(forward: value, reverse: reverse);

    return merge(FlexStyler(animation: config));
  }

  /// Sets the style variants.
  @override
  FlexStyler variants(List<VariantStyle<FlexSpec>> value) {
    return merge(FlexStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  FlexStyler wrap(WidgetModifierConfig value) {
    return merge(FlexStyler(modifier: value));
  }

  /// Sets the widget modifier.
  FlexStyler modifier(WidgetModifierConfig value) {
    return merge(FlexStyler(modifier: value));
  }

  /// Merges with another [FlexStyler].
  @override
  FlexStyler merge(FlexStyler? other) {
    return FlexStyler.create(
      direction: MixOps.merge($direction, other?.$direction),
      mainAxisAlignment: MixOps.merge(
        $mainAxisAlignment,
        other?.$mainAxisAlignment,
      ),
      crossAxisAlignment: MixOps.merge(
        $crossAxisAlignment,
        other?.$crossAxisAlignment,
      ),
      mainAxisSize: MixOps.merge($mainAxisSize, other?.$mainAxisSize),
      verticalDirection: MixOps.merge(
        $verticalDirection,
        other?.$verticalDirection,
      ),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      textBaseline: MixOps.merge($textBaseline, other?.$textBaseline),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      spacing: MixOps.merge($spacing, other?.$spacing),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<FlexSpec>] using [context].
  @override
  StyleSpec<FlexSpec> resolve(BuildContext context) {
    final spec = FlexSpec(
      direction: MixOps.resolve(context, $direction),
      mainAxisAlignment: MixOps.resolve(context, $mainAxisAlignment),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      mainAxisSize: MixOps.resolve(context, $mainAxisSize),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      textDirection: MixOps.resolve(context, $textDirection),
      textBaseline: MixOps.resolve(context, $textBaseline),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
      spacing: MixOps.resolve(context, $spacing),
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
      ..add(DiagnosticsProperty('direction', $direction))
      ..add(DiagnosticsProperty('mainAxisAlignment', $mainAxisAlignment))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('mainAxisSize', $mainAxisSize))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('textBaseline', $textBaseline))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior))
      ..add(DiagnosticsProperty('spacing', $spacing));
  }

  @override
  List<Object?> get props => [
    $direction,
    $mainAxisAlignment,
    $crossAxisAlignment,
    $mainAxisSize,
    $verticalDirection,
    $textDirection,
    $textBaseline,
    $clipBehavior,
    $spacing,
    $animation,
    $modifier,
    $variants,
  ];
}

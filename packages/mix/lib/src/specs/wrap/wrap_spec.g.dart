// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrap_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$WrapSpec implements Spec<WrapSpec>, Diagnosticable {
  Axis? get direction;
  WrapAlignment? get alignment;
  double? get spacing;
  WrapAlignment? get runAlignment;
  double? get runSpacing;
  WrapCrossAlignment? get crossAxisAlignment;
  TextDirection? get textDirection;
  VerticalDirection? get verticalDirection;
  Clip? get clipBehavior;

  @override
  Type get type => WrapSpec;

  @override
  WrapSpec copyWith({
    Axis? direction,
    WrapAlignment? alignment,
    double? spacing,
    WrapAlignment? runAlignment,
    double? runSpacing,
    WrapCrossAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    Clip? clipBehavior,
  }) {
    return WrapSpec(
      direction: direction ?? this.direction,
      alignment: alignment ?? this.alignment,
      spacing: spacing ?? this.spacing,
      runAlignment: runAlignment ?? this.runAlignment,
      runSpacing: runSpacing ?? this.runSpacing,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      textDirection: textDirection ?? this.textDirection,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  WrapSpec lerp(WrapSpec? other, double t) {
    return WrapSpec(
      direction: MixOps.lerpSnap(direction, other?.direction, t),
      alignment: MixOps.lerpSnap(alignment, other?.alignment, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      runAlignment: MixOps.lerpSnap(runAlignment, other?.runAlignment, t),
      runSpacing: MixOps.lerp(runSpacing, other?.runSpacing, t),
      crossAxisAlignment: MixOps.lerpSnap(
        crossAxisAlignment,
        other?.crossAxisAlignment,
        t,
      ),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      verticalDirection: MixOps.lerpSnap(
        verticalDirection,
        other?.verticalDirection,
        t,
      ),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [
    direction,
    alignment,
    spacing,
    runAlignment,
    runSpacing,
    crossAxisAlignment,
    textDirection,
    verticalDirection,
    clipBehavior,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WrapSpec &&
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
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DiagnosticsProperty('runAlignment', runAlignment))
      ..add(DoubleProperty('runSpacing', runSpacing))
      ..add(DiagnosticsProperty('crossAxisAlignment', crossAxisAlignment))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(
        EnumProperty<VerticalDirection>('verticalDirection', verticalDirection),
      )
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

@Deprecated(
  'Rename to `_\$WrapSpec` and migrate the class declaration to `class WrapSpec with _\$WrapSpec`. The `_\$WrapSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$WrapSpecMethods = _$WrapSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class WrapStyler extends MixStyler<WrapStyler, WrapSpec> {
  final Prop<Axis>? $direction;
  final Prop<WrapAlignment>? $alignment;
  final Prop<double>? $spacing;
  final Prop<WrapAlignment>? $runAlignment;
  final Prop<double>? $runSpacing;
  final Prop<WrapCrossAlignment>? $crossAxisAlignment;
  final Prop<TextDirection>? $textDirection;
  final Prop<VerticalDirection>? $verticalDirection;
  final Prop<Clip>? $clipBehavior;

  const WrapStyler.create({
    Prop<Axis>? direction,
    Prop<WrapAlignment>? alignment,
    Prop<double>? spacing,
    Prop<WrapAlignment>? runAlignment,
    Prop<double>? runSpacing,
    Prop<WrapCrossAlignment>? crossAxisAlignment,
    Prop<TextDirection>? textDirection,
    Prop<VerticalDirection>? verticalDirection,
    Prop<Clip>? clipBehavior,
    super.variants,
    super.modifier,
    super.animation,
  }) : $direction = direction,
       $alignment = alignment,
       $spacing = spacing,
       $runAlignment = runAlignment,
       $runSpacing = runSpacing,
       $crossAxisAlignment = crossAxisAlignment,
       $textDirection = textDirection,
       $verticalDirection = verticalDirection,
       $clipBehavior = clipBehavior;

  WrapStyler({
    Axis? direction,
    WrapAlignment? alignment,
    double? spacing,
    WrapAlignment? runAlignment,
    double? runSpacing,
    WrapCrossAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<WrapSpec>>? variants,
  }) : this.create(
         direction: Prop.maybe(direction),
         alignment: Prop.maybe(alignment),
         spacing: Prop.maybe(spacing),
         runAlignment: Prop.maybe(runAlignment),
         runSpacing: Prop.maybe(runSpacing),
         crossAxisAlignment: Prop.maybe(crossAxisAlignment),
         textDirection: Prop.maybe(textDirection),
         verticalDirection: Prop.maybe(verticalDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory WrapStyler.direction(Axis value) => WrapStyler().direction(value);
  factory WrapStyler.alignment(WrapAlignment value) =>
      WrapStyler().alignment(value);
  factory WrapStyler.spacing(double value) => WrapStyler().spacing(value);
  factory WrapStyler.runAlignment(WrapAlignment value) =>
      WrapStyler().runAlignment(value);
  factory WrapStyler.runSpacing(double value) => WrapStyler().runSpacing(value);
  factory WrapStyler.crossAxisAlignment(WrapCrossAlignment value) =>
      WrapStyler().crossAxisAlignment(value);
  factory WrapStyler.textDirection(TextDirection value) =>
      WrapStyler().textDirection(value);
  factory WrapStyler.verticalDirection(VerticalDirection value) =>
      WrapStyler().verticalDirection(value);
  factory WrapStyler.clipBehavior(Clip value) =>
      WrapStyler().clipBehavior(value);

  /// Sets the direction.
  WrapStyler direction(Axis value) {
    return merge(WrapStyler(direction: value));
  }

  /// Sets the alignment.
  WrapStyler alignment(WrapAlignment value) {
    return merge(WrapStyler(alignment: value));
  }

  /// Sets the spacing.
  WrapStyler spacing(double value) {
    return merge(WrapStyler(spacing: value));
  }

  /// Sets the runAlignment.
  WrapStyler runAlignment(WrapAlignment value) {
    return merge(WrapStyler(runAlignment: value));
  }

  /// Sets the runSpacing.
  WrapStyler runSpacing(double value) {
    return merge(WrapStyler(runSpacing: value));
  }

  /// Sets the crossAxisAlignment.
  WrapStyler crossAxisAlignment(WrapCrossAlignment value) {
    return merge(WrapStyler(crossAxisAlignment: value));
  }

  /// Sets the textDirection.
  WrapStyler textDirection(TextDirection value) {
    return merge(WrapStyler(textDirection: value));
  }

  /// Sets the verticalDirection.
  WrapStyler verticalDirection(VerticalDirection value) {
    return merge(WrapStyler(verticalDirection: value));
  }

  /// Sets the clipBehavior.
  WrapStyler clipBehavior(Clip value) {
    return merge(WrapStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  @override
  WrapStyler animate(AnimationConfig value) {
    return merge(WrapStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  WrapStyler variants(List<VariantStyle<WrapSpec>> value) {
    return merge(WrapStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  WrapStyler wrap(WidgetModifierConfig value) {
    return merge(WrapStyler(modifier: value));
  }

  /// Sets the widget modifier.
  WrapStyler modifier(WidgetModifierConfig value) {
    return merge(WrapStyler(modifier: value));
  }

  /// Merges with another [WrapStyler].
  @override
  WrapStyler merge(WrapStyler? other) {
    return WrapStyler.create(
      direction: MixOps.merge($direction, other?.$direction),
      alignment: MixOps.merge($alignment, other?.$alignment),
      spacing: MixOps.merge($spacing, other?.$spacing),
      runAlignment: MixOps.merge($runAlignment, other?.$runAlignment),
      runSpacing: MixOps.merge($runSpacing, other?.$runSpacing),
      crossAxisAlignment: MixOps.merge(
        $crossAxisAlignment,
        other?.$crossAxisAlignment,
      ),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      verticalDirection: MixOps.merge(
        $verticalDirection,
        other?.$verticalDirection,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<WrapSpec>] using [context].
  @override
  StyleSpec<WrapSpec> resolve(BuildContext context) {
    final spec = WrapSpec(
      direction: MixOps.resolve(context, $direction),
      alignment: MixOps.resolve(context, $alignment),
      spacing: MixOps.resolve(context, $spacing),
      runAlignment: MixOps.resolve(context, $runAlignment),
      runSpacing: MixOps.resolve(context, $runSpacing),
      crossAxisAlignment: MixOps.resolve(context, $crossAxisAlignment),
      textDirection: MixOps.resolve(context, $textDirection),
      verticalDirection: MixOps.resolve(context, $verticalDirection),
      clipBehavior: MixOps.resolve(context, $clipBehavior),
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
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('spacing', $spacing))
      ..add(DiagnosticsProperty('runAlignment', $runAlignment))
      ..add(DiagnosticsProperty('runSpacing', $runSpacing))
      ..add(DiagnosticsProperty('crossAxisAlignment', $crossAxisAlignment))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('verticalDirection', $verticalDirection))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
    $direction,
    $alignment,
    $spacing,
    $runAlignment,
    $runSpacing,
    $crossAxisAlignment,
    $textDirection,
    $verticalDirection,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}

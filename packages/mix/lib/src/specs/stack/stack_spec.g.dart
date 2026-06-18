// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$StackSpec implements Spec<StackSpec>, Diagnosticable {
  AlignmentGeometry? get alignment;
  StackFit? get fit;
  TextDirection? get textDirection;
  Clip? get clipBehavior;

  @override
  Type get type => StackSpec;

  @override
  StackSpec copyWith({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
  }) {
    return StackSpec(
      alignment: alignment ?? this.alignment,
      fit: fit ?? this.fit,
      textDirection: textDirection ?? this.textDirection,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  StackSpec lerp(StackSpec? other, double t) {
    return StackSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      fit: MixOps.lerpSnap(fit, other?.fit, t),
      textDirection: MixOps.lerpSnap(textDirection, other?.textDirection, t),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [alignment, fit, textDirection, clipBehavior];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StackSpec &&
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
      ..add(DiagnosticsProperty('alignment', alignment))
      ..add(EnumProperty<StackFit>('fit', fit))
      ..add(EnumProperty<TextDirection>('textDirection', textDirection))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

@Deprecated(
  'Rename to `_\$StackSpec` and migrate the class declaration to `class StackSpec with _\$StackSpec`. The `_\$StackSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$StackSpecMethods = _$StackSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class StackStyler extends MixStyler<StackStyler, StackSpec> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<StackFit>? $fit;
  final Prop<TextDirection>? $textDirection;
  final Prop<Clip>? $clipBehavior;

  const StackStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<StackFit>? fit,
    Prop<TextDirection>? textDirection,
    Prop<Clip>? clipBehavior,
    super.variants,
    super.modifier,
    super.animation,
  }) : $alignment = alignment,
       $fit = fit,
       $textDirection = textDirection,
       $clipBehavior = clipBehavior;

  StackStyler({
    AlignmentGeometry? alignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? clipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<StackSpec>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         fit: Prop.maybe(fit),
         textDirection: Prop.maybe(textDirection),
         clipBehavior: Prop.maybe(clipBehavior),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory StackStyler.alignment(AlignmentGeometry value) =>
      StackStyler().alignment(value);
  factory StackStyler.fit(StackFit value) => StackStyler().fit(value);
  factory StackStyler.textDirection(TextDirection value) =>
      StackStyler().textDirection(value);
  factory StackStyler.clipBehavior(Clip value) =>
      StackStyler().clipBehavior(value);

  /// Sets the alignment.
  StackStyler alignment(AlignmentGeometry value) {
    return merge(StackStyler(alignment: value));
  }

  /// Sets the fit.
  StackStyler fit(StackFit value) {
    return merge(StackStyler(fit: value));
  }

  /// Sets the textDirection.
  StackStyler textDirection(TextDirection value) {
    return merge(StackStyler(textDirection: value));
  }

  /// Sets the clipBehavior.
  StackStyler clipBehavior(Clip value) {
    return merge(StackStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  ///
  /// When [reverse] is provided, it is used as the exit transition
  /// config when leaving this style.
  @override
  StackStyler animate(AnimationConfig value, {AnimationConfig? reverse}) {
    final config = reverse == null
        ? value
        : ReversibleAnimationConfig(forward: value, reverse: reverse);

    return merge(StackStyler(animation: config));
  }

  /// Sets the style variants.
  @override
  StackStyler variants(List<VariantStyle<StackSpec>> value) {
    return merge(StackStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  StackStyler wrap(WidgetModifierConfig value) {
    return merge(StackStyler(modifier: value));
  }

  /// Sets the widget modifier.
  StackStyler modifier(WidgetModifierConfig value) {
    return merge(StackStyler(modifier: value));
  }

  /// Merges with another [StackStyler].
  @override
  StackStyler merge(StackStyler? other) {
    return StackStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      fit: MixOps.merge($fit, other?.$fit),
      textDirection: MixOps.merge($textDirection, other?.$textDirection),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<StackSpec>] using [context].
  @override
  StyleSpec<StackSpec> resolve(BuildContext context) {
    final spec = StackSpec(
      alignment: MixOps.resolve(context, $alignment),
      fit: MixOps.resolve(context, $fit),
      textDirection: MixOps.resolve(context, $textDirection),
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
      ..add(DiagnosticsProperty('alignment', $alignment))
      ..add(DiagnosticsProperty('fit', $fit))
      ..add(DiagnosticsProperty('textDirection', $textDirection))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $fit,
    $textDirection,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$BoxSpec implements Spec<BoxSpec>, Diagnosticable {
  AlignmentGeometry? get alignment;
  EdgeInsetsGeometry? get padding;
  EdgeInsetsGeometry? get margin;
  BoxConstraints? get constraints;
  Decoration? get decoration;
  Decoration? get foregroundDecoration;
  Matrix4? get transform;
  AlignmentGeometry? get transformAlignment;
  Clip? get clipBehavior;

  @override
  Type get type => BoxSpec;

  @override
  BoxSpec copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxConstraints? constraints,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) {
    return BoxSpec(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      constraints: constraints ?? this.constraints,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  BoxSpec lerp(BoxSpec? other, double t) {
    return BoxSpec(
      alignment: MixOps.lerp(alignment, other?.alignment, t),
      padding: MixOps.lerp(padding, other?.padding, t),
      margin: MixOps.lerp(margin, other?.margin, t),
      constraints: MixOps.lerp(constraints, other?.constraints, t),
      decoration: MixOps.lerp(decoration, other?.decoration, t),
      foregroundDecoration: MixOps.lerp(
        foregroundDecoration,
        other?.foregroundDecoration,
        t,
      ),
      transform: MixOps.lerp(transform, other?.transform, t),
      transformAlignment: MixOps.lerp(
        transformAlignment,
        other?.transformAlignment,
        t,
      ),
      clipBehavior: MixOps.lerpSnap(clipBehavior, other?.clipBehavior, t),
    );
  }

  @override
  List<Object?> get props => [
    alignment,
    padding,
    margin,
    constraints,
    decoration,
    foregroundDecoration,
    transform,
    transformAlignment,
    clipBehavior,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BoxSpec &&
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
      ..add(DiagnosticsProperty('padding', padding))
      ..add(DiagnosticsProperty('margin', margin))
      ..add(DiagnosticsProperty('constraints', constraints))
      ..add(DiagnosticsProperty('decoration', decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', foregroundDecoration))
      ..add(DiagnosticsProperty('transform', transform))
      ..add(DiagnosticsProperty('transformAlignment', transformAlignment))
      ..add(EnumProperty<Clip>('clipBehavior', clipBehavior));
  }
}

@Deprecated(
  'Rename to `_\$BoxSpec` and migrate the class declaration to `class BoxSpec with _\$BoxSpec`. The `_\$BoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$BoxSpecMethods = _$BoxSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class BoxStyler extends MixStyler<BoxStyler, BoxSpec>
    with
        SpacingStyleMixin<BoxStyler>,
        ConstraintStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        BorderStyleMixin<BoxStyler>,
        BorderRadiusStyleMixin<BoxStyler>,
        ShadowStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler> {
  final Prop<AlignmentGeometry>? $alignment;
  final Prop<EdgeInsetsGeometry>? $padding;
  final Prop<EdgeInsetsGeometry>? $margin;
  final Prop<BoxConstraints>? $constraints;
  final Prop<Decoration>? $decoration;
  final Prop<Decoration>? $foregroundDecoration;
  final Prop<Matrix4>? $transform;
  final Prop<AlignmentGeometry>? $transformAlignment;
  final Prop<Clip>? $clipBehavior;

  const BoxStyler.create({
    Prop<AlignmentGeometry>? alignment,
    Prop<EdgeInsetsGeometry>? padding,
    Prop<EdgeInsetsGeometry>? margin,
    Prop<BoxConstraints>? constraints,
    Prop<Decoration>? decoration,
    Prop<Decoration>? foregroundDecoration,
    Prop<Matrix4>? transform,
    Prop<AlignmentGeometry>? transformAlignment,
    Prop<Clip>? clipBehavior,
    super.variants,
    super.modifier,
    super.animation,
  }) : $alignment = alignment,
       $padding = padding,
       $margin = margin,
       $constraints = constraints,
       $decoration = decoration,
       $foregroundDecoration = foregroundDecoration,
       $transform = transform,
       $transformAlignment = transformAlignment,
       $clipBehavior = clipBehavior;

  BoxStyler({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    BoxConstraintsMix? constraints,
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<BoxSpec>>? variants,
  }) : this.create(
         alignment: Prop.maybe(alignment),
         padding: Prop.maybeMix(padding),
         margin: Prop.maybeMix(margin),
         constraints: Prop.maybeMix(constraints),
         decoration: Prop.maybeMix(decoration),
         foregroundDecoration: Prop.maybeMix(foregroundDecoration),
         transform: Prop.maybe(transform),
         transformAlignment: Prop.maybe(transformAlignment),
         clipBehavior: Prop.maybe(clipBehavior),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory BoxStyler.alignment(AlignmentGeometry value) =>
      BoxStyler().alignment(value);
  factory BoxStyler.padding(EdgeInsetsGeometryMix value) =>
      BoxStyler().padding(value);
  factory BoxStyler.margin(EdgeInsetsGeometryMix value) =>
      BoxStyler().margin(value);
  factory BoxStyler.constraints(BoxConstraintsMix value) =>
      BoxStyler().constraints(value);
  factory BoxStyler.decoration(DecorationMix value) =>
      BoxStyler().decoration(value);
  factory BoxStyler.foregroundDecoration(DecorationMix value) =>
      BoxStyler().foregroundDecoration(value);
  factory BoxStyler.clipBehavior(Clip value) => BoxStyler().clipBehavior(value);
  factory BoxStyler.color(Color value) => BoxStyler().color(value);
  factory BoxStyler.gradient(GradientMix value) => BoxStyler().gradient(value);
  factory BoxStyler.border(BoxBorderMix value) => BoxStyler().border(value);
  factory BoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      BoxStyler().borderRadius(value);
  factory BoxStyler.elevation(ElevationShadow value) =>
      BoxStyler().elevation(value);
  factory BoxStyler.shadow(BoxShadowMix value) => BoxStyler().shadow(value);
  factory BoxStyler.shadows(BoxShadowListMix value) =>
      BoxStyler().shadows(value);
  factory BoxStyler.width(double value) => BoxStyler().width(value);
  factory BoxStyler.height(double value) => BoxStyler().height(value);
  factory BoxStyler.size(double width, double height) =>
      BoxStyler().size(width, height);
  factory BoxStyler.minWidth(double value) => BoxStyler().minWidth(value);
  factory BoxStyler.maxWidth(double value) => BoxStyler().maxWidth(value);
  factory BoxStyler.minHeight(double value) => BoxStyler().minHeight(value);
  factory BoxStyler.maxHeight(double value) => BoxStyler().maxHeight(value);
  factory BoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      BoxStyler().scale(scale, alignment: alignment);
  factory BoxStyler.rotate(double radians, {Alignment alignment = .center}) =>
      BoxStyler().rotate(radians, alignment: alignment);
  factory BoxStyler.translate(double x, double y, [double z = 0.0]) =>
      BoxStyler().translate(x, y, z);
  factory BoxStyler.skew(double skewX, double skewY) =>
      BoxStyler().skew(skewX, skewY);
  factory BoxStyler.textStyle(TextStyler value) => BoxStyler().textStyle(value);
  factory BoxStyler.image(DecorationImageMix value) => BoxStyler().image(value);
  factory BoxStyler.shape(ShapeBorderMix value) => BoxStyler().shape(value);
  factory BoxStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => BoxStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory BoxStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => BoxStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory BoxStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => BoxStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory BoxStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => BoxStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory BoxStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => BoxStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory BoxStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => BoxStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory BoxStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => BoxStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory BoxStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => BoxStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory BoxStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => BoxStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory BoxStyler.transform(Matrix4 value, {Alignment alignment = .center}) =>
      BoxStyler().transform(value, alignment: alignment);
  factory BoxStyler.animate(AnimationConfig value) =>
      BoxStyler().animate(value);

  BoxStyler textStyle(TextStyler value) {
    return wrap(WidgetModifierConfig.defaultTextStyler(value));
  }

  @override
  BoxStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return merge(BoxStyler(transform: value, transformAlignment: alignment));
  }

  /// Sets the alignment.
  BoxStyler alignment(AlignmentGeometry value) {
    return merge(BoxStyler(alignment: value));
  }

  /// Sets the padding.
  @override
  BoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(padding: value));
  }

  /// Sets the margin.
  @override
  BoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(margin: value));
  }

  /// Sets the constraints.
  @override
  BoxStyler constraints(BoxConstraintsMix value) {
    return merge(BoxStyler(constraints: value));
  }

  /// Sets the decoration.
  @override
  BoxStyler decoration(DecorationMix value) {
    return merge(BoxStyler(decoration: value));
  }

  /// Sets the foregroundDecoration.
  @override
  BoxStyler foregroundDecoration(DecorationMix value) {
    return merge(BoxStyler(foregroundDecoration: value));
  }

  /// Sets the clipBehavior.
  BoxStyler clipBehavior(Clip value) {
    return merge(BoxStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  @override
  BoxStyler animate(AnimationConfig value) {
    return merge(BoxStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  BoxStyler variants(List<VariantStyle<BoxSpec>> value) {
    return merge(BoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  BoxStyler wrap(WidgetModifierConfig value) {
    return merge(BoxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BoxStyler modifier(WidgetModifierConfig value) {
    return merge(BoxStyler(modifier: value));
  }

  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }

  /// Merges with another [BoxStyler].
  @override
  BoxStyler merge(BoxStyler? other) {
    return BoxStyler.create(
      alignment: MixOps.merge($alignment, other?.$alignment),
      padding: MixOps.merge($padding, other?.$padding),
      margin: MixOps.merge($margin, other?.$margin),
      constraints: MixOps.merge($constraints, other?.$constraints),
      decoration: MixOps.merge($decoration, other?.$decoration),
      foregroundDecoration: MixOps.merge(
        $foregroundDecoration,
        other?.$foregroundDecoration,
      ),
      transform: MixOps.merge($transform, other?.$transform),
      transformAlignment: MixOps.merge(
        $transformAlignment,
        other?.$transformAlignment,
      ),
      clipBehavior: MixOps.merge($clipBehavior, other?.$clipBehavior),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<BoxSpec>] using [context].
  @override
  StyleSpec<BoxSpec> resolve(BuildContext context) {
    final spec = BoxSpec(
      alignment: MixOps.resolve(context, $alignment),
      padding: MixOps.resolve(context, $padding),
      margin: MixOps.resolve(context, $margin),
      constraints: MixOps.resolve(context, $constraints),
      decoration: MixOps.resolve(context, $decoration),
      foregroundDecoration: MixOps.resolve(context, $foregroundDecoration),
      transform: MixOps.resolve(context, $transform),
      transformAlignment: MixOps.resolve(context, $transformAlignment),
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
      ..add(DiagnosticsProperty('padding', $padding))
      ..add(DiagnosticsProperty('margin', $margin))
      ..add(DiagnosticsProperty('constraints', $constraints))
      ..add(DiagnosticsProperty('decoration', $decoration))
      ..add(DiagnosticsProperty('foregroundDecoration', $foregroundDecoration))
      ..add(DiagnosticsProperty('transform', $transform))
      ..add(DiagnosticsProperty('transformAlignment', $transformAlignment))
      ..add(DiagnosticsProperty('clipBehavior', $clipBehavior));
  }

  @override
  List<Object?> get props => [
    $alignment,
    $padding,
    $margin,
    $constraints,
    $decoration,
    $foregroundDecoration,
    $transform,
    $transformAlignment,
    $clipBehavior,
    $animation,
    $modifier,
    $variants,
  ];
}

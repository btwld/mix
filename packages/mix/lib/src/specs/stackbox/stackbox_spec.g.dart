// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stackbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$StackBoxSpec implements Spec<StackBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<StackSpec>? get stack;

  @override
  Type get type => StackBoxSpec;

  @override
  StackBoxSpec copyWith({
    StyleSpec<BoxSpec>? box,
    StyleSpec<StackSpec>? stack,
  }) {
    return StackBoxSpec(box: box ?? this.box, stack: stack ?? this.stack);
  }

  @override
  StackBoxSpec lerp(StackBoxSpec? other, double t) {
    return StackBoxSpec(
      box: box?.lerp(other?.box, t),
      stack: stack?.lerp(other?.stack, t),
    );
  }

  @override
  List<Object?> get props => [box, stack];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StackBoxSpec &&
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
      ..add(DiagnosticsProperty('box', box))
      ..add(DiagnosticsProperty('stack', stack));
  }
}

@Deprecated(
  'Rename to `_\$StackBoxSpec` and migrate the class declaration to `class StackBoxSpec with _\$StackBoxSpec`. The `_\$StackBoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$StackBoxSpecMethods = _$StackBoxSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class StackBoxStyler extends MixStyler<StackBoxStyler, StackBoxSpec>
    with
        SpacingStyleMixin<StackBoxStyler>,
        ConstraintStyleMixin<StackBoxStyler>,
        DecorationStyleMixin<StackBoxStyler>,
        BorderStyleMixin<StackBoxStyler>,
        BorderRadiusStyleMixin<StackBoxStyler>,
        ShadowStyleMixin<StackBoxStyler>,
        TransformStyleMixin<StackBoxStyler> {
  final Prop<StyleSpec<BoxSpec>>? $box;
  final Prop<StyleSpec<StackSpec>>? $stack;

  const StackBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<StackSpec>>? stack,
    super.variants,
    super.modifier,
    super.animation,
  }) : $box = box,
       $stack = stack;

  StackBoxStyler({
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    AlignmentGeometry? stackAlignment,
    StackFit? fit,
    TextDirection? textDirection,
    Clip? stackClipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<StackBoxSpec>>? variants,
  }) : this.create(
         box: Prop.maybeMix(
           BoxStyler(
             alignment: alignment,
             padding: padding,
             margin: margin,
             constraints: constraints,
             decoration: decoration,
             foregroundDecoration: foregroundDecoration,
             transform: transform,
             transformAlignment: transformAlignment,
             clipBehavior: clipBehavior,
           ),
         ),
         stack: Prop.maybeMix(
           StackStyler(
             alignment: stackAlignment,
             fit: fit,
             textDirection: textDirection,
             clipBehavior: stackClipBehavior,
           ),
         ),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory StackBoxStyler.color(Color value) => StackBoxStyler().color(value);
  factory StackBoxStyler.gradient(GradientMix value) =>
      StackBoxStyler().gradient(value);
  factory StackBoxStyler.border(BoxBorderMix value) =>
      StackBoxStyler().border(value);
  factory StackBoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      StackBoxStyler().borderRadius(value);
  factory StackBoxStyler.elevation(ElevationShadow value) =>
      StackBoxStyler().elevation(value);
  factory StackBoxStyler.shadow(BoxShadowMix value) =>
      StackBoxStyler().shadow(value);
  factory StackBoxStyler.shadows(List<BoxShadowMix> value) =>
      StackBoxStyler().shadows(value);
  factory StackBoxStyler.width(double value) => StackBoxStyler().width(value);
  factory StackBoxStyler.height(double value) => StackBoxStyler().height(value);
  factory StackBoxStyler.size(double width, double height) =>
      StackBoxStyler().size(width, height);
  factory StackBoxStyler.minWidth(double value) =>
      StackBoxStyler().minWidth(value);
  factory StackBoxStyler.maxWidth(double value) =>
      StackBoxStyler().maxWidth(value);
  factory StackBoxStyler.minHeight(double value) =>
      StackBoxStyler().minHeight(value);
  factory StackBoxStyler.maxHeight(double value) =>
      StackBoxStyler().maxHeight(value);
  factory StackBoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      StackBoxStyler().scale(scale, alignment: alignment);
  factory StackBoxStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => StackBoxStyler().rotate(radians, alignment: alignment);
  factory StackBoxStyler.translate(double x, double y, [double z = 0.0]) =>
      StackBoxStyler().translate(x, y, z);
  factory StackBoxStyler.skew(double skewX, double skewY) =>
      StackBoxStyler().skew(skewX, skewY);
  factory StackBoxStyler.textStyle(TextStyler value) =>
      StackBoxStyler().textStyle(value);
  factory StackBoxStyler.image(DecorationImageMix value) =>
      StackBoxStyler().image(value);
  factory StackBoxStyler.shape(ShapeBorderMix value) =>
      StackBoxStyler().shape(value);
  factory StackBoxStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => StackBoxStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory StackBoxStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => StackBoxStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory StackBoxStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => StackBoxStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory StackBoxStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => StackBoxStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory StackBoxStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => StackBoxStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory StackBoxStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => StackBoxStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory StackBoxStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => StackBoxStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory StackBoxStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => StackBoxStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory StackBoxStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => StackBoxStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory StackBoxStyler.alignment(AlignmentGeometry value) =>
      StackBoxStyler().alignment(value);
  factory StackBoxStyler.padding(EdgeInsetsGeometryMix value) =>
      StackBoxStyler().padding(value);
  factory StackBoxStyler.margin(EdgeInsetsGeometryMix value) =>
      StackBoxStyler().margin(value);
  factory StackBoxStyler.constraints(BoxConstraintsMix value) =>
      StackBoxStyler().constraints(value);
  factory StackBoxStyler.decoration(DecorationMix value) =>
      StackBoxStyler().decoration(value);
  factory StackBoxStyler.foregroundDecoration(DecorationMix value) =>
      StackBoxStyler().foregroundDecoration(value);
  factory StackBoxStyler.clipBehavior(Clip value) =>
      StackBoxStyler().clipBehavior(value);
  factory StackBoxStyler.stackAlignment(AlignmentGeometry value) =>
      StackBoxStyler().stackAlignment(value);
  factory StackBoxStyler.fit(StackFit value) => StackBoxStyler().fit(value);
  factory StackBoxStyler.textDirection(TextDirection value) =>
      StackBoxStyler().textDirection(value);
  factory StackBoxStyler.stackClipBehavior(Clip value) =>
      StackBoxStyler().stackClipBehavior(value);
  factory StackBoxStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => StackBoxStyler().transform(value, alignment: alignment);
  factory StackBoxStyler.animate(AnimationConfig value) =>
      StackBoxStyler().animate(value);

  StackBoxStyler textStyle(TextStyler value) {
    return wrap(WidgetModifierConfig.defaultTextStyler(value));
  }

  StackBoxStyler alignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(alignment: value));
  }

  StackBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(transformAlignment: value));
  }

  StackBoxStyler clipBehavior(Clip value) {
    return merge(StackBoxStyler(clipBehavior: value));
  }

  @override
  StackBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(StackBoxStyler(foregroundDecoration: value));
  }

  @override
  StackBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyler(padding: value));
  }

  @override
  StackBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(StackBoxStyler(margin: value));
  }

  @override
  StackBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      StackBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  @override
  StackBoxStyler decoration(DecorationMix value) {
    return merge(StackBoxStyler(decoration: value));
  }

  @override
  StackBoxStyler constraints(BoxConstraintsMix value) {
    return merge(StackBoxStyler(constraints: value));
  }

  StackBoxStyler stack(StackStyler value) {
    return merge(StackBoxStyler.create(stack: Prop.maybeMix(value)));
  }

  StackBoxStyler stackAlignment(AlignmentGeometry value) {
    return merge(StackBoxStyler(stackAlignment: value));
  }

  StackBoxStyler fit(StackFit value) {
    return merge(StackBoxStyler(fit: value));
  }

  StackBoxStyler textDirection(TextDirection value) {
    return merge(StackBoxStyler(textDirection: value));
  }

  StackBoxStyler stackClipBehavior(Clip value) {
    return merge(StackBoxStyler(stackClipBehavior: value));
  }

  /// Sets the animation configuration.
  @override
  StackBoxStyler animate(AnimationConfig value) {
    return merge(StackBoxStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  StackBoxStyler variants(List<VariantStyle<StackBoxSpec>> value) {
    return merge(StackBoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  StackBoxStyler wrap(WidgetModifierConfig value) {
    return merge(StackBoxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  StackBoxStyler modifier(WidgetModifierConfig value) {
    return merge(StackBoxStyler(modifier: value));
  }

  StackBox call({Key? key, List<Widget> children = const <Widget>[]}) {
    return StackBox(key: key, style: this, children: children);
  }

  /// Merges with another [StackBoxStyler].
  @override
  StackBoxStyler merge(StackBoxStyler? other) {
    return StackBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      stack: MixOps.merge($stack, other?.$stack),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<StackBoxSpec>] using [context].
  @override
  StyleSpec<StackBoxSpec> resolve(BuildContext context) {
    final spec = StackBoxSpec(
      box: MixOps.resolve(context, $box),
      stack: MixOps.resolve(context, $stack),
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
      ..add(DiagnosticsProperty('box', $box))
      ..add(DiagnosticsProperty('stack', $stack));
  }

  @override
  List<Object?> get props => [$box, $stack, $animation, $modifier, $variants];
}

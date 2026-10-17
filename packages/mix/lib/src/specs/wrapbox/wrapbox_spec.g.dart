// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$WrapBoxSpec implements Spec<WrapBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<WrapSpec>? get flow;

  @override
  Type get type => WrapBoxSpec;

  @override
  WrapBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<WrapSpec>? flow}) {
    return WrapBoxSpec(box: box ?? this.box, flow: flow ?? this.flow);
  }

  @override
  WrapBoxSpec lerp(WrapBoxSpec? other, double t) {
    return WrapBoxSpec(
      box: box?.lerp(other?.box, t),
      flow: flow?.lerp(other?.flow, t),
    );
  }

  @override
  List<Object?> get props => [box, flow];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WrapBoxSpec &&
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
      ..add(DiagnosticsProperty('flow', flow));
  }
}

@Deprecated(
  'Rename to `_\$WrapBoxSpec` and migrate the class declaration to `class WrapBoxSpec with _\$WrapBoxSpec`. The `_\$WrapBoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$WrapBoxSpecMethods = _$WrapBoxSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class WrapBoxStyler extends MixStyler<WrapBoxStyler, WrapBoxSpec>
    with
        SpacingStyleMixin<WrapBoxStyler>,
        ConstraintStyleMixin<WrapBoxStyler>,
        DecorationStyleMixin<WrapBoxStyler>,
        BorderStyleMixin<WrapBoxStyler>,
        BorderRadiusStyleMixin<WrapBoxStyler>,
        ShadowStyleMixin<WrapBoxStyler>,
        TransformStyleMixin<WrapBoxStyler>,
        WrapStyleMixin<WrapBoxStyler>,
        _WrapBoxStylerPressableMixin<WrapBoxStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $box;
  final Prop<StyleSpec<WrapSpec>>? $flow;

  const WrapBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<WrapSpec>>? flow,
    super.variants,
    super.modifier,
    super.animation,
  }) : $box = box,
       $flow = flow;

  WrapBoxStyler({
    DecorationMix? decoration,
    DecorationMix? foregroundDecoration,
    EdgeInsetsGeometryMix? padding,
    EdgeInsetsGeometryMix? margin,
    AlignmentGeometry? alignment,
    BoxConstraintsMix? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    Axis? direction,
    WrapAlignment? wrapAlignment,
    double? spacing,
    WrapAlignment? runAlignment,
    double? runSpacing,
    WrapCrossAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    Clip? wrapClipBehavior,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<WrapBoxSpec>>? variants,
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
         flow: Prop.maybeMix(
           WrapStyler(
             direction: direction,
             alignment: wrapAlignment,
             spacing: spacing,
             runAlignment: runAlignment,
             runSpacing: runSpacing,
             crossAxisAlignment: crossAxisAlignment,
             textDirection: textDirection,
             verticalDirection: verticalDirection,
             clipBehavior: wrapClipBehavior,
           ),
         ),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory WrapBoxStyler.color(Color value) => WrapBoxStyler().color(value);
  factory WrapBoxStyler.gradient(GradientMix value) =>
      WrapBoxStyler().gradient(value);
  factory WrapBoxStyler.border(BoxBorderMix value) =>
      WrapBoxStyler().border(value);
  factory WrapBoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      WrapBoxStyler().borderRadius(value);
  factory WrapBoxStyler.elevation(ElevationShadow value) =>
      WrapBoxStyler().elevation(value);
  factory WrapBoxStyler.shadow(BoxShadowMix value) =>
      WrapBoxStyler().shadow(value);
  factory WrapBoxStyler.shadows(List<BoxShadowMix> value) =>
      WrapBoxStyler().shadows(value);
  factory WrapBoxStyler.width(double value) => WrapBoxStyler().width(value);
  factory WrapBoxStyler.height(double value) => WrapBoxStyler().height(value);
  factory WrapBoxStyler.size(double width, double height) =>
      WrapBoxStyler().size(width, height);
  factory WrapBoxStyler.minWidth(double value) =>
      WrapBoxStyler().minWidth(value);
  factory WrapBoxStyler.maxWidth(double value) =>
      WrapBoxStyler().maxWidth(value);
  factory WrapBoxStyler.minHeight(double value) =>
      WrapBoxStyler().minHeight(value);
  factory WrapBoxStyler.maxHeight(double value) =>
      WrapBoxStyler().maxHeight(value);
  factory WrapBoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      WrapBoxStyler().scale(scale, alignment: alignment);
  factory WrapBoxStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => WrapBoxStyler().rotate(radians, alignment: alignment);
  factory WrapBoxStyler.translate(double x, double y, [double z = 0.0]) =>
      WrapBoxStyler().translate(x, y, z);
  factory WrapBoxStyler.skew(double skewX, double skewY) =>
      WrapBoxStyler().skew(skewX, skewY);
  factory WrapBoxStyler.textStyle(TextStyler value) =>
      WrapBoxStyler().textStyle(value);
  factory WrapBoxStyler.image(DecorationImageMix value) =>
      WrapBoxStyler().image(value);
  factory WrapBoxStyler.shape(ShapeBorderMix value) =>
      WrapBoxStyler().shape(value);
  factory WrapBoxStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => WrapBoxStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory WrapBoxStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => WrapBoxStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory WrapBoxStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => WrapBoxStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory WrapBoxStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => WrapBoxStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory WrapBoxStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => WrapBoxStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory WrapBoxStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => WrapBoxStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory WrapBoxStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => WrapBoxStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory WrapBoxStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => WrapBoxStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory WrapBoxStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => WrapBoxStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory WrapBoxStyler.alignment(AlignmentGeometry value) =>
      WrapBoxStyler().alignment(value);
  factory WrapBoxStyler.padding(EdgeInsetsGeometryMix value) =>
      WrapBoxStyler().padding(value);
  factory WrapBoxStyler.margin(EdgeInsetsGeometryMix value) =>
      WrapBoxStyler().margin(value);
  factory WrapBoxStyler.constraints(BoxConstraintsMix value) =>
      WrapBoxStyler().constraints(value);
  factory WrapBoxStyler.decoration(DecorationMix value) =>
      WrapBoxStyler().decoration(value);
  factory WrapBoxStyler.foregroundDecoration(DecorationMix value) =>
      WrapBoxStyler().foregroundDecoration(value);
  factory WrapBoxStyler.clipBehavior(Clip value) =>
      WrapBoxStyler().clipBehavior(value);
  factory WrapBoxStyler.direction(Axis value) =>
      WrapBoxStyler().direction(value);
  factory WrapBoxStyler.wrapAlignment(WrapAlignment value) =>
      WrapBoxStyler().wrapAlignment(value);
  factory WrapBoxStyler.spacing(double value) => WrapBoxStyler().spacing(value);
  factory WrapBoxStyler.runAlignment(WrapAlignment value) =>
      WrapBoxStyler().runAlignment(value);
  factory WrapBoxStyler.runSpacing(double value) =>
      WrapBoxStyler().runSpacing(value);
  factory WrapBoxStyler.crossAxisAlignment(WrapCrossAlignment value) =>
      WrapBoxStyler().crossAxisAlignment(value);
  factory WrapBoxStyler.textDirection(TextDirection value) =>
      WrapBoxStyler().textDirection(value);
  factory WrapBoxStyler.verticalDirection(VerticalDirection value) =>
      WrapBoxStyler().verticalDirection(value);
  factory WrapBoxStyler.wrapClipBehavior(Clip value) =>
      WrapBoxStyler().wrapClipBehavior(value);
  factory WrapBoxStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => WrapBoxStyler().transform(value, alignment: alignment);
  factory WrapBoxStyler.animate(AnimationConfig value) =>
      WrapBoxStyler().animate(value);

  WrapBoxStyler textStyle(TextStyler value) {
    return wrap(WidgetModifierConfig.defaultTextStyler(value));
  }

  WrapBoxStyler alignment(AlignmentGeometry value) {
    return merge(WrapBoxStyler(alignment: value));
  }

  WrapBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(WrapBoxStyler(transformAlignment: value));
  }

  WrapBoxStyler clipBehavior(Clip value) {
    return merge(WrapBoxStyler(clipBehavior: value));
  }

  @override
  WrapBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(WrapBoxStyler(foregroundDecoration: value));
  }

  @override
  WrapBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(WrapBoxStyler(padding: value));
  }

  @override
  WrapBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(WrapBoxStyler(margin: value));
  }

  @override
  WrapBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      WrapBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  @override
  WrapBoxStyler decoration(DecorationMix value) {
    return merge(WrapBoxStyler(decoration: value));
  }

  @override
  WrapBoxStyler constraints(BoxConstraintsMix value) {
    return merge(WrapBoxStyler(constraints: value));
  }

  @override
  WrapBoxStyler flow(WrapStyler value) {
    return merge(WrapBoxStyler.create(flow: Prop.maybeMix(value)));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'box',
    'flow',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the animation configuration.
  @override
  WrapBoxStyler animate(AnimationConfig value) {
    return merge(WrapBoxStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  WrapBoxStyler variants(List<VariantStyle<WrapBoxSpec>> value) {
    return merge(WrapBoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  WrapBoxStyler wrap(WidgetModifierConfig value) {
    return merge(WrapBoxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  WrapBoxStyler modifier(WidgetModifierConfig value) {
    return merge(WrapBoxStyler(modifier: value));
  }

  WrapBox call({Key? key, List<Widget> children = const <Widget>[]}) {
    return WrapBox(key: key, style: this, children: children);
  }

  /// Merges with another [WrapBoxStyler].
  @override
  WrapBoxStyler merge(WrapBoxStyler? other) {
    return WrapBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      flow: MixOps.merge($flow, other?.$flow),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<WrapBoxSpec>] using [context].
  @override
  StyleSpec<WrapBoxSpec> resolve(BuildContext context) {
    final spec = WrapBoxSpec(
      box: MixOps.resolve(context, $box),
      flow: MixOps.resolve(context, $flow),
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
      ..add(DiagnosticsProperty('flow', $flow));
  }

  @override
  List<Object?> get props => [$box, $flow, $animation, $modifier, $variants];
}

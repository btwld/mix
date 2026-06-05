// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexbox_spec.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$FlexBoxSpec implements Spec<FlexBoxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get box;
  StyleSpec<FlexSpec>? get flex;

  @override
  Type get type => FlexBoxSpec;

  @override
  FlexBoxSpec copyWith({StyleSpec<BoxSpec>? box, StyleSpec<FlexSpec>? flex}) {
    return FlexBoxSpec(box: box ?? this.box, flex: flex ?? this.flex);
  }

  @override
  FlexBoxSpec lerp(FlexBoxSpec? other, double t) {
    return FlexBoxSpec(
      box: box?.lerp(other?.box, t),
      flex: flex?.lerp(other?.flex, t),
    );
  }

  @override
  List<Object?> get props => [box, flex];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FlexBoxSpec &&
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
      ..add(DiagnosticsProperty('flex', flex));
  }
}

@Deprecated(
  'Rename to `_\$FlexBoxSpec` and migrate the class declaration to `class FlexBoxSpec with _\$FlexBoxSpec`. The `_\$FlexBoxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$FlexBoxSpecMethods = _$FlexBoxSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class FlexBoxStyler extends MixStyler<FlexBoxStyler, FlexBoxSpec>
    with
        SpacingStyleMixin<FlexBoxStyler>,
        ConstraintStyleMixin<FlexBoxStyler>,
        DecorationStyleMixin<FlexBoxStyler>,
        BorderStyleMixin<FlexBoxStyler>,
        BorderRadiusStyleMixin<FlexBoxStyler>,
        ShadowStyleMixin<FlexBoxStyler>,
        TransformStyleMixin<FlexBoxStyler>,
        FlexStyleMixin<FlexBoxStyler> {
  final Prop<StyleSpec<BoxSpec>>? $box;
  final Prop<StyleSpec<FlexSpec>>? $flex;

  const FlexBoxStyler.create({
    Prop<StyleSpec<BoxSpec>>? box,
    Prop<StyleSpec<FlexSpec>>? flex,
    super.variants,
    super.modifier,
    super.animation,
  }) : $box = box,
       $flex = flex;

  FlexBoxStyler({
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
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
    VerticalDirection? verticalDirection,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
    Clip? flexClipBehavior,
    double? spacing,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<FlexBoxSpec>>? variants,
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
         flex: Prop.maybeMix(
           FlexStyler(
             direction: direction,
             mainAxisAlignment: mainAxisAlignment,
             crossAxisAlignment: crossAxisAlignment,
             mainAxisSize: mainAxisSize,
             verticalDirection: verticalDirection,
             textDirection: textDirection,
             textBaseline: textBaseline,
             clipBehavior: flexClipBehavior,
             spacing: spacing,
           ),
         ),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory FlexBoxStyler.color(Color value) => FlexBoxStyler().color(value);
  factory FlexBoxStyler.gradient(GradientMix value) =>
      FlexBoxStyler().gradient(value);
  factory FlexBoxStyler.border(BoxBorderMix value) =>
      FlexBoxStyler().border(value);
  factory FlexBoxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      FlexBoxStyler().borderRadius(value);
  factory FlexBoxStyler.elevation(ElevationShadow value) =>
      FlexBoxStyler().elevation(value);
  factory FlexBoxStyler.shadow(BoxShadowMix value) =>
      FlexBoxStyler().shadow(value);
  factory FlexBoxStyler.shadows(List<BoxShadowMix> value) =>
      FlexBoxStyler().shadows(value);
  factory FlexBoxStyler.width(double value) => FlexBoxStyler().width(value);
  factory FlexBoxStyler.height(double value) => FlexBoxStyler().height(value);
  factory FlexBoxStyler.size(double width, double height) =>
      FlexBoxStyler().size(width, height);
  factory FlexBoxStyler.minWidth(double value) =>
      FlexBoxStyler().minWidth(value);
  factory FlexBoxStyler.maxWidth(double value) =>
      FlexBoxStyler().maxWidth(value);
  factory FlexBoxStyler.minHeight(double value) =>
      FlexBoxStyler().minHeight(value);
  factory FlexBoxStyler.maxHeight(double value) =>
      FlexBoxStyler().maxHeight(value);
  factory FlexBoxStyler.scale(double scale, {Alignment alignment = .center}) =>
      FlexBoxStyler().scale(scale, alignment: alignment);
  factory FlexBoxStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => FlexBoxStyler().rotate(radians, alignment: alignment);
  factory FlexBoxStyler.translate(double x, double y, [double z = 0.0]) =>
      FlexBoxStyler().translate(x, y, z);
  factory FlexBoxStyler.skew(double skewX, double skewY) =>
      FlexBoxStyler().skew(skewX, skewY);
  factory FlexBoxStyler.textStyle(TextStyler value) =>
      FlexBoxStyler().textStyle(value);
  factory FlexBoxStyler.image(DecorationImageMix value) =>
      FlexBoxStyler().image(value);
  factory FlexBoxStyler.shape(ShapeBorderMix value) =>
      FlexBoxStyler().shape(value);
  factory FlexBoxStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => FlexBoxStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory FlexBoxStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => FlexBoxStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory FlexBoxStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => FlexBoxStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory FlexBoxStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => FlexBoxStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => FlexBoxStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => FlexBoxStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => FlexBoxStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => FlexBoxStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => FlexBoxStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory FlexBoxStyler.row() => FlexBoxStyler().row();
  factory FlexBoxStyler.column() => FlexBoxStyler().column();
  factory FlexBoxStyler.alignment(AlignmentGeometry value) =>
      FlexBoxStyler().alignment(value);
  factory FlexBoxStyler.padding(EdgeInsetsGeometryMix value) =>
      FlexBoxStyler().padding(value);
  factory FlexBoxStyler.margin(EdgeInsetsGeometryMix value) =>
      FlexBoxStyler().margin(value);
  factory FlexBoxStyler.constraints(BoxConstraintsMix value) =>
      FlexBoxStyler().constraints(value);
  factory FlexBoxStyler.decoration(DecorationMix value) =>
      FlexBoxStyler().decoration(value);
  factory FlexBoxStyler.foregroundDecoration(DecorationMix value) =>
      FlexBoxStyler().foregroundDecoration(value);
  factory FlexBoxStyler.clipBehavior(Clip value) =>
      FlexBoxStyler().clipBehavior(value);
  factory FlexBoxStyler.direction(Axis value) =>
      FlexBoxStyler().direction(value);
  factory FlexBoxStyler.mainAxisAlignment(MainAxisAlignment value) =>
      FlexBoxStyler().mainAxisAlignment(value);
  factory FlexBoxStyler.crossAxisAlignment(CrossAxisAlignment value) =>
      FlexBoxStyler().crossAxisAlignment(value);
  factory FlexBoxStyler.mainAxisSize(MainAxisSize value) =>
      FlexBoxStyler().mainAxisSize(value);
  factory FlexBoxStyler.spacing(double value) => FlexBoxStyler().spacing(value);
  factory FlexBoxStyler.verticalDirection(VerticalDirection value) =>
      FlexBoxStyler().verticalDirection(value);
  factory FlexBoxStyler.textDirection(TextDirection value) =>
      FlexBoxStyler().textDirection(value);
  factory FlexBoxStyler.textBaseline(TextBaseline value) =>
      FlexBoxStyler().textBaseline(value);
  factory FlexBoxStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => FlexBoxStyler().transform(value, alignment: alignment);
  factory FlexBoxStyler.animate(AnimationConfig value) =>
      FlexBoxStyler().animate(value);

  FlexBoxStyler textStyle(TextStyler value) {
    return wrap(WidgetModifierConfig.defaultTextStyler(value));
  }

  FlexBoxStyler alignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(alignment: value));
  }

  FlexBoxStyler transformAlignment(AlignmentGeometry value) {
    return merge(FlexBoxStyler(transformAlignment: value));
  }

  FlexBoxStyler clipBehavior(Clip value) {
    return merge(FlexBoxStyler(clipBehavior: value));
  }

  @override
  FlexBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(FlexBoxStyler(foregroundDecoration: value));
  }

  @override
  FlexBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(padding: value));
  }

  @override
  FlexBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(FlexBoxStyler(margin: value));
  }

  @override
  FlexBoxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      FlexBoxStyler(transform: value, transformAlignment: alignment),
    );
  }

  @override
  FlexBoxStyler decoration(DecorationMix value) {
    return merge(FlexBoxStyler(decoration: value));
  }

  @override
  FlexBoxStyler constraints(BoxConstraintsMix value) {
    return merge(FlexBoxStyler(constraints: value));
  }

  @override
  FlexBoxStyler flex(FlexStyler value) {
    return merge(FlexBoxStyler.create(flex: Prop.maybeMix(value)));
  }

  /// Sets the animation configuration.
  @override
  FlexBoxStyler animate(AnimationConfig value) {
    return merge(FlexBoxStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  FlexBoxStyler variants(List<VariantStyle<FlexBoxSpec>> value) {
    return merge(FlexBoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  FlexBoxStyler wrap(WidgetModifierConfig value) {
    return merge(FlexBoxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  FlexBoxStyler modifier(WidgetModifierConfig value) {
    return merge(FlexBoxStyler(modifier: value));
  }

  FlexBox call({Key? key, List<Widget> children = const <Widget>[]}) {
    return FlexBox(key: key, style: this, children: children);
  }

  /// Merges with another [FlexBoxStyler].
  @override
  FlexBoxStyler merge(FlexBoxStyler? other) {
    return FlexBoxStyler.create(
      box: MixOps.merge($box, other?.$box),
      flex: MixOps.merge($flex, other?.$flex),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<FlexBoxSpec>] using [context].
  @override
  StyleSpec<FlexBoxSpec> resolve(BuildContext context) {
    final spec = FlexBoxSpec(
      box: MixOps.resolve(context, $box),
      flex: MixOps.resolve(context, $flex),
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
      ..add(DiagnosticsProperty('flex', $flex));
  }

  @override
  List<Object?> get props => [$box, $flex, $animation, $modifier, $variants];
}

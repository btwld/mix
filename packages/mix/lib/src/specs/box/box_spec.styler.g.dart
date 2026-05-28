// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

// ignore_for_file: prefer_relative_imports, unnecessary_import, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/spec.dart';
import 'box_widget.dart';

import 'box_spec.dart';

class BoxStyler extends MixStyler<BoxStyler, BoxSpec>
    with
        SpacingStyleMixin<BoxStyler>,
        ConstraintStyleMixin<BoxStyler>,
        DecorationStyleMixin<BoxStyler>,
        BorderStyleMixin<BoxStyler>,
        BorderRadiusStyleMixin<BoxStyler>,
        ShadowStyleMixin<BoxStyler>,
        TransformStyleMixin<BoxStyler>,
        _$BoxStylerMixin {
  @override
  final Prop<AlignmentGeometry>? $alignment;
  @override
  final Prop<EdgeInsetsGeometry>? $padding;
  @override
  final Prop<EdgeInsetsGeometry>? $margin;
  @override
  final Prop<BoxConstraints>? $constraints;
  @override
  final Prop<Decoration>? $decoration;
  @override
  final Prop<Decoration>? $foregroundDecoration;
  @override
  final Prop<Matrix4>? $transform;
  @override
  final Prop<AlignmentGeometry>? $transformAlignment;
  @override
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
  factory BoxStyler.shadows(List<BoxShadowMix> value) =>
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

  Box call({Key? key, Widget? child}) {
    return Box(key: key, style: this, child: child);
  }
}

mixin _$BoxStylerMixin on Style<BoxSpec>, Diagnosticable {
  Prop<AlignmentGeometry>? get $alignment;
  Prop<EdgeInsetsGeometry>? get $padding;
  Prop<EdgeInsetsGeometry>? get $margin;
  Prop<BoxConstraints>? get $constraints;
  Prop<Decoration>? get $decoration;
  Prop<Decoration>? get $foregroundDecoration;
  Prop<Matrix4>? get $transform;
  Prop<AlignmentGeometry>? get $transformAlignment;
  Prop<Clip>? get $clipBehavior;

  /// Sets the alignment.
  BoxStyler alignment(AlignmentGeometry value) {
    return merge(BoxStyler(alignment: value));
  }

  /// Sets the padding.
  BoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(padding: value));
  }

  /// Sets the margin.
  BoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(BoxStyler(margin: value));
  }

  /// Sets the constraints.
  BoxStyler constraints(BoxConstraintsMix value) {
    return merge(BoxStyler(constraints: value));
  }

  /// Sets the decoration.
  BoxStyler decoration(DecorationMix value) {
    return merge(BoxStyler(decoration: value));
  }

  /// Sets the foregroundDecoration.
  BoxStyler foregroundDecoration(DecorationMix value) {
    return merge(BoxStyler(foregroundDecoration: value));
  }

  /// Sets the clipBehavior.
  BoxStyler clipBehavior(Clip value) {
    return merge(BoxStyler(clipBehavior: value));
  }

  /// Sets the animation configuration.
  BoxStyler animate(AnimationConfig value) {
    return merge(BoxStyler(animation: value));
  }

  /// Sets the style variants.
  BoxStyler variants(List<VariantStyle<BoxSpec>> value) {
    return merge(BoxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  BoxStyler wrap(WidgetModifierConfig value) {
    return merge(BoxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  BoxStyler modifier(WidgetModifierConfig value) {
    return merge(BoxStyler(modifier: value));
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
